import 'package:grc/features/compensation/domain/models/adjustments/adjustments_page.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';

class AdjustmentsTabState {
  final String searchQuery;
  final String selectedDepartment;
  final String selectedRegion;
  final String selectedStatus;
  final int currentPage;

  const AdjustmentsTabState({
    this.searchQuery = '',
    this.selectedDepartment = AdjustmentsTabConfig.allDepartmentsLabel,
    this.selectedRegion = AdjustmentsTabConfig.allRegionsLabel,
    this.selectedStatus = AdjustmentsTabConfig.allStatusesLabel,
    this.currentPage = 1,
  });

  AdjustmentsTabState copyWith({
    String? searchQuery,
    String? selectedDepartment,
    String? selectedRegion,
    String? selectedStatus,
    int? currentPage,
  }) {
    return AdjustmentsTabState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class AdjustmentsTabNotifier extends Notifier<AdjustmentsTabState> {
  @override
  AdjustmentsTabState build() => const AdjustmentsTabState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
  }

  void setDepartment(String? department) {
    state = state.copyWith(selectedDepartment: department ?? AdjustmentsTabConfig.allDepartmentsLabel, currentPage: 1);
  }

  void setRegion(String? region) {
    state = state.copyWith(selectedRegion: region ?? AdjustmentsTabConfig.allRegionsLabel, currentPage: 1);
  }

  void setStatus(String? status) {
    state = state.copyWith(selectedStatus: status ?? AdjustmentsTabConfig.allStatusesLabel, currentPage: 1);
  }

  void previousPage() {
    if (state.currentPage <= 1) return;
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  void nextPage({required int totalPages}) {
    if (state.currentPage >= totalPages) return;
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  List<String> get departmentOptions => AdjustmentsTabConfig.buildDepartmentOptions();
  List<String> get regionOptions => AdjustmentsTabConfig.buildRegionOptions();
  List<String> get statusOptions => AdjustmentsTabConfig.buildStatusOptions();
}

final adjustmentsTabProvider = NotifierProvider<AdjustmentsTabNotifier, AdjustmentsTabState>(
  AdjustmentsTabNotifier.new,
);

final adjustmentsDataPageProvider = FutureProvider.autoDispose<AdjustmentsPage>((ref) async {
  final enterpriseId = ref.watch(adjustmentsTabEnterpriseIdProvider);
  if (enterpriseId == null) {
    return const AdjustmentsPage(
      adjustments: [],
      total: 0,
      page: 1,
      limit: 10,
      totalPages: 1,
      hasNext: false,
      hasPrevious: false,
    );
  }

  final tabState = ref.watch(adjustmentsTabProvider);
  final useCase = ref.watch(getAdjustmentsUseCaseProvider);

  return useCase(
    enterpriseId: enterpriseId,
    page: tabState.currentPage,
    limit: AdjustmentsTabConfig.pageSize,
    searchQuery: tabState.searchQuery.trim().isEmpty ? null : tabState.searchQuery.trim(),
    status: tabState.selectedStatus == AdjustmentsTabConfig.allStatusesLabel ? null : tabState.selectedStatus,
    department: tabState.selectedDepartment == AdjustmentsTabConfig.allDepartmentsLabel
        ? null
        : tabState.selectedDepartment,
    region: tabState.selectedRegion == AdjustmentsTabConfig.allRegionsLabel ? null : tabState.selectedRegion,
  );
});

final adjustmentsRowsProvider = Provider.autoDispose<List<AdjustmentRowData>>((ref) {
  final page = ref.watch(adjustmentsDataPageProvider).valueOrNull;
  if (page == null) return [];
  return page.adjustments.map((e) => AdjustmentRowData.fromAdjustment(e)).toList();
});

final adjustmentsTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(adjustmentsDataPageProvider).valueOrNull?.total ?? 0;
});

final adjustmentsTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(adjustmentsDataPageProvider).valueOrNull?.totalPages ?? 1;
});

final adjustmentsIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final asyncValue = ref.watch(adjustmentsDataPageProvider);
  return asyncValue.isLoading || asyncValue.isRefreshing;
});

final adjustmentsErrorProvider = Provider.autoDispose<String?>((ref) {
  final asyncValue = ref.watch(adjustmentsDataPageProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});

final adjustmentsShowMobileFiltersProvider = StateProvider<bool>((ref) => false);
