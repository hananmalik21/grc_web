import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/cyber_dashboard_dto.dart';

abstract class CyberDashboardRemoteDataSource {
  Future<CyberDashboardOverviewDto> getOverview();
}

class DioCyberDashboardRemoteDataSource implements CyberDashboardRemoteDataSource {
  const DioCyberDashboardRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<CyberDashboardOverviewDto> getOverview() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.dashboardOverview);
      return CyberDashboardOverviewDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch dashboard overview: ${e.toString()}', originalError: e);
    }
  }
}
