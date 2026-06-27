import 'package:grc/features/hiring/domain/models/submit_interview_feedback_input.dart';
import 'package:grc/features/hiring/domain/repositories/interviews_repository.dart';

class SubmitInterviewFeedbackUseCase {
  const SubmitInterviewFeedbackUseCase({required this.repository});

  final InterviewsRepository repository;

  Future<Map<String, dynamic>> call(SubmitInterviewFeedbackInput input) {
    return repository.submitInterviewFeedback(input);
  }
}
