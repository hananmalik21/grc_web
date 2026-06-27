import 'dart:convert';

import 'package:grc/core/enums/hiring_enums.dart';
import 'package:grc/features/hiring/data/models/create_requisition_request_input.dart';
import 'package:grc/features/hiring/data/services/create_requisition_multipart_form_service.dart';

class CreateRequisitionRequestConversionService {
  const CreateRequisitionRequestConversionService();

  Map<String, dynamic> convert(
    CreateRequisitionRequestInput input, {
    RequisitionCreateAction action = RequisitionCreateAction.submit,
  }) {
    if (action == RequisitionCreateAction.draft) {
      return _buildDraftBody(input);
    }
    return _buildSubmitBody(input);
  }

  Map<String, dynamic> _buildSubmitBody(CreateRequisitionRequestInput input) {
    final minSalary = double.parse(input.salaryRangeMin.trim());
    final maxSalary = double.parse(input.salaryRangeMax.trim());

    final approvedRaw = input.approvedBudgetAmount?.trim();
    final approvedBudget = approvedRaw != null && approvedRaw.isNotEmpty ? double.tryParse(approvedRaw) : null;

    final body = <String, dynamic>{
      'action': RequisitionCreateAction.submit.name.toUpperCase(),
      'enterprise_id': input.enterpriseId,
      'requisition_title': input.requisitionTitle,
      'position_id': input.positionId,
      'org_unit_id': input.orgUnitId,
      'job_family_id': input.jobFamilyId,
      'job_level_id': input.jobLevelId,
      'grade_id': input.gradeId,
      'employment_type_code': input.employmentTypeCode,
      'number_of_openings': input.numberOfOpenings,
      'priority_code': input.priorityCode!.trim(),
      'primary_location_id': input.primaryLocationGuid!.trim(),
      'work_mode_code': input.workModeCode!.trim(),
      'target_start_date': _formatDate(input.targetStartDate!),
      if (input.expectedEndDate != null) 'expected_end_date': _formatDate(input.expectedEndDate!),
      'position_type_code': input.positionTypeCode!.trim(),
      'business_justification': input.businessJustification,
      'impact_if_not_filled': input.impactIfNotFilled,
      'reports_to_position_id': input.reportsToPositionId,
      'justification_org_unit_id': input.justificationOrgUnitId,
      'cost_center_id': input.costCenterId,
      'position_summary': input.positionSummary,
      'key_responsibilities': input.keyResponsibilities,
      'minimum_qualifications': input.minimumQualifications,
      if (input.preferredQualifications != null && input.preferredQualifications!.trim().isNotEmpty)
        'preferred_qualifications': input.preferredQualifications!.trim(),
      'min_education_level_code': input.minimumEducationLevelCode!.trim(),
      'experience_required_code': input.yearsOfExperienceCode!.trim(),
      'hiring_manager_employee_id': input.hiringManagerEmployeeId,
      'recruiter_employee_id': input.recruiterEmployeeId,
      if (input.hrbpEmployeeId != null) 'hrbp_employee_id': input.hrbpEmployeeId,
      'currency_code': input.currencyCode!.trim(),
      'compensation_type_code': input.compensationTypeCode!.trim(),
      'minimum_salary': minSalary,
      'maximum_salary': maxSalary,
      'bonus_eligible_flag': input.bonusEligible ? 'Y' : 'N',
      'equity_eligible_flag': input.equityEligible ? 'Y' : 'N',
      if (input.additionalBenefits != null && input.additionalBenefits!.trim().isNotEmpty)
        'additional_benefits': input.additionalBenefits!.trim(),
      'budget_code': input.budgetCode,
      'approved_budget_amount': ?approvedBudget,
      'created_by': input.createdBy,
    };

    _addOptionalCode(body, 'travel_requirement_code', input.travelRequirementCode);
    _addOptionalCode(body, 'required_certifications', input.requiredCertificationsCode);
    _addOptionalCode(body, 'physical_requirements', input.physicalRequirementsCode);
    _addOptionalCode(body, 'preferred_field_of_study', input.preferredFieldOfStudyCode);
    _addOptionalCode(body, 'management_experience_code', input.managementExperienceCode);

    final skills = _skillsPayload(input);
    if (skills.isNotEmpty) {
      body['skills_json'] = jsonEncode(skills);
    }

    final panelPayload = _interviewPanelPayload(input.interviewPanelEmployeeIds);
    if (panelPayload.isNotEmpty) {
      body['interview_panel_json'] = jsonEncode(panelPayload);
    }

    return body;
  }

