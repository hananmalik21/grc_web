import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_api_providers.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/applications/states/applications_state.dart';
import 'package:grc/features/hiring/presentation/models/application_table_row_data.dart';
import 'package:grc/features/hiring/application/applications/config/applications_list_config.dart';
import 'package:grc/features/hiring/application/applications/mappers/application_table_row_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationsNotifier extends AutoDisposeNotifier<ApplicationsState> {
  final _debouncer = Debouncer();

  @override
  ApplicationsState build() {
    ref.onDispose(_debouncer.dispose);

    ref.listen<int?>(applicationsTabEnterpriseIdProvider, (previous, next) {
      if (previous == next) return;
      Future.microtask(() {
        if (next == null) {
          state = ApplicationsState.initial();
          return;
        }
        loadApplications(page: applicationsDefaultPage, resetFilters: true);
      });
    });

    Future.microtask(() => loadApplications(page: applicationsDefaultPage));
    return ApplicationsState.initial();
  }

  Future<void> loadApplications({int? page, bool resetFilters = false}) async {
    final targetPage = page ?? state.currentPage;
    final enterpriseId = ref.read(applicationsTabEnterpriseIdProvider);

    if (enterpriseId == null || enterpriseId <= 0) {
      state = ApplicationsState.initial();
      return;
    }

    if (resetFilters) {
      final showFilters = state.showFilters;
      state = ApplicationsState.initial().copyWith(isLoading: true, showFilters: showFilters);
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final response = await ref
          .read(getApplicationsUseCaseProvider)
          .call(enterpriseId: enterpriseId, page: targetPage, limit: ApplicationsListConfig.pageSize);

      final pagination = response.pagination;
      final rows = response.items.map(toApplicationTableRowData).toList();
      final filtered = _filterApplications(rows);

      state = state.copyWith(
        items: filtered,
        currentPage: pagination?.page ?? targetPage,
        totalPages: pagination?.totalPages ?? 1,
        totalItems: pagination?.total ?? filtered.length,
        hasNext: pagination?.hasNext ?? false,
        hasPrevious: pagination?.hasPrevious ?? false,
        isLoading: false,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to load applications. Please try again.');
    }
  }

  void changeEnterprise(int? enterpriseId) {
    ref.read(applicationsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    state = ApplicationsState.initial();
    if (enterpriseId != null) {
      loadApplications(page: applicationsDefaultPage);
    }
  }

  void setSearch(String query) {
    _debouncer.run(() {
      state = state.copyWith(searchQuery: query);
      loadApplications(page: applicationsDefaultPage);
    });
  }

  void setStatus(String? value) {
    state = value == null ? state.copyWith(clearStatus: true) : state.copyWith(status: value);
    loadApplications(page: applicationsDefaultPage);
  }

  void setSource(String? value) {
    state = value == null ? state.copyWith(clearSource: true) : state.copyWith(source: value);
    loadApplications(page: applicationsDefaultPage);
  }

  void resetFilters() {
    state = state.copyWith(searchQuery: '', clearStatus: true, clearSource: true);
    loadApplications(page: applicationsDefaultPage);
  }

  void toggleFilters() {
    state = state.copyWith(showFilters: !state.showFilters);
  }

  Future<void> nextPage() async {
    if (!state.hasNext || state.isLoading) return;
    await loadApplications(page: state.currentPage + 1);
  }

  Future<void> previousPage() async {
    if (!state.hasPrevious || state.isLoading) return;
    await loadApplications(page: state.currentPage - 1);
  }

  void retryFetch() {
    loadApplications(page: state.currentPage);
  }

  List<ApplicationTableRowData> _filterApplications(List<ApplicationTableRowData> items) {
    final query = state.searchQuery.trim().toLowerCase();
    final status = state.status;
    final source = state.source;

    return items.where((application) {
      if (status != null && !_matchesLabel(application.status, status)) {
        return false;
      }
      if (source != null && !_matchesLabel(application.source, source)) {
        return false;
      }
      if (query.isEmpty) return true;

      final haystack = [
        application.applicationId,
        application.candidateName,
        application.candidateId,
        application.jobTitle,
        application.requisitionId,
        application.currentStage,
        application.status,
        application.source,
      ].join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();
  }

  bool _matchesLabel(String value, String filter) {
    return _normalizeLabel(value) == _normalizeLabel(filter);
  }

  String _normalizeLabel(String value) {
    return value.replaceAll(RegExp(r'[\s_]'), '').toUpperCase();
  }
}
