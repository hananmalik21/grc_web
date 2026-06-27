import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/salary_change_history/salary_change_history_table_config.dart';
import '../widgets/salary_change_history/salary_change_history_table_types.dart';

class SalaryChangeHistoryTableState {
  final List<SalaryChangeHistoryTableColumn> columnOrder;
  final Map<SalaryChangeHistoryTableColumn, double> widthOverrides;

  const SalaryChangeHistoryTableState({required this.columnOrder, required this.widthOverrides});

  factory SalaryChangeHistoryTableState.initial() {
    return const SalaryChangeHistoryTableState(columnOrder: SalaryChangeHistoryTableColumn.values, widthOverrides: {});
  }

  double widthFor(SalaryChangeHistoryTableColumn column) {
    return widthOverrides[column] ?? SalaryChangeHistoryTableConfig.widthFor(column).w;
  }

  SalaryChangeHistoryTableState copyWith({
    List<SalaryChangeHistoryTableColumn>? columnOrder,
    Map<SalaryChangeHistoryTableColumn, double>? widthOverrides,
  }) {
    return SalaryChangeHistoryTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final salaryChangeHistoryTableWidthsProvider =
    StateNotifierProvider<SalaryChangeHistoryTableWidthsNotifier, SalaryChangeHistoryTableState>(
      (ref) => SalaryChangeHistoryTableWidthsNotifier(),
    );

class SalaryChangeHistoryTableWidthsNotifier extends StateNotifier<SalaryChangeHistoryTableState> {
  SalaryChangeHistoryTableWidthsNotifier() : super(SalaryChangeHistoryTableState.initial());

  void updateWidth(SalaryChangeHistoryTableColumn column, double delta) {
    final minWidth = SalaryChangeHistoryTableConfig.minWidthFor(column).w;

    double clampWidth(double current) =>
        (current + delta).clamp(minWidth, SalaryChangeHistoryTableConfig.maxResizableWidth.w);

    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }

  void reorderColumn(SalaryChangeHistoryTableColumn draggedColumn, SalaryChangeHistoryTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<SalaryChangeHistoryTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
