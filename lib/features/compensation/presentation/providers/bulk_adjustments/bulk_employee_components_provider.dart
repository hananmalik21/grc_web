import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_table_selection_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulkAdjustmentsComponentsConfig {
  BulkAdjustmentsComponentsConfig._();

  static const int employeePageSize = 10;
}

class BulkEmployeeComponentsQuery {
  const BulkEmployeeComponentsQuery({
    required this.enterpriseId,
    required this.employeeGuids,
    required this.page,
    required this.pageSize,
  });

  final int enterpriseId;
  final List<String> employeeGuids;
  final int page;
  final int pageSize;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BulkEmployeeComponentsQuery &&
            enterpriseId == other.enterpriseId &&
            page == other.page &&
            pageSize == other.pageSize &&
            listEquals(employeeGuids, other.employeeGuids);
  }

  @override
  int get hashCode => Object.hash(enterpriseId, page, pageSize, Object.hashAll(employeeGuids));
}

final bulkEmployeeComponentsPageIndexProvider = StateProvider.autoDispose<int>((ref) => 1);

final bulkEmployeeComponentsSyncKeyProvider = StateProvider.autoDispose<String?>((ref) => null);

final bulkSelectedEmployeeLabelsProvider = Provider.autoDispose<Map<String, String>>((ref) {
  final selection = ref.watch(bulkAdjustmentsTableSelectionProvider);
  final labels = <String, String>{};

  for (final entry in selection.entries.values) {
    final guid = entry.employeeGuid.trim();
    if (guid.isEmpty) continue;
    labels.putIfAbsent(guid, () => entry.employeeName);
  }

  return labels;
});

final bulkSelectedEmployeeNumericIdsProvider = Provider.autoDispose<Map<String, int>>((ref) {
  final selection = ref.watch(bulkAdjustmentsTableSelectionProvider);
  final ids = <String, int>{};

  for (final entry in selection.entries.values) {
    final guid = entry.employeeGuid.trim();
    if (guid.isEmpty || entry.employeeNumericId <= 0) continue;
    ids.putIfAbsent(guid, () => entry.employeeNumericId);
  }

  return ids;
});

final bulkEmployeeComponentsQueryProvider = Provider.autoDispose<BulkEmployeeComponentsQuery?>((ref) {
  final enterpriseId = ref.watch(bulkAdjustmentsTabEnterpriseIdProvider);
  final selection = ref.watch(bulkAdjustmentsTableSelectionProvider);
  final page = ref.watch(bulkEmployeeComponentsPageIndexProvider);

  if (enterpriseId == null || enterpriseId <= 0 || selection.isEmpty) {
    return null;
  }

  final employeeGuids = <String>[];
  for (final entry in selection.entries.values) {
    final guid = entry.employeeGuid.trim();
    if (guid.isEmpty || employeeGuids.contains(guid)) continue;
    employeeGuids.add(guid);
  }

  if (employeeGuids.isEmpty) return null;

  return BulkEmployeeComponentsQuery(
    enterpriseId: enterpriseId,
    employeeGuids: employeeGuids,
    page: page,
    pageSize: BulkAdjustmentsComponentsConfig.employeePageSize,
  );
});

final bulkEmployeeComponentsProvider = FutureProvider.autoDispose<BulkEmployeeComponentsPage>((ref) async {
  final query = ref.watch(bulkEmployeeComponentsQueryProvider);
  if (query == null) {
    return BulkEmployeeComponentsPage.empty;
  }

  final useCase = ref.watch(getBulkEmployeeComponentsUseCaseProvider);
  return useCase(
    enterpriseId: query.enterpriseId,
    employeeGuids: query.employeeGuids,
    page: query.page,
    pageSize: query.pageSize,
  );
});

final bulkEmployeeComponentsIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final asyncValue = ref.watch(bulkEmployeeComponentsProvider);
  return asyncValue.isLoading || asyncValue.isRefreshing;
});

final bulkEmployeeComponentsErrorProvider = Provider.autoDispose<String?>((ref) {
  final asyncValue = ref.watch(bulkEmployeeComponentsProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});
