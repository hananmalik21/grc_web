import 'package:grc/features/cyber_security/data/datasources/iam_posture_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/iam_posture_dto.dart';

class IamPostureData {
  final IamPostureSummaryDto summary;
  final List<IamPrincipalDto> principals;

  const IamPostureData({required this.summary, required this.principals});
}

abstract class IamPostureRepository {
  Future<IamPostureData> getPosture();
  Future<int> syncConnector(String connectorId);
}

class IamPostureRepositoryImpl implements IamPostureRepository {
  const IamPostureRepositoryImpl({
    required IamPostureRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final IamPostureRemoteDataSource _remoteDataSource;

  @override
  Future<IamPostureData> getPosture() async {
    final results = await Future.wait([
      _remoteDataSource.getSummary(),
      _remoteDataSource.getPrincipals(),
    ]);
    return IamPostureData(
      summary: results[0] as IamPostureSummaryDto,
      principals: results[1] as List<IamPrincipalDto>,
    );
  }

  @override
  Future<int> syncConnector(String connectorId) =>
      _remoteDataSource.syncConnector(connectorId);
}
