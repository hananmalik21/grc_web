import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_config.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequisitionsTableState {
  const RequisitionsTableState({required this.columnOrder, required this.widthOverrides});

  final List<RequisitionsTableColumn> columnOrder;
  final Map<RequisitionsTableColumn, double> widthOverrides;

  factory RequisitionsTableState.initial() {
    return RequisitionsTableState(columnOrder: RequisitionsTableColumn.values, widthOverrides: const {});
  }

  double widthFor(RequisitionsTableColumn column) {
    final resolved = widthOverrides[column] ?? RequisitionsTableConfig.widthFor(column).w;
    return resolved.clamp(RequisitionsTableConfig.minWidthFor(column).w, RequisitionsTableConfig.maxResizableWidth.w);
  }

  RequisitionsTableState copyWith({
    List<RequisitionsTableColumn>? columnOrder,
    Map<RequisitionsTableColumn, double>? widthOverrides,
  }) {
    return RequisitionsTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final requisitionsTableWidthsProvider = StateNotifierProvider<RequisitionsTableWidthsNotifier, RequisitionsTableState>(
  (ref) => RequisitionsTableWidthsNotifier(),
);

class RequisitionsTableWidthsNotifier extends StateNotifier<RequisitionsTableState> {
  RequisitionsTableWidthsNotifier() : super(RequisitionsTableState.initial());

  void updateWidth(RequisitionsTableColumn column, double delta) {
    final minWidth = RequisitionsTableConfig.minWidthFor(column).w;
    final maxWidth = RequisitionsTableConfig.maxResizableWidth.w;
    final nextWidth = (state.widthFor(column) + delta).clamp(minWidth, maxWidth);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: nextWidth});
  }

  void reorderColumn(RequisitionsTableColumn draggedColumn, RequisitionsTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<RequisitionsTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
