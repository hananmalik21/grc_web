import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/active_structure_stats_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_stats.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/active_structure_stats_repository.dart';

class ActiveStructureStatsRepositoryImpl implements ActiveStructureStatsRepository {
  final ActiveStructureStatsRemoteDataSource remoteDataSource;

  const ActiveStructureStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ActiveStructureStats> getActiveStructureStats({required int enterpriseId}) async {
    try {
      return await remoteDataSource.getActiveStructureStats(enterpriseId: enterpriseId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
