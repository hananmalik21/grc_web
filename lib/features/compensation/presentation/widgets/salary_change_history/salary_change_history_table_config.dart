import 'salary_change_history_table_types.dart';

class SalaryChangeHistoryTableConfig {
  SalaryChangeHistoryTableConfig._();

  static const double actionsWidth = 100;

  static const double changeIdWidth = 140;
  static const double employeeWidth = 180;
  static const double departmentWidth = 180;
  static const double changeTypeWidth = 160;
  static const double effectiveDateWidth = 160;
  static const double previousSalaryWidth = 160;
  static const double newSalaryWidth = 150;
  static const double changeWidth = 160;
  static const double statusWidth = 140;

  static const double minResizableWidth = 90;
  static const double maxResizableWidth = 420;

  static const double changeIdMinWidth = 120;
  static const double employeeMinWidth = 150;
  static const double departmentMinWidth = 140;
  static const double changeTypeMinWidth = 130;
  static const double effectiveDateMinWidth = 130;
  static const double previousSalaryMinWidth = 130;
  static const double newSalaryMinWidth = 120;
  static const double changeMinWidth = 130;
  static const double statusMinWidth = 110;

  static double widthFor(SalaryChangeHistoryTableColumn column) {
    return switch (column) {
      SalaryChangeHistoryTableColumn.changeId => changeIdWidth,
      SalaryChangeHistoryTableColumn.employee => employeeWidth,
      SalaryChangeHistoryTableColumn.department => departmentWidth,
      SalaryChangeHistoryTableColumn.changeType => changeTypeWidth,
      SalaryChangeHistoryTableColumn.effectiveDate => effectiveDateWidth,
      SalaryChangeHistoryTableColumn.previousSalary => previousSalaryWidth,
      SalaryChangeHistoryTableColumn.newSalary => newSalaryWidth,
      SalaryChangeHistoryTableColumn.change => changeWidth,
      SalaryChangeHistoryTableColumn.status => statusWidth,
    };
  }

  static double minWidthFor(SalaryChangeHistoryTableColumn column) {
    return switch (column) {
      SalaryChangeHistoryTableColumn.changeId => changeIdMinWidth,
      SalaryChangeHistoryTableColumn.employee => employeeMinWidth,
      SalaryChangeHistoryTableColumn.department => departmentMinWidth,
      SalaryChangeHistoryTableColumn.changeType => changeTypeMinWidth,
      SalaryChangeHistoryTableColumn.effectiveDate => effectiveDateMinWidth,
      SalaryChangeHistoryTableColumn.previousSalary => previousSalaryMinWidth,
      SalaryChangeHistoryTableColumn.newSalary => newSalaryMinWidth,
      SalaryChangeHistoryTableColumn.change => changeMinWidth,
      SalaryChangeHistoryTableColumn.status => statusMinWidth,
    };
  }
}
