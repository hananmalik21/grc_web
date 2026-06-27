import 'package:grc/features/hiring/data/dto/talent_pools_dto.dart';

abstract class TalentPoolsRepository {
  Future<TalentPoolsPageDto> getTalentPools({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> createTalentPool({
    required int enterpriseId,
    required String poolName,
    required String createdBy,
  });

  Future<Map<String, dynamic>> addCandidateToTalentPools({
    required String candidateGuid,
    required int enterpriseId,
    required List<String> poolGuids,
    required String updatedBy,
  });
}
