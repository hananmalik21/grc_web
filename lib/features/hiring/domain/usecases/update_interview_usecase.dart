import 'package:grc/features/hiring/domain/models/update_interview_input.dart';
import 'package:grc/features/hiring/domain/repositories/interviews_repository.dart';

class UpdateInterviewUseCase {
  const UpdateInterviewUseCase({required this.repository});

  final InterviewsRepository repository;

  Future<Map<String, dynamic>> call(UpdateInterviewInput input) {
    return repository.updateInterview(input);
  }
}
