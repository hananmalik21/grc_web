import 'compensation_plans_table_types.dart';

class CompensationPlansTableConfig {
  CompensationPlansTableConfig._();

  static const double actionsWidth = 160.5;

  static const double planNameWidth = 282;
  static const double planCodeWidth = 161.58;
  static const double planTypeWidth = 150;
  static const double statusWidth = 120;
  static const double currencyWidth = 97.55;

  static const int pageSize = 10;

  static double widthFor(CompensationPlansTableColumn column) {
    return switch (column) {
      CompensationPlansTableColumn.planName => planNameWidth,
      CompensationPlansTableColumn.planCode => planCodeWidth,
      CompensationPlansTableColumn.planType => planTypeWidth,
      CompensationPlansTableColumn.status => statusWidth,
      CompensationPlansTableColumn.currency => currencyWidth,
    };
  }

  static const showActions = true;
}
