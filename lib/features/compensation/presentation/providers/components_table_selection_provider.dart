import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/component_table_row_data.dart';

typedef ComponentsSelectedCodes = Set<String>;

final componentsTableSelectionProvider =
    StateNotifierProvider<ComponentsTableSelectionNotifier, ComponentsSelectedCodes>(
      (ref) => ComponentsTableSelectionNotifier(),
    );

class ComponentsTableSelectionNotifier extends StateNotifier<ComponentsSelectedCodes> {
  ComponentsTableSelectionNotifier() : super(<String>{});

  bool isSelected(String code) => state.contains(code);

  void toggle(String code) {
    if (state.contains(code)) {
      state = {...state}..remove(code);
    } else {
      state = {...state, code};
    }
  }

  void clear() => state = <String>{};

  void setAllForRows(List<ComponentTableRowData> rows, {required bool selected}) {
    final codes = rows.map((e) => e.code).toSet();
    if (selected) {
      state = {...state, ...codes};
    } else {
      state = {...state}..removeAll(codes);
    }
  }
}
