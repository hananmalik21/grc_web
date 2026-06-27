import 'package:grc/features/payroll/application/person_result_detail/controllers/person_result_detail_table_width_controller.dart';
import 'package:grc/features/payroll/application/person_result_detail/states/person_result_detail_table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultDetailTableWidthsProvider =
    StateNotifierProvider<PersonResultDetailTableWidthController, PersonResultDetailTableState>(
      (ref) => PersonResultDetailTableWidthController(),
    );
