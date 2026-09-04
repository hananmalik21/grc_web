import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/cyber_paged_dto.dart';
import 'package:grc/features/cyber_security/data/models/telemetry_dto.dart';

abstract class TelemetryRemoteDataSource {
  Future<TelemetryIngestResultDto> ingest({
    required String connectorId,
    required List<Map<String, dynamic>> events,
  });

  Future<CyberPagedDto<TelemetryLogDto>> getLogs({
    int page = 1,
    int pageSize = 25,
    String? provider,
    String? category,
  });
}

class DioTelemetryRemoteDataSource implements TelemetryRemoteDataSource {
  const DioTelemetryRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<TelemetryIngestResultDto> ingest({
    required String connectorId,
    required List<Map<String, dynamic>> events,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.telemetryIngest,
        body: {'connectorId': connectorId, 'events': events},
      );
      return TelemetryIngestResultDto.fromJson(
        response['data'] as Map<String, dynamic>? ?? const {},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to ingest telemetry: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<CyberPagedDto<TelemetryLogDto>> getLogs({
    int page = 1,
    int pageSize = 25,
    String? provider,
    String? category,
  }) async {
    try {
      final query = <String, String>{
        'page': '$page',
        'pageSize': '$pageSize',
        if (provider case final value?) 'provider': value,
        if (category case final value?) 'category': value,
      };
      final response = await _apiClient.get(
        ApiEndpoints.telemetryLogs,
        queryParameters: query,
      );
      return CyberPagedDto.fromJson(response, TelemetryLogDto.fromJson);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load telemetry logs: $e',
        originalError: e,
      );
    }
  }
}
