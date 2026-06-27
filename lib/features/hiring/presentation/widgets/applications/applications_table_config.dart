import 'applications_table_types.dart';

class ApplicationsTableConfig {
  ApplicationsTableConfig._();

  static const double actionsWidth = 120;
  static const double applicationIdWidth = 160;
  static const double candidateWidth = 180;
  static const double requisitionWidth = 220;
  static const double appliedDateWidth = 140;
  static const double currentStageWidth = 160;
  static const double statusWidth = 160;
  static const double sourceWidth = 180;

  static double widthFor(ApplicationsTableColumn column) {
    return switch (column) {
      ApplicationsTableColumn.applicationId => applicationIdWidth,
      ApplicationsTableColumn.candidate => candidateWidth,
      ApplicationsTableColumn.requisition => requisitionWidth,
      ApplicationsTableColumn.appliedDate => appliedDateWidth,
      ApplicationsTableColumn.currentStage => currentStageWidth,
      ApplicationsTableColumn.status => statusWidth,
      ApplicationsTableColumn.source => sourceWidth,
    };
  }

  static const double maxResizableWidth = 500;

  static const double applicationIdMinWidth = 120;
  static const double candidateMinWidth = 140;
  static const double requisitionMinWidth = 180;
  static const double appliedDateMinWidth = 100;
  static const double currentStageMinWidth = 120;
  static const double statusMinWidth = 120;
  static const double sourceMinWidth = 140;

  static double minWidthFor(ApplicationsTableColumn column) {
    return switch (column) {
      ApplicationsTableColumn.applicationId => applicationIdMinWidth,
      ApplicationsTableColumn.candidate => candidateMinWidth,
      ApplicationsTableColumn.requisition => requisitionMinWidth,
      ApplicationsTableColumn.appliedDate => appliedDateMinWidth,
      ApplicationsTableColumn.currentStage => currentStageMinWidth,
      ApplicationsTableColumn.status => statusMinWidth,
      ApplicationsTableColumn.source => sourceMinWidth,
    };
  }

  static const bool showActions = false;
  static const int pageSize = 10;
}
