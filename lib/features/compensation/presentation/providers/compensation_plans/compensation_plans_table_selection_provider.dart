import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/compensation_plan_table_row_data.dart';

typedef CompensationPlansSelectedCodes = Set<String>;

final compensationPlansTableSelectionProvider =
    StateNotifierProvider<CompensationPlansTableSelectionNotifier, CompensationPlansSelectedCodes>(
      (ref) => CompensationPlansTableSelectionNotifier(),
    );

class CompensationPlansTableSelectionNotifier extends StateNotifier<CompensationPlansSelectedCodes> {
  CompensationPlansTableSelectionNotifier() : super(<String>{});

  void toggle(String code) {
    if (state.contains(code)) {
      state = {...state}..remove(code);
    } else {
      state = {...state, code};
    }
  }

  void clear() => state = <String>{};

  void setAllForRows(List<CompensationPlanTableRowData> rows, {required bool selected}) {
    final codes = rows.map((e) => e.code).toSet();
    if (selected) {
      state = {...state, ...codes};
    } else {
      state = {...state}..removeAll(codes);
    }
  }
}
