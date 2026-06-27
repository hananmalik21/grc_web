import 'package:grc/features/leave_management/domain/models/paginated_policies.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:intl/intl.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_enums.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class AbsPoliciesResponseDto {
  final bool success;
  final String message;
  final List<AbsPolicyItemDto> data;
  final AbsPoliciesMetaDto? meta;

  const AbsPoliciesResponseDto({required this.success, required this.message, required this.data, this.meta});

  factory AbsPoliciesResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = _extractPolicyList(json);
    final metaJson = _extractMetaJson(json);

    return AbsPoliciesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataList.map((e) => AbsPolicyItemDto.fromJson(e as Map<String, dynamic>)).toList(),
      meta: metaJson != null ? AbsPoliciesMetaDto.fromJson(metaJson) : null,
    );
  }

  static List<dynamic> _extractPolicyList(Map<String, dynamic> json) {
    final raw = json['data'];
    if (raw == null) return [];
    if (raw is List<dynamic>) return raw;
    if (raw is Map<String, dynamic>) {
      final list =
          raw['items'] as List<dynamic>? ??
          raw['list'] as List<dynamic>? ??
          raw['data'] as List<dynamic>? ??
          raw['policies'] as List<dynamic>?;
      return list ?? [];
    }
    return [];
  }

  static Map<String, dynamic>? _extractMetaJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>?;
    if (meta != null) return meta;
    final data = json['data'] as Map<String, dynamic>?;
    return data?['meta'] as Map<String, dynamic>?;
  }

  PaginatedPolicies toDomain() {
    final policies = data.map((d) => d.toDomain()).toList();
    final pagination =
        meta?.toDomain() ??
        PaginationInfo(
          currentPage: 1,
          totalPages: 1,
          totalItems: policies.length,
          pageSize: policies.length,
          hasNext: false,
          hasPrevious: false,
        );
    return PaginatedPolicies(policies: policies, pagination: pagination);
  }
}

class AbsPolicyItemDto {
  final int policyId;
  final String policyGuid;
  final int tenantId;
  final int leaveTypeId;
  final String? leaveTypeEn;
  final String? leaveTypeAr;
  final String? policyName;
  final int policyEntitlementDays;
  final String policyAccrualMethod;
  final String policyStatus;
  final String? kuwaitLaborCompliant;
  final String? policyCreatedBy;
  final String? policyCreatedDate;

  final int? eligibilityId;
  final int? minServiceYears;
  final int? maxServiceYears;
  final List<String> employeeCategoryCodes;
  final List<String> employmentTypeCodes;
  final List<String> contractTypeCodes;
  final List<String> genderCodes;
  final List<String> religionCodes;
  final List<String> maritalStatusCodes;
  final String? probationAllowed;

  final int? ruleId;
  final int? minNoticeDays;
  final int? maxConsecutiveDays;
  final String? requiresDocument;
  final String? countWeekendsAsLeave;
  final String? rulesAllowCarryForward;
  final String? rulesAllowEncashment;

  final int? cfRuleId;
  final String? cfAllowCarryForward;
  final int? carryForwardLimitDays;
  final int? gracePeriodDays;
  final String? autoForfeitFlag;
  final String? forfeitTriggerCode;
  final int? notifyBeforeDays;

  final int? encashRuleId;
  final String? encashAllowEncashment;
  final int? encashmentLimitDays;
  final int? encashmentRatePct;

  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? enableProRata;

  final List<GradeRowDto> gradeRows;

