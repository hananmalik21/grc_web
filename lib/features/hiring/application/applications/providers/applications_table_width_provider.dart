import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/applications_table_types.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/applications_table_config.dart';

class ApplicationsTableWidthState {
  final List<ApplicationsTableColumn> columnOrder;
  final Map<ApplicationsTableColumn, double> widthOverrides;

  ApplicationsTableWidthState({required this.columnOrder, required this.widthOverrides});

  double widthFor(ApplicationsTableColumn column) {
    final resolved = widthOverrides[column] ?? ApplicationsTableConfig.widthFor(column).w;
    return resolved.clamp(ApplicationsTableConfig.minWidthFor(column).w, ApplicationsTableConfig.maxResizableWidth.w);
  }

  ApplicationsTableWidthState copyWith({
    List<ApplicationsTableColumn>? columnOrder,
    Map<ApplicationsTableColumn, double>? widthOverrides,
  }) {
    return ApplicationsTableWidthState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

class ApplicationsTableWidthsNotifier extends Notifier<ApplicationsTableWidthState> {
  @override
  ApplicationsTableWidthState build() {
    return ApplicationsTableWidthState(columnOrder: ApplicationsTableColumn.values.toList(), widthOverrides: const {});
  }

  void updateWidth(ApplicationsTableColumn column, double delta) {
    final minWidth = ApplicationsTableConfig.minWidthFor(column).w;
    final maxWidth = ApplicationsTableConfig.maxResizableWidth.w;
    final nextWidth = (state.widthFor(column) + delta).clamp(minWidth, maxWidth);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: nextWidth});
  }

  void reorderColumn(ApplicationsTableColumn draggedColumn, ApplicationsTableColumn targetColumn) {
    if (draggedColumn == targetColumn) return;

    final updated = List<ApplicationsTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(draggedColumn);
    final newIndex = updated.indexOf(targetColumn);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, draggedColumn);

    state = state.copyWith(columnOrder: updated);
  }
}

final applicationsTableWidthsProvider = NotifierProvider<ApplicationsTableWidthsNotifier, ApplicationsTableWidthState>(
  ApplicationsTableWidthsNotifier.new,
);
