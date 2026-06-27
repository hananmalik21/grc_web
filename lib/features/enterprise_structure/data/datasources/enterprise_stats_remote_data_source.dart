import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/enterprise_stats_dto.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise_stats.dart';

abstract class EnterpriseStatsRemoteDataSource {
  Future<EnterpriseStats> getEnterpriseStats({required int enterpriseId});
}

class EnterpriseStatsRemoteDataSourceImpl implements EnterpriseStatsRemoteDataSource {
  final ApiClient apiClient;

  const EnterpriseStatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<EnterpriseStats> getEnterpriseStats({required int enterpriseId}) async {
    try {
      final queryParams = <String, String>{'enterprise_id': enterpriseId.toString()};
      final response = await apiClient.get(ApiEndpoints.enterpriseStats, queryParameters: queryParams);

      final data = response['data'] as Map<String, dynamic>? ?? response;
      final dto = EnterpriseStatsDto.fromJson(data);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch enterprise stats: ${e.toString()}', originalError: e);
    }
  }
}
