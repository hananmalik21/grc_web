import 'package:grc/features/cyber_security/data/datasources/telemetry_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cyber_paged_dto.dart';
import 'package:grc/features/cyber_security/data/models/telemetry_dto.dart';

abstract class TelemetryRepository {
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

class TelemetryRepositoryImpl implements TelemetryRepository {
  const TelemetryRepositoryImpl({
    required TelemetryRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final TelemetryRemoteDataSource _remoteDataSource;

  @override
  Future<TelemetryIngestResultDto> ingest({
    required String connectorId,
    required List<Map<String, dynamic>> events,
  }) => _remoteDataSource.ingest(connectorId: connectorId, events: events);

  @override
  Future<CyberPagedDto<TelemetryLogDto>> getLogs({
    int page = 1,
    int pageSize = 25,
    String? provider,
    String? category,
  }) => _remoteDataSource.getLogs(
    page: page,
    pageSize: pageSize,
    provider: provider,
    category: category,
  );
}
