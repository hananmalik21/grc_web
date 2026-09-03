import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/iam_posture_dto.dart';

abstract class IamPostureRemoteDataSource {
  Future<IamPostureSummaryDto> getSummary();
  Future<List<IamPrincipalDto>> getPrincipals({
    int page = 1,
    int pageSize = 100,
  });
  Future<int> syncConnector(String connectorId);
}

class DioIamPostureRemoteDataSource implements IamPostureRemoteDataSource {
  const DioIamPostureRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<IamPostureSummaryDto> getSummary() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.iamPostureSummary);
      return IamPostureSummaryDto.fromJson(
        response['data'] as Map<String, dynamic>? ?? const {},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load IAM posture summary: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<IamPrincipalDto>> getPrincipals({
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.iamPosturePrincipals,
        queryParameters: {'page': '$page', 'pageSize': '$pageSize'},
      );
      final data = response['data'];
      if (data is! List) return const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(IamPrincipalDto.fromJson)
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load IAM principals: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<int> syncConnector(String connectorId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.iamPostureSync(connectorId),
      );
      final data = response['data'];
      return data is Map ? int.tryParse('${data['synced']}') ?? 0 : 0;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to sync IAM posture: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
