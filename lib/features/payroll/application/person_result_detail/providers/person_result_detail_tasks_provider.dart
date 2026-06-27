import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_config.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_ui_provider.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultDetailTasksProvider = Provider.family<List<PayrollProcessResultTask>, String>((ref, personNumber) {
  return kMockPayrollProcessResultTasks;
});

final personResultDetailFilteredTasksProvider = Provider.family<List<PayrollProcessResultTask>, String>((
  ref,
  personNumber,
) {
  final tasks = ref.watch(personResultDetailTasksProvider(personNumber));
  final uiState = ref.watch(personResultDetailUiProvider);

  final sorted = List<PayrollProcessResultTask>.from(tasks);
  sorted.sort((a, b) {
    final comparison = switch (uiState.sortField) {
      PersonResultDetailSortField.taskName => a.taskName.compareTo(b.taskName),
      PersonResultDetailSortField.status => a.status.index.compareTo(b.status.index),
      PersonResultDetailSortField.flowName => a.flowName.compareTo(b.flowName),
      PersonResultDetailSortField.processDate => a.processDate.compareTo(b.processDate),
      PersonResultDetailSortField.payroll => a.payroll.compareTo(b.payroll),
      PersonResultDetailSortField.payrollPeriod => a.payrollPeriod.compareTo(b.payrollPeriod),
      PersonResultDetailSortField.amount => a.amount.compareTo(b.amount),
    };

    return uiState.sortAscending ? comparison : -comparison;
  });

  return sorted;
});

final personResultDetailTotalItemsProvider = Provider.family<int, String>((ref, personNumber) {
  return ref.watch(personResultDetailFilteredTasksProvider(personNumber)).length;
});

final personResultDetailTotalPagesProvider = Provider.family<int, String>((ref, personNumber) {
  final totalItems = ref.watch(personResultDetailTotalItemsProvider(personNumber));
  if (totalItems == 0) return 1;
  return (totalItems / PersonResultDetailTableConfig.pageSize).ceil();
});

final personResultDetailPaginatedTasksProvider = Provider.family<List<PayrollProcessResultTask>, String>((
  ref,
  personNumber,
) {
  final tasks = ref.watch(personResultDetailFilteredTasksProvider(personNumber));
  final uiState = ref.watch(personResultDetailUiProvider);
  final startIndex = (uiState.currentPage - 1) * PersonResultDetailTableConfig.pageSize;

  if (startIndex >= tasks.length) return const [];

  return tasks.skip(startIndex).take(PersonResultDetailTableConfig.pageSize).toList();
});

final personResultDetailHasNextProvider = Provider.family<bool, String>((ref, personNumber) {
  final uiState = ref.watch(personResultDetailUiProvider);
  final totalPages = ref.watch(personResultDetailTotalPagesProvider(personNumber));
  return uiState.currentPage < totalPages;
});

final personResultDetailHasPreviousProvider = Provider.family<bool, String>((ref, personNumber) {
  final uiState = ref.watch(personResultDetailUiProvider);
  return uiState.currentPage > 1;
});

final personResultDetailSummaryPeriodProvider = Provider.family<String, String>((ref, personNumber) {
  final tasks = ref.watch(personResultDetailTasksProvider(personNumber));
  if (tasks.isEmpty) return '';

  return tasks.first.payrollPeriod;
});
