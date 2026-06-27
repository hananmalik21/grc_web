import 'package:grc/features/leave_management/domain/models/leave_policy.dart';

abstract class LeavePoliciesRepository {
  Future<List<LeavePolicy>> getLeavePolicies({int? tenantId, String? status, String? kuwaitLaborCompliant});
  Future<LeavePolicy> createLeavePolicy(CreateLeavePolicyParams params);
  Future<void> updateLeavePolicy(String policyGuid, UpdateLeavePolicyParams params, {int? tenantId});
}
