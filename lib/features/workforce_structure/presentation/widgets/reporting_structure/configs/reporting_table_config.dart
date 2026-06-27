class ReportingTableConfig {
  ReportingTableConfig._();

  // Column Visibility Flags
  static const bool showCode = true;
  static const bool showTitle = true;
  static const bool showDepartment = true;
  static const bool showLevel = true;
  static const bool showGrade = true;
  static const bool showReportsTo = true;
  static const bool showStatus = true;
  static const bool showActions = true;

  // Column Widths
  static const double codeWidth = 160;
  static const double titleWidth = 270;
  static const double departmentWidth = 200;
  static const double levelWidth = 180;
  static const double gradeWidth = 160;
  static const double reportsToWidth = 230;
  static const double statusWidth = 150;
  static const double actionsWidth = 150;

  static const double cellPaddingHorizontal = 20;
}
