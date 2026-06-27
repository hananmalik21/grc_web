class OvertimeTableConfig {
  OvertimeTableConfig._();

  static const bool showEmployee = true;
  static const bool showDate = true;
  static const bool showType = true;
  static const bool showHours = true;
  static const bool showRate = true;
  static const bool showAmount = true;
  static const bool showStatus = true;
  static const bool showActions = true;

  static const double employeeWidth = 320;
  static const double dateWidth = 240;
  static const double typeWidth = 200;
  static const double hoursWidth = 200;
  static const double rateWidth = 140;
  static const double amountWidth = 160;
  static const double statusWidth = 200;
  static const double actionsWidth = 160;

  static const double cellPaddingHorizontal = 28;

  static double get totalWidth {
    double width = 0;
    if (showEmployee) width += employeeWidth;
    if (showDate) width += dateWidth;
    if (showType) width += typeWidth;
    if (showHours) width += hoursWidth;
    if (showRate) width += rateWidth;
    if (showAmount) width += amountWidth;
    if (showStatus) width += statusWidth;
    if (showActions) width += actionsWidth;
    return width;
  }
}
