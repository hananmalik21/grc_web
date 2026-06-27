import 'components_table_types.dart';

class ComponentsTableConfig {
  ComponentsTableConfig._();

  // Keep these closer to other module tables so the table doesn't look "shrunk"
  // when the viewport is wide.
  static const double actionsWidth = 200;

  static const double componentWidth = 260;
  static const double categoryWidth = 260;
  static const double calculationWidth = 180;
  static const double statusWidth = 190;
  static const double payrollWidth = 170;
  static const double usedInWidth = 160;

  static double widthFor(ComponentsTableColumn column) {
    return switch (column) {
      ComponentsTableColumn.component => componentWidth,
      ComponentsTableColumn.category => categoryWidth,
      ComponentsTableColumn.calculation => calculationWidth,
      ComponentsTableColumn.status => statusWidth,
      ComponentsTableColumn.payroll => payrollWidth,
      ComponentsTableColumn.usedIn => usedInWidth,
    };
  }

  static const showActions = true;
  static const int pageSize = 10;
}
