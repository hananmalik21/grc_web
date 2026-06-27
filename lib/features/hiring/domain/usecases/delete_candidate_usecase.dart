import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class DeleteCandidateUseCase {
  const DeleteCandidateUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(DeleteCandidateInput input) {
    return repository.deleteCandidate(input);
  }
}
