import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class DeleteCandidateAssessmentUseCase {
  const DeleteCandidateAssessmentUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(DeleteCandidateAssessmentInput input) {
    return repository.deleteCandidateAssessment(input);
  }
}
