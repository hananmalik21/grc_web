import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/url_bytes_fetcher.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/employee_management/data/datasources/manage_employees_remote_data_source.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/data/repositories/manage_employees_list_repository_impl.dart';
import 'package:grc/features/employee_management/domain/repositories/manage_employees_list_repository.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_filters_state.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_state.dart';
import 'package:grc/features/employee_management/presentation/services/employee_documents_download_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _urlBytesFetcherProvider = Provider<UrlBytesFetcher>((ref) {
  return UrlBytesFetcher(dio: ref.watch(_apiClientProvider).dio);
});

final employeeDocumentsDownloadServiceProvider = Provider<EmployeeDocumentsDownloadService>((ref) {
  return EmployeeDocumentsDownloadService(urlBytesFetcher: ref.watch(_urlBytesFetcherProvider));
});

final manageEmployeesRemoteDataSourceProvider = Provider<ManageEmployeesRemoteDataSource>((ref) {
  return ManageEmployeesRemoteDataSourceImpl(apiClient: ref.watch(_apiClientProvider));
});

final manageEmployeesListRepositoryProvider = Provider<ManageEmployeesListRepository>((ref) {
  return ManageEmployeesListRepositoryImpl(remoteDataSource: ref.watch(manageEmployeesRemoteDataSourceProvider));
});

class ManageEmployeesListNotifier extends Notifier<ManageEmployeesListState> {
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  Debouncer? _searchDebouncer;

  @override
  ManageEmployeesListState build() {
    ref.onDispose(() {
      _searchDebouncer?.dispose();
      _searchDebouncer = null;
    });
    ref.listen<int?>(manageEmployeesEnterpriseIdProvider, (previous, next) {
      if (next == null) {
        state = state.copyWith(
          items: [],
          pagination: null,
          clearSearchQuery: true,
          lastEnterpriseId: null,
          isLoading: false,
        );
        return;
      }
      if (previous != next) {
        state = state.copyWith(
          items: [],
          pagination: null,
          clearSearchQuery: true,
          lastEnterpriseId: next,
          isLoading: true,
        );
        Future.microtask(() => loadPage(next, 1));
      }
    });
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    return ManageEmployeesListState(lastEnterpriseId: enterpriseId, isLoading: enterpriseId != null);
  }

  void prepareForTabLeave() {
    state = state.copyWith(isLoading: true, error: null, items: [], pagination: null);
  }

  Future<void> reloadOnOpen() async {
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(isLoading: false);
      return;
    }
    state = state.copyWith(isLoading: true, error: null, items: [], pagination: null);
    await loadPage(enterpriseId, 1);
  }

  void setSearchQueryInput(String value) {
    _searchDebouncer ??= Debouncer(delay: _searchDebounceDuration);
    final trimmed = value.trim();
    _searchDebouncer!.run(() => search(trimmed));
  }

  Future<void> loadPage(int enterpriseId, int page, {int pageSize = 10, String? search}) async {
    final filters = ref.read(manageEmployeesFiltersProvider);
    final isClearingSearch = search != null && search.trim().isEmpty;
    final effectiveSearch = isClearingSearch ? null : (search ?? state.searchQuery);

    state = state.copyWith(
      isLoading: true,
      error: null,
      lastEnterpriseId: enterpriseId,
      currentPage: page,
      searchQuery: effectiveSearch,
      clearSearchQuery: effectiveSearch == null,
    );
    final repository = ref.read(manageEmployeesListRepositoryProvider);
    final result = await repository.getEmployees(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: effectiveSearch,
      assignmentStatus: filters.assignmentStatus?.raw,
      positionId: filters.positionId,
      jobFamilyId: filters.jobFamilyId,
      jobLevelId: filters.jobLevelId,
      gradeId: filters.gradeId,
      orgUnitId: filters.orgUnitId,
      levelCode: filters.levelCode,
    );
    state = state.copyWith(
      items: result.items,
      pagination: result.pagination,
      isLoading: false,
      error: null,
      searchQuery: effectiveSearch,
    );
  }

  void search(String query) {
    _searchDebouncer?.dispose();
    _searchDebouncer = null;
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) return;
    final q = query.trim();

    loadPage(enterpriseId, 1, search: q.isEmpty ? '' : q);
  }

  Future<void> goToPage(int page, {int pageSize = 10}) async {
    final enterpriseId = state.lastEnterpriseId ?? ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) return;
    await loadPage(enterpriseId, page, pageSize: pageSize);
  }

  Future<void> refresh() async {
    final enterpriseId = state.lastEnterpriseId ?? ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) return;
    await loadPage(enterpriseId, state.currentPage);
  }

  void prependEmployee(EmployeeListItem item) {
    state = state.copyWith(items: [item, ...state.items]);
  }

  void replaceEmployee(EmployeeListItem updatedItem) {
    final id = updatedItem.id;
    if (id.isEmpty) return;
    final items = state.items.map((e) => e.id == id ? updatedItem : e).toList();
    state = state.copyWith(items: items);
  }
}

final manageEmployeesListProvider = NotifierProvider<ManageEmployeesListNotifier, ManageEmployeesListState>(
  ManageEmployeesListNotifier.new,
);
