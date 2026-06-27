import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';

class CreateOfferState {
  final int currentStep;
  final Map<String, String> fieldErrors;
  final bool isSubmitting;
  final String? submitError;

  // Basic Details
  final CandidateData? selectedCandidate;
  final Application? selectedApplication;
  final String? candidateName;
  final Position? selectedPosition;
  final String? jobTitle;
  final String? gradeLevel;
  final String? department;
  final OrgUnit? selectedDepartmentOrgUnit;
  final Map<String, OrgUnit> orgLevelSelections;
  final List<OrgUnit> orgPrefillPath;
  final EmployeeListItem? selectedReportingTo;
  final String? reportsTo;
  final String? workLocation;
  final String? workMode;
  final DateTime? offerDate;
  final DateTime? proposedStartDate;
  final EmplLookupValue? selectedContractType;
  final String? comments;

  // Compensation
  final String? baseSalary;
  final String? currency;
  final String? paymentFrequency;
  final String? annualBonus;
  final String? bonusStructure;
  final String? signOnBonus;
  final String? relocationAssistance;
  final String? stockOptions;
  final String? vestingPeriod;
  final bool bonusEligible;
  final String? bonusPercentage;
  final String? allowanceDetails;

  // Benefits
  final bool healthInsurance;
  final bool dentalInsurance;
  final bool visionInsurance;
  final bool lifeInsurance;
  final String? retirementPlan;
  final String? ptoDays;
  final String? sickDays;
  final String? personalDays;
  final String? parentalLeave;
  final List<String> additionalBenefits;

  // Terms & Conditions
  final String? probationPeriod;
  final String? noticePeriod;
  final DateTime? offerExpiryDate;
  final bool backgroundCheckRequired;
  final bool drugTestRequired;
  final bool ndaRequired;
  final bool nonCompeteRequired;
  final String? additionalTerms;
  final List<Document> attachments;

  const CreateOfferState({
    this.currentStep = 0,
    this.fieldErrors = const {},
    this.isSubmitting = false,
    this.submitError,
    this.selectedCandidate,
    this.selectedApplication,
    this.candidateName,
    this.selectedPosition,
    this.jobTitle,
    this.gradeLevel,
    this.department,
    this.selectedDepartmentOrgUnit,
    this.orgLevelSelections = const {},
    this.orgPrefillPath = const [],
    this.selectedReportingTo,
    this.reportsTo,
    this.workLocation,
    this.workMode,
    this.offerDate,
    this.proposedStartDate,
    this.selectedContractType,
    this.comments,
    this.baseSalary,
    this.currency = 'USD',
    this.paymentFrequency = 'Annual',
    this.annualBonus,
    this.bonusStructure,
    this.signOnBonus,
    this.relocationAssistance,
    this.stockOptions,
    this.vestingPeriod,
    this.bonusEligible = false,
    this.bonusPercentage,
    this.allowanceDetails,
    this.healthInsurance = false,
    this.dentalInsurance = false,
    this.visionInsurance = false,
    this.lifeInsurance = false,
    this.retirementPlan,
    this.ptoDays,
    this.sickDays,
    this.personalDays,
    this.parentalLeave,
    this.additionalBenefits = const [],
    this.probationPeriod,
    this.noticePeriod,
    this.offerExpiryDate,
    this.backgroundCheckRequired = false,
    this.drugTestRequired = false,
    this.ndaRequired = false,
    this.nonCompeteRequired = false,
    this.additionalTerms,
    this.attachments = const [],
  });

