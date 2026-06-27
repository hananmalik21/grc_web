import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';

class PersonResultsUiState {
  const PersonResultsUiState({
    this.searchQuery = '',
    this.tableFilterQuery = '',
    this.sortField = PersonResultsSortField.name,
    this.sortAscending = true,
    this.currentPage = 1,
  });

  final String searchQuery;
  final String tableFilterQuery;
  final PersonResultsSortField sortField;
  final bool sortAscending;
  final int currentPage;

  PersonResultsUiState copyWith({
    String? searchQuery,
    String? tableFilterQuery,
    PersonResultsSortField? sortField,
    bool? sortAscending,
    int? currentPage,
  }) {
    return PersonResultsUiState(
      searchQuery: searchQuery ?? this.searchQuery,
      tableFilterQuery: tableFilterQuery ?? this.tableFilterQuery,
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
