import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_enums.dart';
import 'package:intl/intl.dart';

/// Full policy detail from GET /api/abs/policies response.
/// Contains all data needed to populate the policy configuration UI.
class PolicyDetail {
  // Basic Info
  final int policyId;
  final String policyGuid;
  final int tenantId;
  final int leaveTypeId;
  final String leaveTypeEn;
  final String leaveTypeAr;
  final String? policyName;
  final int entitlementDays;
  final PolicyAccrualMethod accrualMethod;
  final PolicyStatus status;
  final bool kuwaitLaborCompliant;
  final String? createdBy;
  final DateTime? createdDate;

  // Eligibility
  final int? minServiceYears;
  final int? maxServiceYears;
  final List<String> employeeCategoryCodes;
  final List<String> employmentTypeCodes;
  final List<String> contractTypeCodes;
  final List<String> genderCodes;
  final List<String> religionCodes;
  final List<String> maritalStatusCodes;
  final bool probationAllowed;

  // Advanced Rules
  final int? minNoticeDays;
  final int? maxConsecutiveDays;
  final bool requiresDocument;
  final bool countWeekendsAsLeave;
  final bool countPublicHolidaysAsLeave;

  // Carry Forward
  final bool allowCarryForward;
  final int? carryForwardLimitDays;
  final int? gracePeriodDays;

  // Forfeit
  final bool autoForfeit;
  final String? forfeitTriggerCode;
  final int? notifyBeforeDays;

  // Encashment
  final bool allowEncashment;
  final int? encashmentLimitDays;
  final int? encashmentRatePct;

  // Grade Entitlements
  final List<GradeEntitlement> gradeRows;
  final bool enableProRata;
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;

  /// Empty policy for "Add New Policy" form. All optional fields are null/empty; required fields use safe defaults.
  static PolicyDetail empty() {
    return PolicyDetail(
      policyId: 0,
      policyGuid: '',
      tenantId: 0,
      leaveTypeId: 0,
      leaveTypeEn: '',
      leaveTypeAr: '',
      policyName: null,
      entitlementDays: 0,
      accrualMethod: PolicyAccrualMethod.yearly,
      status: PolicyStatus.draft,
      kuwaitLaborCompliant: false,
      createdBy: null,
      createdDate: null,
      minServiceYears: null,
      maxServiceYears: null,
      employeeCategoryCodes: const [],
      employmentTypeCodes: const [],
      contractTypeCodes: const [],
      genderCodes: const [],
      religionCodes: const [],
      maritalStatusCodes: const [],
      probationAllowed: true,
      minNoticeDays: null,
      maxConsecutiveDays: null,
      requiresDocument: false,
      countWeekendsAsLeave: false,
      countPublicHolidaysAsLeave: false,
      allowCarryForward: false,
      carryForwardLimitDays: null,
      gracePeriodDays: null,
      autoForfeit: false,
      forfeitTriggerCode: null,
      notifyBeforeDays: null,
      allowEncashment: false,
      encashmentLimitDays: null,
      encashmentRatePct: null,
      gradeRows: const [],
      enableProRata: false,
      effectiveStartDate: null,
      effectiveEndDate: null,
    );
  }

  const PolicyDetail({
    required this.policyId,
    required this.policyGuid,
    required this.tenantId,
    required this.leaveTypeId,
    required this.leaveTypeEn,
    required this.leaveTypeAr,
    this.policyName,
    required this.entitlementDays,
    required this.accrualMethod,
    required this.status,
    required this.kuwaitLaborCompliant,
    this.createdBy,
    this.createdDate,
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
    this.countWeekendsAsLeave = false,
    this.countPublicHolidaysAsLeave = false,
    required this.allowCarryForward,
    this.carryForwardLimitDays,
    this.gracePeriodDays,
    required this.autoForfeit,
    this.forfeitTriggerCode,
    this.notifyBeforeDays,
    required this.allowEncashment,
    this.encashmentLimitDays,
    this.encashmentRatePct,
    this.gradeRows = const [],
    this.enableProRata = false,
    this.effectiveStartDate,
    this.effectiveEndDate,
  });

