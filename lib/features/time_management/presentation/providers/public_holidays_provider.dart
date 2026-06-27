import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/time_management/data/config/public_holidays_config.dart';
import 'package:grc/features/time_management/data/datasources/public_holiday_remote_datasource.dart';
import 'package:grc/features/time_management/data/repositories/public_holiday_repository_impl.dart';
import 'package:grc/features/time_management/domain/models/public_holiday.dart';
import 'package:grc/features/time_management/domain/repositories/public_holiday_repository.dart';
import 'package:grc/features/time_management/domain/usecases/create_public_holiday_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/delete_public_holiday_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/get_public_holidays_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/update_public_holiday_usecase.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/enums/time_management_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final publicHolidayApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final publicHolidayRemoteDataSourceProvider = Provider<PublicHolidayRemoteDataSource>((ref) {
  final apiClient = ref.watch(publicHolidayApiClientProvider);
  return PublicHolidayRemoteDataSourceImpl(apiClient: apiClient);
});

final publicHolidayRepositoryProvider = Provider.family<PublicHolidayRepository, int>((ref, enterpriseId) {
  final remoteDataSource = ref.watch(publicHolidayRemoteDataSourceProvider);
  return PublicHolidayRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: enterpriseId);
});

final getPublicHolidaysUseCaseProvider = Provider.family<GetPublicHolidaysUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(publicHolidayRepositoryProvider(enterpriseId));
  return GetPublicHolidaysUseCase(repository: repository);
});

final createPublicHolidayUseCaseProvider = Provider.family<CreatePublicHolidayUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(publicHolidayRepositoryProvider(enterpriseId));
  return CreatePublicHolidayUseCase(repository: repository);
});

final updatePublicHolidayUseCaseProvider = Provider.family<UpdatePublicHolidayUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(publicHolidayRepositoryProvider(enterpriseId));
  return UpdatePublicHolidayUseCase(repository);
});

final deletePublicHolidayUseCaseProvider = Provider.family<DeletePublicHolidayUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(publicHolidayRepositoryProvider(enterpriseId));
  return DeletePublicHolidayUseCase(repository: repository);
});

class PublicHolidaysState extends PaginationState<PublicHoliday> {
  final String? deleteSuccessMessage;
  final String? deleteErrorMessage;
  final String? createSuccessMessage;
  final String? createErrorMessage;
  final int? deletingHolidayId;

  const PublicHolidaysState({
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
    this.deleteSuccessMessage,
    this.deleteErrorMessage,
    this.createSuccessMessage,
    this.createErrorMessage,
    this.deletingHolidayId,
    this.selectedYear,
    this.selectedType,
  });

  final String? selectedYear;
  final String? selectedType;

  @override
  PublicHolidaysState copyWith({
    List<PublicHoliday>? items,
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
    String? selectedYear,
    String? selectedType,
    String? deleteSuccessMessage,
    String? deleteErrorMessage,
    String? createSuccessMessage,
    String? createErrorMessage,
    int? deletingHolidayId,
    bool clearError = false,
    bool clearSearch = false,
    bool clearSideEffects = false,
    bool clearDeletingHolidayId = false,
  }) {
    return PublicHolidaysState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: clearError ? false : (hasError ?? this.hasError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      status: clearStatus ? null : (status ?? this.status),
      selectedYear: selectedYear ?? this.selectedYear,
      selectedType: selectedType ?? this.selectedType,
      deleteSuccessMessage: clearSideEffects ? null : (deleteSuccessMessage ?? this.deleteSuccessMessage),
      deleteErrorMessage: clearSideEffects ? null : (deleteErrorMessage ?? this.deleteErrorMessage),
      createSuccessMessage: clearSideEffects ? null : (createSuccessMessage ?? this.createSuccessMessage),
      createErrorMessage: clearSideEffects ? null : (createErrorMessage ?? this.createErrorMessage),
      deletingHolidayId: clearDeletingHolidayId ? null : (deletingHolidayId ?? this.deletingHolidayId),
    );
  }

  List<PublicHoliday> get holidays => items;
  int get totalHolidays => totalItems;
  bool get hasMore => hasNextPage;
}

