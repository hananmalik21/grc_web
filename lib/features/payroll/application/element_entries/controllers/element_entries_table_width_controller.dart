import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_config.dart';
import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_types.dart';
import 'package:grc/features/payroll/application/element_entries/states/element_entries_table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElementEntriesTableWidthController extends StateNotifier<ElementEntriesTableState> {
  ElementEntriesTableWidthController() : super(ElementEntriesTableState.initial());

  void updateWidth(ElementEntriesTableColumn column, double delta) {
    final minWidth = ElementEntriesTableConfig.minWidthFor(column);
    double clampWidth(double current) => (current + delta).clamp(minWidth, 700.0);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }

  void reorderColumn(ElementEntriesTableColumn draggedColumn, ElementEntriesTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<ElementEntriesTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
