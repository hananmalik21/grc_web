import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/employee_compensation/employee_compensation_table_config.dart';
import '../widgets/employee_compensation/employee_compensation_table_types.dart';

class EmployeeCompensationTableState {
  final List<EmployeeCompensationTableColumn> columnOrder;
  final Map<EmployeeCompensationTableColumn, double> widthOverrides;

  const EmployeeCompensationTableState({required this.columnOrder, required this.widthOverrides});

  factory EmployeeCompensationTableState.initial() {
    return const EmployeeCompensationTableState(
      columnOrder: EmployeeCompensationTableColumn.values,
      widthOverrides: {},
    );
  }

  double widthFor(EmployeeCompensationTableColumn column) {
    return widthOverrides[column] ?? EmployeeCompensationTableConfig.widthFor(column).w;
  }

  EmployeeCompensationTableState copyWith({
    List<EmployeeCompensationTableColumn>? columnOrder,
    Map<EmployeeCompensationTableColumn, double>? widthOverrides,
  }) {
    return EmployeeCompensationTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final employeeCompensationTableWidthsProvider =
    StateNotifierProvider<EmployeeCompensationTableWidthsNotifier, EmployeeCompensationTableState>(
      (ref) => EmployeeCompensationTableWidthsNotifier(),
    );

class EmployeeCompensationTableWidthsNotifier extends StateNotifier<EmployeeCompensationTableState> {
  EmployeeCompensationTableWidthsNotifier() : super(EmployeeCompensationTableState.initial());

  void updateWidth(EmployeeCompensationTableColumn column, double delta) {
    final minWidth = EmployeeCompensationTableConfig.minWidthFor(column).w;

    double clampWidth(double current) =>
        (current + delta).clamp(minWidth, EmployeeCompensationTableConfig.maxResizableWidth.w);

    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }

  void reorderColumn(EmployeeCompensationTableColumn draggedColumn, EmployeeCompensationTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<EmployeeCompensationTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
