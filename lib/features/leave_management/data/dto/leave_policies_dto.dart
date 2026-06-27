import 'package:grc/features/leave_management/domain/models/leave_policy.dart';

class LeavePolicyDto {
  final int policyId;
  final String policyGuid;
  final int tenantId;
  final int leaveTypeId;
  final String? leaveTypeEn;
  final String? leaveTypeAr;
  final int entitlementDays;
  final String accrualMethodCode;
  final String status;
  final String? kuwaitLaborCompliant;
  final String? createdBy;
  final String? createdDate;
  final String? lastUpdatedBy;
  final String? lastUpdateDate;

  const LeavePolicyDto({
    required this.policyId,
    required this.policyGuid,
    required this.tenantId,
    required this.leaveTypeId,
    this.leaveTypeEn,
    this.leaveTypeAr,
    required this.entitlementDays,
    required this.accrualMethodCode,
    required this.status,
    this.kuwaitLaborCompliant,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdateDate,
  });

  factory LeavePolicyDto.fromJson(Map<String, dynamic> json) {
    return LeavePolicyDto(
      policyId: (json['policy_id'] as num?)?.toInt() ?? 0,
      policyGuid: json['policy_guid'] as String? ?? '',
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      leaveTypeId: (json['leave_type_id'] as num?)?.toInt() ?? 0,
      leaveTypeEn: json['leave_type_en'] as String?,
      leaveTypeAr: json['leave_type_ar'] as String?,
      entitlementDays: (json['entitlement_days'] as num?)?.toInt() ?? 0,
      accrualMethodCode: json['accrual_method_code'] as String? ?? 'NONE',
      status: json['status'] as String? ?? 'ACTIVE',
      kuwaitLaborCompliant: json['kuwait_labor_compliant'] as String?,
      createdBy: json['created_by'] as String?,
      createdDate: json['created_date'] as String?,
      lastUpdatedBy: json['last_updated_by'] as String?,
      lastUpdateDate: json['last_update_date'] as String?,
    );
  }

  LeavePolicy toDomain() {
    final nameEn = leaveTypeEn ?? 'Leave Type $leaveTypeId';
    final nameAr = leaveTypeAr ?? '';
    final isKuwaitLaw = (kuwaitLaborCompliant ?? '').toUpperCase() == 'Y';
    final accrualDisplay = _mapAccrualToDisplay(accrualMethodCode);
    return LeavePolicy(
      policyGuid: policyGuid,
      nameEn: nameEn,
      nameAr: nameAr,
      isKuwaitLaw: isKuwaitLaw,
      description: 'Leave policy for $nameEn — $entitlementDays days entitlement.',
      entitlement: '$entitlementDays days',
      accrualType: accrualDisplay,
      minService: '-',
      advanceNotice: '-',
      isPaid: true,
      carryoverDays: null,
      requiresAttachment: false,
      genderRestriction: null,
      entitlementDays: entitlementDays,
      accrualMethodCode: accrualMethodCode,
      status: status,
      kuwaitLaborCompliant: kuwaitLaborCompliant,
    );
  }

  String _mapAccrualToDisplay(String code) {
    switch (code.toUpperCase()) {
      case 'MONTHLY':
        return 'Monthly';
      case 'YEARLY':
        return 'Yearly';
      case 'NONE':
        return 'None';
      default:
        return code;
    }
  }
}

class LeavePoliciesResponseDto {
  final bool success;
  final LeavePoliciesMetaDto? meta;
  final List<LeavePolicyDto> data;

  const LeavePoliciesResponseDto({required this.success, this.meta, required this.data});

  factory LeavePoliciesResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return LeavePoliciesResponseDto(
      success: json['success'] as bool? ?? false,
      meta: null,
      data: dataList.map((e) => LeavePolicyDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class LeavePoliciesMetaDto {
  final int count;
  final int total;
  final String? executionTime;
  final int? tenantId;

  const LeavePoliciesMetaDto({required this.count, required this.total, this.executionTime, this.tenantId});
}
