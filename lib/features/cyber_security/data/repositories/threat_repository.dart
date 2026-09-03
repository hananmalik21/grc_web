import 'package:grc/features/cyber_security/data/datasources/threat_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/threat_dto.dart';

abstract class ThreatRepository {
  Future<List<ThreatDto>> getLiveThreats();
  Future<ThreatDto> updateStatus(String id, String status);
}

class ThreatRepositoryImpl implements ThreatRepository {
  const ThreatRepositoryImpl({required ThreatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ThreatRemoteDataSource _remoteDataSource;

  @override
  Future<List<ThreatDto>> getLiveThreats() =>
      _remoteDataSource.getLiveThreats();

  @override
  Future<ThreatDto> updateStatus(String id, String status) =>
      _remoteDataSource.updateStatus(id, status);
}
