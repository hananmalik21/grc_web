import 'adjustments_table_types.dart';

class AdjustmentsTableLayoutConfig {
  AdjustmentsTableLayoutConfig._();

  static const double minEmployeeWidth = 160.0;
  static const double minDepartmentWidth = 120.0;
  static const double minAdjustmentTypeWidth = 140.0;
  static const double minCurrentSalaryWidth = 110.0;
  static const double minAdjustmentMethodWidth = 130.0;
  static const double minAdjustmentValueWidth = 110.0;
  static const double minNewSalaryWidth = 110.0;
  static const double minIncreaseWidth = 110.0;
  static const double minEffectiveDateWidth = 130.0;
  static const double minReasonWidth = 220.0;
  static const double minStatusWidth = 170.0;

  static double minWidthFor(AdjustmentsTableColumn column) {
    switch (column) {
      case AdjustmentsTableColumn.employee:
        return minEmployeeWidth;
      case AdjustmentsTableColumn.department:
        return minDepartmentWidth;
      case AdjustmentsTableColumn.adjustmentType:
        return minAdjustmentTypeWidth;
      case AdjustmentsTableColumn.currentSalary:
        return minCurrentSalaryWidth;
      case AdjustmentsTableColumn.adjustmentMethod:
        return minAdjustmentMethodWidth;
      case AdjustmentsTableColumn.adjustmentValue:
        return minAdjustmentValueWidth;
      case AdjustmentsTableColumn.newSalary:
        return minNewSalaryWidth;
      case AdjustmentsTableColumn.increase:
        return minIncreaseWidth;
      case AdjustmentsTableColumn.effectiveDate:
        return minEffectiveDateWidth;
      case AdjustmentsTableColumn.reason:
        return minReasonWidth;
      case AdjustmentsTableColumn.status:
        return minStatusWidth;
    }
  }

  static const double maxColumnWidth = 700.0;

  static const double actionsWidth = 200;

  static const double employeeWidth = 260;
  static const double departmentWidth = 180;
  static const double adjustmentTypeWidth = 220;
  static const double currentSalaryWidth = 170;
  static const double adjustmentMethodWidth = 200;
  static const double adjustmentValueWidth = 180;
  static const double newSalaryWidth = 170;
  static const double increaseWidth = 170;
  static const double effectiveDateWidth = 190;
  static const double reasonWidth = 240;
  static const double statusWidth = 190;

  static const bool showActions = true;

  static double widthFor(AdjustmentsTableColumn column) {
    return switch (column) {
      AdjustmentsTableColumn.employee => employeeWidth,
      AdjustmentsTableColumn.department => departmentWidth,
      AdjustmentsTableColumn.adjustmentType => adjustmentTypeWidth,
      AdjustmentsTableColumn.currentSalary => currentSalaryWidth,
      AdjustmentsTableColumn.adjustmentMethod => adjustmentMethodWidth,
      AdjustmentsTableColumn.adjustmentValue => adjustmentValueWidth,
      AdjustmentsTableColumn.newSalary => newSalaryWidth,
      AdjustmentsTableColumn.increase => increaseWidth,
      AdjustmentsTableColumn.effectiveDate => effectiveDateWidth,
      AdjustmentsTableColumn.reason => reasonWidth,
      AdjustmentsTableColumn.status => statusWidth,
    };
  }
}
