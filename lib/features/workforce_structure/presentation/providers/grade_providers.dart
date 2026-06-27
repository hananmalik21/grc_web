import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/workforce_structure/data/datasources/grade_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/grade_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/repositories/grade_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_grade_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_grade_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_grades_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_grade_usecase.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gradeRemoteDataSourceProvider = Provider<GradeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GradeRemoteDataSourceImpl(apiClient: apiClient);
});

final gradeRepositoryProvider = Provider<GradeRepository>((ref) {
  return GradeRepositoryImpl(remoteDataSource: ref.read(gradeRemoteDataSourceProvider));
});

final getGradesUseCaseProvider = Provider<GetGradesUseCase>((ref) {
  return GetGradesUseCase(ref.read(gradeRepositoryProvider));
});

final createGradeUseCaseProvider = Provider<CreateGradeUseCase>((ref) {
  return CreateGradeUseCase(ref.read(gradeRepositoryProvider));
});

final deleteGradeUseCaseProvider = Provider<DeleteGradeUseCase>((ref) {
  return DeleteGradeUseCase(ref.read(gradeRepositoryProvider));
});

final updateGradeUseCaseProvider = Provider<UpdateGradeUseCase>((ref) {
  return UpdateGradeUseCase(ref.read(gradeRepositoryProvider));
});

class GradeState extends PaginationState<Grade> {
  final bool isCreating;
  final int? deletingGradeId;
  final int? updatingGradeId;

  const GradeState({
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
    this.isCreating = false,
    this.deletingGradeId,
    this.updatingGradeId,
  });

  @override
  GradeState copyWith({
    List<Grade>? items,
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
    bool? isCreating,
    int? deletingGradeId,
    bool clearDeletingGradeId = false,
    int? updatingGradeId,
    bool clearUpdatingGradeId = false,
  }) {
    return GradeState(
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
      isCreating: isCreating ?? this.isCreating,
      deletingGradeId: clearDeletingGradeId ? null : (deletingGradeId ?? this.deletingGradeId),
      updatingGradeId: clearUpdatingGradeId ? null : (updatingGradeId ?? this.updatingGradeId),
    );
  }
}

