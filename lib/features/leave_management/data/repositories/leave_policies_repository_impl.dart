import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/leave_policies_remote_data_source.dart';
import 'package:grc/features/leave_management/domain/models/leave_policy.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_policies_repository.dart';

class LeavePoliciesRepositoryImpl implements LeavePoliciesRepository {
  final LeavePoliciesRemoteDataSource remoteDataSource;

  LeavePoliciesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LeavePolicy>> getLeavePolicies({int? tenantId, String? status, String? kuwaitLaborCompliant}) async {
    try {
      final dto = await remoteDataSource.getLeavePolicies(
        tenantId: tenantId,
        status: status,
        kuwaitLaborCompliant: kuwaitLaborCompliant,
      );
      return dto.data.map((e) => e.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<LeavePolicy> createLeavePolicy(CreateLeavePolicyParams params) async {
    return remoteDataSource.createLeavePolicy(params);
  }

  @override
  Future<void> updateLeavePolicy(String policyGuid, UpdateLeavePolicyParams params, {int? tenantId}) async {
    await remoteDataSource.updateLeavePolicy(policyGuid, params, tenantId: tenantId);
  }
}
