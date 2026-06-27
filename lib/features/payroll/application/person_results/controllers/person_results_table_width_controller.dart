import 'package:grc/features/payroll/application/person_results/config/person_results_table_config.dart';
import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';
import 'package:grc/features/payroll/application/person_results/states/person_results_table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonResultsTableWidthController extends StateNotifier<PersonResultsTableState> {
  PersonResultsTableWidthController() : super(PersonResultsTableState.initial());

  void updateWidth(PersonResultsTableColumn column, double delta) {
    final minWidth = PersonResultsTableConfig.minWidthFor(column);
    double clampWidth(double current) => (current + delta).clamp(minWidth, 700.0);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }

  void reorderColumn(PersonResultsTableColumn draggedColumn, PersonResultsTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<PersonResultsTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
