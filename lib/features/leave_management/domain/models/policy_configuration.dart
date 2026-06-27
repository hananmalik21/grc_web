class PolicyConfiguration {
  final String policyName;
  final String leaveTypeName;
  final String leaveTypeNameArabic;
  final String version;
  final String lastModified;
  final String selectedBy;
  final List<String> tags;
  final bool isActive;
  final EligibilityCriteria eligibilityCriteria;
  final EntitlementAccrual entitlementAccrual;
  final AdvancedRules advancedRules;
  final ApprovalWorkflows approvalWorkflows;
  final BlackoutPeriods blackoutPeriods;
  final CarryForwardRules carryForwardRules;
  final ForfeitRules forfeitRules;
  final EncashmentRules encashmentRules;
  final ComplianceCheck complianceCheck;

  const PolicyConfiguration({
    required this.policyName,
    required this.leaveTypeName,
    required this.leaveTypeNameArabic,
    required this.version,
    required this.lastModified,
    required this.selectedBy,
    required this.tags,
    required this.isActive,
    required this.eligibilityCriteria,
    required this.entitlementAccrual,
    required this.advancedRules,
    required this.approvalWorkflows,
    required this.blackoutPeriods,
    required this.carryForwardRules,
    required this.forfeitRules,
    required this.encashmentRules,
    required this.complianceCheck,
  });
}

class EligibilityCriteria {
  final bool yearsOfServiceEnabled;
  final String? minYearsRequired;
  final String? maxYearsAllowed;
  final bool employeeCategoryEnabled;
  final String? employeeCategory;
  final List<String> employeeCategoryCodes;
  final bool employmentTypeEnabled;
  final String? employmentType;
  final List<String> employmentTypeCodes;
  final bool contractTypeEnabled;
  final String? contractType;
  final List<String> contractTypeCodes;
  final bool genderEnabled;
  final String? gender;
  final List<String> genderCodes;
  final bool religionEnabled;
  final String? religion;
  final List<String> religionCodes;
  final bool maritalStatusEnabled;
  final String? maritalStatus;
  final List<String> maritalStatusCodes;
  final bool availableDuringProbation;
  final String? gradesRestriction;

  const EligibilityCriteria({
    this.yearsOfServiceEnabled = false,
    this.minYearsRequired,
    this.maxYearsAllowed,
    this.employeeCategoryEnabled = false,
    this.employeeCategory,
    this.employeeCategoryCodes = const [],
    this.employmentTypeEnabled = false,
    this.employmentType,
    this.employmentTypeCodes = const [],
    this.contractTypeEnabled = false,
    this.contractType,
    this.contractTypeCodes = const [],
    this.genderEnabled = false,
    this.gender,
    this.genderCodes = const [],
    this.religionEnabled = false,
    this.religion,
    this.religionCodes = const [],
    this.maritalStatusEnabled = false,
    this.maritalStatus,
    this.maritalStatusCodes = const [],
    this.availableDuringProbation = false,
    this.gradesRestriction,
  });
}

class EntitlementAccrual {
  final String annualEntitlement;
  final String accrualMethod;
  final String accrualRate;
  final String effectiveDate;
  final bool enableProRataCalculation;

  const EntitlementAccrual({
    required this.annualEntitlement,
    required this.accrualMethod,
    required this.accrualRate,
    required this.effectiveDate,
    this.enableProRataCalculation = false,
  });
}

class AdvancedRules {
  final String maxConsecutiveDays;
  final String minNoticePeriod;
  final bool countWeekendsAsLeave;
  final bool countPublicHolidaysAsLeave;
  final bool requiredSupportingDocumentation;

  const AdvancedRules({
    required this.maxConsecutiveDays,
    required this.minNoticePeriod,
    this.countWeekendsAsLeave = false,
    this.countPublicHolidaysAsLeave = false,
    this.requiredSupportingDocumentation = false,
  });
}

class ApprovalWorkflows {
  final String approvalWorkflow;
  final String autoApprovalThreshold;

  const ApprovalWorkflows({required this.approvalWorkflow, required this.autoApprovalThreshold});
}

class BlackoutPeriods {
  final String fromTo;

  const BlackoutPeriods({required this.fromTo});
}

class CarryForwardRules {
  final bool allowCarryForward;
  final String carryForwardLimit;
  final String gracePeriod;

  const CarryForwardRules({this.allowCarryForward = false, required this.carryForwardLimit, required this.gracePeriod});
}

class ForfeitRules {
  final bool enableAutomaticForfeit;
  final String? forfeitTrigger;
  final String endOfGracePeriod;

  const ForfeitRules({this.enableAutomaticForfeit = false, this.forfeitTrigger, required this.endOfGracePeriod});
}

class EncashmentRules {
  final bool allowLeaveEncashment;
  final String encashmentLimit;
  final String encashmentRate;

  const EncashmentRules({
    this.allowLeaveEncashment = false,
    required this.encashmentLimit,
    required this.encashmentRate,
  });
}

class ComplianceCheck {
  final bool minimumEntitlementMet;
  final bool accrualMethodValid;
  final bool eligibilityCriteriaValid;

  const ComplianceCheck({
    this.minimumEntitlementMet = true,
    this.accrualMethodValid = true,
    this.eligibilityCriteriaValid = true,
  });
}
