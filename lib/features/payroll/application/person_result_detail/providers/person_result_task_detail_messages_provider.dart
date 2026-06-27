import 'package:grc/features/payroll/application/person_result_detail/controllers/person_result_task_detail_messages_controller.dart';
import 'package:grc/features/payroll/application/person_result_detail/states/person_result_task_detail_messages_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultTaskDetailMessagesProvider =
    StateNotifierProvider<PersonResultTaskDetailMessagesController, PersonResultTaskDetailMessagesState>(
      (ref) => PersonResultTaskDetailMessagesController(),
    );