  const AbsPolicyItemDto({
    required this.policyId,
    required this.policyGuid,
    required this.tenantId,
    required this.leaveTypeId,
    this.leaveTypeEn,
    this.leaveTypeAr,
    this.policyName,
    required this.policyEntitlementDays,
    required this.policyAccrualMethod,
    required this.policyStatus,
    this.kuwaitLaborCompliant,
    this.policyCreatedBy,
    this.policyCreatedDate,
    this.eligibilityId,
    this.minServiceYears,
    this.maxServiceYears,
    this.employeeCategoryCodes = const [],
    this.employmentTypeCodes = const [],
    this.contractTypeCodes = const [],
    this.genderCodes = const [],
    this.religionCodes = const [],
    this.maritalStatusCodes = const [],
    this.probationAllowed,
    this.ruleId,
    this.minNoticeDays,
    this.maxConsecutiveDays,
    this.requiresDocument,
    this.countWeekendsAsLeave,
    this.rulesAllowCarryForward,
    this.rulesAllowEncashment,
    this.cfRuleId,
    this.cfAllowCarryForward,
    this.carryForwardLimitDays,
    this.gracePeriodDays,
    this.autoForfeitFlag,
    this.forfeitTriggerCode,
    this.notifyBeforeDays,
    this.encashRuleId,
    this.encashAllowEncashment,
    this.encashmentLimitDays,
    this.encashmentRatePct,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.enableProRata,
    this.gradeRows = const [],
  });

