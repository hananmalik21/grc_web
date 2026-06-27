import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/workforce_structure/data/datasources/employee_remote_data_source.dart';
import 'package:grc/features/workforce_structure/data/repositories/employee_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/domain/repositories/employee_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final employeeRemoteDataSourceProvider = Provider<EmployeeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EmployeeRemoteDataSourceImpl(apiClient: apiClient);
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl(remoteDataSource: ref.read(employeeRemoteDataSourceProvider));
});

// Employee State
class EmployeeState {
  final List<Employee> employees;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final int pageSize;
  final int total;
  final bool hasNext;
  final bool hasPrevious;
  final String? searchQuery;
  final int? enterpriseId;

  const EmployeeState({
    this.employees = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 1,
    this.pageSize = 10,
    this.total = 0,
    this.hasNext = false,
    this.hasPrevious = false,
    this.searchQuery,
    this.enterpriseId,
  });

  EmployeeState copyWith({
    List<Employee>? employees,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? total,
    bool? hasNext,
    bool? hasPrevious,
    String? searchQuery,
    int? enterpriseId,
    bool clearEmployees = false,
  }) {
    return EmployeeState(
      employees: clearEmployees ? [] : (employees ?? this.employees),
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      searchQuery: searchQuery ?? this.searchQuery,
      enterpriseId: enterpriseId ?? this.enterpriseId,
    );
  }
}

// Employee Notifier
class EmployeeNotifier extends StateNotifier<EmployeeState> {
  final EmployeeRepository repository;

  EmployeeNotifier({required this.repository}) : super(const EmployeeState());

  Future<void> loadEmployees({required int enterpriseId, String? search, int page = 1, bool append = false}) async {
    if (!append) {
      state = state.copyWith(isLoading: true, hasError: false, errorMessage: null, clearEmployees: true);
    }

    try {
      final result = await repository.getEmployees(
        enterpriseId: enterpriseId,
        search: search,
        page: page,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        employees: append ? [...state.employees, ...result.employees] : result.employees,
        isLoading: false,
        hasError: false,
        currentPage: result.pagination.currentPage,
        total: result.pagination.totalItems,
        hasNext: result.pagination.hasNext,
        hasPrevious: result.pagination.hasPrevious,
        searchQuery: search,
        enterpriseId: enterpriseId,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load employees: ${e.toString()}',
      );
    }
  }

  Future<void> searchEmployees({required int enterpriseId, String? search}) async {
    await loadEmployees(enterpriseId: enterpriseId, search: search, page: 1);
  }

  Future<void> loadNextPage() async {
    if (!state.hasNext || state.isLoading) return;

    await loadEmployees(
      enterpriseId: state.enterpriseId!,
      search: state.searchQuery,
      page: state.currentPage + 1,
      append: true,
    );
  }

  Future<void> refresh() async {
    if (state.enterpriseId != null) {
      await loadEmployees(enterpriseId: state.enterpriseId!, search: state.searchQuery, page: state.currentPage);
    }
  }
}

// Global Employee Provider
final employeeNotifierProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>((ref) {
  final repository = ref.watch(employeeRepositoryProvider);
  return EmployeeNotifier(repository: repository);
});

// Convenience Providers
final employeesListProvider = Provider<List<Employee>>((ref) {
  return ref.watch(employeeNotifierProvider).employees;
});

final employeesLoadingProvider = Provider<bool>((ref) {
  return ref.watch(employeeNotifierProvider).isLoading;
});

final employeesErrorProvider = Provider<String?>((ref) {
  return ref.watch(employeeNotifierProvider).errorMessage;
});