  Map<String, dynamic> _buildDraftBody(CreateRequisitionRequestInput input) {
    final body = <String, dynamic>{
      'action': RequisitionCreateAction.draft.name.toUpperCase(),
      'enterprise_id': input.enterpriseId,
      'requisition_title': input.requisitionTitle,
      'position_id': input.positionId,
      'number_of_openings': input.numberOfOpenings,
      'created_by': input.createdBy,
    };

    if (input.orgUnitId.isNotEmpty) {
      body['org_unit_id'] = input.orgUnitId;
    }
    if (input.justificationOrgUnitId.isNotEmpty) {
      body['justification_org_unit_id'] = input.justificationOrgUnitId;
    }
    if (input.jobFamilyId > 0) {
      body['job_family_id'] = input.jobFamilyId;
    }
    if (input.jobLevelId > 0) {
      body['job_level_id'] = input.jobLevelId;
    }
    if (input.gradeId > 0) {
      body['grade_id'] = input.gradeId;
    }
    if (input.employmentTypeCode.isNotEmpty) {
      body['employment_type_code'] = input.employmentTypeCode;
    }

    _addOptionalCode(body, 'priority_code', input.priorityCode);
    _addOptionalGuid(body, 'primary_location_id', input.primaryLocationGuid);
    _addOptionalCode(body, 'work_mode_code', input.workModeCode);
    _addOptionalCode(body, 'position_type_code', input.positionTypeCode);

    if (input.targetStartDate != null) {
      body['target_start_date'] = _formatDate(input.targetStartDate!);
    }

    if (input.expectedEndDate != null) {
      body['expected_end_date'] = _formatDate(input.expectedEndDate!);
    }

    _addText(body, 'business_justification', input.businessJustification);
    _addText(body, 'impact_if_not_filled', input.impactIfNotFilled);

    if (input.reportsToPositionId.isNotEmpty) {
      body['reports_to_position_id'] = input.reportsToPositionId;
    }

    _addText(body, 'cost_center_id', input.costCenterId);
    _addText(body, 'position_summary', input.positionSummary);
    _addText(body, 'key_responsibilities', input.keyResponsibilities);
    _addText(body, 'minimum_qualifications', input.minimumQualifications);

    if (input.preferredQualifications != null && input.preferredQualifications!.trim().isNotEmpty) {
      body['preferred_qualifications'] = input.preferredQualifications!.trim();
    }

    _addOptionalCode(body, 'travel_requirement_code', input.travelRequirementCode);
    _addOptionalCode(body, 'required_certifications', input.requiredCertificationsCode);
    _addOptionalCode(body, 'physical_requirements', input.physicalRequirementsCode);

    final skills = _skillsPayload(input);
    if (skills.isNotEmpty) {
      body['skills_json'] = jsonEncode(skills);
    }

    _addOptionalCode(body, 'min_education_level_code', input.minimumEducationLevelCode);
    _addOptionalCode(body, 'experience_required_code', input.yearsOfExperienceCode);
    _addOptionalCode(body, 'preferred_field_of_study', input.preferredFieldOfStudyCode);
    _addOptionalCode(body, 'management_experience_code', input.managementExperienceCode);

    if (input.hiringManagerEmployeeId > 0) {
      body['hiring_manager_employee_id'] = input.hiringManagerEmployeeId;
    }
    if (input.recruiterEmployeeId > 0) {
      body['recruiter_employee_id'] = input.recruiterEmployeeId;
    }
    if (input.hrbpEmployeeId != null) {
      body['hrbp_employee_id'] = input.hrbpEmployeeId;
    }

    final panelPayload = _interviewPanelPayload(input.interviewPanelEmployeeIds);
    if (panelPayload.isNotEmpty) {
      body['interview_panel_json'] = jsonEncode(panelPayload);
    }

    _addOptionalCode(body, 'currency_code', input.currencyCode);
    _addOptionalCode(body, 'compensation_type_code', input.compensationTypeCode);

    final minSalary = double.tryParse(input.salaryRangeMin.trim());
    final maxSalary = double.tryParse(input.salaryRangeMax.trim());
    if (minSalary != null) {
      body['minimum_salary'] = minSalary;
    }
    if (maxSalary != null) {
      body['maximum_salary'] = maxSalary;
    }

    body['bonus_eligible_flag'] = input.bonusEligible ? 'Y' : 'N';
    body['equity_eligible_flag'] = input.equityEligible ? 'Y' : 'N';

    if (input.additionalBenefits != null && input.additionalBenefits!.trim().isNotEmpty) {
      body['additional_benefits'] = input.additionalBenefits!.trim();
    }

    _addText(body, 'budget_code', input.budgetCode);

    final approvedRaw = input.approvedBudgetAmount?.trim();
    if (approvedRaw != null && approvedRaw.isNotEmpty) {
      final approvedBudget = double.tryParse(approvedRaw);
      if (approvedBudget != null) {
        body['approved_budget_amount'] = approvedBudget;
      }
    }

    return body;
  }

  void _addText(Map<String, dynamic> body, String key, String value) {
    if (value.trim().isNotEmpty) {
      body[key] = value.trim();
    }
  }

  void _addOptionalCode(Map<String, dynamic> body, String key, String? code) {
    final trimmed = _trimCode(code);
    if (trimmed != null) {
      body[key] = trimmed;
    }
  }

  void _addOptionalGuid(Map<String, dynamic> body, String key, String? guid) {
    final trimmed = guid?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      body[key] = trimmed;
    }
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String? _trimCode(String? code) {
    final trimmed = code?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  List<Map<String, String>> _skillsPayload(CreateRequisitionRequestInput input) {
    return input.requiredSkillCodes
        .map((raw) => raw.trim())
        .where((code) => code.isNotEmpty)
        .map((code) => {'skill_code': code})
        .toList();
  }

  List<Map<String, dynamic>> _interviewPanelPayload(List<int> employeeIds) {
    if (employeeIds.isEmpty) return <Map<String, dynamic>>[];

    return employeeIds.map((id) {
      return {'employee_id': id, 'role': CreateRequisitionMultipartFormService.defaultInterviewPanelRole};
    }).toList();
  }
}
