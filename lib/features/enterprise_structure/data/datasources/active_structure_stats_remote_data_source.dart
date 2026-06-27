import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/active_structure_stats_dto.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_stats.dart';

abstract class ActiveStructureStatsRemoteDataSource {
  Future<ActiveStructureStats> getActiveStructureStats({required int enterpriseId});
}

class ActiveStructureStatsRemoteDataSourceImpl implements ActiveStructureStatsRemoteDataSource {
  final ApiClient apiClient;

  const ActiveStructureStatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ActiveStructureStats> getActiveStructureStats({required int enterpriseId}) async {
    try {
      final queryParams = <String, String>{'enterprise_id': enterpriseId.toString()};
      final response = await apiClient.get(ApiEndpoints.activeStructureStats, queryParameters: queryParams);

      final data = response['data'] as Map<String, dynamic>? ?? response;
      final dto = ActiveStructureStatsDto.fromJson(data);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch active structure stats: ${e.toString()}', originalError: e);
    }
  }
}
