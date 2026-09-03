import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/threat_dto.dart';

abstract class ThreatRemoteDataSource {
  Future<List<ThreatDto>> getLiveThreats({int page = 1, int pageSize = 100});
  Future<ThreatDto> updateStatus(String id, String status);
}

class DioThreatRemoteDataSource implements ThreatRemoteDataSource {
  const DioThreatRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ThreatDto>> getLiveThreats({
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.threatsLive,
        queryParameters: {'page': '$page', 'pageSize': '$pageSize'},
      );
      final data = response['data'];
      if (data is! List) return const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(ThreatDto.fromJson)
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load live threats: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<ThreatDto> updateStatus(String id, String status) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.threatStatus(id),
        body: {'status': status},
      );
      return ThreatDto.fromJson(
        response['data'] as Map<String, dynamic>? ?? const {},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update threat status: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
