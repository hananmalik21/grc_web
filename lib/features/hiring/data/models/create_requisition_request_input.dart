import 'package:grc/core/models/document_attachment_input.dart';

class CreateRequisitionRequestInput {
  const CreateRequisitionRequestInput({
    required this.enterpriseId,
    required this.createdBy,
    required this.requisitionTitle,
    required this.positionId,
    required this.orgUnitId,
    required this.justificationOrgUnitId,
    required this.jobFamilyId,
    required this.jobLevelId,
    required this.gradeId,
    required this.employmentTypeCode,
    required this.numberOfOpenings,
    required this.priorityCode,
    required this.primaryLocationGuid,
    required this.workModeCode,
    this.targetStartDate,
    required this.positionTypeCode,
    required this.businessJustification,
    required this.impactIfNotFilled,
    required this.reportsToPositionId,
    required this.costCenterId,
    required this.positionSummary,
    required this.keyResponsibilities,
    required this.minimumQualifications,
    required this.requiredSkillCodes,
    required this.minimumEducationLevelCode,
    required this.yearsOfExperienceCode,
    required this.hiringManagerEmployeeId,
    required this.recruiterEmployeeId,
    required this.interviewPanelEmployeeIds,
    required this.currencyCode,
    required this.compensationTypeCode,
    required this.salaryRangeMin,
    required this.salaryRangeMax,
    required this.bonusEligible,
    required this.equityEligible,
    required this.budgetCode,
    this.expectedEndDate,
    this.preferredQualifications,
    this.travelRequirementCode,
    this.requiredCertificationsCode,
    this.physicalRequirementsCode,
    this.preferredFieldOfStudyCode,
    this.managementExperienceCode,
    this.hrbpEmployeeId,
    this.additionalBenefits,
    this.approvedBudgetAmount,
    this.attachment,
  });

  final int enterpriseId;
  final String createdBy;

  final String requisitionTitle;
  final String positionId;
  final String orgUnitId;
  final String justificationOrgUnitId;
  final int jobFamilyId;
  final int jobLevelId;
  final int gradeId;
  final String employmentTypeCode;
  final int numberOfOpenings;

  final String? priorityCode;
  final String? primaryLocationGuid;
  final String? workModeCode;
  final DateTime? targetStartDate;
  final DateTime? expectedEndDate;
  final String? positionTypeCode;

  final String businessJustification;
  final String impactIfNotFilled;
  final String reportsToPositionId;
  final String costCenterId;

  final String positionSummary;
  final String keyResponsibilities;
  final String minimumQualifications;
  final String? preferredQualifications;

  final String? travelRequirementCode;
  final String? requiredCertificationsCode;
  final String? physicalRequirementsCode;

  final List<String> requiredSkillCodes;
  final String? minimumEducationLevelCode;
  final String? yearsOfExperienceCode;
  final String? preferredFieldOfStudyCode;
  final String? managementExperienceCode;

  final int hiringManagerEmployeeId;
  final int recruiterEmployeeId;
  final int? hrbpEmployeeId;
  final List<int> interviewPanelEmployeeIds;

  final String? currencyCode;
  final String? compensationTypeCode;
  final String salaryRangeMin;
  final String salaryRangeMax;
  final bool bonusEligible;
  final bool equityEligible;
  final String? additionalBenefits;
  final String budgetCode;
  final String? approvedBudgetAmount;

  final DocumentAttachmentInput? attachment;
}
