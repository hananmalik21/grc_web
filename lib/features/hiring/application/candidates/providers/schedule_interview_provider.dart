import 'package:grc/features/hiring/application/candidates/controllers/schedule_interview_controller.dart';
import 'package:grc/features/hiring/application/candidates/states/schedule_interview_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleInterviewProvider =
    AutoDisposeNotifierProviderFamily<ScheduleInterviewNotifier, ScheduleInterviewState, String>(
      ScheduleInterviewNotifier.new,
    );
