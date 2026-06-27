import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/domain/repositories/employee_repository.dart';
import 'package:grc/features/workforce_structure/presentation/providers/employee_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCompensationPlanAssignmentEmployeesState {
  final List<Employee> employees;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final String? searchQuery;
  final int? enterpriseId;

  const CreateCompensationPlanAssignmentEmployeesState({
    this.employees = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.totalPages = 0,
    this.hasNext = false,
    this.hasPrevious = false,
    this.searchQuery,
    this.enterpriseId,
  });

  CreateCompensationPlanAssignmentEmployeesState copyWith({
    List<Employee>? employees,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    String? searchQuery,
    int? enterpriseId,
    bool clearEmployees = false,
  }) {
    return CreateCompensationPlanAssignmentEmployeesState(
      employees: clearEmployees ? const [] : (employees ?? this.employees),
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      searchQuery: searchQuery ?? this.searchQuery,
      enterpriseId: enterpriseId ?? this.enterpriseId,
    );
  }
}

class CreateCompensationPlanAssignmentEmployeesNotifier
    extends StateNotifier<CreateCompensationPlanAssignmentEmployeesState> {
  final EmployeeRepository _repository;
  final Map<int, Employee> _cacheById = <int, Employee>{};

  CreateCompensationPlanAssignmentEmployeesNotifier({required EmployeeRepository repository})
    : _repository = repository,
      super(const CreateCompensationPlanAssignmentEmployeesState());

  Future<void> loadEmployees({required int enterpriseId, String? search, int page = 1}) async {
    final isFirstPage = page == 1;
    final currentEnterpriseId = state.enterpriseId;
    final shouldResetCache = currentEnterpriseId != null && currentEnterpriseId != enterpriseId;

    if (shouldResetCache) {
      _cacheById.clear();
    }

    state = state.copyWith(
      currentPage: page,
      isLoading: isFirstPage,
      isLoadingMore: !isFirstPage,
      hasError: false,
      errorMessage: null,
      enterpriseId: enterpriseId,
      searchQuery: search,
      clearEmployees: isFirstPage,
    );

    try {
      final result = await _repository.getEmployees(
        enterpriseId: enterpriseId,
        search: search,
        page: page,
        pageSize: state.pageSize,
      );

      for (final employee in result.employees) {
        _cacheById[employee.id] = employee;
      }

      state = state.copyWith(
        employees: result.employees,
        isLoading: false,
        isLoadingMore: false,
        hasError: false,
        errorMessage: null,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.total,
        totalPages: result.pagination.totalPages,
        hasNext: result.pagination.hasNext,
        hasPrevious: result.pagination.hasPrevious,
        searchQuery: search,
        enterpriseId: enterpriseId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load employees: ${e.toString()}',
      );
    }
  }

  Future<void> searchEmployees({required int enterpriseId, String? search}) async {
    await loadEmployees(enterpriseId: enterpriseId, search: search, page: 1);
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNext || state.enterpriseId == null) return;

    final previousPage = state.currentPage;
    final nextPage = state.currentPage + 1;
    state = state.copyWith(
      currentPage: nextPage,
      isLoading: true,
      isLoadingMore: false,
      hasError: false,
      errorMessage: null,
    );

    try {
      final result = await _repository.getEmployees(
        enterpriseId: state.enterpriseId!,
        search: state.searchQuery,
        page: nextPage,
        pageSize: state.pageSize,
      );

      for (final employee in result.employees) {
        _cacheById[employee.id] = employee;
      }

      state = state.copyWith(
        employees: result.employees,
        isLoading: false,
        isLoadingMore: false,
        hasError: false,
        errorMessage: null,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.total,
        totalPages: result.pagination.totalPages,
        hasNext: result.pagination.hasNext,
        hasPrevious: result.pagination.hasPrevious,
        searchQuery: state.searchQuery,
        enterpriseId: state.enterpriseId,
      );
    } catch (e) {
      state = state.copyWith(
        currentPage: previousPage,
        isLoading: false,
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load employees: ${e.toString()}',
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (state.enterpriseId == null ||
        state.isLoading ||
        page == state.currentPage ||
        page < 1 ||
        page > state.totalPages) {
      return;
    }

    final previousPage = state.currentPage;
    state = state.copyWith(
      currentPage: page,
      isLoading: true,
      isLoadingMore: false,
      hasError: false,
      errorMessage: null,
    );

    try {
      final result = await _repository.getEmployees(
        enterpriseId: state.enterpriseId!,
        search: state.searchQuery,
        page: page,
        pageSize: state.pageSize,
      );

      for (final employee in result.employees) {
        _cacheById[employee.id] = employee;
      }

      state = state.copyWith(
        employees: result.employees,
        isLoading: false,
        isLoadingMore: false,
        hasError: false,
        errorMessage: null,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.total,
        totalPages: result.pagination.totalPages,
        hasNext: result.pagination.hasNext,
        hasPrevious: result.pagination.hasPrevious,
        searchQuery: state.searchQuery,
        enterpriseId: state.enterpriseId,
      );
    } catch (e) {
      state = state.copyWith(
        currentPage: previousPage,
        isLoading: false,
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load employees: ${e.toString()}',
      );
    }
  }

  List<Employee> resolveEmployeesByIds(Iterable<String> ids) {
    final selected = <Employee>[];
    for (final id in ids) {
      final parsedId = int.tryParse(id);
      if (parsedId == null) continue;
      final employee = _cacheById[parsedId];
      if (employee != null) {
        selected.add(employee);
      }
    }
    return selected;
  }
}

final createCompensationPlanAssignmentEmployeesNotifierProvider =
    StateNotifierProvider.autoDispose<
      CreateCompensationPlanAssignmentEmployeesNotifier,
      CreateCompensationPlanAssignmentEmployeesState
    >((ref) {
      final repository = ref.read(employeeRepositoryProvider);
      return CreateCompensationPlanAssignmentEmployeesNotifier(repository: repository);
    });
