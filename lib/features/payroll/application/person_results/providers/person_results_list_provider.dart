import 'package:grc/features/payroll/application/person_results/config/person_results_table_config.dart';
import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_ui_provider.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultsEmployeesProvider = Provider<List<PersonResultEmployee>>((ref) {
  return kMockPersonResultEmployees;
});

final personResultsFilteredEmployeesProvider = Provider<List<PersonResultEmployee>>((ref) {
  final employees = ref.watch(personResultsEmployeesProvider);
  final uiState = ref.watch(personResultsUiProvider);

  final filtered = employees.where((employee) {
    return employee.matchesQuery(uiState.searchQuery) && employee.matchesQuery(uiState.tableFilterQuery);
  }).toList();

  filtered.sort((a, b) {
    final comparison = switch (uiState.sortField) {
      PersonResultsSortField.name => a.name.compareTo(b.name),
      PersonResultsSortField.businessTitle => a.businessTitle.compareTo(b.businessTitle),
      PersonResultsSortField.personNumber => a.personNumber.compareTo(b.personNumber),
      PersonResultsSortField.assignmentNumber => a.assignmentNumber.compareTo(b.assignmentNumber),
      PersonResultsSortField.assignmentStatus => a.isActive == b.isActive ? 0 : (a.isActive ? -1 : 1),
      PersonResultsSortField.workerType => a.workerType.compareTo(b.workerType),
      PersonResultsSortField.workEmail => a.workEmail.compareTo(b.workEmail),
      PersonResultsSortField.workPhone => a.workPhone.compareTo(b.workPhone),
    };

    return uiState.sortAscending ? comparison : -comparison;
  });

  return filtered;
});

final personResultsTotalItemsProvider = Provider<int>((ref) {
  return ref.watch(personResultsFilteredEmployeesProvider).length;
});

final personResultsTotalPagesProvider = Provider<int>((ref) {
  final totalItems = ref.watch(personResultsTotalItemsProvider);
  if (totalItems == 0) return 1;
  return (totalItems / PersonResultsTableConfig.pageSize).ceil();
});

final personResultsPaginatedEmployeesProvider = Provider<List<PersonResultEmployee>>((ref) {
  final employees = ref.watch(personResultsFilteredEmployeesProvider);
  final uiState = ref.watch(personResultsUiProvider);
  final startIndex = (uiState.currentPage - 1) * PersonResultsTableConfig.pageSize;

  if (startIndex >= employees.length) return const [];

  return employees.skip(startIndex).take(PersonResultsTableConfig.pageSize).toList();
});

final personResultsHasNextProvider = Provider<bool>((ref) {
  final uiState = ref.watch(personResultsUiProvider);
  final totalPages = ref.watch(personResultsTotalPagesProvider);
  return uiState.currentPage < totalPages;
});

final personResultsHasPreviousProvider = Provider<bool>((ref) {
  final uiState = ref.watch(personResultsUiProvider);
  return uiState.currentPage > 1;
});
