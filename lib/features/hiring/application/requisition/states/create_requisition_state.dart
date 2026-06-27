import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';

class CreateRequisitionState {
  final int currentStep;
  final Map<String, String> fieldErrors;

  final Position? selectedPosition;
  final String? jobTitle;
  final String? department;
  final OrgUnit? selectedDepartmentOrgUnit;
  final OrgUnit? selectedJustificationOrgUnit;
  final JobFamily? selectedJobFamily;
  final JobLevel? selectedJobLevel;
  final Grade? selectedGrade;
  final EmplLookupValue? selectedContractType;
  final int numberOfOpenings;

  final String? priority;

  final String? primaryLocation;

  final String? workMode;
  final DateTime? targetStartDate;
  final DateTime? expectedEndDate;

  final String? positionType;
  final String? businessJustification;
  final String? impactIfNotFilled;

  final String? reportsTo;
  final Position? reportsToPosition;
  final String? organizationalUnit;
  final String? costCenter;

  final String? positionSummary;
  final String? keyResponsibilities;
  final String? minimumQualifications;
  final String? preferredQualifications;

  /// REC lookup [lookupCode].
  final String? travelRequirement;
  final String? requiredCertifications;
  final String? physicalRequirements;

  /// Skill REC lookup [lookupCode] values.
  final List<String> requiredSkills;

  /// REC lookup [lookupCode].
  final String? minimumEducationLevel;
  final String? yearsOfExperience;
  final String? preferredFieldOfStudy;
  final String? managementExperience;

  final String? hiringManager;
  final String? recruiter;
  final String? hrBusinessPartner;
  final Employee? hiringManagerEmployee;
  final Employee? recruiterEmployee;
  final Employee? hrBusinessPartnerEmployee;
  final List<Employee?> interviewPanelMembers;

  /// REC lookup [lookupCode].
  final String? currency;
  final String? compensationType;
  final String? salaryRangeMin;
  final String? salaryRangeMax;

  final bool bonusEligible;
  final bool equityEligible;
  final String? additionalBenefits;

  final String? budgetCode;
  final String? approvedBudgetAmount;

  final List<Document> attachments;

  final bool isSubmitting;
  final bool isSavingDraft;
  final bool isLoadingEdit;
  final bool isEditLoadStarted;
  final bool isEditHydrated;
  final String? editingRequisitionGuid;
  final List<OrgUnit> basicInfoOrgPrefillPath;
  final List<OrgUnit> justificationOrgPrefillPath;
  final Map<String, OrgUnit> basicInfoOrgLevelSelections;
  final Map<String, OrgUnit> justificationOrgLevelSelections;

  const CreateRequisitionState({
    this.currentStep = 0,
    this.fieldErrors = const {},
    this.isSubmitting = false,
    this.isSavingDraft = false,
    this.isLoadingEdit = false,
    this.isEditLoadStarted = false,
    this.isEditHydrated = false,
    this.editingRequisitionGuid,
    this.basicInfoOrgPrefillPath = const [],
    this.justificationOrgPrefillPath = const [],
    this.basicInfoOrgLevelSelections = const {},
    this.justificationOrgLevelSelections = const {},
    this.selectedPosition,
    this.jobTitle,
    this.department,
    this.selectedDepartmentOrgUnit,
    this.selectedJustificationOrgUnit,
    this.selectedJobFamily,
    this.selectedJobLevel,
    this.selectedGrade,
    this.selectedContractType,
    this.numberOfOpenings = 1,
    this.priority,
    this.primaryLocation,
    this.workMode,
    this.targetStartDate,
    this.expectedEndDate,
    this.positionType,
    this.businessJustification,
    this.impactIfNotFilled,
    this.reportsTo,
    this.reportsToPosition,
    this.organizationalUnit,
    this.costCenter,
    this.positionSummary,
    this.keyResponsibilities,
    this.minimumQualifications,
    this.preferredQualifications,
    this.travelRequirement,
    this.requiredCertifications,
    this.physicalRequirements,
    this.requiredSkills = const [],
    this.minimumEducationLevel,
    this.yearsOfExperience,
    this.preferredFieldOfStudy,
    this.managementExperience,
    this.hiringManager,
    this.recruiter,
    this.hrBusinessPartner,
    this.hiringManagerEmployee,
    this.recruiterEmployee,
    this.hrBusinessPartnerEmployee,
    this.interviewPanelMembers = const <Employee?>[null],
    this.currency,
    this.compensationType,
    this.salaryRangeMin,
    this.salaryRangeMax,
    this.bonusEligible = false,
    this.equityEligible = false,
    this.additionalBenefits,
    this.budgetCode,
    this.approvedBudgetAmount,
    this.attachments = const [],
  });

