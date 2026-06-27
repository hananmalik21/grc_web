import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';
import 'package:grc/features/payroll/application/person_results/states/person_results_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonResultsUiController extends StateNotifier<PersonResultsUiState> {
  PersonResultsUiController() : super(const PersonResultsUiState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
  }

  void setTableFilterQuery(String query) {
    state = state.copyWith(tableFilterQuery: query, currentPage: 1);
  }

  void setSortField(PersonResultsSortField field) {
    if (state.sortField == field) {
      state = state.copyWith(sortAscending: !state.sortAscending, currentPage: 1);
      return;
    }

    state = state.copyWith(sortField: field, sortAscending: true, currentPage: 1);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }
}
