import 'package:grc/core/models/document_attachment_input.dart';
import 'package:grc/core/enums/hiring_enums.dart';
import 'package:grc/features/hiring/data/models/create_requisition_request_input.dart';
import 'package:grc/features/hiring/data/services/create_requisition_request_conversion_service.dart';
import 'package:grc/features/hiring/data/dto/create_requisition_request_dto.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_state.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';

abstract final class CreateRequisitionRequestMapper {
  CreateRequisitionRequestMapper._();

  static const CreateRequisitionRequestConversionService _conversionService =
      CreateRequisitionRequestConversionService();

  static CreateRequisitionRequestDto fromState({
    required CreateRequisitionState state,
    required int enterpriseId,
    required String createdBy,
    String? lastUpdatedBy,
  }) {
    final input = _buildSubmitInput(state: state, enterpriseId: enterpriseId, createdBy: createdBy);
    final fields = _conversionService.convert(input);
    if (lastUpdatedBy != null) {
      fields['last_updated_by'] = lastUpdatedBy;
    }
    return CreateRequisitionRequestDto(fields: fields, attachment: input.attachment);
  }

  static CreateRequisitionRequestDto fromStateAsDraft({
    required CreateRequisitionState state,
    required int enterpriseId,
    required String createdBy,
    required String lastUpdatedBy,
  }) {
    final input = _buildDraftInput(state: state, enterpriseId: enterpriseId, createdBy: createdBy);
    final fields = _conversionService.convert(input, action: RequisitionCreateAction.draft);
    fields['last_updated_by'] = lastUpdatedBy;
    return CreateRequisitionRequestDto(fields: fields, attachment: input.attachment);
  }

  static CreateRequisitionRequestInput _buildDraftInput({
    required CreateRequisitionState state,
    required int enterpriseId,
    required String createdBy,
  }) {
    final position = state.selectedPosition!;
    final deptUnit = state.selectedDepartmentOrgUnit;
    final justificationUnit = state.selectedJustificationOrgUnit;
    final jobFamily = state.selectedJobFamily;
    final jobLevel = state.selectedJobLevel;
    final grade = state.selectedGrade;
    final contract = state.selectedContractType;
    final reportsTo = state.reportsToPosition;

    return _toInput(
      state: state,
      enterpriseId: enterpriseId,
      createdBy: createdBy,
      position: position,
      deptUnitId: deptUnit?.orgUnitId ?? '',
      justificationOrgUnitId: justificationUnit?.orgUnitId ?? '',
      jobFamilyId: jobFamily?.id ?? 0,
      jobLevelId: jobLevel?.id ?? 0,
      gradeId: grade?.id ?? 0,
      employmentTypeCode: contract?.lookupCode ?? '',
      reportsToPositionId: reportsTo?.id ?? '',
      targetStartDate: state.targetStartDate,
      hiringManagerEmployeeId: state.hiringManagerEmployee?.id ?? 0,
      recruiterEmployeeId: state.recruiterEmployee?.id ?? 0,
    );
  }

  static CreateRequisitionRequestInput _buildSubmitInput({
    required CreateRequisitionState state,
    required int enterpriseId,
    required String createdBy,
  }) {
    final position = state.selectedPosition!;
    final deptUnit = state.selectedDepartmentOrgUnit!;
    final justificationUnit = state.selectedJustificationOrgUnit!;
    final jobFamily = state.selectedJobFamily!;
    final jobLevel = state.selectedJobLevel!;
    final grade = state.selectedGrade!;
    final contract = state.selectedContractType!;
    final reportsTo = state.reportsToPosition!;

    return _toInput(
      state: state,
      enterpriseId: enterpriseId,
      createdBy: createdBy,
      position: position,
      deptUnitId: deptUnit.orgUnitId,
      justificationOrgUnitId: justificationUnit.orgUnitId,
      jobFamilyId: jobFamily.id,
      jobLevelId: jobLevel.id,
      gradeId: grade.id,
      employmentTypeCode: contract.lookupCode,
      reportsToPositionId: reportsTo.id,
      targetStartDate: state.targetStartDate!,
      hiringManagerEmployeeId: state.hiringManagerEmployee!.id,
      recruiterEmployeeId: state.recruiterEmployee!.id,
    );
  }