  CreateRequisitionState copyWith({
    int? currentStep,
    Map<String, String>? fieldErrors,
    Position? selectedPosition,
    bool clearSelectedPosition = false,
    String? jobTitle,
    String? department,
    bool clearDepartment = false,
    OrgUnit? selectedDepartmentOrgUnit,
    bool clearSelectedDepartmentOrgUnit = false,
    OrgUnit? selectedJustificationOrgUnit,
    bool clearSelectedJustificationOrgUnit = false,
    JobFamily? selectedJobFamily,
    bool clearSelectedJobFamily = false,
    JobLevel? selectedJobLevel,
    bool clearSelectedJobLevel = false,
    Grade? selectedGrade,
    bool clearSelectedGrade = false,
    EmplLookupValue? selectedContractType,
    bool clearSelectedContractType = false,
    int? numberOfOpenings,
    String? priority,
    String? primaryLocation,
    String? workMode,
    DateTime? targetStartDate,
    DateTime? expectedEndDate,
    String? positionType,
    String? businessJustification,
    String? impactIfNotFilled,
    String? reportsTo,
    Position? reportsToPosition,
    String? organizationalUnit,
    String? costCenter,
    String? positionSummary,
    String? keyResponsibilities,
    String? minimumQualifications,
    String? preferredQualifications,
    String? travelRequirement,
    String? requiredCertifications,
    String? physicalRequirements,
    List<String>? requiredSkills,
    String? minimumEducationLevel,
    String? yearsOfExperience,
    String? preferredFieldOfStudy,
    String? managementExperience,
    String? hiringManager,
    String? recruiter,
    String? hrBusinessPartner,
    Employee? hiringManagerEmployee,
    bool clearHiringManagerEmployee = false,
    Employee? recruiterEmployee,
    bool clearRecruiterEmployee = false,
    Employee? hrBusinessPartnerEmployee,
    bool clearHrBusinessPartnerEmployee = false,
    List<Employee?>? interviewPanelMembers,
    String? currency,
    String? compensationType,
    String? salaryRangeMin,
    String? salaryRangeMax,
    bool? bonusEligible,
    bool? equityEligible,
    String? additionalBenefits,
    String? budgetCode,
    String? approvedBudgetAmount,
    List<Document>? attachments,
    bool? isSubmitting,
    bool? isSavingDraft,
    bool? isLoadingEdit,
    bool? isEditLoadStarted,
    bool? isEditHydrated,
    String? editingRequisitionGuid,
    List<OrgUnit>? basicInfoOrgPrefillPath,
    bool clearBasicInfoOrgPrefillPath = false,
    List<OrgUnit>? justificationOrgPrefillPath,
    bool clearJustificationOrgPrefillPath = false,
    Map<String, OrgUnit>? basicInfoOrgLevelSelections,
    bool clearBasicInfoOrgLevelSelections = false,
    Map<String, OrgUnit>? justificationOrgLevelSelections,
    bool clearJustificationOrgLevelSelections = false,
  }) {
    return CreateRequisitionState(
      currentStep: currentStep ?? this.currentStep,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isLoadingEdit: isLoadingEdit ?? this.isLoadingEdit,
      isEditLoadStarted: isEditLoadStarted ?? this.isEditLoadStarted,
      isEditHydrated: isEditHydrated ?? this.isEditHydrated,
      editingRequisitionGuid: editingRequisitionGuid ?? this.editingRequisitionGuid,
      basicInfoOrgPrefillPath: clearBasicInfoOrgPrefillPath
          ? const []
          : (basicInfoOrgPrefillPath ?? this.basicInfoOrgPrefillPath),
      justificationOrgPrefillPath: clearJustificationOrgPrefillPath
          ? const []
          : (justificationOrgPrefillPath ?? this.justificationOrgPrefillPath),
      basicInfoOrgLevelSelections: clearBasicInfoOrgLevelSelections
          ? const {}
          : (basicInfoOrgLevelSelections ?? this.basicInfoOrgLevelSelections),
      justificationOrgLevelSelections: clearJustificationOrgLevelSelections
          ? const {}
          : (justificationOrgLevelSelections ?? this.justificationOrgLevelSelections),
      selectedPosition: clearSelectedPosition ? null : (selectedPosition ?? this.selectedPosition),
      jobTitle: jobTitle ?? this.jobTitle,
      department: clearDepartment ? null : (department ?? this.department),
      selectedDepartmentOrgUnit: clearSelectedDepartmentOrgUnit
          ? null
          : (selectedDepartmentOrgUnit ?? this.selectedDepartmentOrgUnit),
      selectedJustificationOrgUnit: clearSelectedJustificationOrgUnit
          ? null
          : (selectedJustificationOrgUnit ?? this.selectedJustificationOrgUnit),
      selectedJobFamily: clearSelectedJobFamily ? null : (selectedJobFamily ?? this.selectedJobFamily),
      selectedJobLevel: clearSelectedJobLevel ? null : (selectedJobLevel ?? this.selectedJobLevel),
      selectedGrade: clearSelectedGrade ? null : (selectedGrade ?? this.selectedGrade),
      selectedContractType: clearSelectedContractType ? null : (selectedContractType ?? this.selectedContractType),
      numberOfOpenings: numberOfOpenings ?? this.numberOfOpenings,
      priority: priority ?? this.priority,
      primaryLocation: primaryLocation ?? this.primaryLocation,
      workMode: workMode ?? this.workMode,
      targetStartDate: targetStartDate ?? this.targetStartDate,
      expectedEndDate: expectedEndDate ?? this.expectedEndDate,
      positionType: positionType ?? this.positionType,
      businessJustification: businessJustification ?? this.businessJustification,
      impactIfNotFilled: impactIfNotFilled ?? this.impactIfNotFilled,
      reportsTo: reportsTo ?? this.reportsTo,
      reportsToPosition: reportsToPosition ?? this.reportsToPosition,
      organizationalUnit: organizationalUnit ?? this.organizationalUnit,
      costCenter: costCenter ?? this.costCenter,
      positionSummary: positionSummary ?? this.positionSummary,
      keyResponsibilities: keyResponsibilities ?? this.keyResponsibilities,
      minimumQualifications: minimumQualifications ?? this.minimumQualifications,
      preferredQualifications: preferredQualifications ?? this.preferredQualifications,
      travelRequirement: travelRequirement ?? this.travelRequirement,
      requiredCertifications: requiredCertifications ?? this.requiredCertifications,
      physicalRequirements: physicalRequirements ?? this.physicalRequirements,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      minimumEducationLevel: minimumEducationLevel ?? this.minimumEducationLevel,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      preferredFieldOfStudy: preferredFieldOfStudy ?? this.preferredFieldOfStudy,
      managementExperience: managementExperience ?? this.managementExperience,
      hiringManager: hiringManager ?? this.hiringManager,
      recruiter: recruiter ?? this.recruiter,
      hrBusinessPartner: hrBusinessPartner ?? this.hrBusinessPartner,
      hiringManagerEmployee: clearHiringManagerEmployee ? null : (hiringManagerEmployee ?? this.hiringManagerEmployee),
      recruiterEmployee: clearRecruiterEmployee ? null : (recruiterEmployee ?? this.recruiterEmployee),
      hrBusinessPartnerEmployee: clearHrBusinessPartnerEmployee
          ? null
          : (hrBusinessPartnerEmployee ?? this.hrBusinessPartnerEmployee),
      interviewPanelMembers: interviewPanelMembers ?? this.interviewPanelMembers,
      currency: currency ?? this.currency,
      compensationType: compensationType ?? this.compensationType,
      salaryRangeMin: salaryRangeMin ?? this.salaryRangeMin,
      salaryRangeMax: salaryRangeMax ?? this.salaryRangeMax,
      bonusEligible: bonusEligible ?? this.bonusEligible,
      equityEligible: equityEligible ?? this.equityEligible,
      additionalBenefits: additionalBenefits ?? this.additionalBenefits,
      budgetCode: budgetCode ?? this.budgetCode,
      approvedBudgetAmount: approvedBudgetAmount ?? this.approvedBudgetAmount,
      attachments: attachments ?? this.attachments,
    );
  }
}
