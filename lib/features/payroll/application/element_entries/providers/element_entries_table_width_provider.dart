import 'package:grc/features/payroll/application/element_entries/controllers/element_entries_table_width_controller.dart';
import 'package:grc/features/payroll/application/element_entries/states/element_entries_table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final elementEntriesTableWidthsProvider =
    StateNotifierProvider<ElementEntriesTableWidthController, ElementEntriesTableState>(
      (ref) => ElementEntriesTableWidthController(),
    );
