import 'package:grc/features/payroll/application/person_result_detail/states/person_result_detail_ui_state.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonResultDetailUiController extends StateNotifier<PersonResultDetailUiState> {
  PersonResultDetailUiController() : super(const PersonResultDetailUiState());

  void setSortField(PersonResultDetailSortField field) {
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
