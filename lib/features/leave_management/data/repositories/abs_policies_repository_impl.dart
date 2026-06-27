import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/abs_policies_remote_data_source.dart';
import 'package:grc/features/leave_management/data/dto/abs_policies_dto.dart';
import 'package:grc/features/leave_management/domain/models/paginated_policies.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/domain/repositories/abs_policies_repository.dart';

class AbsPoliciesRepositoryImpl implements AbsPoliciesRepository {
  final AbsPoliciesRemoteDataSource remoteDataSource;

  AbsPoliciesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedPolicies> getPolicies({required int tenantId, int page = 1, int pageSize = 10}) async {
    try {
      final dto = await remoteDataSource.getPolicies(tenantId: tenantId, page: page, pageSize: pageSize);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<PolicyListItem?> createPolicy(dynamic createRequest) async {
    try {
      final request = createRequest as CreatePolicyRequestDto;
      final response = await remoteDataSource.createPolicy(request);
      if (!response.success) {
        throw ServerException(response.message.isNotEmpty ? response.message : 'Failed to create policy');
      }
      return response.data.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to create policy: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<PolicyListItem?> updatePolicy(String policyGuid, dynamic updateRequest) async {
    try {
      final request = updateRequest as UpdatePolicyRequestDto;
      final response = await remoteDataSource.updatePolicy(policyGuid, request);
      if (!response.success) return null;
      return response.data.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to update policy: ${e.toString()}', originalError: e);
    }
  }
}