class GradeNotifier extends StateNotifier<GradeState>
    with PaginationMixin<Grade>
    implements PaginationController<Grade> {
  final GetGradesUseCase _getGradesUseCase;
  final CreateGradeUseCase _createGradeUseCase;
  final DeleteGradeUseCase _deleteGradeUseCase;
  final UpdateGradeUseCase _updateGradeUseCase;
  final _debouncer = Debouncer();
  final int? tenantId;

  GradeNotifier(
    this._getGradesUseCase,
    this._createGradeUseCase,
    this._deleteGradeUseCase,
    this._updateGradeUseCase,
    this.tenantId,
  ) : super(const GradeState());

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true) as GradeState;

    try {
      final response = await _getGradesUseCase.execute(
        page: 1,
        pageSize: state.pageSize,
        search: state.searchQuery,
        tenantId: tenantId,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: response.data,
                currentPage: response.meta.pagination.page,
                pageSize: response.meta.pagination.pageSize,
                totalItems: response.meta.pagination.total,
                totalPages: response.meta.pagination.totalPages,
                hasNextPage: response.meta.pagination.hasNext,
                hasPreviousPage: response.meta.pagination.hasPrevious,
                isFirstPage: true,
              )
              as GradeState;
    } catch (e) {
      state = handleErrorState(state, e.toString()) as GradeState;
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    final previousPage = state.currentPage;
    final nextPage = state.currentPage + 1;
    state = handleLoadingState(state, false).copyWith(isLoading: true, currentPage: nextPage) as GradeState;

    try {
      final response = await _getGradesUseCase.execute(
        page: nextPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
        tenantId: tenantId,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: response.data,
                currentPage: response.meta.pagination.page,
                pageSize: response.meta.pagination.pageSize,
                totalItems: response.meta.pagination.total,
                totalPages: response.meta.pagination.totalPages,
                hasNextPage: response.meta.pagination.hasNext,
                hasPreviousPage: response.meta.pagination.hasPrevious,
                isFirstPage: false,
              )
              as GradeState;
    } catch (e) {
      state = handleErrorState(state.copyWith(currentPage: previousPage), e.toString()) as GradeState;
    }
  }

  Future<void> goToPage(int targetPage) async {
    if (state.isLoading || state.currentPage == targetPage) return;

    state = handleLoadingState(state, true) as GradeState;

    try {
      final response = await _getGradesUseCase.execute(
        page: targetPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
        tenantId: tenantId,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: response.data,
                currentPage: response.meta.pagination.page,
                pageSize: response.meta.pagination.pageSize,
                totalItems: response.meta.pagination.total,
                totalPages: response.meta.pagination.totalPages,
                hasNextPage: response.meta.pagination.hasNext,
                hasPreviousPage: response.meta.pagination.hasPrevious,
                isFirstPage: true,
              )
              as GradeState;
    } catch (e) {
      state = handleErrorState(state, e.toString()) as GradeState;
    }
  }

  @override
  Future<void> refresh() async {
    reset();
    await loadFirstPage();
  }

  @override
  void reset() {
    state = const GradeState();
  }

  Future<void> createGrade(Grade grade) async {
    state = state.copyWith(isCreating: true);
    try {
      await _createGradeUseCase.execute(grade, tenantId: tenantId);
      state = state.copyWith(isCreating: false);
      refresh();
    } catch (e) {
      state = state.copyWith(isCreating: false);
      rethrow;
    }
  }

  Future<void> deleteGrade(int gradeId) async {
    state = state.copyWith(deletingGradeId: gradeId);
    try {
      await _deleteGradeUseCase.execute(gradeId, tenantId: tenantId);
      state = state.copyWith(
        items: state.items.where((g) => g.id != gradeId).toList(),
        totalItems: state.totalItems - 1,
        clearDeletingGradeId: true,
      );
    } catch (e) {
      state = state.copyWith(clearDeletingGradeId: true);
      rethrow;
    }
  }

  Future<void> updateGrade(int gradeId, Grade updatedGrade) async {
    state = state.copyWith(updatingGradeId: gradeId);
    try {
      await _updateGradeUseCase.execute(gradeId, updatedGrade, tenantId: tenantId);
      state = state.copyWith(clearUpdatingGradeId: true);
      refresh();
    } catch (e) {
      state = state.copyWith(clearUpdatingGradeId: true);
      rethrow;
    }
  }

  void search(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query, items: []);
    _debouncer.run(() => loadFirstPage());
  }

  void clearSearch() {
    search('');
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

final gradeNotifierProvider = StateNotifierProvider<GradeNotifier, GradeState>((ref) {
  final tenantId = ref.watch(gradeStructureEnterpriseIdProvider);
  final notifier = GradeNotifier(
    ref.read(getGradesUseCaseProvider),
    ref.read(createGradeUseCaseProvider),
    ref.read(deleteGradeUseCaseProvider),
    ref.read(updateGradeUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final gradeListProvider = Provider<List<Grade>>((ref) {
  return ref.watch(gradeNotifierProvider).items;
});

final gradeLoadingProvider = Provider<bool>((ref) {
  return ref.watch(gradeNotifierProvider).isLoading;
});

final gradeErrorProvider = Provider<String?>((ref) {
  return ref.watch(gradeNotifierProvider).errorMessage;
});

final gradeCreatingProvider = Provider<bool>((ref) {
  return ref.watch(gradeNotifierProvider).isCreating;
});

final gradesForJobLevelFormProvider = FutureProvider.autoDispose<List<Grade>>((ref) async {
  final enterpriseId = ref.watch(positionsEnterpriseIdProvider);
  if (enterpriseId == null) return [];
  final useCase = ref.read(getGradesUseCaseProvider);
  const pageSize = 500;
  final response = await useCase.execute(page: 1, pageSize: pageSize, tenantId: enterpriseId);
  List<Grade> all = List.from(response.data);
  for (int page = 2; page <= response.meta.pagination.totalPages; page++) {
    final next = await useCase.execute(page: page, pageSize: pageSize, tenantId: enterpriseId);
    all.addAll(next.data);
  }
  return all;
});

final allGradesForPositionFormProvider = FutureProvider.autoDispose<List<Grade>>((ref) async {
  final enterpriseId = ref.watch(positionsEnterpriseIdProvider);
  if (enterpriseId == null) return [];
  final useCase = ref.read(getGradesUseCaseProvider);
  const pageSize = 500;
  final response = await useCase.execute(page: 1, pageSize: pageSize, tenantId: enterpriseId);
  List<Grade> all = List.from(response.data);
  for (int page = 2; page <= response.meta.pagination.totalPages; page++) {
    final next = await useCase.execute(page: page, pageSize: pageSize, tenantId: enterpriseId);
    all.addAll(next.data);
  }
  return all;
});

int? _gradeNumberFromGradeNumber(String gradeNumber) {
  final match = RegExp(r'\d+$').firstMatch(gradeNumber);
  if (match == null) return null;
  return int.tryParse(match.group(0)!);
}

bool _isGradeInRange(Grade g, Grade minGrade, Grade maxGrade) {
  if (g.gradeCategory != minGrade.gradeCategory) return false;
  final gNum = _gradeNumberFromGradeNumber(g.gradeNumber);
  final minNum = _gradeNumberFromGradeNumber(minGrade.gradeNumber);
  final maxNum = _gradeNumberFromGradeNumber(maxGrade.gradeNumber);
  if (gNum == null || minNum == null || maxNum == null) return false;
  return gNum >= minNum && gNum <= maxNum;
}

List<Grade> _filterAndSortGradesInRange(List<Grade> all, Grade minGrade, Grade maxGrade) {
  final filtered = all.where((g) => _isGradeInRange(g, minGrade, maxGrade)).toList();
  filtered.sort((a, b) {
    final aNum = _gradeNumberFromGradeNumber(a.gradeNumber) ?? 0;
    final bNum = _gradeNumberFromGradeNumber(b.gradeNumber) ?? 0;
    return aNum.compareTo(bNum);
  });
  return filtered;
}

final gradesInRangeForPositionFormProvider = FutureProvider.autoDispose<List<Grade>>((ref) async {
  final all = await ref.watch(gradesForJobLevelFormProvider.future);

  final jobLevel = ref.watch(positionFormNotifierProvider.select((state) => state.jobLevel));
  if (jobLevel == null) return [];

  Grade? minGrade = jobLevel.minGrade ?? all.where((g) => g.id == jobLevel.minGradeId).firstOrNull;
  Grade? maxGrade = jobLevel.maxGrade ?? all.where((g) => g.id == jobLevel.maxGradeId).firstOrNull;

  if (minGrade == null || maxGrade == null) return [];
  return _filterAndSortGradesInRange(all, minGrade, maxGrade);
});

final resolvedGradeForPositionFormProvider = Provider.autoDispose<Grade?>((ref) {
  final formGrade = ref.watch(positionFormNotifierProvider.select((s) => s.grade));
  if (formGrade == null) return null;
  final gradesInRangeAsync = ref.watch(gradesInRangeForPositionFormProvider);
  final gradeFromRange = gradesInRangeAsync.whenOrNull(
    data: (grades) => grades.where((g) => g.id == formGrade.id).firstOrNull,
  );
  if (gradeFromRange != null) return gradeFromRange;
  final allGradesAsync = ref.watch(allGradesForPositionFormProvider);
  return allGradesAsync.whenOrNull(data: (all) => all.where((g) => g.id == formGrade.id).firstOrNull) ?? formGrade;
});

String _formatBudgetValue(String value) {
  if (value.trim().isEmpty) return value;
  final parsed = double.tryParse(value.trim());
  return parsed != null ? parsed.toStringAsFixed(2) : value;
}

final effectiveBudgetForPositionFormProvider =
    Provider.autoDispose<({String budgetedMin, String budgetedMax, String actualAverage})>((ref) {
      final formState = ref.watch(positionFormNotifierProvider);
      return (
        budgetedMin: _formatBudgetValue(formState.budgetedMin),
        budgetedMax: _formatBudgetValue(formState.budgetedMax),
        actualAverage: _formatBudgetValue(formState.actualAverage),
      );
    });

bool _gradeHasStepSalaries(Grade g) => g.minSalary > 0;

final selectedStepsForPositionFormProvider = Provider.autoDispose<List<GradeStep>>((ref) {
  final formState = ref.watch(positionFormNotifierProvider);
  final resolvedGrade = ref.watch(resolvedGradeForPositionFormProvider);
  final minStr = formState.minStep;
  final maxStr = formState.maxStep;
  if (minStr == null || minStr.isEmpty) return [];
  final minNo = int.tryParse(minStr.replaceAll(RegExp(r'[^0-9]'), ''));
  if (minNo == null || minNo < 1 || minNo > 5) return [];
  final maxNo = (maxStr != null && maxStr.isNotEmpty)
      ? (int.tryParse(maxStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? minNo)
      : minNo;
  if (resolvedGrade == null || !_gradeHasStepSalaries(resolvedGrade)) return [];
  return resolvedGrade.steps.where((s) => s.step >= minNo && s.step <= maxNo).toList();
});
