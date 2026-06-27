import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_api_providers.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_filter_provider.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int requisitionsDefaultPage = 1;

final requisitionsCurrentPageProvider = StateProvider.autoDispose<int>((ref) => requisitionsDefaultPage);

class RequisitionsPageResult {
  const RequisitionsPageResult({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<RequisitionTableRowData> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;
  final bool hasPrevious;

  static const empty = RequisitionsPageResult(
    items: [],
    totalItems: 0,
    totalPages: 1,
    currentPage: requisitionsDefaultPage,
    hasNext: false,
    hasPrevious: false,
  );
}

/// Fetches requisitions from the REC API. Auto-disposes when the tab unmounts.
final requisitionsPageProvider = FutureProvider.autoDispose<RequisitionsPageResult>((ref) async {
  ref.watch(requisitionsTabRefreshTickProvider);
  final enterpriseId = ref.watch(requisitionsTabEnterpriseIdProvider);
  final filters = ref.watch(requisitionsFilterProvider);
  final currentPage = ref.watch(requisitionsCurrentPageProvider);

  if (enterpriseId == null) {
    return RequisitionsPageResult.empty;
  }

  final useCase = ref.watch(getRequisitionsUseCaseProvider);
  final response = await useCase(
    enterpriseId: enterpriseId,
    page: currentPage,
    pageSize: RequisitionsTableConfig.pageSize,
  );

  final pagination = response.pagination;
  final filtered = _filterRows(response.toTableRows(), filters);

  return RequisitionsPageResult(
    items: filtered,
    totalItems: pagination?.total ?? filtered.length,
    totalPages: pagination?.totalPages ?? 1,
    currentPage: pagination?.page ?? currentPage,
    hasNext: pagination?.hasNext ?? false,
    hasPrevious: pagination?.hasPrevious ?? false,
  );
});

List<RequisitionTableRowData> _filterRows(List<RequisitionTableRowData> rows, RequisitionsFilterState filters) {
  final query = filters.searchQuery.trim().toLowerCase();

  return rows.where((row) {
    if (filters.department != null && row.departmentKey != filters.department) {
      return false;
    }
    if (filters.priority != null && row.priorityKey != filters.priority) {
      return false;
    }
    final rowStatusKey = row.statusEnum?.filterKey ?? '';
    if (filters.status != null && rowStatusKey != filters.status) {
      return false;
    }
    if (filters.workMode != null && row.workModeKey != filters.workMode) {
      return false;
    }
    if (filters.employmentType != null && row.employmentTypeKey != filters.employmentType) {
      return false;
    }
    if (query.isEmpty) return true;

    final haystack = [
      row.requisitionCode,
      row.jobTitle,
      row.department,
      row.roleTitle,
      row.location,
      row.hiringManager,
    ].join(' ').toLowerCase();

    return haystack.contains(query);
  }).toList();
}

final requisitionsTableRowsProvider = FutureProvider.autoDispose<List<RequisitionTableRowData>>((ref) async {
  final page = await ref.watch(requisitionsPageProvider.future);
  return page.items;
});

final requisitionsTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(requisitionsPageProvider).valueOrNull?.totalPages ?? 1;
});

final requisitionsTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(requisitionsPageProvider).valueOrNull?.totalItems ?? 0;
});

final requisitionsHasNextProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(requisitionsPageProvider).valueOrNull?.hasNext ?? false;
});

final requisitionsHasPreviousProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(requisitionsPageProvider).valueOrNull?.hasPrevious ?? false;
});

final requisitionsTableIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(requisitionsPageProvider).isLoading;
});

final requisitionsTableErrorProvider = Provider.autoDispose<String?>((ref) {
  final async = ref.watch(requisitionsPageProvider);
  return async.hasError ? async.error.toString() : null;
});

final requisitionsSkeletonRowsProvider = Provider.autoDispose<List<RequisitionTableRowData>>((ref) {
  return [
    RequisitionTableRowData(
      id: 'sk-1',
      requisitionCode: 'REQ-2026-000',
      jobTitle: 'Loading Requisition',
      gradeNumber: 'L5',
      employmentTypeCode: 'FULL_TIME',
      employmentTypeLabel: 'Full-time',
      employmentTypeKey: 'full_time',
      department: 'Engineering',
      departmentKey: 'engineering',
      roleTitle: 'Software Engineer',
      hiringManager: 'Loading Manager',
      location: 'San Francisco, CA',
      workModeCode: 'HYBRID',
      workModeLabel: 'Hybrid',
      workModeKey: 'hybrid',
      openings: 1,
      compensationRange: r'$100K - $120K',
      status: 'Open',
      approvalStatusLabel: 'Approved',
      approvalCompleted: 1,
      approvalTotal: 3,
      priorityLabel: 'High',
      priorityKey: 'high',
      targetStart: DateTime(2026, 6, 1),
    ),
    RequisitionTableRowData(
      id: 'sk-2',
      requisitionCode: 'REQ-2026-001',
      jobTitle: 'Loading Requisition',
      gradeNumber: 'L4',
      employmentTypeCode: 'FULL_TIME',
      employmentTypeLabel: 'Full-time',
      employmentTypeKey: 'full_time',
      department: 'Product',
      departmentKey: 'operations',
      roleTitle: 'Product Manager',
      hiringManager: 'Loading Manager',
      location: 'New York, NY',
      workModeCode: 'REMOTE',
      workModeLabel: 'Remote',
      workModeKey: 'remote',
      openings: 1,
      compensationRange: r'$100K - $120K',
      status: 'Pending Approval',
      approvalStatusLabel: 'Pending Approval',
      approvalCompleted: 2,
      approvalTotal: 3,
      priorityLabel: 'Medium',
      priorityKey: 'medium',
      targetStart: DateTime(2026, 7, 1),
    ),
  ];
});
