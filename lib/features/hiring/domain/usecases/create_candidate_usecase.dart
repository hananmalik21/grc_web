import 'package:grc/features/hiring/domain/models/candidates/create_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class CreateCandidateUseCase {
  const CreateCandidateUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(CreateCandidateRequestInput input) {
    return repository.createCandidate(input);
  }
}