class PublicHolidaysNotifier extends StateNotifier<PublicHolidaysState>
    with PaginationMixin<PublicHoliday>
    implements PaginationController<PublicHoliday> {
  final GetPublicHolidaysUseCase getHolidaysUseCase;
  final DeletePublicHolidayUseCase deleteHolidayUseCase;
  final CreatePublicHolidayUseCase createHolidayUseCase;
  final UpdatePublicHolidayUseCase updateHolidayUseCase;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  int? _currentEnterpriseId;

  PublicHolidaysNotifier({
    required this.getHolidaysUseCase,
    required this.deleteHolidayUseCase,
    required this.createHolidayUseCase,
    required this.updateHolidayUseCase,
    required int enterpriseId,
  }) : _currentEnterpriseId = enterpriseId,
       super(const PublicHolidaysState()) {
    state = state.copyWith(selectedYear: PublicHolidaysConfig.defaultYear);
  }

  void setEnterpriseId(int enterpriseId) {
    if (_currentEnterpriseId == enterpriseId) return;
    _currentEnterpriseId = enterpriseId;
    reset();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> loadHolidays({bool refresh = false}) async {
    await loadFirstPage();
  }

  String? validateHolidayInputs({
    required String nameEn,
    required DateTime? date,
    required HolidayType? type,
    required String descriptionEn,
    required String? appliesToLabel,
    required String yearText,
  }) {
    if (nameEn.trim().isEmpty) {
      return 'Holiday name in English is required';
    }
    if (date == null) {
      return 'Please select a date';
    }
    if (type == null) {
      return 'Please select a holiday type';
    }
    if (descriptionEn.trim().isEmpty) {
      return 'Description in English is required';
    }
    if (appliesToLabel == null || appliesToLabel.trim().isEmpty) {
      return 'Please select who this holiday applies to';
    }
    if (yearText.trim().isEmpty) {
      return 'Year is required';
    }
    final year = int.tryParse(yearText.trim());
    if (year == null || year < 1900 || year > 2100) {
      return 'Please enter a valid year';
    }
    return null;
  }

  @override
  Future<void> loadFirstPage() async {
    if (_currentEnterpriseId == null) return;
    if (state.isLoading) return;

    state = handleLoadingState(state, true) as PublicHolidaysState;

    try {
      final result = await getHolidaysUseCase(
        tenantId: _currentEnterpriseId!,
        page: 1,
        pageSize: state.pageSize,
        search: state.searchQuery,
        year: state.selectedYear == PublicHolidaysConfig.defaultYear ? null : state.selectedYear,
        type: state.selectedType,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: result.holidays,
                currentPage: result.pagination.currentPage,
                pageSize: result.pagination.pageSize,
                totalItems: result.pagination.totalItems,
                totalPages: result.pagination.totalPages,
                hasNextPage: result.pagination.hasNext,
                hasPreviousPage: result.pagination.hasPrevious,
                isFirstPage: true,
              )
              as PublicHolidaysState;
    } on AppException catch (e) {
      state = handleErrorState(state, e.message) as PublicHolidaysState;
    } catch (e) {
      state = handleErrorState(state, 'Failed to load holidays: ${e.toString()}') as PublicHolidaysState;
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (_currentEnterpriseId == null || state.isLoadingMore || !state.hasNextPage) return;

    state = handleLoadingState(state, false) as PublicHolidaysState;

    try {
      final nextPage = state.currentPage + 1;
      final result = await getHolidaysUseCase(
        tenantId: _currentEnterpriseId!,
        page: nextPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
        year: state.selectedYear == PublicHolidaysConfig.defaultYear ? null : state.selectedYear,
        type: state.selectedType,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: result.holidays,
                currentPage: result.pagination.currentPage,
                pageSize: result.pagination.pageSize,
                totalItems: result.pagination.totalItems,
                totalPages: result.pagination.totalPages,
                hasNextPage: result.pagination.hasNext,
                hasPreviousPage: result.pagination.hasPrevious,
                isFirstPage: false,
              )
              as PublicHolidaysState;
    } on AppException catch (e) {
      state = handleErrorState(state, e.message) as PublicHolidaysState;
    } catch (e) {
      state = handleErrorState(state, 'Failed to load more holidays: ${e.toString()}') as PublicHolidaysState;
    }
  }

  Future<void> goToPage(int page) async {
    if (_currentEnterpriseId == null) return;
    if (state.isLoading || page == state.currentPage || page < 1 || page > state.totalPages) return;

    state = handleLoadingState(state, false) as PublicHolidaysState;

    try {
      final result = await getHolidaysUseCase(
        tenantId: _currentEnterpriseId!,
        page: page,
        pageSize: state.pageSize,
        search: state.searchQuery,
        year: state.selectedYear,
        type: state.selectedType,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: result.holidays,
                currentPage: result.pagination.currentPage,
                pageSize: result.pagination.pageSize,
                totalItems: result.pagination.totalItems,
                totalPages: result.pagination.totalPages,
                hasNextPage: result.pagination.hasNext,
                hasPreviousPage: result.pagination.hasPrevious,
                isFirstPage: true,
              )
              as PublicHolidaysState;
    } on AppException catch (e) {
      state = handleErrorState(state, e.message) as PublicHolidaysState;
    } catch (e) {
      state = handleErrorState(state, 'Failed to load page $page: ${e.toString()}') as PublicHolidaysState;
    }
  }

  @override
  void reset() {
    state = PublicHolidaysState(pageSize: state.pageSize);
  }

  void setSearchQuery(String query) {
    final trimmedQuery = query.trim();
    if (state.searchQuery == trimmedQuery) return;

    state = state.copyWith(searchQuery: trimmedQuery, currentPage: 1);
    _debouncer.run(() async {
      await loadFirstPage();
    });
  }

  void clearSearch() {
    if (state.searchQuery == null || state.searchQuery!.isEmpty) return;
    state = state.copyWith(clearSearch: true, currentPage: 1);
    loadHolidays(refresh: true);
  }

  void setSelectedYear(String? year) {
    final normalized = year ?? PublicHolidaysConfig.defaultYear;
    if (state.selectedYear == normalized) return;
    state = state.copyWith(selectedYear: normalized, currentPage: 1);
    loadHolidays(refresh: true);
  }

  void setSelectedType(String? type) {
    if (state.selectedType == type) return;
    state = state.copyWith(selectedType: type, currentPage: 1);
    loadHolidays(refresh: true);
  }

  @override
  Future<void> refresh() async {
    await loadHolidays(refresh: true);
  }

  void addHolidayOptimistically(PublicHoliday holiday) {
    final newHolidays = [holiday, ...state.items];
    state = state.copyWith(items: newHolidays, totalItems: state.totalItems + 1);
  }

  void removeHolidayOptimistically(int holidayId) {
    state = state.copyWith(
      items: state.items.where((h) => h.id != holidayId).toList(),
      totalItems: state.totalItems > 0 ? state.totalItems - 1 : 0,
    );
  }

  Future<void> deleteHoliday(int holidayId, {bool hard = true}) async {
    if (_currentEnterpriseId == null) return;
    state = state.copyWith(deletingHolidayId: holidayId);

    try {
      await deleteHolidayUseCase.execute(holidayId, tenantId: _currentEnterpriseId!, hard: hard);
      state = state.copyWith(
        deletingHolidayId: null,
        deleteSuccessMessage: 'Holiday deleted successfully',
        items: state.items.where((h) => h.id != holidayId).toList(),
        totalItems: state.totalItems > 0 ? state.totalItems - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(deletingHolidayId: null, deleteErrorMessage: 'Failed to delete holiday: ${e.toString()}');
    }
  }

  void clearSideEffects() {
    state = state.copyWith(clearSideEffects: true);
  }

  PublicHoliday? getHolidayById(int holidayId) {
    try {
      return state.items.firstWhere((h) => h.id == holidayId);
    } catch (e) {
      return null;
    }
  }

  Future<void> createHoliday({
    required int tenantId,
    required String nameEn,
    String? nameAr,
    required DateTime date,
    required int year,
    required HolidayType type,
    required String descriptionEn,
    required String descriptionAr,
    required String appliesTo,
    required bool isPaid,
  }) async {
    try {
      final createdHoliday = await createHolidayUseCase.execute(
        tenantId: tenantId,
        nameEn: nameEn,
        nameAr: nameAr ?? '',
        date: date,
        year: year,
        type: type,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        appliesTo: appliesTo,
        isPaid: isPaid,
      );

      state = state.copyWith(
        items: [createdHoliday, ...state.items],
        totalItems: state.totalItems + 1,
        createSuccessMessage: 'Holiday created successfully',
      );
    } catch (e) {
      state = state.copyWith(createErrorMessage: 'Failed to create holiday: ${e.toString()}');
    }
  }

  Future<void> updateHoliday({
    required int holidayId,
    required int tenantId,
    required String nameEn,
    required String nameAr,
    required DateTime date,
    required int year,
    required HolidayType type,
    required String descriptionEn,
    required String descriptionAr,
    required String appliesTo,
    required bool isPaid,
  }) async {
    try {
      final updateUseCase = updateHolidayUseCase;
      await updateUseCase.execute(
        holidayId: holidayId,
        tenantId: tenantId,
        nameEn: nameEn,
        nameAr: nameAr,
        date: date,
        year: year,
        type: type,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        appliesTo: appliesTo,
        isPaid: isPaid,
      );

      await refresh();
      state = state.copyWith(createSuccessMessage: 'Holiday updated successfully');
    } catch (e) {
      state = state.copyWith(createErrorMessage: 'Failed to update holiday: ${e.toString()}');
    }
  }
}

final publicHolidaysNotifierProvider = StateNotifierProvider.family<PublicHolidaysNotifier, PublicHolidaysState, int>((
  ref,
  enterpriseId,
) {
  final getHolidaysUseCase = ref.watch(getPublicHolidaysUseCaseProvider(enterpriseId));
  final deleteHolidayUseCase = ref.watch(deletePublicHolidayUseCaseProvider(enterpriseId));
  final createHolidayUseCase = ref.watch(createPublicHolidayUseCaseProvider(enterpriseId));
  final updateHolidayUseCase = ref.watch(updatePublicHolidayUseCaseProvider(enterpriseId));
  return PublicHolidaysNotifier(
    getHolidaysUseCase: getHolidaysUseCase,
    deleteHolidayUseCase: deleteHolidayUseCase,
    createHolidayUseCase: createHolidayUseCase,
    updateHolidayUseCase: updateHolidayUseCase,
    enterpriseId: enterpriseId,
  );
});
