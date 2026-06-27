import 'package:grc/features/hiring/data/datasources/talent_pools_remote_data_source.dart';
import 'package:grc/features/hiring/data/dto/talent_pools_dto.dart';
import 'package:grc/features/hiring/domain/repositories/talent_pools_repository.dart';

class TalentPoolsRepositoryImpl implements TalentPoolsRepository {
  const TalentPoolsRepositoryImpl({required this.remoteDataSource});

  final TalentPoolsRemoteDataSource remoteDataSource;

  @override
  Future<TalentPoolsPageDto> getTalentPools({required int enterpriseId, int page = 1, int pageSize = 10}) {
    return remoteDataSource.getTalentPools(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
  }

  @override
  Future<Map<String, dynamic>> createTalentPool({
    required int enterpriseId,
    required String poolName,
    required String createdBy,
  }) {
    return remoteDataSource.createTalentPool(enterpriseId: enterpriseId, poolName: poolName, createdBy: createdBy);
  }

  @override
  Future<Map<String, dynamic>> addCandidateToTalentPools({
    required String candidateGuid,
    required int enterpriseId,
    required List<String> poolGuids,
    required String updatedBy,
  }) {
    return remoteDataSource.addCandidateToTalentPools(
      candidateGuid: candidateGuid,
      enterpriseId: enterpriseId,
      poolGuids: poolGuids,
      updatedBy: updatedBy,
    );
  }
}
