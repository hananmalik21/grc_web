import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_config.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/states/person_result_detail_table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonResultDetailTableWidthController extends StateNotifier<PersonResultDetailTableState> {
  PersonResultDetailTableWidthController() : super(PersonResultDetailTableState.initial());

  void updateWidth(PersonResultDetailTableColumn column, double delta) {
    final minWidth = PersonResultDetailTableConfig.minWidthFor(column);
    double clampWidth(double current) => (current + delta).clamp(minWidth, 700.0);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }

  void reorderColumn(PersonResultDetailTableColumn draggedColumn, PersonResultDetailTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<PersonResultDetailTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
