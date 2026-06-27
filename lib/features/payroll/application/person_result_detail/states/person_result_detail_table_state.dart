import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_config.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonResultDetailTableState {
  const PersonResultDetailTableState({required this.columnOrder, required this.widthOverrides});

  final List<PersonResultDetailTableColumn> columnOrder;
  final Map<PersonResultDetailTableColumn, double> widthOverrides;

  factory PersonResultDetailTableState.initial() {
    return PersonResultDetailTableState(columnOrder: PersonResultDetailTableColumn.values, widthOverrides: const {});
  }

  double widthFor(PersonResultDetailTableColumn column) {
    return widthOverrides[column] ?? PersonResultDetailTableConfig.widthFor(column).w;
  }

  PersonResultDetailTableState copyWith({
    List<PersonResultDetailTableColumn>? columnOrder,
    Map<PersonResultDetailTableColumn, double>? widthOverrides,
  }) {
    return PersonResultDetailTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}
