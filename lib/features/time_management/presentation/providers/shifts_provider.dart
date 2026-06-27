import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/time_management/data/datasources/shift_remote_datasource.dart';
import 'package:grc/features/time_management/data/repositories/shift_repository_impl.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/repositories/shift_repository.dart';
import 'package:grc/features/time_management/domain/usecases/delete_shift_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/get_shifts_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/update_shift_usecase.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final shiftRemoteDataSourceProvider = Provider<ShiftRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ShiftRemoteDataSourceImpl(apiClient: apiClient);
});

/// Family provider for shift repository that accepts enterprise ID
final shiftRepositoryProvider = Provider.family<ShiftRepository, int>((ref, enterpriseId) {
  final remoteDataSource = ref.watch(shiftRemoteDataSourceProvider);
  return ShiftRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: enterpriseId);
});

/// Family provider for get shifts use case that accepts enterprise ID
final getShiftsUseCaseProvider = Provider.family<GetShiftsUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(shiftRepositoryProvider(enterpriseId));
  return GetShiftsUseCase(repository: repository);
});

/// Family provider for delete shift use case that accepts enterprise ID
final deleteShiftUseCaseProvider = Provider.family<DeleteShiftUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(shiftRepositoryProvider(enterpriseId));
  return DeleteShiftUseCase(repository: repository);
});

/// Family provider for update shift use case that accepts enterprise ID
final updateShiftUseCaseProvider = Provider.family<UpdateShiftUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(shiftRepositoryProvider(enterpriseId));
  return UpdateShiftUseCase(repository: repository);
});

/// Shift State that extends PaginationState with deletion status
class ShiftState extends PaginationState<ShiftOverview> {
  final bool isDeleting;
  final int? deletingShiftId;

  const ShiftState({
    super.items = const [],
    super.isLoading = false,
    super.isLoadingMore = false,
    super.hasError = false,
    super.errorMessage,
    super.currentPage = 1,
    super.pageSize = 10,
    super.totalItems = 0,
    super.totalPages = 0,
    super.hasNextPage = false,
    super.hasPreviousPage = false,
    super.searchQuery,
    super.status,
    this.isDeleting = false,
    this.deletingShiftId,
  });

  @override
  ShiftState copyWith({
    List<ShiftOverview>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    PositionStatus? status,
    bool clearStatus = false,
    bool? isDeleting,
    int? deletingShiftId,
    bool clearDeletingShiftId = false,
  }) {
    return ShiftState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
      isDeleting: isDeleting ?? this.isDeleting,
      deletingShiftId: clearDeletingShiftId ? null : (deletingShiftId ?? this.deletingShiftId),
    );
  }

  /// Returns the status as a string for UI display
  String get statusString {
    if (status == null) return 'All Status';
    return status == PositionStatus.active ? 'Active' : 'Inactive';
  }
}

