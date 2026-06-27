import 'package:grc/features/payroll/application/person_results/controllers/person_results_ui_controller.dart';
import 'package:grc/features/payroll/application/person_results/states/person_results_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultsUiProvider = StateNotifierProvider<PersonResultsUiController, PersonResultsUiState>((ref) {
  return PersonResultsUiController();
});
