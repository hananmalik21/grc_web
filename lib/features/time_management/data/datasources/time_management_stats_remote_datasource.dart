import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/dto/time_management_stats_dto.dart';
import 'package:grc/features/time_management/domain/models/time_management_stats.dart';

abstract class TimeManagementStatsRemoteDataSource {
  Future<TimeManagementStats> getTimeManagementStats({required int enterpriseId});
}

class TimeManagementStatsRemoteDataSourceImpl implements TimeManagementStatsRemoteDataSource {
  final ApiClient apiClient;

  const TimeManagementStatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TimeManagementStats> getTimeManagementStats({required int enterpriseId}) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final queryParameters = <String, String>{'tenant_id': enterpriseId.toString()};
      final response = await apiClient.get(ApiEndpoints.tmStats, queryParameters: queryParameters);

      final dto = TimeManagementStatsDto.fromJson(response['data'] as Map<String, dynamic>);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch time management stats: ${e.toString()}', originalError: e);
    }
  }
}
