import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/cloud_posture_dto.dart';

abstract class CloudPostureRemoteDataSource {
  Future<CloudCoverageDashboardDto> getCloudCoverage();
}

class DioCloudPostureRemoteDataSource implements CloudPostureRemoteDataSource {
  const DioCloudPostureRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<CloudCoverageDashboardDto> getCloudCoverage() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.dashboardCloudCoverage,
      );
      return CloudCoverageDashboardDto.fromJson(
        response['data'] as Map<String, dynamic>? ?? const {},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load cloud coverage: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
