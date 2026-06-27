import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/dto/abs_policies_dto.dart';

abstract class AbsPoliciesRemoteDataSource {
  Future<AbsPoliciesResponseDto> getPolicies({required int tenantId, int page = 1, int pageSize = 10});
  Future<CreatePolicyResponseDto> createPolicy(CreatePolicyRequestDto body);
  Future<UpdatePolicyResponseDto> updatePolicy(String policyGuid, UpdatePolicyRequestDto body);
}

class AbsPoliciesRemoteDataSourceImpl implements AbsPoliciesRemoteDataSource {
  final ApiClient apiClient;

  AbsPoliciesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AbsPoliciesResponseDto> getPolicies({required int tenantId, int page = 1, int pageSize = 10}) async {
    try {
      final queryParameters = <String, String>{
        'tenant_id': tenantId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final response = await apiClient.get(ApiEndpoints.absPolicies, queryParameters: queryParameters);

      return AbsPoliciesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CreatePolicyResponseDto> createPolicy(CreatePolicyRequestDto body) async {
    try {
      final response = await apiClient.post(ApiEndpoints.absCreatePolicy, body: body.toJson());
      return CreatePolicyResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create policy: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<UpdatePolicyResponseDto> updatePolicy(String policyGuid, UpdatePolicyRequestDto body) async {
    try {
      final response = await apiClient.put(ApiEndpoints.absUpdatePolicy(policyGuid), body: body.toJson());
      return UpdatePolicyResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update policy: ${e.toString()}', originalError: e);
    }
  }
}
