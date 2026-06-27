import 'package:grc/features/hiring/application/candidates/states/schedule_interview_state.dart';
import 'package:grc/features/hiring/application/interviews/controllers/create_new_interview_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createNewInterviewProvider = AutoDisposeNotifierProvider<CreateNewInterviewNotifier, ScheduleInterviewState>(
  CreateNewInterviewNotifier.new,
);
