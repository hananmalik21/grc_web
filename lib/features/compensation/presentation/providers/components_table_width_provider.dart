import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/components/components_table_config.dart';
import '../widgets/components/components_table_types.dart';

class ComponentsTableState {
  final List<ComponentsTableColumn> columnOrder;
  final Map<ComponentsTableColumn, double> widthOverrides;

  const ComponentsTableState({required this.columnOrder, required this.widthOverrides});

  factory ComponentsTableState.initial() {
    return ComponentsTableState(columnOrder: ComponentsTableColumn.values, widthOverrides: const {});
  }

  double widthFor(ComponentsTableColumn column) {
    return widthOverrides[column] ?? ComponentsTableConfig.widthFor(column).w;
  }

  ComponentsTableState copyWith({
    List<ComponentsTableColumn>? columnOrder,
    Map<ComponentsTableColumn, double>? widthOverrides,
  }) {
    return ComponentsTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final componentsTableWidthsProvider = StateNotifierProvider<ComponentsTableWidthsNotifier, ComponentsTableState>(
  (ref) => ComponentsTableWidthsNotifier(),
);

class ComponentsTableWidthsNotifier extends StateNotifier<ComponentsTableState> {
  ComponentsTableWidthsNotifier() : super(ComponentsTableState.initial());

  void updateWidth(ComponentsTableColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(80.0, 700.0);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }

  void reorderColumn(ComponentsTableColumn draggedColumn, ComponentsTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<ComponentsTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
