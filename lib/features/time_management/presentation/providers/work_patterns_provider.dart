import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/time_management/data/datasources/work_pattern_remote_datasource.dart';
import 'package:grc/features/time_management/data/repositories/work_pattern_repository_impl.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/domain/repositories/work_pattern_repository.dart';
import 'package:grc/features/time_management/domain/usecases/create_work_pattern_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/delete_work_pattern_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/get_work_patterns_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/update_work_pattern_usecase.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/providers/work_pattern_create_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workPatternRemoteDataSourceProvider = Provider<WorkPatternRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkPatternRemoteDataSourceImpl(apiClient: apiClient);
});

final workPatternRepositoryProvider = Provider.family<WorkPatternRepository, int>((ref, enterpriseId) {
  final remoteDataSource = ref.watch(workPatternRemoteDataSourceProvider);
  return WorkPatternRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: enterpriseId);
});

final getWorkPatternsUseCaseProvider = Provider.family<GetWorkPatternsUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workPatternRepositoryProvider(enterpriseId));
  return GetWorkPatternsUseCase(repository: repository);
});

final createWorkPatternUseCaseProvider = Provider.family<CreateWorkPatternUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workPatternRepositoryProvider(enterpriseId));
  return CreateWorkPatternUseCase(repository: repository);
});

final deleteWorkPatternUseCaseProvider = Provider.family<DeleteWorkPatternUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workPatternRepositoryProvider(enterpriseId));
  return DeleteWorkPatternUseCase(repository: repository);
});

final updateWorkPatternUseCaseProvider = Provider.family<UpdateWorkPatternUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workPatternRepositoryProvider(enterpriseId));
  return UpdateWorkPatternUseCase(repository: repository);
});

class WorkPatternState extends PaginationState<WorkPattern> {
  const WorkPatternState({
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
  });

  @override
  WorkPatternState copyWith({
    List<WorkPattern>? items,
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
  }) {
    return WorkPatternState(
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
    );
  }
}

final workPatternsNotifierProvider = StateNotifierProvider.family<WorkPatternsNotifier, WorkPatternState, int>((
  ref,
  enterpriseId,
) {
  return WorkPatternsNotifier(
    ref.read(getWorkPatternsUseCaseProvider(enterpriseId)),
    ref.read(createWorkPatternUseCaseProvider(enterpriseId)),
    ref.read(updateWorkPatternUseCaseProvider(enterpriseId)),
    ref.read(deleteWorkPatternUseCaseProvider(enterpriseId)),
    ref,
  );
});

