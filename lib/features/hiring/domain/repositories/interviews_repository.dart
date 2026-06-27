import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/domain/models/submit_interview_feedback_input.dart';
import 'package:grc/features/hiring/domain/models/update_interview_input.dart';

abstract class InterviewsRepository {
  Future<InterviewsPage> getInterviews({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> submitInterviewFeedback(SubmitInterviewFeedbackInput input);

  Future<Map<String, dynamic>> updateInterview(UpdateInterviewInput input);
}
