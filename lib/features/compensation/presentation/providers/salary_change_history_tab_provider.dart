import 'package:grc/features/compensation/domain/models/adjustments/salary_change_history.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/salary_change_history_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/salary_change_history_filter_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_change_history_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalaryChangeHistoryTabState {
  final int currentPage;
  final int pageSize;

  const SalaryChangeHistoryTabState({this.currentPage = 1, this.pageSize = 10});

  SalaryChangeHistoryTabState copyWith({int? currentPage, int? pageSize}) {
    return SalaryChangeHistoryTabState(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class SalaryChangeHistoryTabNotifier extends Notifier<SalaryChangeHistoryTabState> {
  @override
  SalaryChangeHistoryTabState build() => const SalaryChangeHistoryTabState();

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void previousPage() {
    if (state.currentPage <= 1) return;
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  void nextPage({required int totalPages}) {
    if (state.currentPage >= totalPages) return;
    state = state.copyWith(currentPage: state.currentPage + 1);
  }
}

final salaryChangeHistoryTabProvider = NotifierProvider<SalaryChangeHistoryTabNotifier, SalaryChangeHistoryTabState>(
  SalaryChangeHistoryTabNotifier.new,
);

final salaryChangeHistoryDataPageProvider = FutureProvider.autoDispose<SalaryChangeHistoryPage>((ref) async {
  final enterpriseId = ref.watch(salaryChangeHistoryTabEnterpriseIdProvider);
  if (enterpriseId == null) {
    return const SalaryChangeHistoryPage(
      summary: SalaryChangeHistorySummary(employeeCount: 0, totalImpact: 0, currencyCode: '', displayTotalImpact: '—'),
      data: [],
      pagination: SalaryChangeHistoryPagination(
        page: 1,
        limit: 10,
        total: 0,
        totalPages: 1,
        hasNext: false,
        hasPrevious: false,
      ),
    );
  }

  final tabState = ref.watch(salaryChangeHistoryTabProvider);
  final filterState = ref.watch(salaryChangeHistoryFilterProvider);
  final useCase = ref.watch(getSalaryChangeHistoryUseCaseProvider);

  return useCase(
    enterpriseId: enterpriseId,
    page: tabState.currentPage,
    limit: tabState.pageSize,
    searchQuery: filterState.searchQuery.trim().isEmpty ? null : filterState.searchQuery.trim(),
    status: filterState.status.label == 'All Status' ? null : filterState.status.label,
  );
});

final salaryChangeHistoryTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(salaryChangeHistoryDataPageProvider).valueOrNull?.pagination.total ?? 0;
});

final salaryChangeHistoryTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(salaryChangeHistoryDataPageProvider).valueOrNull?.pagination.totalPages ?? 1;
});

final salaryChangeHistoryIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final asyncValue = ref.watch(salaryChangeHistoryDataPageProvider);
  return asyncValue.isLoading || asyncValue.isRefreshing;
});

final salaryChangeHistoryErrorProvider = Provider.autoDispose<String?>((ref) {
  final asyncValue = ref.watch(salaryChangeHistoryDataPageProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});
