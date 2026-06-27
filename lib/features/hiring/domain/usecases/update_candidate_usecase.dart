import 'package:grc/features/hiring/domain/models/candidates/update_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class UpdateCandidateUseCase {
  const UpdateCandidateUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(UpdateCandidateRequestInput input) {
    return repository.updateCandidate(input);
  }
}
