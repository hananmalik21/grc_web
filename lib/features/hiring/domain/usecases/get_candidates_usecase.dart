import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class GetCandidatesUseCase {
  const GetCandidatesUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<CandidatesPage> call({required int enterpriseId, int page = 1, int pageSize = 10}) {
    return repository.getCandidates(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
  }
}
