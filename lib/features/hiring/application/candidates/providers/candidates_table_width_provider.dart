import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_config.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidatesTableState {
  const CandidatesTableState({required this.columnOrder, required this.widthOverrides});

  final List<CandidatesTableColumn> columnOrder;
  final Map<CandidatesTableColumn, double> widthOverrides;

  factory CandidatesTableState.initial() {
    return CandidatesTableState(columnOrder: CandidatesTableColumn.values, widthOverrides: const {});
  }

  double widthFor(CandidatesTableColumn column) {
    final resolved = widthOverrides[column] ?? CandidatesTableConfig.widthFor(column).w;
    return resolved.clamp(CandidatesTableConfig.minWidthFor(column).w, CandidatesTableConfig.maxResizableWidth.w);
  }

  CandidatesTableState copyWith({
    List<CandidatesTableColumn>? columnOrder,
    Map<CandidatesTableColumn, double>? widthOverrides,
  }) {
    return CandidatesTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final candidatesTableWidthsProvider = StateNotifierProvider<CandidatesTableWidthsNotifier, CandidatesTableState>(
  (ref) => CandidatesTableWidthsNotifier(),
);

class CandidatesTableWidthsNotifier extends StateNotifier<CandidatesTableState> {
  CandidatesTableWidthsNotifier() : super(CandidatesTableState.initial());

  void updateWidth(CandidatesTableColumn column, double delta) {
    final minWidth = CandidatesTableConfig.minWidthFor(column).w;
    final maxWidth = CandidatesTableConfig.maxResizableWidth.w;
    final nextWidth = (state.widthFor(column) + delta).clamp(minWidth, maxWidth);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: nextWidth});
  }

  void reorderColumn(CandidatesTableColumn draggedColumn, CandidatesTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<CandidatesTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}
