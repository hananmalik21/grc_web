import 'package:grc/features/cyber_security/data/datasources/people_risk_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cyber_paged_dto.dart';
import 'package:grc/features/cyber_security/data/models/cyber_risk_dto.dart';

abstract class PeopleRiskRepository {
  Future<CyberPagedDto<PeopleRiskDto>> getRiskRegister({
    int page = 1,
    int pageSize = 25,
    String? department,
    String? riskTier,
  });

  Future<PeopleEvaluationResultDto> evaluate();
  Future<List<PeopleHeatmapDepartmentDto>> getHeatmap();
}

class PeopleRiskRepositoryImpl implements PeopleRiskRepository {
  const PeopleRiskRepositoryImpl({
    required PeopleRiskRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final PeopleRiskRemoteDataSource _remoteDataSource;

  @override
  Future<CyberPagedDto<PeopleRiskDto>> getRiskRegister({
    int page = 1,
    int pageSize = 25,
    String? department,
    String? riskTier,
  }) => _remoteDataSource.getRiskRegister(
    page: page,
    pageSize: pageSize,
    department: department,
    riskTier: riskTier,
  );

  @override
  Future<PeopleEvaluationResultDto> evaluate() => _remoteDataSource.evaluate();

  @override
  Future<List<PeopleHeatmapDepartmentDto>> getHeatmap() =>
      _remoteDataSource.getHeatmap();
}