  static int? _parseOptionalInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory AbsPolicyItemDto.fromJson(Map<String, dynamic> json) {
    final gradeRowsList = json['grade_rows'] as List<dynamic>? ?? [];

    return AbsPolicyItemDto(
      policyId: (json['policy_id'] as num?)?.toInt() ?? 0,
      policyGuid: json['policy_guid'] as String? ?? '',
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      leaveTypeId: (json['leave_type_id'] as num?)?.toInt() ?? 0,
      leaveTypeEn: json['leave_type_en'] as String?,
      leaveTypeAr: json['leave_type_ar'] as String?,
      policyName: json['policy_name'] as String?,
      policyEntitlementDays: (json['policy_entitlement_days'] as num?)?.toInt() ?? 0,
      policyAccrualMethod: json['policy_accrual_method'] as String? ?? 'NONE',
      policyStatus: json['policy_status'] as String? ?? 'ACTIVE',
      kuwaitLaborCompliant: json['kuwait_labor_compliant'] as String?,
      policyCreatedBy: json['policy_created_by'] as String?,
      policyCreatedDate: json['policy_created_date'] as String?,
      eligibilityId: (json['eligibility_id'] as num?)?.toInt(),
      minServiceYears: (json['min_service_years'] as num?)?.toInt(),
      maxServiceYears: (json['max_service_years'] as num?)?.toInt(),
      employeeCategoryCodes: _splitCode(json['employee_category_code'] as String?),
      employmentTypeCodes: _splitCode(json['employment_type_code'] as String?),
      contractTypeCodes: _splitCode(json['contract_type_code'] as String?),
      genderCodes: _splitCode(json['gender_code'] as String?),
      religionCodes: _splitCode(json['religion_code'] as String?),
      maritalStatusCodes: _splitCode(json['marital_status_code'] as String?),
      probationAllowed: json['probation_allowed'] as String?,
      ruleId: (json['rule_id'] as num?)?.toInt(),
      minNoticeDays: (json['min_notice_days'] as num?)?.toInt(),
      maxConsecutiveDays: (json['max_consecutive_days'] as num?)?.toInt(),
      requiresDocument: json['requires_document'] as String?,
      countWeekendsAsLeave: json['count_weekends_as_leave'] as String?,
      rulesAllowCarryForward: json['rules_allow_carry_forward'] as String?,
      rulesAllowEncashment: json['rules_allow_encashment'] as String?,
      cfRuleId: (json['cf_rule_id'] as num?)?.toInt(),
      cfAllowCarryForward: json['cf_allow_carry_forward'] as String?,
      carryForwardLimitDays: (json['carry_forward_limit_days'] as num?)?.toInt(),
      gracePeriodDays: _parseOptionalInt(json['grace_period_days'] ?? json['gracePeriodDays']),
      autoForfeitFlag: json['auto_forfeit_flag'] as String?,
      forfeitTriggerCode: json['forfeit_trigger_code'] as String?,
      notifyBeforeDays: (json['notify_before_days'] as num?)?.toInt(),
      encashRuleId: (json['encash_rule_id'] as num?)?.toInt(),
      encashAllowEncashment: json['encash_allow_encashment'] as String?,
      encashmentLimitDays: _parseOptionalInt(json['encashment_limit_days'] ?? json['encashmentLimitDays']),
      encashmentRatePct: _parseOptionalInt(json['encashment_rate_pct'] ?? json['encashmentRatePct']),
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      enableProRata: json['enable_pro_rata'] as String?,
      gradeRows: gradeRowsList.map((e) => GradeRowDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  PolicyListItem toDomain() {
    final status = PolicyStatus.fromCode(policyStatus);
    final accrual = PolicyAccrualMethod.fromCode(policyAccrualMethod);
    final displayName = leaveTypeEn ?? 'Leave Type $leaveTypeId';
    final nameAr = leaveTypeAr ?? '';
    final tags = <String>['$policyEntitlementDays Days', accrual.displayName];
    final detail = toDetailDomain();

    return PolicyListItem(
      policyId: policyId,
      policyGuid: policyGuid,
      name: displayName,
      nameArabic: nameAr,
      tags: tags,
      isActive: status == PolicyStatus.active,
      status: status,
      entitlementDays: policyEntitlementDays,
      accrualMethod: accrual,
      policyName: policyName,
      detail: detail,
    );
  }

  PolicyDetail toDetailDomain() {
    final status = PolicyStatus.fromCode(policyStatus);
    final accrual = PolicyAccrualMethod.fromCode(policyAccrualMethod);

    return PolicyDetail(
      policyId: policyId,
      policyGuid: policyGuid,
      tenantId: tenantId,
      leaveTypeId: leaveTypeId,
      leaveTypeEn: leaveTypeEn ?? 'Leave Type $leaveTypeId',
      leaveTypeAr: leaveTypeAr ?? '',
      policyName: policyName,
      entitlementDays: policyEntitlementDays,
      accrualMethod: accrual,
      status: status,
      kuwaitLaborCompliant: _isYes(kuwaitLaborCompliant),
      createdBy: policyCreatedBy,
      createdDate: _parseDateTime(policyCreatedDate),
      minServiceYears: minServiceYears,
      maxServiceYears: maxServiceYears,
      employeeCategoryCodes: employeeCategoryCodes,
      employmentTypeCodes: employmentTypeCodes,
      contractTypeCodes: contractTypeCodes,
      genderCodes: genderCodes,
      religionCodes: religionCodes,
      maritalStatusCodes: maritalStatusCodes,
      probationAllowed: _isYes(probationAllowed),
      minNoticeDays: minNoticeDays,
      maxConsecutiveDays: maxConsecutiveDays,
      requiresDocument: _isYes(requiresDocument),
      countWeekendsAsLeave: _isYes(countWeekendsAsLeave),
      allowCarryForward: _isYes(cfAllowCarryForward),
      carryForwardLimitDays: carryForwardLimitDays,
      gracePeriodDays: gracePeriodDays,
      autoForfeit: _isYes(autoForfeitFlag),
      forfeitTriggerCode: forfeitTriggerCode,
      notifyBeforeDays: notifyBeforeDays,
      allowEncashment: _isYes(encashAllowEncashment),
      encashmentLimitDays: encashmentLimitDays,
      encashmentRatePct: encashmentRatePct,
      gradeRows: gradeRows.map((g) => g.toDomain()).toList(),
      enableProRata: _isYes(enableProRata),
      effectiveStartDate: _parseDateTime(effectiveStartDate),
      effectiveEndDate: _parseDateTime(effectiveEndDate),
    );
  }

  PolicyConfiguration toConfiguration() {
    final detail = toDetailDomain();
    return detail.toConfiguration();
  }

  bool _isYes(String? value) => value?.toUpperCase() == 'Y';

  DateTime? _parseDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }
}

class GradeRowDto {
  final int entitlementId;
  final int? gradeFrom;
  final int? gradeTo;
  final int gradeEntitlementDays;
  final double? gradeAccrualRate;
  final String gradeStatus;
  final String? accrualMethodCode;

  const GradeRowDto({
    required this.entitlementId,
    this.gradeFrom,
    this.gradeTo,
    required this.gradeEntitlementDays,
    this.gradeAccrualRate,
    required this.gradeStatus,
    this.accrualMethodCode,
  });

  factory GradeRowDto.fromJson(Map<String, dynamic> json) {
    return GradeRowDto(
      entitlementId: (json['entitlement_id'] as num?)?.toInt() ?? 0,
      gradeFrom: (json['grade_from'] as num?)?.toInt(),
      gradeTo: (json['grade_to'] as num?)?.toInt(),
      gradeEntitlementDays: (json['grade_entitlement_days'] as num?)?.toInt() ?? 0,
      gradeAccrualRate: (json['grade_accrual_rate'] as num?)?.toDouble(),
      gradeStatus: json['grade_status'] as String? ?? 'ACTIVE',
      accrualMethodCode: json['accrual_method_code'] as String? ?? json['grade_accrual_method'] as String?,
    );
  }

  /// Uses only the grade row's accrual_method_code from the API (no policy-level fallback).
  GradeEntitlement toDomain() {
    return GradeEntitlement(
      entitlementId: entitlementId,
      gradeFrom: gradeFrom,
      gradeTo: gradeTo,
      entitlementDays: gradeEntitlementDays,
      accrualRate: gradeAccrualRate,
      isActive: gradeStatus.toUpperCase() == 'ACTIVE',
      accrualMethodCode: accrualMethodCode,
    );
  }
}

class UpdatePolicyRequestDto {
  final int tenantId;
  final int leaveTypeId;
  final int entitlementDays;
  final String accrualMethodCode;
  final String updatedBy;
  final String? policyName;
  final int? minServiceYears;
  final int? maxServiceYears;
  final List<String> employeeCategoryCodes;
  final List<String> employmentTypeCodes;
  final List<String> contractTypeCodes;
  final List<String> genderCodes;
  final List<String> religionCodes;
  final List<String> maritalStatusCodes;
  final String probationAllowed;
  final String policyStatus;
  final int? minNoticeDays;
  final int? maxConsecutiveDays;
  final String requiresDocument;
  final String countWeekendsAsLeave;
  final String allowCarryForward;
  final String allowEncashment;
  final int? carryForwardLimit;
  final int? gracePeriodDays;
  final String autoForfeitFlag;
  final String? forfeitTriggerCode;
  final int? notifyBeforeDays;
  final int? encashmentLimitDays;
  final int? encashmentRatePct;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String enableProRata;
  final List<UpdatePolicyGradeRowDto> gradeRows;

  const UpdatePolicyRequestDto({
    required this.tenantId,
    required this.leaveTypeId,
    required this.entitlementDays,
    required this.accrualMethodCode,
    required this.updatedBy,
    this.policyName,
    this.minServiceYears,
    this.maxServiceYears,
    this.employeeCategoryCodes = const [],
    this.employmentTypeCodes = const [],
    this.contractTypeCodes = const [],
    this.genderCodes = const [],
    this.religionCodes = const [],
    this.maritalStatusCodes = const [],
    required this.probationAllowed,
    required this.policyStatus,
    this.minNoticeDays,
    this.maxConsecutiveDays,
    required this.requiresDocument,
    required this.countWeekendsAsLeave,
    required this.allowCarryForward,
    required this.allowEncashment,
    this.carryForwardLimit,
    this.gracePeriodDays,
    required this.autoForfeitFlag,
    this.forfeitTriggerCode,
    this.notifyBeforeDays,
    this.encashmentLimitDays,
    this.encashmentRatePct,
    this.effectiveStartDate,
    this.effectiveEndDate,
    required this.enableProRata,
    this.gradeRows = const [],
  });

  factory UpdatePolicyRequestDto.fromDetail(PolicyDetail detail, {required String updatedBy}) {
    return UpdatePolicyRequestDto(
      tenantId: detail.tenantId,
      leaveTypeId: detail.leaveTypeId,
      entitlementDays: detail.entitlementDays,
      accrualMethodCode: detail.accrualMethod.code,
      updatedBy: updatedBy,
      policyName: detail.policyName,
      minServiceYears: detail.minServiceYears,
      maxServiceYears: detail.maxServiceYears,
      employeeCategoryCodes: detail.employeeCategoryCodes.toList(),
      employmentTypeCodes: detail.employmentTypeCodes.toList(),
      contractTypeCodes: detail.contractTypeCodes.toList(),
      genderCodes: detail.genderCodes.toList(),
      religionCodes: detail.religionCodes.toList(),
      maritalStatusCodes: detail.maritalStatusCodes.toList(),
      probationAllowed: detail.probationAllowed ? 'Y' : 'N',
      policyStatus: detail.status.code,
      minNoticeDays: detail.minNoticeDays,
      maxConsecutiveDays: detail.maxConsecutiveDays,
      requiresDocument: detail.requiresDocument ? 'Y' : 'N',
      countWeekendsAsLeave: detail.countWeekendsAsLeave ? 'Y' : 'N',
      allowCarryForward: detail.allowCarryForward ? 'Y' : 'N',
      allowEncashment: detail.allowEncashment ? 'Y' : 'N',
      carryForwardLimit: detail.carryForwardLimitDays,
      gracePeriodDays: detail.gracePeriodDays,
      autoForfeitFlag: detail.autoForfeit ? 'Y' : 'N',
      forfeitTriggerCode: detail.forfeitTriggerCode,
      notifyBeforeDays: detail.notifyBeforeDays,
      encashmentLimitDays: detail.encashmentLimitDays,
      encashmentRatePct: detail.encashmentRatePct,
      effectiveStartDate: detail.effectiveStartDate != null
          ? DateFormat('yyyy-MM-dd').format(detail.effectiveStartDate!)
          : null,
      effectiveEndDate: detail.effectiveEndDate != null
          ? DateFormat('yyyy-MM-dd').format(detail.effectiveEndDate!)
          : null,
      enableProRata: detail.enableProRata ? 'Y' : 'N',
      gradeRows: detail.gradeRows
          .map(
            (g) => UpdatePolicyGradeRowDto(
              gradeFrom: g.gradeFrom ?? 1,
              gradeTo: g.gradeTo,
              entitlementDays: g.entitlementDays,
              accrualRate: g.accrualRate,
              status: g.isActive ? 'ACTIVE' : 'INACTIVE',
              accrualMethodCode: g.accrualMethodCode,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tenant_id': tenantId,
      'leave_type_id': leaveTypeId,
      'entitlement_days': entitlementDays,
      'accrual_method_code': accrualMethodCode,
      'updated_by': updatedBy,
      'policy_name': policyName,
      'min_service_years': minServiceYears,
      'max_service_years': maxServiceYears,
      'employee_category_codes': employeeCategoryCodes,
      'employment_type_codes': employmentTypeCodes,
      'contract_type_codes': contractTypeCodes,
      'gender_codes': genderCodes,
      'religion_codes': religionCodes,
      'marital_status_codes': maritalStatusCodes,
      'probation_allowed': probationAllowed,
      'policy_status': policyStatus,
      'min_notice_days': minNoticeDays,
      'max_consecutive_days': maxConsecutiveDays,
      'requires_document': requiresDocument,
      'count_weekends_as_leave': countWeekendsAsLeave,
      'allow_carry_forward': allowCarryForward,
      'allow_encashment': allowEncashment,
      'carry_forward_limit': carryForwardLimit,
      'grace_period_days': gracePeriodDays,
      'auto_forfeit_flag': autoForfeitFlag,
      'forfeit_trigger_code': forfeitTriggerCode,
      'notify_before_days': notifyBeforeDays,
      'encashment_limit_days': encashmentLimitDays,
      'encashment_rate_pct': encashmentRatePct,
      'effective_start_date': effectiveStartDate,
      'effective_end_date': effectiveEndDate,
      'enable_pro_rata': enableProRata,
      'grade_rows': gradeRows.map((e) => e.toJson()).toList(),
    };
  }
}

class UpdatePolicyGradeRowDto {
  final int gradeFrom;
  final int? gradeTo;
  final int entitlementDays;
  final double? accrualRate;
  final String status;
  final String? accrualMethodCode;

  const UpdatePolicyGradeRowDto({
    required this.gradeFrom,
    this.gradeTo,
    required this.entitlementDays,
    this.accrualRate,
    required this.status,
    this.accrualMethodCode,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'grade_from': gradeFrom,
      'grade_to': gradeTo,
      'entitlement_days': entitlementDays,
      'accrual_rate': accrualRate,
      'status': status,
    };
    if (accrualMethodCode != null) {
      map['accrual_method_code'] = accrualMethodCode;
    }
    return map;
  }
}

class UpdatePolicyResponseDto {
  final bool success;
  final String message;
  final AbsPolicyItemDto data;
  final Map<String, dynamic>? meta;

  const UpdatePolicyResponseDto({required this.success, required this.message, required this.data, this.meta});

  factory UpdatePolicyResponseDto.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>?;
    return UpdatePolicyResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataJson != null ? AbsPolicyItemDto.fromJson(dataJson) : AbsPolicyItemDto.fromJson({}),
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}

/// Request body for POST /api/abs/create-policy.
class CreatePolicyRequestDto {
  final int tenantId;
  final int leaveTypeId;
  final int entitlementDays;
  final String policyName;
  final String accrualMethodCode;
  final String createdBy;
  final int? minServiceYears;
  final int? maxServiceYears;
  final List<String> employeeCategoryCodes;
  final List<String> employmentTypeCodes;
  final List<String> contractTypeCodes;
  final List<String> genderCodes;
  final List<String> religionCodes;
  final List<String> maritalStatusCodes;
  final String probationAllowed;
  final int? minNoticeDays;
  final int? maxConsecutiveDays;
  final String requiresDocument;
  final String countWeekendsAsLeave;
  final String allowCarryForward;
  final String allowEncashment;
  final int? carryForwardLimit;
  final int? gracePeriodDays;
  final String autoForfeitFlag;
  final int? notifyBeforeDays;
  final int? encashmentLimitDays;
  final int? encashmentRatePct;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String enableProRata;
  final List<CreatePolicyGradeRowDto> gradeRows;

  const CreatePolicyRequestDto({
    required this.tenantId,
    required this.leaveTypeId,
    required this.entitlementDays,
    required this.policyName,
    required this.accrualMethodCode,
    required this.createdBy,
    this.minServiceYears,
    this.maxServiceYears,
    this.employeeCategoryCodes = const [],
    this.employmentTypeCodes = const [],
    this.contractTypeCodes = const [],
    this.genderCodes = const [],
    this.religionCodes = const [],
    this.maritalStatusCodes = const [],
    required this.probationAllowed,
    this.minNoticeDays,
    this.maxConsecutiveDays,
    required this.requiresDocument,
    required this.countWeekendsAsLeave,
    required this.allowCarryForward,
    required this.allowEncashment,
    this.carryForwardLimit,
    this.gracePeriodDays,
    required this.autoForfeitFlag,
    this.notifyBeforeDays,
    this.encashmentLimitDays,
    this.encashmentRatePct,
    this.effectiveStartDate,
    this.effectiveEndDate,
    required this.enableProRata,
    this.gradeRows = const [],
  });

  factory CreatePolicyRequestDto.fromDetail(PolicyDetail detail, {required int tenantId, required String createdBy}) {
    return CreatePolicyRequestDto(
      tenantId: tenantId,
      leaveTypeId: detail.leaveTypeId,
      entitlementDays: detail.entitlementDays,
      policyName: detail.policyName?.trim().isNotEmpty == true
          ? detail.policyName!.trim()
          : (detail.leaveTypeEn.trim().isNotEmpty ? detail.leaveTypeEn.trim() : 'New Policy'),
      accrualMethodCode: detail.accrualMethod.code,
      createdBy: createdBy,
      minServiceYears: detail.minServiceYears,
      maxServiceYears: detail.maxServiceYears,
      employeeCategoryCodes: detail.employeeCategoryCodes.toList(),
      employmentTypeCodes: detail.employmentTypeCodes.toList(),
      contractTypeCodes: detail.contractTypeCodes.toList(),
      genderCodes: detail.genderCodes.toList(),
      religionCodes: detail.religionCodes.toList(),
      maritalStatusCodes: detail.maritalStatusCodes.toList(),
      probationAllowed: detail.probationAllowed ? 'Y' : 'N',
      minNoticeDays: detail.minNoticeDays,
      maxConsecutiveDays: detail.maxConsecutiveDays,
      requiresDocument: detail.requiresDocument ? 'Y' : 'N',
      countWeekendsAsLeave: detail.countWeekendsAsLeave ? 'Y' : 'N',
      allowCarryForward: detail.allowCarryForward ? 'Y' : 'N',
      allowEncashment: detail.allowEncashment ? 'Y' : 'N',
      carryForwardLimit: detail.carryForwardLimitDays,
      gracePeriodDays: detail.gracePeriodDays,
      autoForfeitFlag: detail.autoForfeit ? 'Y' : 'N',
      notifyBeforeDays: detail.notifyBeforeDays,
      encashmentLimitDays: detail.encashmentLimitDays,
      encashmentRatePct: detail.encashmentRatePct,
      effectiveStartDate: detail.effectiveStartDate != null
          ? DateFormat('yyyy-MM-dd').format(detail.effectiveStartDate!)
          : null,
      effectiveEndDate: detail.effectiveEndDate != null
          ? DateFormat('yyyy-MM-dd').format(detail.effectiveEndDate!)
          : null,
      enableProRata: detail.enableProRata ? 'Y' : 'N',
      gradeRows: detail.gradeRows
          .map(
            (g) => CreatePolicyGradeRowDto(
              gradeFrom: g.gradeFrom ?? 1,
              gradeTo: g.gradeTo,
              entitlementDays: g.entitlementDays,
              accrualRate: g.accrualRate,
              status: g.isActive ? 'ACTIVE' : 'INACTIVE',
              accrualMethodCode: g.accrualMethodCode,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tenant_id': tenantId,
      'leave_type_id': leaveTypeId,
      'entitlement_days': entitlementDays,
      'policy_name': policyName,
      'accrual_method_code': accrualMethodCode,
      'created_by': createdBy,
      'min_service_years': minServiceYears,
      'max_service_years': maxServiceYears,
      'employee_category_codes': employeeCategoryCodes,
      'employment_type_codes': employmentTypeCodes,
      'contract_type_codes': contractTypeCodes,
      'gender_codes': genderCodes,
      'religion_codes': religionCodes,
      'marital_status_codes': maritalStatusCodes,
      'probation_allowed': probationAllowed,
      'min_notice_days': minNoticeDays,
      'max_consecutive_days': maxConsecutiveDays,
      'requires_document': requiresDocument,
      'count_weekends_as_leave': countWeekendsAsLeave,
      'allow_carry_forward': allowCarryForward,
      'allow_encashment': allowEncashment,
      'carry_forward_limit': carryForwardLimit,
      'grace_period_days': gracePeriodDays,
      'auto_forfeit_flag': autoForfeitFlag,
      'notify_before_days': notifyBeforeDays,
      'encashment_limit_days': encashmentLimitDays,
      'encashment_rate_pct': encashmentRatePct,
      'effective_start_date': effectiveStartDate,
      'effective_end_date': effectiveEndDate,
      'enable_pro_rata': enableProRata,
      'grade_rows': gradeRows.map((e) => e.toJson()).toList(),
    };
  }
}

class CreatePolicyGradeRowDto {
  final int gradeFrom;
  final int? gradeTo;
  final int entitlementDays;
  final double? accrualRate;
  final String status;
  final String? accrualMethodCode;

  const CreatePolicyGradeRowDto({
    required this.gradeFrom,
    this.gradeTo,
    required this.entitlementDays,
    this.accrualRate,
    required this.status,
    this.accrualMethodCode,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'grade_from': gradeFrom,
      'grade_to': gradeTo,
      'entitlement_days': entitlementDays,
      'accrual_rate': accrualRate,
      'status': status,
    };
    if (accrualMethodCode != null) {
      map['accrual_method_code'] = accrualMethodCode;
    }
    return map;
  }
}

/// Response for POST /api/abs/create-policy. Same shape as update; data is single policy.
class CreatePolicyResponseDto {
  final bool success;
  final String message;
  final AbsPolicyItemDto data;
  final Map<String, dynamic>? meta;

  const CreatePolicyResponseDto({required this.success, required this.message, required this.data, this.meta});

  factory CreatePolicyResponseDto.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>?;
    return CreatePolicyResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataJson != null ? AbsPolicyItemDto.fromJson(dataJson) : AbsPolicyItemDto.fromJson({}),
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}

class AbsPoliciesMetaDto {
  final int count;
  final int? tenantId;
  final AbsPoliciesPaginationDto? pagination;
  final int? executionTimeMs;

  const AbsPoliciesMetaDto({required this.count, this.tenantId, this.pagination, this.executionTimeMs});

  factory AbsPoliciesMetaDto.fromJson(Map<String, dynamic> json) {
    final pagJson = json['pagination'] as Map<String, dynamic>?;

    return AbsPoliciesMetaDto(
      count: (json['count'] as num?)?.toInt() ?? 0,
      tenantId: (json['tenant_id'] as num?)?.toInt(),
      pagination: pagJson != null ? AbsPoliciesPaginationDto.fromJson(pagJson) : null,
      executionTimeMs: (json['execution_time_ms'] as num?)?.toInt(),
    );
  }

  PaginationInfo toDomain() {
    final p = pagination;
    if (p == null) {
      return PaginationInfo(
        currentPage: 1,
        totalPages: 1,
        totalItems: count,
        pageSize: count,
        hasNext: false,
        hasPrevious: false,
      );
    }
    return p.toDomain();
  }
}

class AbsPoliciesPaginationDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const AbsPoliciesPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory AbsPoliciesPaginationDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      if (value is num) return value.toInt();
      return defaultValue;
    }

    bool parseBool(dynamic value, {bool defaultValue = false}) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return defaultValue;
    }

    return AbsPoliciesPaginationDto(
      page: parseInt(json['page'], defaultValue: 1),
      pageSize: parseInt(json['page_size'], defaultValue: 10),
      total: parseInt(json['total']),
      totalPages: parseInt(json['total_pages'], defaultValue: 1),
      hasNext: parseBool(json['has_next']),
      hasPrevious: parseBool(json['has_previous']),
    );
  }

  PaginationInfo toDomain() {
    return PaginationInfo(
      currentPage: page,
      totalPages: totalPages,
      totalItems: total,
      pageSize: pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

List<String> _splitCode(String? value) {
  if (value == null || value.isEmpty) return const [];
  return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}
