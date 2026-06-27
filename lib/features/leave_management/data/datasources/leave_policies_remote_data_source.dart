import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/dto/leave_policies_dto.dart';
import 'package:grc/features/leave_management/domain/models/leave_policy.dart';

abstract class LeavePoliciesRemoteDataSource {
  Future<LeavePoliciesResponseDto> getLeavePolicies({int? tenantId, String? status, String? kuwaitLaborCompliant});
  Future<LeavePolicy> createLeavePolicy(CreateLeavePolicyParams params);
  Future<void> updateLeavePolicy(String policyGuid, UpdateLeavePolicyParams params, {int? tenantId});
}

class LeavePoliciesRemoteDataSourceImpl implements LeavePoliciesRemoteDataSource {
  final ApiClient apiClient;

  LeavePoliciesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LeavePoliciesResponseDto> getLeavePolicies({
    int? tenantId,
    String? status,
    String? kuwaitLaborCompliant,
  }) async {
    try {
      final queryParameters = <String, String>{};
      if (tenantId != null) queryParameters['tenant_id'] = tenantId.toString();
      if (status != null && status.isNotEmpty) queryParameters['status'] = status;
      if (kuwaitLaborCompliant != null && kuwaitLaborCompliant.isNotEmpty) {
        queryParameters['kuwait_labor_compliant'] = kuwaitLaborCompliant;
      }

      final response = await apiClient.get(
        ApiEndpoints.absLeavePolicies,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );

      return LeavePoliciesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<LeavePolicy> createLeavePolicy(CreateLeavePolicyParams params) async {
    try {
      final body = <String, dynamic>{
        'tenant_id': params.tenantId,
        'leave_type_id': params.leaveTypeId,
        'leave_type_en': params.leaveTypeEn,
        'leave_type_ar': params.leaveTypeAr,
        'entitlement_days': params.entitlementDays,
        'accrual_method_code': params.accrualMethodCode,
        'status': params.status,
        'kuwait_labor_compliant': params.kuwaitLaborCompliant,
      };
      final response = await apiClient.post(ApiEndpoints.absLeavePolicies, body: body);
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        final dto = LeavePolicyDto.fromJson(data);
        return dto.toDomain();
      }
      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        final dto = LeavePolicyDto.fromJson(data.first as Map<String, dynamic>);
        return dto.toDomain();
      }
      return _policyFromCreateParams(params);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create leave policy: ${e.toString()}', originalError: e);
    }
  }

  LeavePolicy _policyFromCreateParams(CreateLeavePolicyParams params) {
    final accrualDisplay = switch (params.accrualMethodCode.toUpperCase()) {
      'MONTHLY' => 'Monthly',
      'YEARLY' => 'Yearly',
      'NONE' => 'None',
      _ => params.accrualMethodCode,
    };
    return LeavePolicy(
      policyGuid: null,
      nameEn: params.leaveTypeEn,
      nameAr: params.leaveTypeAr,
      isKuwaitLaw: params.kuwaitLaborCompliant.toUpperCase() == 'Y',
      description: 'Leave policy for ${params.leaveTypeEn} — ${params.entitlementDays} days entitlement.',
      entitlement: '${params.entitlementDays} days',
      accrualType: accrualDisplay,
      minService: '-',
      advanceNotice: '-',
      isPaid: true,
      carryoverDays: null,
      requiresAttachment: false,
      genderRestriction: null,
      entitlementDays: params.entitlementDays,
      accrualMethodCode: params.accrualMethodCode,
      status: params.status,
      kuwaitLaborCompliant: params.kuwaitLaborCompliant,
    );
  }

  @override
  Future<void> updateLeavePolicy(String policyGuid, UpdateLeavePolicyParams params, {int? tenantId}) async {
    try {
      final queryParameters = <String, String>{};
      if (tenantId != null) queryParameters['tenant_id'] = tenantId.toString();
      final body = <String, dynamic>{
        'leave_type_en': params.leaveTypeEn,
        'entitlement_days': params.entitlementDays,
        'accrual_method_code': params.accrualMethodCode,
        'status': params.status,
        'kuwait_labor_compliant': params.kuwaitLaborCompliant,
      };
      await apiClient.put(
        ApiEndpoints.absLeavePolicyUpdate(policyGuid),
        body: body,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update leave policy: ${e.toString()}', originalError: e);
    }
  }
}
