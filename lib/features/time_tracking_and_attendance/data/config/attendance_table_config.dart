class AttendanceTableConfig {
  AttendanceTableConfig._();

  static const bool showEmployee = true;
  static const bool showDepartment = true;
  static const bool showDate = true;
  static const bool showCheckIn = true;
  static const bool showCheckOut = true;
  static const bool showStatus = true;
  static const bool showActions = true;

  static const double employeeWidth = 320;
  static const double departmentWidth = 240;
  static const double dateWidth = 240;
  static const double checkInWidth = 200;
  static const double checkOutWidth = 200;
  static const double statusWidth = 200;
  static const double actionsWidth = 160;

  static const double cellPaddingHorizontal = 28;

  static double get totalWidth {
    double width = 0;
    if (showEmployee) width += employeeWidth;
    if (showDepartment) width += departmentWidth;
    if (showDate) width += dateWidth;
    if (showCheckIn) width += checkInWidth;
    if (showCheckOut) width += checkOutWidth;
    if (showStatus) width += statusWidth;
    if (showActions) width += actionsWidth;
    return width;
  }
}
