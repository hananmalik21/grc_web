import 'employee_compensation_table_types.dart';

class EmployeeCompensationTableConfig {
  EmployeeCompensationTableConfig._();

  static const double actionsWidth = 120;

  static const double employeeWidth = 170;
  static const double departmentWidth = 150;
  static const double regionWidth = 170;
  static const double positionWidth = 185;
  static const double compensationPlanWidth = 250;
  static const double salaryStructureWidth = 230;
  static const double gradeWidth = 90;
  static const double baseSalaryWidth = 160;
  static const double allowancesWidth = 160;
  static const double benefitsWidth = 160;
  static const double totalCompWidth = 160;
  static const double statusWidth = 120;

  static const double minResizableWidth = 90;
  static const double maxResizableWidth = 420;

  static const double employeeMinWidth = 150;
  static const double departmentMinWidth = 130;
  static const double regionMinWidth = 150;
  static const double positionMinWidth = 150;
  static const double compensationPlanMinWidth = 210;
  static const double salaryStructureMinWidth = 190;
  static const double gradeMinWidth = 80;
  static const double baseSalaryMinWidth = 145;
  static const double allowancesMinWidth = 145;
  static const double benefitsMinWidth = 145;
  static const double totalCompMinWidth = 145;
  static const double statusMinWidth = 110;

  static double widthFor(EmployeeCompensationTableColumn column) {
    return switch (column) {
      EmployeeCompensationTableColumn.employee => employeeWidth,
      EmployeeCompensationTableColumn.department => departmentWidth,
      EmployeeCompensationTableColumn.region => regionWidth,
      EmployeeCompensationTableColumn.position => positionWidth,
      EmployeeCompensationTableColumn.compensationPlan => compensationPlanWidth,
      EmployeeCompensationTableColumn.salaryStructure => salaryStructureWidth,
      EmployeeCompensationTableColumn.grade => gradeWidth,
      EmployeeCompensationTableColumn.baseSalary => baseSalaryWidth,
      EmployeeCompensationTableColumn.allowances => allowancesWidth,
      EmployeeCompensationTableColumn.benefits => benefitsWidth,
      EmployeeCompensationTableColumn.totalComp => totalCompWidth,
      EmployeeCompensationTableColumn.status => statusWidth,
    };
  }

  static double minWidthFor(EmployeeCompensationTableColumn column) {
    return switch (column) {
      EmployeeCompensationTableColumn.employee => employeeMinWidth,
      EmployeeCompensationTableColumn.department => departmentMinWidth,
      EmployeeCompensationTableColumn.region => regionMinWidth,
      EmployeeCompensationTableColumn.position => positionMinWidth,
      EmployeeCompensationTableColumn.compensationPlan => compensationPlanMinWidth,
      EmployeeCompensationTableColumn.salaryStructure => salaryStructureMinWidth,
      EmployeeCompensationTableColumn.grade => gradeMinWidth,
      EmployeeCompensationTableColumn.baseSalary => baseSalaryMinWidth,
      EmployeeCompensationTableColumn.allowances => allowancesMinWidth,
      EmployeeCompensationTableColumn.benefits => benefitsMinWidth,
      EmployeeCompensationTableColumn.totalComp => totalCompMinWidth,
      EmployeeCompensationTableColumn.status => statusMinWidth,
    };
  }
}