class WorkPatternsNotifier extends StateNotifier<WorkPatternState>
    with PaginationMixin<WorkPattern>
    implements PaginationController<WorkPattern> {
  final GetWorkPatternsUseCase _getWorkPatternsUseCase;
  final CreateWorkPatternUseCase _createWorkPatternUseCase;
  final UpdateWorkPatternUseCase _updateWorkPatternUseCase;
  final DeleteWorkPatternUseCase _deleteWorkPatternUseCase;
  int? _currentEnterpriseId;
  final Ref _ref;

  WorkPatternsNotifier(
    this._getWorkPatternsUseCase,
    this._createWorkPatternUseCase,
    this._updateWorkPatternUseCase,
    this._deleteWorkPatternUseCase,
    this._ref,
  ) : super(const WorkPatternState());

  String? validateCreateInputs({
    required String patternCode,
    required String patternNameEn,
    required String? patternNameAr,
    required String? patternType,
    required int totalHoursPerWeek,
  }) {
    if (patternCode.trim().isEmpty) {
      return 'Pattern code is required';
    }

    if (patternNameEn.trim().isEmpty) {
      return 'Pattern name (English) is required';
    }

    if (patternType == null || patternType.trim().isEmpty) {
      return 'Pattern type is required';
    }

    if (totalHoursPerWeek <= 0) {
      return 'Total hours per week must be greater than 0';
    }

    return null;
  }

  String? validateUpdateInputs({
    required String patternNameEn,
    required String? patternNameAr,
    required String? patternType,
    required int totalHoursPerWeek,
  }) {
    if (patternNameEn.trim().isEmpty) {
      return 'Pattern name (English) is required';
    }

    if (patternType == null || patternType.trim().isEmpty) {
      return 'Pattern type is required';
    }

    if (totalHoursPerWeek <= 0 || totalHoursPerWeek > 168) {
      return 'Please enter a valid number of hours per week (1-168)';
    }

    return null;
  }

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
    state = WorkPatternState(
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
      final result = await _getWorkPatternsUseCase(page: 1, pageSize: state.pageSize);

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.workPatterns,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: true,
      );
      state = WorkPatternState(
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
      state = WorkPatternState(
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

    final loadingState = handleLoadingState(state, false);
    state = WorkPatternState(
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
      final nextPage = state.currentPage + 1;
      final result = await _getWorkPatternsUseCase(page: nextPage, pageSize: state.pageSize);

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.workPatterns,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: false,
      );
      state = WorkPatternState(
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
      state = WorkPatternState(
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

  Future<void> goToPage(int page) async {
    if (state.isLoading || page == state.currentPage || page < 1 || page > state.totalPages) return;

    final loadingState = handleLoadingState(state, false);
    state = WorkPatternState(
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
      final result = await _getWorkPatternsUseCase(page: page, pageSize: state.pageSize);

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.workPatterns,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: true,
      );
      state = WorkPatternState(
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
      state = WorkPatternState(
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
  void reset() {
    state = const WorkPatternState();
  }

  /// Create a work pattern with optimistic update
  Future<WorkPattern> createWorkPattern(
    WidgetRef ref, {
    required String patternCode,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    ref.read(workPatternCreateStateProvider.notifier).state = const WorkPatternCreateState(isCreating: true);

    try {
      final createdPattern = await _createWorkPatternUseCase.execute(
        patternCode: patternCode,
        patternNameEn: patternNameEn,
        patternNameAr: patternNameAr,
        patternType: patternType,
        totalHoursPerWeek: totalHoursPerWeek,
        status: status,
        days: days,
      );

      ref.read(workPatternCreateStateProvider.notifier).state = const WorkPatternCreateState(isCreating: false);
      state = state.copyWith(items: [createdPattern, ...state.items], totalItems: state.totalItems + 1);
      ref.read(timeManagementStatsNotifierProvider.notifier).refresh();

      return createdPattern;
    } catch (e) {
      ref.read(workPatternCreateStateProvider.notifier).state = WorkPatternCreateState(
        isCreating: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Update a work pattern
  Future<WorkPattern> updateWorkPattern({
    required int workPatternId,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    try {
      final updatedPattern = await _updateWorkPatternUseCase.execute(
        workPatternId: workPatternId,
        patternNameEn: patternNameEn,
        patternNameAr: patternNameAr,
        patternType: patternType,
        totalHoursPerWeek: totalHoursPerWeek,
        status: status,
        days: days,
      );
      state = state.copyWith(
        items: state.items.map((p) => p.workPatternId == workPatternId ? updatedPattern : p).toList(),
      );

      return updatedPattern;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a work pattern - wait for API response before updating list
  Future<void> deleteWorkPattern({required int workPatternId, required bool hard}) async {
    try {
      await _deleteWorkPatternUseCase.execute(workPatternId: workPatternId, hard: hard);

      state = state.copyWith(
        items: state.items.where((p) => p.workPatternId != workPatternId).toList(),
        totalItems: state.totalItems - 1,
      );

      _ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
    } catch (e) {
      rethrow;
    }
  }
}

class WorkPatternDaysState {
  const WorkPatternDaysState({
    this.workingDays = const <int>{},
    this.restDays = const <int>{},
    this.offDays = const <int>{},
  });

  final Set<int> workingDays;
  final Set<int> restDays;
  final Set<int> offDays;

  WorkPatternDaysState copyWith({Set<int>? workingDays, Set<int>? restDays, Set<int>? offDays}) {
    return WorkPatternDaysState(
      workingDays: workingDays ?? this.workingDays,
      restDays: restDays ?? this.restDays,
      offDays: offDays ?? this.offDays,
    );
  }
}

class WorkPatternDaysNotifier extends StateNotifier<WorkPatternDaysState> {
  WorkPatternDaysNotifier() : super(const WorkPatternDaysState());

  void initializeFromDays(List<WorkPatternDay> days) {
    final working = <int>{};
    final rest = <int>{};
    final off = <int>{};

    for (final day in days) {
      switch (day.dayType) {
        case 'WORK':
          working.add(day.dayOfWeek);
          break;
        case 'REST':
          rest.add(day.dayOfWeek);
          break;
        case 'OFF':
          off.add(day.dayOfWeek);
          break;
        default:
          break;
      }
    }

    state = WorkPatternDaysState(workingDays: working, restDays: rest, offDays: off);
  }

  void toggleWorkingDay(int dayNumber) {
    final working = Set<int>.from(state.workingDays);
    final rest = Set<int>.from(state.restDays);
    final off = Set<int>.from(state.offDays);
    if (working.contains(dayNumber)) {
      working.remove(dayNumber);
    } else {
      working.add(dayNumber);
      rest.remove(dayNumber);
      off.remove(dayNumber);
    }
    state = WorkPatternDaysState(workingDays: working, restDays: rest, offDays: off);
  }

  void toggleRestDay(int dayNumber) {
    final working = Set<int>.from(state.workingDays);
    final rest = Set<int>.from(state.restDays);
    final off = Set<int>.from(state.offDays);
    if (rest.contains(dayNumber)) {
      rest.remove(dayNumber);
    } else {
      rest.add(dayNumber);
      working.remove(dayNumber);
      off.remove(dayNumber);
    }
    state = WorkPatternDaysState(workingDays: working, restDays: rest, offDays: off);
  }

  void toggleOffDay(int dayNumber) {
    final working = Set<int>.from(state.workingDays);
    final rest = Set<int>.from(state.restDays);
    final off = Set<int>.from(state.offDays);
    if (off.contains(dayNumber)) {
      off.remove(dayNumber);
    } else {
      off.add(dayNumber);
      working.remove(dayNumber);
      rest.remove(dayNumber);
    }
    state = WorkPatternDaysState(workingDays: working, restDays: rest, offDays: off);
  }

  void reset() {
    state = const WorkPatternDaysState();
  }
}

final workPatternDaysProvider = StateNotifierProvider.autoDispose
    .family<WorkPatternDaysNotifier, WorkPatternDaysState, int>((ref, enterpriseId) => WorkPatternDaysNotifier());

const String workPatternTypeLookupCode = 'PATTERN_TYPE';

class WorkPatternTypeState {
  const WorkPatternTypeState({this.selectedCode});

  final String? selectedCode;

  WorkPatternTypeState copyWith({String? selectedCode}) {
    return WorkPatternTypeState(selectedCode: selectedCode ?? this.selectedCode);
  }
}

class WorkPatternTypeNotifier extends StateNotifier<WorkPatternTypeState> {
  WorkPatternTypeNotifier() : super(const WorkPatternTypeState());

  void setSelectedCode(String? code) {
    state = state.copyWith(selectedCode: code);
  }
}

final workPatternTypeProvider = StateNotifierProvider.autoDispose
    .family<WorkPatternTypeNotifier, WorkPatternTypeState, int>((ref, enterpriseId) => WorkPatternTypeNotifier());

EmplLookupValue? _workPatternTypeByCode(String? code, List<EmplLookupValue> values) {
  if (code == null || code.isEmpty) return null;
  try {
    return values.firstWhere((v) => v.lookupCode == code);
  } catch (_) {
    return null;
  }
}

class WorkPatternTypeViewState {
  const WorkPatternTypeViewState({
    required this.items,
    required this.isLoading,
    required this.selected,
    required this.requiredWorkingDays,
  });

  final List<EmplLookupValue> items;
  final bool isLoading;
  final EmplLookupValue? selected;
  final int? requiredWorkingDays;
}

int? _requiredWorkingDaysForPatternLabel(String? patternLabel) {
  if (patternLabel == null || patternLabel.isEmpty) return null;
  final match = RegExp(r'^(\d+)').firstMatch(patternLabel.trim());
  if (match == null) return 0;
  return int.tryParse(match.group(1) ?? '');
}

final workPatternTypeViewProvider = Provider.autoDispose.family<WorkPatternTypeViewState, int>((ref, enterpriseId) {
  final typeState = ref.watch(workPatternTypeProvider(enterpriseId));
  final lookupAsync = ref.watch(
    entLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: workPatternTypeLookupCode)),
  );
  final items = lookupAsync.valueOrNull ?? <EmplLookupValue>[];
  final selected = _workPatternTypeByCode(typeState.selectedCode, items);
  final requiredWorkingDays = _requiredWorkingDaysForPatternLabel(selected?.meaningEn);

  return WorkPatternTypeViewState(
    items: items,
    isLoading: lookupAsync.isLoading,
    selected: selected,
    requiredWorkingDays: requiredWorkingDays,
  );
});
