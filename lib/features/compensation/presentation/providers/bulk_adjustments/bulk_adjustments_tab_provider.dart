import 'package:grc/features/compensation/domain/models/adjustments/adjustments_page.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_tab_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bulkAdjustmentsTabProvider = NotifierProvider<AdjustmentsTabNotifier, AdjustmentsTabState>(
  AdjustmentsTabNotifier.new,
);

final bulkAdjustmentsDataPageProvider = FutureProvider.autoDispose<AdjustmentsPage>((ref) async {
  final enterpriseId = ref.watch(bulkAdjustmentsTabEnterpriseIdProvider);
  if (enterpriseId == null) {
    return const AdjustmentsPage(
      adjustments: [],
      total: 0,
      page: 1,
      limit: BulkAdjustmentsTabConfig.pageSize,
      totalPages: 1,
      hasNext: false,
      hasPrevious: false,
    );
  }

  final tabState = ref.watch(bulkAdjustmentsTabProvider);
  final useCase = ref.watch(getAdjustmentsUseCaseProvider);

  return useCase(
    enterpriseId: enterpriseId,
    page: tabState.currentPage,
    limit: BulkAdjustmentsTabConfig.pageSize,
    searchQuery: tabState.searchQuery.trim().isEmpty ? null : tabState.searchQuery.trim(),
    status: tabState.selectedStatus == AdjustmentsTabConfig.allStatusesLabel ? null : tabState.selectedStatus,
    department: tabState.selectedDepartment == AdjustmentsTabConfig.allDepartmentsLabel
        ? null
        : tabState.selectedDepartment,
    region: tabState.selectedRegion == AdjustmentsTabConfig.allRegionsLabel ? null : tabState.selectedRegion,
  );
});

final bulkAdjustmentsRowsProvider = Provider.autoDispose<List<AdjustmentRowData>>((ref) {
  final page = ref.watch(bulkAdjustmentsDataPageProvider).valueOrNull;
  if (page == null) return [];
  return page.adjustments.map((e) => AdjustmentRowData.fromAdjustment(e)).toList();
});

final bulkAdjustmentsTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(bulkAdjustmentsDataPageProvider).valueOrNull?.total ?? 0;
});

final bulkAdjustmentsTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(bulkAdjustmentsDataPageProvider).valueOrNull?.totalPages ?? 1;
});

final bulkAdjustmentsIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final asyncValue = ref.watch(bulkAdjustmentsDataPageProvider);
  return asyncValue.isLoading || asyncValue.isRefreshing;
});

final bulkAdjustmentsErrorProvider = Provider.autoDispose<String?>((ref) {
  final asyncValue = ref.watch(bulkAdjustmentsDataPageProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});

final bulkAdjustmentsShowMobileFiltersProvider = StateProvider<bool>((ref) => false);
