import 'package:grc/features/hiring/domain/repositories/talent_pools_repository.dart';

class AddCandidateToTalentPoolsUseCase {
  const AddCandidateToTalentPoolsUseCase({required this.repository});

  final TalentPoolsRepository repository;

  Future<Map<String, dynamic>> call({
    required String candidateGuid,
    required int enterpriseId,
    required List<String> poolGuids,
    required String updatedBy,
  }) {
    return repository.addCandidateToTalentPools(
      candidateGuid: candidateGuid,
      enterpriseId: enterpriseId,
      poolGuids: poolGuids,
      updatedBy: updatedBy,
    );
  }
}
