import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_api_providers.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/interviews/states/submit_interview_feedback_state.dart';
import 'package:grc/features/hiring/domain/models/submit_interview_feedback_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubmitInterviewFeedbackNotifier
    extends AutoDisposeFamilyNotifier<SubmitInterviewFeedbackState, SubmitInterviewFeedbackParams> {
  @override
  SubmitInterviewFeedbackState build(SubmitInterviewFeedbackParams params) {
    return const SubmitInterviewFeedbackState();
  }

  Future<bool> submit({
    required int overallRating,
    required String? recommendation,
    String? technicalSkills,
    String? communication,
    String? cultureFit,
    String? detailedComments,
  }) async {
    if (overallRating < 1 || recommendation == null || recommendation.trim().isEmpty) {
      return false;
    }

    final interviewGuid = arg.interviewGuid.trim();
    if (interviewGuid.isEmpty) {
      state = state.copyWith(submitError: 'Interview not found');
      return false;
    }

    final enterpriseId = ref.read(interviewsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(submitError: 'Select an enterprise first');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      await ref
          .read(submitInterviewFeedbackUseCaseProvider)
          .call(
            SubmitInterviewFeedbackInput(
              interviewGuid: interviewGuid,
              enterpriseId: enterpriseId,
              overallRating: overallRating,
              technicalSkills: technicalSkills,
              communication: communication,
              cultureFit: cultureFit,
              recommendation: recommendation,
              detailedComments: detailedComments,
              createdBy: createdBy,
            ),
          );

      ref.read(interviewsTabRefreshTickProvider.notifier).state++;

      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to submit feedback. Please try again.');
      return false;
    }
  }
}
