import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/time_management/data/datasources/work_schedule_remote_datasource.dart';
import 'package:grc/features/time_management/data/repositories/work_schedule_repository_impl.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/domain/repositories/work_schedule_repository.dart';
import 'package:grc/features/time_management/domain/usecases/create_work_schedule_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/delete_work_schedule_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/get_work_schedules_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/update_work_schedule_usecase.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workScheduleApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final workScheduleRemoteDataSourceProvider = Provider<WorkScheduleRemoteDataSource>((ref) {
  final apiClient = ref.watch(workScheduleApiClientProvider);
  return WorkScheduleRemoteDataSourceImpl(apiClient: apiClient);
});

final workScheduleRepositoryProvider = Provider.family<WorkScheduleRepository, int>((ref, enterpriseId) {
  final remoteDataSource = ref.watch(workScheduleRemoteDataSourceProvider);
  return WorkScheduleRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: enterpriseId);
});

final getWorkSchedulesUseCaseProvider = Provider.family<GetWorkSchedulesUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workScheduleRepositoryProvider(enterpriseId));
  return GetWorkSchedulesUseCase(repository: repository);
});

final createWorkScheduleUseCaseProvider = Provider.family<CreateWorkScheduleUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workScheduleRepositoryProvider(enterpriseId));
  return CreateWorkScheduleUseCase(repository: repository);
});

final updateWorkScheduleUseCaseProvider = Provider.family<UpdateWorkScheduleUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workScheduleRepositoryProvider(enterpriseId));
  return UpdateWorkScheduleUseCase(repository: repository);
});

final deleteWorkScheduleUseCaseProvider = Provider.family<DeleteWorkScheduleUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workScheduleRepositoryProvider(enterpriseId));
  return DeleteWorkScheduleUseCase(repository: repository);
});

class WorkScheduleState extends PaginationState<WorkSchedule> {
  final Set<int> deletingScheduleIds;

  const WorkScheduleState({
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
    this.deletingScheduleIds = const {},
  });

  @override
  WorkScheduleState copyWith({
    List<WorkSchedule>? items,
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
    bool clearItems = false,
    Set<int>? deletingScheduleIds,
  }) {
    return WorkScheduleState(
      items: clearItems ? const [] : (items ?? this.items),
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
      deletingScheduleIds: deletingScheduleIds ?? this.deletingScheduleIds,
    );
  }
}

final workSchedulesNotifierProvider = StateNotifierProvider.family<WorkSchedulesNotifier, WorkScheduleState, int>((
  ref,
  enterpriseId,
) {
  return WorkSchedulesNotifier(
    ref.read(getWorkSchedulesUseCaseProvider(enterpriseId)),
    ref.read(updateWorkScheduleUseCaseProvider(enterpriseId)),
    ref.read(deleteWorkScheduleUseCaseProvider(enterpriseId)),
    ref,
  );
});

