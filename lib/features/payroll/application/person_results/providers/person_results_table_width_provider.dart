import 'package:grc/features/payroll/application/person_results/controllers/person_results_table_width_controller.dart';
import 'package:grc/features/payroll/application/person_results/states/person_results_table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultsTableWidthsProvider =
    StateNotifierProvider<PersonResultsTableWidthController, PersonResultsTableState>(
      (ref) => PersonResultsTableWidthController(),
    );
