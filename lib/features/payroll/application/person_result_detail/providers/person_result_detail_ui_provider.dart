import 'package:grc/features/payroll/application/person_result_detail/controllers/person_result_detail_ui_controller.dart';
import 'package:grc/features/payroll/application/person_result_detail/states/person_result_detail_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultDetailUiProvider = StateNotifierProvider<PersonResultDetailUiController, PersonResultDetailUiState>(
  (ref) => PersonResultDetailUiController(),
);
