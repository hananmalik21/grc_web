import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/enterprise_stats_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise_stats.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/enterprise_stats_repository.dart';

class EnterpriseStatsRepositoryImpl implements EnterpriseStatsRepository {
  final EnterpriseStatsRemoteDataSource remoteDataSource;

  const EnterpriseStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<EnterpriseStats> getEnterpriseStats({required int enterpriseId}) async {
    try {
      return await remoteDataSource.getEnterpriseStats(enterpriseId: enterpriseId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
