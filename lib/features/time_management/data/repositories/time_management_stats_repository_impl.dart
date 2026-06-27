import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/datasources/time_management_stats_remote_datasource.dart';
import 'package:grc/features/time_management/domain/models/time_management_stats.dart';
import 'package:grc/features/time_management/domain/repositories/time_management_stats_repository.dart';

class TimeManagementStatsRepositoryImpl implements TimeManagementStatsRepository {
  final TimeManagementStatsRemoteDataSource remoteDataSource;

  const TimeManagementStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TimeManagementStats> getTimeManagementStats({required int enterpriseId}) async {
    try {
      return await remoteDataSource.getTimeManagementStats(enterpriseId: enterpriseId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