  CreateOfferState copyWith({
    int? currentStep,
    Map<String, String>? fieldErrors,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    CandidateData? selectedCandidate,
    Application? selectedApplication,
    bool clearSelectedApplication = false,
    String? candidateName,
    Position? selectedPosition,
    bool clearSelectedPosition = false,
    String? jobTitle,
    String? gradeLevel,
    String? department,
    bool clearDepartment = false,
    OrgUnit? selectedDepartmentOrgUnit,
    bool clearSelectedDepartmentOrgUnit = false,
    Map<String, OrgUnit>? orgLevelSelections,
    bool clearOrgLevelSelections = false,
    List<OrgUnit>? orgPrefillPath,
    bool clearOrgPrefillPath = false,
    EmployeeListItem? selectedReportingTo,
    bool clearSelectedReportingTo = false,
    String? reportsTo,
    bool clearReportsTo = false,
    String? workLocation,
    String? workMode,
    DateTime? offerDate,
    DateTime? proposedStartDate,
    EmplLookupValue? selectedContractType,
    bool clearSelectedContractType = false,
    String? comments,
    String? baseSalary,
    String? currency,
    String? paymentFrequency,
    String? annualBonus,
    String? bonusStructure,
    String? signOnBonus,
    String? relocationAssistance,
    String? stockOptions,
    String? vestingPeriod,
    bool? bonusEligible,
    String? bonusPercentage,
    String? allowanceDetails,
    bool? healthInsurance,
    bool? dentalInsurance,
    bool? visionInsurance,
    bool? lifeInsurance,
    String? retirementPlan,
    String? ptoDays,
    String? sickDays,
    String? personalDays,
    String? parentalLeave,
    List<String>? additionalBenefits,
    String? probationPeriod,
    String? noticePeriod,
    DateTime? offerExpiryDate,
    bool? backgroundCheckRequired,
    bool? drugTestRequired,
    bool? ndaRequired,
    bool? nonCompeteRequired,
    String? additionalTerms,
    List<Document>? attachments,
  }) {
    return CreateOfferState(
      currentStep: currentStep ?? this.currentStep,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      selectedCandidate: selectedCandidate ?? this.selectedCandidate,
      selectedApplication: clearSelectedApplication ? null : (selectedApplication ?? this.selectedApplication),
      candidateName: candidateName ?? this.candidateName,
      selectedPosition: clearSelectedPosition ? null : (selectedPosition ?? this.selectedPosition),
      jobTitle: jobTitle ?? this.jobTitle,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      department: clearDepartment ? null : (department ?? this.department),
      selectedDepartmentOrgUnit: clearSelectedDepartmentOrgUnit
          ? null
          : (selectedDepartmentOrgUnit ?? this.selectedDepartmentOrgUnit),
      orgLevelSelections: clearOrgLevelSelections ? const {} : (orgLevelSelections ?? this.orgLevelSelections),
      orgPrefillPath: clearOrgPrefillPath ? const [] : (orgPrefillPath ?? this.orgPrefillPath),
      selectedReportingTo: clearSelectedReportingTo ? null : (selectedReportingTo ?? this.selectedReportingTo),
      reportsTo: clearReportsTo ? null : (reportsTo ?? this.reportsTo),
      workLocation: workLocation ?? this.workLocation,
      workMode: workMode ?? this.workMode,
      offerDate: offerDate ?? this.offerDate,
      proposedStartDate: proposedStartDate ?? this.proposedStartDate,
      selectedContractType: clearSelectedContractType ? null : (selectedContractType ?? this.selectedContractType),
      comments: comments ?? this.comments,
      baseSalary: baseSalary ?? this.baseSalary,
      currency: currency ?? this.currency,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      annualBonus: annualBonus ?? this.annualBonus,
      bonusStructure: bonusStructure ?? this.bonusStructure,
      signOnBonus: signOnBonus ?? this.signOnBonus,
      relocationAssistance: relocationAssistance ?? this.relocationAssistance,
      stockOptions: stockOptions ?? this.stockOptions,
      vestingPeriod: vestingPeriod ?? this.vestingPeriod,
      bonusEligible: bonusEligible ?? this.bonusEligible,
      bonusPercentage: bonusPercentage ?? this.bonusPercentage,
      allowanceDetails: allowanceDetails ?? this.allowanceDetails,
      healthInsurance: healthInsurance ?? this.healthInsurance,
      dentalInsurance: dentalInsurance ?? this.dentalInsurance,
      visionInsurance: visionInsurance ?? this.visionInsurance,
      lifeInsurance: lifeInsurance ?? this.lifeInsurance,
      retirementPlan: retirementPlan ?? this.retirementPlan,
      ptoDays: ptoDays ?? this.ptoDays,
      sickDays: sickDays ?? this.sickDays,
      personalDays: personalDays ?? this.personalDays,
      parentalLeave: parentalLeave ?? this.parentalLeave,
      additionalBenefits: additionalBenefits ?? this.additionalBenefits,
      probationPeriod: probationPeriod ?? this.probationPeriod,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      offerExpiryDate: offerExpiryDate ?? this.offerExpiryDate,
      backgroundCheckRequired: backgroundCheckRequired ?? this.backgroundCheckRequired,
      drugTestRequired: drugTestRequired ?? this.drugTestRequired,
      ndaRequired: ndaRequired ?? this.ndaRequired,
      nonCompeteRequired: nonCompeteRequired ?? this.nonCompeteRequired,
      additionalTerms: additionalTerms ?? this.additionalTerms,
      attachments: attachments ?? this.attachments,
    );
  }
}

class CreateOfferSubmitResult {
  const CreateOfferSubmitResult({required this.success, this.message});

  final bool success;
  final String? message;
}
