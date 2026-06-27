import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';

class PersonResultDetailUiState {
  const PersonResultDetailUiState({
    this.sortField = PersonResultDetailSortField.taskName,
    this.sortAscending = true,
    this.currentPage = 1,
  });

  final PersonResultDetailSortField sortField;
  final bool sortAscending;
  final int currentPage;

  PersonResultDetailUiState copyWith({PersonResultDetailSortField? sortField, bool? sortAscending, int? currentPage}) {
    return PersonResultDetailUiState(
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
