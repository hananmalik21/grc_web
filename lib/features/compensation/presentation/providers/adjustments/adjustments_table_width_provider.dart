import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_layout_config.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_types.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';

class AdjustmentsTableState {
  final List<AdjustmentsTableColumn> columnOrder;
  final Map<AdjustmentsTableColumn, double> widthOverrides;

  const AdjustmentsTableState({required this.columnOrder, required this.widthOverrides});

  factory AdjustmentsTableState.initial() {
    return AdjustmentsTableState(columnOrder: AdjustmentsTabConfig.defaultColumnOrder, widthOverrides: {});
  }

  double widthFor(AdjustmentsTableColumn column) {
    return widthOverrides[column] ?? AdjustmentsTableLayoutConfig.widthFor(column);
  }

  AdjustmentsTableState copyWith({
    List<AdjustmentsTableColumn>? columnOrder,
    Map<AdjustmentsTableColumn, double>? widthOverrides,
  }) {
    return AdjustmentsTableState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final adjustmentsTableWidthsProvider = StateNotifierProvider<AdjustmentsTableWidthsNotifier, AdjustmentsTableState>(
  (ref) => AdjustmentsTableWidthsNotifier(),
);

class AdjustmentsTableWidthsNotifier extends StateNotifier<AdjustmentsTableState> {
  AdjustmentsTableWidthsNotifier() : super(AdjustmentsTableState.initial());

  void updateWidth(AdjustmentsTableColumn column, double delta) {
    double minWidth = AdjustmentsTableLayoutConfig.minWidthFor(column);
    double maxWidth = AdjustmentsTableLayoutConfig.maxColumnWidth;
    double clampWidth(double current) => (current + delta).clamp(minWidth, maxWidth);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clampWidth(state.widthFor(column))});
  }
}
