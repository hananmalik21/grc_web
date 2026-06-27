import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/workforce_structure/data/datasources/workforce_stats_remote_datasource.dart';
import 'package:grc/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:grc/features/workforce_structure/domain/repositories/workforce_stats_repository.dart';

class WorkforceStatsRepositoryImpl implements WorkforceStatsRepository {
  final WorkforceStatsRemoteDataSource remoteDataSource;

  const WorkforceStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WorkforceStats> getWorkforceStats({int? tenantId}) async {
    try {
      return await remoteDataSource.getWorkforceStats(tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
