import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';

class PersonResultDetailTableConfig {
  PersonResultDetailTableConfig._();

  static const int pageSize = 10;
  static const double actionsWidth = 80;

  static const double taskNameWidth = 231;
  static const double statusWidth = 140;
  static const double flowNameWidth = 273;
  static const double processDateWidth = 115;
  static const double payrollWidth = 205;
  static const double payrollPeriodWidth = 123;
  static const double amountWidth = 134;

  static const List<PersonResultDetailTableColumn> columns = PersonResultDetailTableColumn.values;
  static const showActions = true;

  static double widthFor(PersonResultDetailTableColumn column) {
    return switch (column) {
      PersonResultDetailTableColumn.taskName => taskNameWidth,
      PersonResultDetailTableColumn.status => statusWidth,
      PersonResultDetailTableColumn.flowName => flowNameWidth,
      PersonResultDetailTableColumn.processDate => processDateWidth,
      PersonResultDetailTableColumn.payroll => payrollWidth,
      PersonResultDetailTableColumn.payrollPeriod => payrollPeriodWidth,
      PersonResultDetailTableColumn.amount => amountWidth,
    };
  }

  static double minWidthFor(PersonResultDetailTableColumn column) {
    return switch (column) {
      PersonResultDetailTableColumn.taskName => 160,
      PersonResultDetailTableColumn.status => 140,
      PersonResultDetailTableColumn.flowName => 160,
      PersonResultDetailTableColumn.payroll => 140,
      PersonResultDetailTableColumn.amount => 100,
      _ => 80,
    };
  }
}
