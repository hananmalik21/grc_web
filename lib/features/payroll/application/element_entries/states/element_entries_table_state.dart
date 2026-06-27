import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_config.dart';
import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElementEntriesTableState {
  const ElementEntriesTableState({required this.columnOrder, required this.widthOverrides});

  final List<ElementEntriesTableColumn> columnOrder;
  final Map<ElementEntriesTableColumn, double> widthOverrides;

  factory ElementEntriesTableState.initial() {
    return ElementEntriesTableState(columnOrder: ElementEntriesTableColumn.values, widthOverrides: const {});
  }

  double widthFor(ElementEntriesTableColumn column) {
    return widthOverrides[column] ?? ElementEntriesTableConfig.widthFor(column).w;
  }

  ElementEntriesTableState copyWith({
    List<ElementEntriesTableColumn>? columnOrder,
    Map<ElementEntriesTableColumn, double>? widthOverrides,
  }) {
    return ElementEntriesTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}
