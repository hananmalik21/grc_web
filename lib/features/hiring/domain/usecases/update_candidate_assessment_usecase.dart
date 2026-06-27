import 'package:grc/features/hiring/domain/models/candidates/update_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class UpdateCandidateAssessmentUseCase {
  const UpdateCandidateAssessmentUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(UpdateCandidateAssessmentInput input) {
    return repository.updateCandidateAssessment(input);
  }
}
