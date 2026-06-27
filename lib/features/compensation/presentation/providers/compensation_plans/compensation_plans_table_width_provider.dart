import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/compensation_plans/compensation_plans_table_config.dart';
import '../../widgets/compensation_plans/compensation_plans_table_types.dart';

class CompensationPlansTableState {
  final List<CompensationPlansTableColumn> columnOrder;
  final Map<CompensationPlansTableColumn, double> widthOverrides;

  const CompensationPlansTableState({required this.columnOrder, required this.widthOverrides});

  factory CompensationPlansTableState.initial() {
    return const CompensationPlansTableState(columnOrder: CompensationPlansTableColumn.values, widthOverrides: {});
  }

  double widthFor(CompensationPlansTableColumn column) {
    return widthOverrides[column] ?? CompensationPlansTableConfig.widthFor(column);
  }

  CompensationPlansTableState copyWith({
    List<CompensationPlansTableColumn>? columnOrder,
    Map<CompensationPlansTableColumn, double>? widthOverrides,
  }) {
    return CompensationPlansTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final compensationPlansTableWidthsProvider =
    StateNotifierProvider<CompensationPlansTableWidthsNotifier, CompensationPlansTableState>(
      (ref) => CompensationPlansTableWidthsNotifier(),
    );

class CompensationPlansTableWidthsNotifier extends StateNotifier<CompensationPlansTableState> {
  CompensationPlansTableWidthsNotifier() : super(CompensationPlansTableState.initial());

  void updateWidth(CompensationPlansTableColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(80.0, 700.0);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }

  void reorderColumn(CompensationPlansTableColumn draggedColumn, CompensationPlansTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<CompensationPlansTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
