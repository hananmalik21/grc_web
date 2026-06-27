import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/security_manager/data/repositories/function_roles/function_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/usecases/get_function_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobRoleFunctionRolesSelectionState {
  const JobRoleFunctionRolesSelectionState({
    this.roles = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.currentPage = 1,
    this.pageSize = 20,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.total = 0,
    this.codeToIdCache = const {},
  });

  final List<FunctionRoleItem> roles;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final int total;

  /// Accumulated code→id map across all fetched pages, used at submit time.
  final Map<String, String> codeToIdCache;

  int get safeCurrentPage => currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);

  List<FunctionRoleItem> get paginatedRoles => roles;

  List<FunctionRoleItem> get filteredRoles => roles;

  JobRoleFunctionRolesSelectionState copyWith({
    List<FunctionRoleItem>? roles,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? searchQuery,
    int? currentPage,
    int? pageSize,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    int? total,
    Map<String, String>? codeToIdCache,
  }) {
    return JobRoleFunctionRolesSelectionState(
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      total: total ?? this.total,
      codeToIdCache: codeToIdCache ?? this.codeToIdCache,
    );
  }
}

class JobRoleFunctionRolesSelectionNotifier extends StateNotifier<JobRoleFunctionRolesSelectionState> {
  JobRoleFunctionRolesSelectionNotifier(this._useCase, this._ref) : super(const JobRoleFunctionRolesSelectionState());

  final GetFunctionRolesUseCase _useCase;
  final Ref _ref;
  final _debouncer = Debouncer();

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> refresh() => _fetchPage(1, resetSearch: true);

  Future<void> _fetchPage(int page, {bool resetSearch = false}) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(isLoading: false, roles: const [], error: 'Select an enterprise to load function roles');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true, currentPage: page);

    try {
      final search = resetSearch ? null : (state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim());
      final result = await _useCase(
        enterpriseId: enterpriseId,
        search: search,
        page: page,
        pageSize: state.pageSize,
      );
      final items = result.roles.map(FunctionRoleItem.fromFunctionRole).toList();
      final newCache = {
        ...state.codeToIdCache,
        for (final r in items) r.code: r.id,
      };
      state = state.copyWith(
        roles: items,
        isLoading: false,
        currentPage: result.page,
        totalPages: result.totalPages,
        hasNext: result.hasNext,
        hasPrevious: result.hasPrevious,
        total: result.total,
        codeToIdCache: newCache,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load function roles: ${e.toString()}');
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
    _debouncer.run(() => _fetchPage(1));
  }

  void goToPage(int page) => _fetchPage(page.clamp(1, state.totalPages));

  void nextPage() => goToPage(state.safeCurrentPage + 1);

  void previousPage() => goToPage(state.safeCurrentPage - 1);
}

final jobRoleFunctionRolesSelectionProvider =
    StateNotifierProvider.autoDispose<JobRoleFunctionRolesSelectionNotifier, JobRoleFunctionRolesSelectionState>((ref) {
      final client = ApiClient(baseUrl: ApiConfig.baseUrl);
      final repository = FunctionRolesRepositoryImpl(client);
      final useCase = GetFunctionRolesUseCase(repository);
      return JobRoleFunctionRolesSelectionNotifier(useCase, ref);
    });
