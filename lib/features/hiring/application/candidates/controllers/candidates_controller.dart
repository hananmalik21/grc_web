import 'package:grc/features/hiring/application/candidates/providers/candidates_filter_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_table_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CandidatesController {
  const CandidatesController(this.ref);

  final Ref ref;

  int? get enterpriseId => ref.read(candidatesTabEnterpriseIdProvider);

  bool get hasEnterpriseSelected => enterpriseId != null && enterpriseId! > 0;

  void refreshCandidates() {
    ref.read(candidatesTabRefreshTickProvider.notifier).state++;
  }

  void changeEnterprise(int? enterpriseId) {
    ref.read(candidatesTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    resetFilters();
    ref.read(candidatesShowFiltersProvider.notifier).state = false;
    refreshCandidates();
  }

  void setSearch(String query) {
    ref.read(candidatesFilterProvider.notifier).setSearch(query);
    setPage(1);
  }

  void setStatus(String? status) {
    ref.read(candidatesFilterProvider.notifier).setStatus(status);
    setPage(1);
  }

  void resetFilters() {
    ref.read(candidatesFilterProvider.notifier).reset();
    setPage(1);
  }

  void setPage(int page) {
    ref.read(candidatesCurrentPageProvider.notifier).state = page;
  }

  void nextPage() {
    final currentPage = ref.read(candidatesCurrentPageProvider);
    setPage(currentPage + 1);
  }

  void previousPage() {
    final currentPage = ref.read(candidatesCurrentPageProvider);
    if (currentPage > 1) {
      setPage(currentPage - 1);
    }
  }

  void setViewMode(CandidatesViewMode viewMode) {
    ref.read(candidatesViewModeProvider.notifier).state = viewMode;
  }

  void toggleViewMode() {
    final currentMode = ref.read(candidatesViewModeProvider);
    final nextMode = currentMode == CandidatesViewMode.grid ? CandidatesViewMode.list : CandidatesViewMode.grid;
    setViewMode(nextMode);
  }

  void toggleFilters() {
    ref.read(candidatesShowFiltersProvider.notifier).update((state) => !state);
  }

  void retryFetch() {
    ref.invalidate(candidatesPageProvider);
  }
}

