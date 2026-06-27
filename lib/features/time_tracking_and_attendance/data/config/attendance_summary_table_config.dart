class AttendanceSummaryTableConfig {
  AttendanceSummaryTableConfig._();

  static const bool showEmployee = true;
  static const bool showDate = true;
  static const bool showCheckIn = true;
  static const bool showCheckOut = true;
  static const bool showHours = true;
  static const bool showOvertime = true;
  static const bool showStatus = true;
  static const bool showActions = false;

  static const double employeeWidth = 360;
  static const double dateWidth = 220;
  static const double checkInWidth = 200;
  static const double checkOutWidth = 200;
  static const double hoursWidth = 180;
  static const double overtimeWidth = 180;
  static const double statusWidth = 200;
  static const double actionsWidth = 150;

  static const double cellPaddingHorizontal = 28;

  static double get totalWidth {
    double width = 0;
    if (showEmployee) width += employeeWidth;
    if (showDate) width += dateWidth;
    if (showCheckIn) width += checkInWidth;
    if (showCheckOut) width += checkOutWidth;
    if (showHours) width += hoursWidth;
    if (showOvertime) width += overtimeWidth;
    if (showStatus) width += statusWidth;
    if (showActions) width += actionsWidth;
    return width;
  }
}