  PolicyDetail copyWith({
    int? policyId,
    String? policyGuid,
    int? tenantId,
    int? leaveTypeId,
    String? leaveTypeEn,
    String? leaveTypeAr,
    String? policyName,
    int? entitlementDays,
    PolicyAccrualMethod? accrualMethod,
    PolicyStatus? status,
    bool? kuwaitLaborCompliant,
    String? createdBy,
    DateTime? createdDate,
    int? minServiceYears,
    int? maxServiceYears,
    List<String>? employeeCategoryCodes,
    List<String>? employmentTypeCodes,
    List<String>? contractTypeCodes,
    List<String>? genderCodes,
    List<String>? religionCodes,
    List<String>? maritalStatusCodes,
    bool? probationAllowed,
    int? minNoticeDays,
    int? maxConsecutiveDays,
    bool? requiresDocument,
    bool? countWeekendsAsLeave,
    bool? countPublicHolidaysAsLeave,
    bool? allowCarryForward,
    int? carryForwardLimitDays,
    int? gracePeriodDays,
    bool? autoForfeit,
    String? forfeitTriggerCode,
    int? notifyBeforeDays,
    bool? allowEncashment,
    int? encashmentLimitDays,
    int? encashmentRatePct,
    List<GradeEntitlement>? gradeRows,
    bool? enableProRata,
    DateTime? effectiveStartDate,
    DateTime? effectiveEndDate,
  }) {
    return PolicyDetail(
      policyId: policyId ?? this.policyId,
      policyGuid: policyGuid ?? this.policyGuid,
      tenantId: tenantId ?? this.tenantId,
      leaveTypeId: leaveTypeId ?? this.leaveTypeId,
      leaveTypeEn: leaveTypeEn ?? this.leaveTypeEn,
      leaveTypeAr: leaveTypeAr ?? this.leaveTypeAr,
      policyName: policyName ?? this.policyName,
      entitlementDays: entitlementDays ?? this.entitlementDays,
      accrualMethod: accrualMethod ?? this.accrualMethod,
      status: status ?? this.status,
      kuwaitLaborCompliant: kuwaitLaborCompliant ?? this.kuwaitLaborCompliant,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      minServiceYears: minServiceYears ?? this.minServiceYears,
      maxServiceYears: maxServiceYears ?? this.maxServiceYears,
      employeeCategoryCodes: employeeCategoryCodes ?? this.employeeCategoryCodes,
      employmentTypeCodes: employmentTypeCodes ?? this.employmentTypeCodes,
      contractTypeCodes: contractTypeCodes ?? this.contractTypeCodes,
      genderCodes: genderCodes ?? this.genderCodes,
      religionCodes: religionCodes ?? this.religionCodes,
      maritalStatusCodes: maritalStatusCodes ?? this.maritalStatusCodes,
      probationAllowed: probationAllowed ?? this.probationAllowed,
      minNoticeDays: minNoticeDays ?? this.minNoticeDays,
      maxConsecutiveDays: maxConsecutiveDays ?? this.maxConsecutiveDays,
      requiresDocument: requiresDocument ?? this.requiresDocument,
      countWeekendsAsLeave: countWeekendsAsLeave ?? this.countWeekendsAsLeave,
      countPublicHolidaysAsLeave: countPublicHolidaysAsLeave ?? this.countPublicHolidaysAsLeave,
      allowCarryForward: allowCarryForward ?? this.allowCarryForward,
      carryForwardLimitDays: carryForwardLimitDays ?? this.carryForwardLimitDays,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      autoForfeit: autoForfeit ?? this.autoForfeit,
      forfeitTriggerCode: forfeitTriggerCode ?? this.forfeitTriggerCode,
      notifyBeforeDays: notifyBeforeDays ?? this.notifyBeforeDays,
      allowEncashment: allowEncashment ?? this.allowEncashment,
      encashmentLimitDays: encashmentLimitDays ?? this.encashmentLimitDays,
      encashmentRatePct: encashmentRatePct ?? this.encashmentRatePct,
      gradeRows: gradeRows ?? this.gradeRows,
      enableProRata: enableProRata ?? this.enableProRata,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      effectiveEndDate: effectiveEndDate ?? this.effectiveEndDate,
    );
  }

