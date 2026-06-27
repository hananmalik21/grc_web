import 'requisitions_table_types.dart';

class RequisitionsTableConfig {
  RequisitionsTableConfig._();

  static const double actionsWidth = 232;

  static const double detailsWidth = 220;
  static const double departmentWidth = 190;
  static const double locationWidth = 155;
  static const double openingsWidth = 105;
  static const double compensationWidth = 165;
  static const double statusWidth = 175;
  static const double approvalWidth = 135;
  static const double priorityWidth = 120;
  static const double targetStartWidth = 125;

  static double widthFor(RequisitionsTableColumn column) {
    return switch (column) {
      RequisitionsTableColumn.details => detailsWidth,
      RequisitionsTableColumn.department => departmentWidth,
      RequisitionsTableColumn.location => locationWidth,
      RequisitionsTableColumn.openings => openingsWidth,
      RequisitionsTableColumn.compensation => compensationWidth,
      RequisitionsTableColumn.status => statusWidth,
      RequisitionsTableColumn.approval => approvalWidth,
      RequisitionsTableColumn.priority => priorityWidth,
      RequisitionsTableColumn.targetStart => targetStartWidth,
    };
  }

  static const double maxResizableWidth = 520;

  static const double detailsMinWidth = 180;
  static const double departmentMinWidth = 155;
  static const double locationMinWidth = 125;
  static const double openingsMinWidth = 72;
  static const double compensationMinWidth = 140;
  static const double statusMinWidth = 115;
  static const double approvalMinWidth = 105;
  static const double priorityMinWidth = 95;
  static const double targetStartMinWidth = 105;

  static double minWidthFor(RequisitionsTableColumn column) {
    return switch (column) {
      RequisitionsTableColumn.details => detailsMinWidth,
      RequisitionsTableColumn.department => departmentMinWidth,
      RequisitionsTableColumn.location => locationMinWidth,
      RequisitionsTableColumn.openings => openingsMinWidth,
      RequisitionsTableColumn.compensation => compensationMinWidth,
      RequisitionsTableColumn.status => statusMinWidth,
      RequisitionsTableColumn.approval => approvalMinWidth,
      RequisitionsTableColumn.priority => priorityMinWidth,
      RequisitionsTableColumn.targetStart => targetStartMinWidth,
    };
  }

  static const bool showActions = true;
  static const int pageSize = 10;
}