  static CreateRequisitionRequestInput _toInput({
    required CreateRequisitionState state,
    required int enterpriseId,
    required String createdBy,
    required Position position,
    required String deptUnitId,
    required String justificationOrgUnitId,
    required int jobFamilyId,
    required int jobLevelId,
    required int gradeId,
    required String employmentTypeCode,
    required String reportsToPositionId,
    required DateTime? targetStartDate,
    required int hiringManagerEmployeeId,
    required int recruiterEmployeeId,
  }) {
    final panelIds = <int>[];
    for (final employee in state.interviewPanelMembers) {
      if (employee != null) panelIds.add(employee.id);
    }

    DocumentAttachmentInput? attachment;
    if (state.attachments.isNotEmpty) {
      attachment = _documentAttachment(state.attachments.first);
    }

    return CreateRequisitionRequestInput(
      enterpriseId: enterpriseId,
      createdBy: createdBy,
      requisitionTitle: position.titleEnglish.trim().isNotEmpty ? position.titleEnglish.trim() : position.code,
      positionId: position.id,
      orgUnitId: deptUnitId,
      justificationOrgUnitId: justificationOrgUnitId,
      jobFamilyId: jobFamilyId,
      jobLevelId: jobLevelId,
      gradeId: gradeId,
      employmentTypeCode: employmentTypeCode,
      numberOfOpenings: state.numberOfOpenings,
      priorityCode: state.priority,
      primaryLocationGuid: state.primaryLocation,
      workModeCode: state.workMode,
      targetStartDate: targetStartDate,
      expectedEndDate: state.expectedEndDate,
      positionTypeCode: state.positionType,
      businessJustification: state.businessJustification?.trim() ?? '',
      impactIfNotFilled: state.impactIfNotFilled?.trim() ?? '',
      reportsToPositionId: reportsToPositionId,
      costCenterId: state.costCenter?.trim() ?? '',
      positionSummary: state.positionSummary?.trim() ?? '',
      keyResponsibilities: state.keyResponsibilities?.trim() ?? '',
      minimumQualifications: state.minimumQualifications?.trim() ?? '',
      preferredQualifications: state.preferredQualifications,
      travelRequirementCode: state.travelRequirement,
      requiredCertificationsCode: state.requiredCertifications,
      physicalRequirementsCode: state.physicalRequirements,
      requiredSkillCodes: List<String>.from(state.requiredSkills),
      minimumEducationLevelCode: state.minimumEducationLevel,
      yearsOfExperienceCode: state.yearsOfExperience,
      preferredFieldOfStudyCode: state.preferredFieldOfStudy,
      managementExperienceCode: state.managementExperience,
      hiringManagerEmployeeId: hiringManagerEmployeeId,
      recruiterEmployeeId: recruiterEmployeeId,
      hrbpEmployeeId: state.hrBusinessPartnerEmployee?.id,
      interviewPanelEmployeeIds: panelIds,
      currencyCode: state.currency,
      compensationTypeCode: state.compensationType,
      salaryRangeMin: state.salaryRangeMin?.trim() ?? '',
      salaryRangeMax: state.salaryRangeMax?.trim() ?? '',
      bonusEligible: state.bonusEligible,
      equityEligible: state.equityEligible,
      additionalBenefits: state.additionalBenefits,
      budgetCode: state.budgetCode?.trim() ?? '',
      approvedBudgetAmount: state.approvedBudgetAmount,
      attachment: attachment,
    );
  }

  static DocumentAttachmentInput _documentAttachment(Document doc) {
    return DocumentAttachmentInput(
      name: doc.name,
      path: doc.path,
      size: doc.size,
      bytes: doc.bytes,
      extension: doc.extension,
    );
  }
}