  /// Display name for the policy (uses leave type name)
  String get displayName => leaveTypeEn;

  /// Formatted created date
  String get formattedCreatedDate {
    if (createdDate == null) return '-';
    return DateFormat('yyyy-MM-dd').format(createdDate!);
  }

  /// Formatted effective start date (yyyy-MM-dd)
  String get formattedEffectiveStartDate {
    if (effectiveStartDate == null) return '-';
    return DateFormat('yyyy-MM-dd').format(effectiveStartDate!);
  }

  /// Formatted effective end date (yyyy-MM-dd)
  String get formattedEffectiveEndDate {
    if (effectiveEndDate == null) return '-';
    return DateFormat('yyyy-MM-dd').format(effectiveEndDate!);
  }

  /// Build grade restriction string from grade rows
  String? get gradesRestriction {
    if (gradeRows.isEmpty) return null;
    return gradeRows
        .map((g) {
          final from = g.gradeFrom ?? 1;
          final to = g.gradeTo != null ? '${g.gradeTo}' : '+';
          return 'Grade $from-$to: ${g.entitlementDays} days';
        })
        .join(', ');
  }

  /// Convert to PolicyConfiguration for UI display
  PolicyConfiguration toConfiguration() {
    return PolicyConfiguration(
      policyName: policyName?.trim().isNotEmpty == true ? policyName! : leaveTypeEn,
      leaveTypeName: leaveTypeEn,
      leaveTypeNameArabic: leaveTypeAr,
      version: '1.0',
      lastModified: formattedCreatedDate,
      selectedBy: createdBy ?? 'System',
      tags: ['$entitlementDays Days', accrualMethod.displayName],
      isActive: status == PolicyStatus.active,
      eligibilityCriteria: EligibilityCriteria(
        yearsOfServiceEnabled: minServiceYears != null,
        minYearsRequired: minServiceYears?.toString(),
        maxYearsAllowed: maxServiceYears?.toString() ?? 'No limit',
        employeeCategoryEnabled: employeeCategoryCodes.isNotEmpty,
        employeeCategory: employeeCategoryCodes.map((c) => _formatCode(c)).join(', '),
        employeeCategoryCodes: employeeCategoryCodes,
        employmentTypeEnabled: employmentTypeCodes.isNotEmpty,
        employmentType: employmentTypeCodes.map((c) => _formatCode(c)).join(', '),
        employmentTypeCodes: employmentTypeCodes,
        contractTypeEnabled: contractTypeCodes.isNotEmpty,
        contractType: contractTypeCodes.map((c) => _formatCode(c)).join(', '),
        contractTypeCodes: contractTypeCodes,
        genderEnabled: genderCodes.isNotEmpty,
        gender: genderCodes.map((c) => _formatCode(c)).join(', '),
        genderCodes: genderCodes,
        religionEnabled: religionCodes.isNotEmpty,
        religion: religionCodes.map((c) => _formatCode(c)).join(', '),
        religionCodes: religionCodes,
        maritalStatusEnabled: maritalStatusCodes.isNotEmpty,
        maritalStatus: maritalStatusCodes.map((c) => _formatCode(c)).join(', '),
        maritalStatusCodes: maritalStatusCodes,
        availableDuringProbation: probationAllowed,
        gradesRestriction: gradesRestriction,
      ),
      entitlementAccrual: EntitlementAccrual(
        annualEntitlement: entitlementDays.toString(),
        accrualMethod: accrualMethod.displayName,
        accrualRate: _calculateAccrualRate(),
        effectiveDate: effectiveStartDate != null || effectiveEndDate != null
            ? '$formattedEffectiveStartDate – $formattedEffectiveEndDate'
            : formattedCreatedDate,
        enableProRataCalculation: enableProRata,
      ),
      advancedRules: AdvancedRules(
        maxConsecutiveDays: maxConsecutiveDays?.toString() ?? '-',
        minNoticePeriod: minNoticeDays?.toString() ?? '-',
        countWeekendsAsLeave: countWeekendsAsLeave,
        countPublicHolidaysAsLeave: countPublicHolidaysAsLeave,
        requiredSupportingDocumentation: requiresDocument,
      ),
      approvalWorkflows: const ApprovalWorkflows(approvalWorkflow: 'Manager', autoApprovalThreshold: '0'),
      blackoutPeriods: const BlackoutPeriods(fromTo: '-'),
      carryForwardRules: CarryForwardRules(
        allowCarryForward: allowCarryForward,
        carryForwardLimit: carryForwardLimitDays?.toString() ?? '0',
        gracePeriod: gracePeriodDays?.toString() ?? '0',
      ),
      forfeitRules: ForfeitRules(
        enableAutomaticForfeit: autoForfeit,
        forfeitTrigger: _formatForfeitTrigger(forfeitTriggerCode),
        endOfGracePeriod: notifyBeforeDays != null ? '$notifyBeforeDays days before' : '-',
      ),
      encashmentRules: EncashmentRules(
        allowLeaveEncashment: allowEncashment,
        encashmentLimit: encashmentLimitDays?.toString() ?? '0',
        encashmentRate: encashmentRatePct?.toString() ?? '0',
      ),
      complianceCheck: ComplianceCheck(
        minimumEntitlementMet: kuwaitLaborCompliant,
        accrualMethodValid: true,
        eligibilityCriteriaValid: true,
      ),
    );
  }

