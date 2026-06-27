import 'package:grc/features/payroll/application/person_results/config/person_results_table_config.dart';
import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonResultsTableState {
  const PersonResultsTableState({required this.columnOrder, required this.widthOverrides});

  final List<PersonResultsTableColumn> columnOrder;
  final Map<PersonResultsTableColumn, double> widthOverrides;

  factory PersonResultsTableState.initial() {
    return PersonResultsTableState(columnOrder: PersonResultsTableColumn.values, widthOverrides: const {});
  }

  double widthFor(PersonResultsTableColumn column) {
    return widthOverrides[column] ?? PersonResultsTableConfig.widthFor(column).w;
  }

  PersonResultsTableState copyWith({
    List<PersonResultsTableColumn>? columnOrder,
    Map<PersonResultsTableColumn, double>? widthOverrides,
  }) {
    return PersonResultsTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}