/// Shifts Notifier with pagination support
class ShiftsNotifier extends StateNotifier<ShiftState>
    with PaginationMixin<ShiftOverview>
    implements PaginationController<ShiftOverview> {
  final GetShiftsUseCase _getShiftsUseCase;
  final UpdateShiftUseCase _updateShiftUseCase;
  final DeleteShiftUseCase _deleteShiftUseCase;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  int? _currentEnterpriseId;

  final Ref _ref;

  ShiftsNotifier(this._getShiftsUseCase, this._updateShiftUseCase, this._deleteShiftUseCase, this._ref)
    : super(const ShiftState());

  void setEnterpriseId(int enterpriseId) {
    if (_currentEnterpriseId != enterpriseId) {
      _currentEnterpriseId = enterpriseId;
      reset();
      loadFirstPage();
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true) as ShiftState;

    try {
      final response = await _getShiftsUseCase(
        search: state.searchQuery,
        isActive: _getActiveStatusFilter(),
        page: 1,
        pageSize: state.pageSize.clamp(1, 100),
      );

      final shifts = response.shifts.isEmpty ? <ShiftOverview>[] : response.shifts;
      final pagination = response.pagination;

      final validCurrentPage = pagination.currentPage < 1 ? 1 : pagination.currentPage;
      final validPageSize = pagination.pageSize < 1 ? state.pageSize : pagination.pageSize;
      final validTotalItems = pagination.totalItems < 0 ? 0 : pagination.totalItems;
      final validTotalPages = pagination.totalPages < 0 ? 0 : pagination.totalPages;

      state =
          handleSuccessState(
                currentState: state,
                newItems: shifts,
                currentPage: validCurrentPage,
                pageSize: validPageSize,
                totalItems: validTotalItems,
                totalPages: validTotalPages,
                hasNextPage: pagination.hasNext && validCurrentPage < validTotalPages,
                hasPreviousPage: pagination.hasPrevious && validCurrentPage > 1,
                isFirstPage: true,
              )
              as ShiftState;
    } catch (e) {
      final errorMessage = e.toString();
      state =
          handleErrorState(state, errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage) as ShiftState;
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage || state.currentPage < 1) {
      return;
    }

    state = handleLoadingState(state, false) as ShiftState;

    try {
      final nextPage = state.currentPage + 1;

      if (state.totalPages > 0 && nextPage > state.totalPages) {
        state = state.copyWith(
          isLoadingMore: false,
          hasError: true,
          errorMessage: 'Cannot load page beyond total pages',
        );
        return;
      }

      final response = await _getShiftsUseCase(
        search: state.searchQuery,
        isActive: _getActiveStatusFilter(),
        page: nextPage,
        pageSize: state.pageSize.clamp(1, 100),
      );

      final shifts = response.shifts.isEmpty ? <ShiftOverview>[] : response.shifts;
      final pagination = response.pagination;

      final validCurrentPage = pagination.currentPage < 1 ? nextPage : pagination.currentPage;
      final validPageSize = pagination.pageSize < 1 ? state.pageSize : pagination.pageSize;
      final validTotalItems = pagination.totalItems < 0 ? state.totalItems : pagination.totalItems;
      final validTotalPages = pagination.totalPages < 0 ? state.totalPages : pagination.totalPages;

      state =
          handleSuccessState(
                currentState: state,
                newItems: shifts,
                currentPage: validCurrentPage,
                pageSize: validPageSize,
                totalItems: validTotalItems,
                totalPages: validTotalPages,
                hasNextPage: pagination.hasNext && validCurrentPage < validTotalPages,
                hasPreviousPage: pagination.hasPrevious && validCurrentPage > 1,
                isFirstPage: false,
              )
              as ShiftState;
    } catch (e) {
      final errorMessage = e.toString();
      state =
          handleErrorState(state, errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage) as ShiftState;
    }
  }

  @override
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = ShiftState(pageSize: state.pageSize);
  }

  void search(String query) {
    final normalizedQuery = query.trim();

    if (state.searchQuery == normalizedQuery) return;

    state = state.copyWith(searchQuery: normalizedQuery);
    _debouncer.run(() {
      refresh();
    });
  }

  Future<void> goToPage(int page) async {
    if (state.isLoading || page == state.currentPage || page < 1 || page > state.totalPages) return;

    state = handleLoadingState(state, false) as ShiftState;

    try {
      final response = await _getShiftsUseCase(
        search: state.searchQuery,
        isActive: _getActiveStatusFilter(),
        page: page,
        pageSize: state.pageSize.clamp(1, 100),
      );

      final shifts = response.shifts.isEmpty ? <ShiftOverview>[] : response.shifts;
      final pagination = response.pagination;

      state =
          handleSuccessState(
                currentState: state,
                newItems: shifts,
                currentPage: pagination.currentPage < 1 ? page : pagination.currentPage,
                pageSize: pagination.pageSize < 1 ? state.pageSize : pagination.pageSize,
                totalItems: pagination.totalItems < 0 ? state.totalItems : pagination.totalItems,
                totalPages: pagination.totalPages < 0 ? state.totalPages : pagination.totalPages,
                hasNextPage: pagination.hasNext && pagination.currentPage < pagination.totalPages,
                hasPreviousPage: pagination.hasPrevious && pagination.currentPage > 1,
                isFirstPage: true,
              )
              as ShiftState;
    } catch (e) {
      final errorMessage = e.toString();
      state =
          handleErrorState(state, errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage) as ShiftState;
    }
  }

  void setStatusFilter(bool? isActive) {
    final status = isActive == null ? null : (isActive ? PositionStatus.active : PositionStatus.inactive);

    if (state.status == status) return;

    if (status == null) {
      state = state.copyWith(clearStatus: true);
    } else {
      state = state.copyWith(status: status);
    }
    refresh();
  }

  /// Sets status filter from string value ('All Status', 'Active', 'Inactive')
  void setStatusFilterFromString(String? statusString) {
    if (statusString == null) return;

    final isActive = statusString == 'All Status'
        ? null
        : statusString == 'Active'
        ? true
        : false;

    setStatusFilter(isActive);
  }

  bool? _getActiveStatusFilter() {
    if (state.status == null) return null;
    return state.status == PositionStatus.active;
  }

  void addShiftOptimistically(ShiftOverview shift) {
    final currentItems = List<ShiftOverview>.from(state.items);
    currentItems.insert(0, shift);

    state = state.copyWith(items: currentItems, totalItems: state.totalItems + 1);
  }

  Future<ShiftOverview?> updateShift({required int shiftId, required Map<String, dynamic> shiftData}) async {
    try {
      final updatedShift = await _updateShiftUseCase.call(shiftId: shiftId, shiftData: shiftData);

      final updatedItems = state.items.map((shift) => shift.id == shiftId ? updatedShift : shift).toList();

      state = state.copyWith(items: updatedItems);

      return updatedShift;
    } on AppException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteShift({required int shiftId, required bool hard}) async {
    if (state.isDeleting) return false;

    state = state.copyWith(isDeleting: true, deletingShiftId: shiftId);

    try {
      await _deleteShiftUseCase.call(shiftId: shiftId, hard: hard);

      final updatedItems = state.items.where((shift) => shift.id != shiftId).toList();
      final newTotalItems = (state.totalItems - 1).clamp(0, double.infinity).toInt();

      state = state.copyWith(
        items: updatedItems,
        totalItems: newTotalItems,
        isDeleting: false,
        clearDeletingShiftId: true,
      );

      _ref.read(timeManagementStatsNotifierProvider.notifier).refresh();

      return true;
    } on AppException {
      state = state.copyWith(isDeleting: false, clearDeletingShiftId: true);
      rethrow;
    } catch (e) {
      state = state.copyWith(isDeleting: false, clearDeletingShiftId: true);
      rethrow;
    }
  }
}

/// Family provider for shifts notifier that accepts enterprise ID
final shiftsNotifierProvider = StateNotifierProvider.family<ShiftsNotifier, ShiftState, int>((ref, enterpriseId) {
  return ShiftsNotifier(
    ref.read(getShiftsUseCaseProvider(enterpriseId)),
    ref.read(updateShiftUseCaseProvider(enterpriseId)),
    ref.read(deleteShiftUseCaseProvider(enterpriseId)),
    ref,
  );
});