  /// Calculate accrual rate based on method
  String _calculateAccrualRate() {
    switch (accrualMethod) {
      case PolicyAccrualMethod.monthly:
        return (entitlementDays / 12).toStringAsFixed(2);
      case PolicyAccrualMethod.yearly:
        return entitlementDays.toString();
      case PolicyAccrualMethod.none:
        return '0';
    }
  }

  /// Format code to display name (e.g., FIXED_TERM -> Fixed Term)
  String? _formatCode(String? code) {
    if (code == null || code.isEmpty) return null;
    return code
        .split('_')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
        .join(' ');
  }

  /// Format forfeit trigger code to display name
  String? _formatForfeitTrigger(String? code) {
    if (code == null || code.isEmpty) return null;
    switch (code.toUpperCase()) {
      case 'END_OF_GRACE':
        return 'End of Grace Period';
      case 'END_OF_YEAR':
        return 'End of Year';
      default:
        return _formatCode(code);
    }
  }
}

/// Grade-based entitlement row
class GradeEntitlement {
  final int entitlementId;
  final int? gradeFrom;
  final int? gradeTo;
  final int entitlementDays;
  final double? accrualRate;
  final bool isActive;
  final String? accrualMethodCode;

  const GradeEntitlement({
    required this.entitlementId,
    this.gradeFrom,
    this.gradeTo,
    required this.entitlementDays,
    this.accrualRate,
    required this.isActive,
    this.accrualMethodCode,
  });

  String get gradeRange {
    final from = gradeFrom ?? 1;
    final to = gradeTo != null ? '$gradeTo' : '+';
    return '$from - $to';
  }

  GradeEntitlement copyWith({
    int? entitlementId,
    int? gradeFrom,
    int? gradeTo,
    int? entitlementDays,
    double? accrualRate,
    bool? isActive,
    String? accrualMethodCode,
  }) {
    return GradeEntitlement(
      entitlementId: entitlementId ?? this.entitlementId,
      gradeFrom: gradeFrom ?? this.gradeFrom,
      gradeTo: gradeTo ?? this.gradeTo,
      entitlementDays: entitlementDays ?? this.entitlementDays,
      accrualRate: accrualRate ?? this.accrualRate,
      isActive: isActive ?? this.isActive,
      accrualMethodCode: accrualMethodCode ?? this.accrualMethodCode,
    );
  }
}
