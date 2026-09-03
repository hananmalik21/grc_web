import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/cloud_posture_dto.dart';

abstract class CloudConnectorRemoteDataSource {
  Future<List<CloudCoverageConnectorDto>> listConnectors();

  Future<CloudCoverageConnectorDto> registerConnector({
    required String provider,
    required String name,
    required Map<String, dynamic> authConfig,
  });
}

class DioCloudConnectorRemoteDataSource
    implements CloudConnectorRemoteDataSource {
  const DioCloudConnectorRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<CloudCoverageConnectorDto>> listConnectors() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.cloudConnectors);
      final data = response['data'];
      if (data is! List) return const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(CloudCoverageConnectorDto.fromJson)
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load cloud connectors: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<CloudCoverageConnectorDto> registerConnector({
    required String provider,
    required String name,
    required Map<String, dynamic> authConfig,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.cloudConnectors,
        body: {'provider': provider, 'name': name, 'authConfig': authConfig},
      );
      return CloudCoverageConnectorDto.fromJson(
        response['data'] as Map<String, dynamic>? ?? const {},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to register cloud connector: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
