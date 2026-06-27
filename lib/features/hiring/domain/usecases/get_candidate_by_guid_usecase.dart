import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class GetCandidateByGuidUseCase {
  const GetCandidateByGuidUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Candidate> call({required String candidateGuid, required int enterpriseId}) {
    return repository.getCandidateByGuid(candidateGuid: candidateGuid, enterpriseId: enterpriseId);
  }
}
