import 'package:grc/features/hiring/application/interviews/controllers/submit_interview_feedback_controller.dart';
import 'package:grc/features/hiring/application/interviews/states/submit_interview_feedback_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final submitInterviewFeedbackControllerProvider =
    AutoDisposeNotifierProviderFamily<
      SubmitInterviewFeedbackNotifier,
      SubmitInterviewFeedbackState,
      SubmitInterviewFeedbackParams
    >(SubmitInterviewFeedbackNotifier.new);
