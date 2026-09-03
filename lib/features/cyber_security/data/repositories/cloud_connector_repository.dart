import 'package:grc/features/cyber_security/data/datasources/cloud_connector_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cloud_posture_dto.dart';

abstract class CloudConnectorRepository {
  Future<List<CloudCoverageConnectorDto>> listConnectors();

  Future<CloudCoverageConnectorDto> registerConnector({
    required String provider,
    required String name,
    required Map<String, dynamic> authConfig,
  });
}

class CloudConnectorRepositoryImpl implements CloudConnectorRepository {
  const CloudConnectorRepositoryImpl({
    required CloudConnectorRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CloudConnectorRemoteDataSource _remoteDataSource;

  @override
  Future<List<CloudCoverageConnectorDto>> listConnectors() =>
      _remoteDataSource.listConnectors();

  @override
  Future<CloudCoverageConnectorDto> registerConnector({
    required String provider,
    required String name,
    required Map<String, dynamic> authConfig,
  }) => _remoteDataSource.registerConnector(
    provider: provider,
    name: name,
    authConfig: authConfig,
  );
}
