import 'package:grc/features/cyber_security/data/datasources/cloud_posture_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cloud_posture_dto.dart';

abstract class CloudPostureRepository {
  Future<CloudCoverageDashboardDto> getCloudCoverage();
}

class CloudPostureRepositoryImpl implements CloudPostureRepository {
  const CloudPostureRepositoryImpl({
    required CloudPostureRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CloudPostureRemoteDataSource _remoteDataSource;

  @override
  Future<CloudCoverageDashboardDto> getCloudCoverage() =>
      _remoteDataSource.getCloudCoverage();
}
