import 'package:grc/features/hiring/application/interviews/providers/interviews_filter_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_table_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterviewsController {
  const InterviewsController(this.ref);

  final Ref ref;

  int? get enterpriseId => ref.read(interviewsTabEnterpriseIdProvider);

  bool get hasEnterpriseSelected => enterpriseId != null && enterpriseId! > 0;

  void refreshInterviews() {
    ref.read(interviewsTabRefreshTickProvider.notifier).state++;
  }

  void changeEnterprise(int? enterpriseId) {
    ref.read(interviewsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    resetFilters();
    ref.read(interviewsShowFiltersProvider.notifier).state = false;
    refreshInterviews();
  }

  void setSearch(String query) {
    ref.read(interviewsFilterProvider.notifier).setSearch(query);
    setPage(1);
  }

  void setStatus(String? status) {
    ref.read(interviewsFilterProvider.notifier).setStatus(status);
    setPage(1);
  }

  void resetFilters() {
    ref.read(interviewsFilterProvider.notifier).reset();
    setPage(1);
  }

  void setPage(int page) {
    ref.read(interviewsCurrentPageProvider.notifier).state = page;
  }

  void nextPage() {
    final currentPage = ref.read(interviewsCurrentPageProvider);
    setPage(currentPage + 1);
  }

  void previousPage() {
    final currentPage = ref.read(interviewsCurrentPageProvider);
    if (currentPage > 1) {
      setPage(currentPage - 1);
    }
  }

  void setViewMode(InterviewsViewMode viewMode) {
    ref.read(interviewsViewModeProvider.notifier).state = viewMode;
  }

  void toggleViewMode() {
    final currentMode = ref.read(interviewsViewModeProvider);
    final nextMode = currentMode == InterviewsViewMode.calendar ? InterviewsViewMode.list : InterviewsViewMode.calendar;
    setViewMode(nextMode);
  }

  void toggleFilters() {
    ref.read(interviewsShowFiltersProvider.notifier).update((state) => !state);
  }

  void retryFetch() {
    ref.invalidate(interviewsPageProvider);
  }
}
