import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/cyber_paged_dto.dart';
import 'package:grc/features/cyber_security/data/models/cyber_risk_dto.dart';

abstract class PeopleRiskRemoteDataSource {
  Future<CyberPagedDto<PeopleRiskDto>> getRiskRegister({
    int page = 1,
    int pageSize = 25,
    String? department,
    String? riskTier,
  });

  Future<PeopleEvaluationResultDto> evaluate();

  Future<List<PeopleHeatmapDepartmentDto>> getHeatmap();
}

class DioPeopleRiskRemoteDataSource implements PeopleRiskRemoteDataSource {
  const DioPeopleRiskRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<CyberPagedDto<PeopleRiskDto>> getRiskRegister({
    int page = 1,
    int pageSize = 25,
    String? department,
    String? riskTier,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.peopleRiskRegister,
        queryParameters: {
          'page': '$page',
          'pageSize': '$pageSize',
          if (department != null) 'department': department,
          if (riskTier != null) 'riskTier': riskTier,
        },
      );
      return CyberPagedDto.fromJson(response, PeopleRiskDto.fromJson);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load people risk register: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<PeopleEvaluationResultDto> evaluate() async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.peopleEvaluate,
        body: {},
      );
      return PeopleEvaluationResultDto.fromJson(
        response['data'] as Map<String, dynamic>? ?? const {},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to evaluate people risk: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<List<PeopleHeatmapDepartmentDto>> getHeatmap() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.peopleHeatmap);
      final data = (response['data'] as Map<String, dynamic>?)?['departments'];
      return (data as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(PeopleHeatmapDepartmentDto.fromJson)
              .toList() ??
          const [];
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load people heatmap: $e',
        originalError: e,
      );
    }
  }
}