class WorkSchedulesNotifier extends StateNotifier<WorkScheduleState>
    with PaginationMixin<WorkSchedule>
    implements PaginationController<WorkSchedule> {
  final GetWorkSchedulesUseCase _getWorkSchedulesUseCase;
  final UpdateWorkScheduleUseCase _updateWorkScheduleUseCase;
  final DeleteWorkScheduleUseCase _deleteWorkScheduleUseCase;
  final Ref _ref;
  int? _currentEnterpriseId;

  WorkSchedulesNotifier(
    this._getWorkSchedulesUseCase,
    this._updateWorkScheduleUseCase,
    this._deleteWorkScheduleUseCase,
    this._ref,
  ) : super(const WorkScheduleState());

  void setEnterpriseId(int enterpriseId) {
    if (_currentEnterpriseId != enterpriseId) {
      _currentEnterpriseId = enterpriseId;
      reset();
      loadFirstPage();
    }
  }

  @override
  Future<void> loadFirstPage() async {
    if (_currentEnterpriseId == null) return;

    final loadingState = handleLoadingState(state, true);
    state = WorkScheduleState(
      items: loadingState.items,
      isLoading: loadingState.isLoading,
      isLoadingMore: loadingState.isLoadingMore,
      hasError: loadingState.hasError,
      errorMessage: loadingState.errorMessage,
      currentPage: loadingState.currentPage,
      pageSize: loadingState.pageSize,
      totalItems: loadingState.totalItems,
      totalPages: loadingState.totalPages,
      hasNextPage: loadingState.hasNextPage,
      hasPreviousPage: loadingState.hasPreviousPage,
    );

    try {
      final result = await _getWorkSchedulesUseCase(page: 1, pageSize: state.pageSize);

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.workSchedules,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: true,
      );
      state = WorkScheduleState(
        items: newState.items,
        isLoading: newState.isLoading,
        isLoadingMore: newState.isLoadingMore,
        hasError: newState.hasError,
        errorMessage: newState.errorMessage,
        currentPage: newState.currentPage,
        pageSize: newState.pageSize,
        totalItems: newState.totalItems,
        totalPages: newState.totalPages,
        hasNextPage: newState.hasNextPage,
        hasPreviousPage: newState.hasPreviousPage,
      );
    } catch (e) {
      final errorState = handleErrorState(state, e.toString());
      state = WorkScheduleState(
        items: errorState.items,
        isLoading: errorState.isLoading,
        isLoadingMore: errorState.isLoadingMore,
        hasError: errorState.hasError,
        errorMessage: errorState.errorMessage,
        currentPage: errorState.currentPage,
        pageSize: errorState.pageSize,
        totalItems: errorState.totalItems,
        totalPages: errorState.totalPages,
        hasNextPage: errorState.hasNextPage,
        hasPreviousPage: errorState.hasPreviousPage,
      );
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (_currentEnterpriseId == null || state.isLoadingMore || !state.hasNextPage) {
      return;
    }
    await goToPage(state.currentPage + 1);
  }

  Future<void> goToPage(int page) async {
    if (_currentEnterpriseId == null ||
        state.isLoadingMore ||
        (page < 1 || page > state.totalPages && state.totalPages > 0)) {
      return;
    }

    final loadingState = handleLoadingState(state, false);
    state = WorkScheduleState(
      items: loadingState.items,
      isLoading: loadingState.isLoading,
      isLoadingMore: loadingState.isLoadingMore,
      hasError: loadingState.hasError,
      errorMessage: loadingState.errorMessage,
      currentPage: loadingState.currentPage,
      pageSize: loadingState.pageSize,
      totalItems: loadingState.totalItems,
      totalPages: loadingState.totalPages,
      hasNextPage: loadingState.hasNextPage,
      hasPreviousPage: loadingState.hasPreviousPage,
    );

    try {
      final result = await _getWorkSchedulesUseCase(page: page, pageSize: state.pageSize);

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.workSchedules,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: false,
      );
      state = WorkScheduleState(
        items: newState.items,
        isLoading: newState.isLoading,
        isLoadingMore: newState.isLoadingMore,
        hasError: newState.hasError,
        errorMessage: newState.errorMessage,
        currentPage: newState.currentPage,
        pageSize: newState.pageSize,
        totalItems: newState.totalItems,
        totalPages: newState.totalPages,
        hasNextPage: newState.hasNextPage,
        hasPreviousPage: newState.hasPreviousPage,
      );
    } catch (e) {
      final errorState = handleErrorState(state, e.toString());
      state = WorkScheduleState(
        items: errorState.items,
        isLoading: errorState.isLoading,
        isLoadingMore: errorState.isLoadingMore,
        hasError: errorState.hasError,
        errorMessage: errorState.errorMessage,
        currentPage: errorState.currentPage,
        pageSize: errorState.pageSize,
        totalItems: errorState.totalItems,
        totalPages: errorState.totalPages,
        hasNextPage: errorState.hasNextPage,
        hasPreviousPage: errorState.hasPreviousPage,
      );
    }
  }

  @override
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = const WorkScheduleState();
  }

  void search(String query) {
    final normalizedQuery = query.trim();
    if (state.searchQuery == normalizedQuery) return;
    state = state.copyWith(searchQuery: normalizedQuery);
    refresh();
  }

  Future<WorkSchedule> updateWorkSchedule({required int scheduleId, required Map<String, dynamic> data}) async {
    try {
      final updatedSchedule = await _updateWorkScheduleUseCase.call(scheduleId: scheduleId, data: data);

      final updatedItems = state.items.map((schedule) {
        return schedule.workScheduleId == scheduleId ? updatedSchedule : schedule;
      }).toList();

      state = WorkScheduleState(
        items: updatedItems,
        isLoading: state.isLoading,
        isLoadingMore: state.isLoadingMore,
        hasError: state.hasError,
        errorMessage: state.errorMessage,
        currentPage: state.currentPage,
        pageSize: state.pageSize,
        totalItems: state.totalItems,
        totalPages: state.totalPages,
        hasNextPage: state.hasNextPage,
        hasPreviousPage: state.hasPreviousPage,
      );

      _ref.read(timeManagementStatsNotifierProvider.notifier).refresh();

      return updatedSchedule;
    } catch (e) {
      throw Exception('Failed to update work schedule: ${e.toString()}');
    }
  }

  Future<void> deleteWorkSchedule(int scheduleId, {bool hard = true}) async {
    final deletingIds = Set<int>.from(state.deletingScheduleIds)..add(scheduleId);
    state = state.copyWith(deletingScheduleIds: deletingIds);

    try {
      await _deleteWorkScheduleUseCase.call(scheduleId: scheduleId, hard: hard);

      final updatedItems = state.items.where((item) => item.workScheduleId != scheduleId).toList();
      final updatedDeletingIds = Set<int>.from(state.deletingScheduleIds)..remove(scheduleId);

      state = state.copyWith(
        items: updatedItems,
        deletingScheduleIds: updatedDeletingIds,
        totalItems: state.totalItems > 0 ? state.totalItems - 1 : 0,
      );

      _ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
    } catch (e) {
      final updatedDeletingIds = Set<int>.from(state.deletingScheduleIds)..remove(scheduleId);
      state = state.copyWith(
        deletingScheduleIds: updatedDeletingIds,
        hasError: true,
        errorMessage: 'Failed to delete work schedule: ${e.toString()}',
      );
      rethrow;
    }
  }
}
