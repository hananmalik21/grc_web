import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';

class LeavePolicy {
  final String? policyGuid;
  final String nameEn;
  final String nameAr;
  final bool isKuwaitLaw;
  final String description;
  final String entitlement;
  final String accrualType;
  final String minService;
  final String advanceNotice;
  final bool isPaid;
  final int? carryoverDays;
  final bool requiresAttachment;
  final String? genderRestriction;
  final int? entitlementDays;
  final String? accrualMethodCode;
  final String? status;
  final String? kuwaitLaborCompliant;
  final bool allowEncashment;
  final bool autoForfeit;
  final bool probationAllowed;
  final bool countWeekendsAsLeave;
  final bool countPublicHolidaysAsLeave;
  final int? maxConsecutiveDays;

  /// Maps from ABS policy list item for display in Leave Policies tab (same card design).
  factory LeavePolicy.fromPolicyListItem(PolicyListItem item) {
    final detail = item.detail;
    return LeavePolicy(
      policyGuid: item.policyGuid,
      nameEn: item.name,
      nameAr: item.nameArabic,
      isKuwaitLaw: detail?.kuwaitLaborCompliant ?? false,
      description: item.tags.isEmpty ? '' : item.tags.join(', '),
      entitlement: '${item.entitlementDays}',
      accrualType: item.accrualMethod.displayName,
      minService: detail?.minServiceYears?.toString() ?? '-',
      advanceNotice: detail?.minNoticeDays?.toString() ?? '-',
      isPaid: true,
      carryoverDays: detail?.carryForwardLimitDays,
      requiresAttachment: detail?.requiresDocument ?? false,
      genderRestriction: null,
      entitlementDays: item.entitlementDays,
      accrualMethodCode: item.accrualMethod.code,
      status: item.status.code,
      kuwaitLaborCompliant: detail?.kuwaitLaborCompliant == true ? 'Y' : 'N',
      allowEncashment: detail?.allowEncashment ?? false,
      autoForfeit: detail?.autoForfeit ?? false,
      probationAllowed: detail?.probationAllowed ?? false,
      countWeekendsAsLeave: detail?.countWeekendsAsLeave ?? false,
      countPublicHolidaysAsLeave: detail?.countPublicHolidaysAsLeave ?? false,
      maxConsecutiveDays: detail?.maxConsecutiveDays,
    );
  }

  const LeavePolicy({
    this.policyGuid,
    required this.nameEn,
    required this.nameAr,
    required this.isKuwaitLaw,
    required this.description,
    required this.entitlement,
    required this.accrualType,
    required this.minService,
    required this.advanceNotice,
    required this.isPaid,
    this.carryoverDays,
    required this.requiresAttachment,
    this.genderRestriction,
    this.entitlementDays,
    this.accrualMethodCode,
    this.status,
    this.kuwaitLaborCompliant,
    this.allowEncashment = false,
    this.autoForfeit = false,
    this.probationAllowed = false,
    this.countWeekendsAsLeave = false,
    this.countPublicHolidaysAsLeave = false,
    this.maxConsecutiveDays,
  });

  LeavePolicy copyWith({
    String? policyGuid,
    String? nameEn,
    String? nameAr,
    bool? isKuwaitLaw,
    String? description,
    String? entitlement,
    String? accrualType,
    String? minService,
    String? advanceNotice,
    bool? isPaid,
    int? carryoverDays,
    bool? requiresAttachment,
    String? genderRestriction,
    int? entitlementDays,
    String? accrualMethodCode,
    String? status,
    String? kuwaitLaborCompliant,
    bool? allowEncashment,
    bool? autoForfeit,
    bool? probationAllowed,
    bool? countWeekendsAsLeave,
    bool? countPublicHolidaysAsLeave,
    int? maxConsecutiveDays,
  }) {
    return LeavePolicy(
      policyGuid: policyGuid ?? this.policyGuid,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      isKuwaitLaw: isKuwaitLaw ?? this.isKuwaitLaw,
      description: description ?? this.description,
      entitlement: entitlement ?? this.entitlement,
      accrualType: accrualType ?? this.accrualType,
      minService: minService ?? this.minService,
      advanceNotice: advanceNotice ?? this.advanceNotice,
      isPaid: isPaid ?? this.isPaid,
      carryoverDays: carryoverDays ?? this.carryoverDays,
      requiresAttachment: requiresAttachment ?? this.requiresAttachment,
      genderRestriction: genderRestriction ?? this.genderRestriction,
      entitlementDays: entitlementDays ?? this.entitlementDays,
      accrualMethodCode: accrualMethodCode ?? this.accrualMethodCode,
      status: status ?? this.status,
      kuwaitLaborCompliant: kuwaitLaborCompliant ?? this.kuwaitLaborCompliant,
      allowEncashment: allowEncashment ?? this.allowEncashment,
      autoForfeit: autoForfeit ?? this.autoForfeit,
      probationAllowed: probationAllowed ?? this.probationAllowed,
      countWeekendsAsLeave: countWeekendsAsLeave ?? this.countWeekendsAsLeave,
      countPublicHolidaysAsLeave: countPublicHolidaysAsLeave ?? this.countPublicHolidaysAsLeave,
      maxConsecutiveDays: maxConsecutiveDays ?? this.maxConsecutiveDays,
    );
  }
}

class UpdateLeavePolicyParams {
  final String leaveTypeEn;
  final int entitlementDays;
  final String accrualMethodCode;
  final String status;
  final String kuwaitLaborCompliant;

  const UpdateLeavePolicyParams({
    required this.leaveTypeEn,
    required this.entitlementDays,
    required this.accrualMethodCode,
    required this.status,
    required this.kuwaitLaborCompliant,
  });
}

class CreateLeavePolicyParams {
  final int tenantId;
  final int leaveTypeId;
  final String leaveTypeEn;
  final String leaveTypeAr;
  final int entitlementDays;
  final String accrualMethodCode;
  final String status;
  final String kuwaitLaborCompliant;

  const CreateLeavePolicyParams({
    required this.tenantId,
    required this.leaveTypeId,
    required this.leaveTypeEn,
    required this.leaveTypeAr,
    required this.entitlementDays,
    required this.accrualMethodCode,
    required this.status,
    required this.kuwaitLaborCompliant,
  });
}
