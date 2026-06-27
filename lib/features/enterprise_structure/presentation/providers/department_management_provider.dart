import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/department.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_departments_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for department list with pagination
class DepartmentListState {
  final List<DepartmentOverview> departments;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final bool hasError;
  final PaginationInfo? pagination;
  final int total;
  final int currentPage;
  final int pageSize;
  final String? searchQuery;

  const DepartmentListState({
    this.departments = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.hasError = false,
    this.pagination,
    this.total = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.searchQuery,
  });

  DepartmentListState copyWith({
    List<DepartmentOverview>? departments,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool? hasError,
    PaginationInfo? pagination,
    int? total,
    int? currentPage,
    int? pageSize,
    String? searchQuery,
  }) {
    return DepartmentListState(
      departments: departments ?? this.departments,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      pagination: pagination ?? this.pagination,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasMore => pagination?.hasNext ?? false;
  bool get hasPrevious => pagination?.hasPrevious ?? false;
}

/// Notifier for department list with pagination
class DepartmentListNotifier extends StateNotifier<DepartmentListState> {
  final GetDepartmentsUseCase getDepartmentsUseCase;
  bool _isDisposed = false;

  DepartmentListNotifier({required this.getDepartmentsUseCase})
      : super(const DepartmentListState()) {
    Future.microtask(() {
      if (!_isDisposed) {
        loadDepartments();
      }
    });
  }

  /// Constructor with custom page size
  DepartmentListNotifier.withPageSize({
    required this.getDepartmentsUseCase,
    int pageSize = 1000,
  }) : super(DepartmentListState(pageSize: pageSize)) {
    Future.microtask(() {
      if (!_isDisposed) {
        loadDepartments();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Load departments for the first page
  Future<void> loadDepartments({bool refresh = false, String? search}) async {
    if (_isDisposed) return;

    final searchQuery = search ?? state.searchQuery;

    if (refresh) {
      if (_isDisposed) return;
      state = state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: null,
        currentPage: 1,
        searchQuery: searchQuery,
      );
    } else if (state.isLoading) {
      return; // Already loading
    } else {
      if (_isDisposed) return;
      state = state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: null,
        searchQuery: searchQuery,
      );
    }

    try {
      final result = await getDepartmentsUseCase(
        search: searchQuery?.isEmpty == true ? null : searchQuery,
        page: refresh ? 1 : state.currentPage,
        pageSize: state.pageSize,
      );

      if (_isDisposed) return;

      try {
        state = state.copyWith(
          departments: result.departments,
          pagination: result.pagination,
          total: result.total,
          isLoading: false,
          hasError: false,
          currentPage: result.pagination.page,
        );
      } catch (e) {
        if (!_isDisposed) rethrow;
      }
    } on AppException catch (e) {
      if (_isDisposed) return;
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: e.message,
        );
      } catch (_) {
        // Ignore if disposed
      }
    } catch (e) {
      if (_isDisposed) return;
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Failed to load departments: ${e.toString()}',
        );
      } catch (_) {
        // Ignore if disposed
      }
    }
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await getDepartmentsUseCase(
        search: state.searchQuery?.isEmpty == true ? null : state.searchQuery,
        page: nextPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        departments: [...state.departments, ...result.departments],
        pagination: result.pagination,
        total: result.total,
        isLoadingMore: false,
        currentPage: nextPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load more departments: ${e.toString()}',
      );
    }
  }

  /// Load previous page
  Future<void> loadPreviousPage() async {
    if (state.isLoading || !state.hasPrevious) return;

    state = state.copyWith(isLoading: true);

    try {
      final previousPage = state.currentPage - 1;
      final result = await getDepartmentsUseCase(
        search: state.searchQuery?.isEmpty == true ? null : state.searchQuery,
        page: previousPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        departments: result.departments,
        pagination: result.pagination,
        total: result.total,
        isLoading: false,
        currentPage: previousPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load departments: ${e.toString()}',
      );
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    await loadDepartments(refresh: true);
  }

  /// Search departments
  Future<void> search(String query) async {
    await loadDepartments(refresh: true, search: query);
  }
}

/// Provider for department list notifier
final departmentListNotifierProvider =
    StateNotifierProvider.autoDispose<DepartmentListNotifier, DepartmentListState>(
  (ref) {
    final getDepartmentsUseCase = ref.watch(getDepartmentsUseCaseProvider);
    return DepartmentListNotifier(getDepartmentsUseCase: getDepartmentsUseCase);
  },
);

/// Legacy provider for backward compatibility (returns list directly)
final departmentListProvider = Provider<List<DepartmentOverview>>((ref) {
  final state = ref.watch(departmentListNotifierProvider);
  return state.departments;
});

final departmentSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for filtered departments with search
final filteredDepartmentProvider = Provider<List<DepartmentOverview>>((ref) {
  final state = ref.watch(departmentListNotifierProvider);
  final query = ref.watch(departmentSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return state.departments;

  return state.departments.where((department) {
    return department.name.toLowerCase().contains(query) ||
        department.code.toLowerCase().contains(query) ||
        department.headName.toLowerCase().contains(query);
  }).toList();
});
