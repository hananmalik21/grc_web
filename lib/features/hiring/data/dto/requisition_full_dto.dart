import 'package:grc/features/hiring/data/dto/requisitions_dto.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_education_experience.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_full.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_position_detail.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_skill.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_status_info.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/utils/requisition_display_labels.dart';
import 'package:grc/features/hiring/presentation/utils/requisition_ui_placeholder.dart';
import 'package:grc/core/enums/hiring_enums.dart';

class RequisitionFullDto {
  const RequisitionFullDto({
    required this.requisitionGuid,
    required this.requisitionNumber,
    required this.requisitionTitle,
    required this.enterpriseId,
    this.approvalStatusCode,
    this.openStatusCode,
    this.employmentTypeCode = '',
    this.position,
    this.grade,
    this.jobFamily,
    this.jobLevel,
    this.jobLevelCode,
    this.rootOrgUnit,
    this.orgHierarchy = const [],
    this.justificationOrgHierarchy = const [],
    this.orgStructure = const [],
    this.justification,
    this.interviewPanel = const [],
    this.detail = const RequisitionDetailDto(
      employmentTypeCode: '',
      numberOfOpenings: 0,
      priorityCode: '',
      workModeCode: '',
    ),
    this.statusInfo,
    this.hiringTeam,
    this.budget,
    this.positionDetail,
    this.educationExperience,
    this.skills = const [],
    this.approvalCompletedSteps = 0,
    this.approvalTotalSteps = 0,
  });

  final String requisitionGuid;
  final String requisitionNumber;
  final String requisitionTitle;
  final int enterpriseId;
  final String? approvalStatusCode;
  final String? openStatusCode;
  final String employmentTypeCode;
  final RequisitionPositionDto? position;
  final RequisitionGradeDto? grade;
  final RequisitionJobFamilyDto? jobFamily;
  final RequisitionJobLevelDto? jobLevel;
  final String? jobLevelCode;
  final RequisitionOrgUnitDto? rootOrgUnit;
  final List<RequisitionOrgUnitDto> orgHierarchy;
  final List<RequisitionOrgUnitDto> justificationOrgHierarchy;
  final List<RequisitionOrgUnitDto> orgStructure;
  final RequisitionJustificationDto? justification;
  final List<RequisitionInterviewPanelMemberDto> interviewPanel;
  final RequisitionDetailDto detail;
  final RequisitionStatusInfoDto? statusInfo;
  final RequisitionHiringTeamDto? hiringTeam;
  final RequisitionBudgetDto? budget;
  final RequisitionPositionDetailDto? positionDetail;
  final RequisitionEducationExperienceDto? educationExperience;
  final List<RequisitionSkillDto> skills;
  final int approvalCompletedSteps;
  final int approvalTotalSteps;

  factory RequisitionFullDto.fromJson(Map<String, dynamic> json) {
    final detailJson = json['requisition_detail'];
    final budgetJson = json['budget'];
    final hiringTeamJson = json['hiring_team'];
    final gradeJson = json['grade'];
    final positionJson = json['position'];
    final statusJson = json['status'];
    final positionDetailJson = json['position_detail'];
    final educationJson = json['education_experience'];
    final jobLevelJson = json['job_level'];
    final jobFamilyJson = json['job_family'];
    final orgUnitJson = json['org_unit'];
    final justificationJson = json['justification'];
    final orgHierarchy = parseRequisitionOrgUnitList(json['org_hierarchy']);
    final justificationOrgHierarchy = parseRequisitionOrgUnitList(json['justification_org_hierarchy']);

    return RequisitionFullDto(
      requisitionGuid: json['requisition_guid'] as String? ?? '',
      requisitionNumber: json['requisition_number'] as String? ?? '',
      requisitionTitle: json['requisition_title'] as String? ?? '',
      enterpriseId: _parseInt(json['enterprise_id'], defaultValue: 0),
      approvalStatusCode: json['approval_status_code'] as String?,
      openStatusCode: json['open_status_code'] as String?,
      employmentTypeCode: json['employment_type_code'] as String? ?? '',
      position: positionJson is Map<String, dynamic> ? RequisitionPositionDto.fromJson(positionJson) : null,
      grade: gradeJson is Map<String, dynamic> ? RequisitionGradeDto.fromJson(gradeJson) : null,
      jobFamily: jobFamilyJson is Map<String, dynamic> ? RequisitionJobFamilyDto.fromJson(jobFamilyJson) : null,
      jobLevel: jobLevelJson is Map<String, dynamic> ? RequisitionJobLevelDto.fromJson(jobLevelJson) : null,
      jobLevelCode: jobLevelJson is Map<String, dynamic> ? jobLevelJson['level_code'] as String? : null,
      rootOrgUnit: orgUnitJson is Map<String, dynamic> ? RequisitionOrgUnitDto.fromJson(orgUnitJson) : null,
      orgHierarchy: orgHierarchy,
      justificationOrgHierarchy: justificationOrgHierarchy,
      orgStructure: orgHierarchy.isNotEmpty ? orgHierarchy : justificationOrgHierarchy,
      justification: justificationJson is Map<String, dynamic>
          ? RequisitionJustificationDto.fromJson(justificationJson)
          : null,
      interviewPanel: _parseInterviewPanel(json['interview_panel']),
      detail: detailJson is Map<String, dynamic>
          ? RequisitionDetailDto.fromJson(detailJson)
          : const RequisitionDetailDto(employmentTypeCode: '', numberOfOpenings: 0, priorityCode: '', workModeCode: ''),
      statusInfo: statusJson is Map<String, dynamic> ? RequisitionStatusInfoDto.fromJson(statusJson) : null,
      hiringTeam: hiringTeamJson is Map<String, dynamic> ? RequisitionHiringTeamDto.fromJson(hiringTeamJson) : null,
      budget: budgetJson is Map<String, dynamic> ? RequisitionBudgetDto.fromJson(budgetJson) : null,
      positionDetail: positionDetailJson is Map<String, dynamic>
          ? RequisitionPositionDetailDto.fromJson(positionDetailJson)
          : null,
      educationExperience: educationJson is Map<String, dynamic>
          ? RequisitionEducationExperienceDto.fromJson(educationJson)
          : null,
      skills: _parseSkills(json['skills']),
      approvalCompletedSteps: _parseInt(json['approval_completed_steps'] ?? json['approval_steps_completed']),
      approvalTotalSteps: _parseInt(json['approval_total_steps'] ?? json['total_approval_steps']),
    );
  }

  RequisitionFull toDomain() {
    return RequisitionFull(
      requisitionGuid: requisitionGuid,
      requisitionNumber: requisitionNumber,
      requisitionTitle: requisitionTitle,
      enterpriseId: enterpriseId,
      approvalStatusCode: approvalStatusCode,
      openStatusCode: openStatusCode,
      employmentTypeCode: employmentTypeCode,
      position: position?.toDomain(),
      grade: grade?.toDomain(),
      jobLevelCode: jobLevelCode,
      orgStructure: orgStructure.map((dto) => dto.toDomain()).toList(),
      detail: detail.toDomain(),
      statusInfo: statusInfo?.toDomain(),
      hiringTeam: hiringTeam?.toDomain(),
      budget: budget?.toDomain(),
      positionDetail: positionDetail?.toDomain(),
      educationExperience: educationExperience?.toDomain(),
      skills: skills.map((dto) => dto.toDomain()).toList(),
      approvalCompletedSteps: approvalCompletedSteps,
      approvalTotalSteps: approvalTotalSteps,
    );
  }

  /// Converts this API DTO into the UI row model used by requisition detail.
  RequisitionTableRowData toTableRowData() {
    final requisition = toDomain();
    final row = _toTableRow(_toRequisitionFromFull(requisition));
    final positionDetail = requisition.positionDetail;

    return RequisitionTableRowData(
      id: row.id,
      requisitionCode: row.requisitionCode,
      jobTitle: row.jobTitle,
      gradeNumber: row.gradeNumber,
      employmentTypeCode: row.employmentTypeCode,
      employmentTypeLabel: row.employmentTypeLabel,
      employmentTypeKey: row.employmentTypeKey,
      department: row.department,
      departmentKey: row.departmentKey,
      roleTitle: row.roleTitle,
      hiringManager: row.hiringManager,
      location: row.location,
      workModeCode: row.workModeCode,
      workModeLabel: row.workModeLabel,
      workModeKey: row.workModeKey,
      openings: row.openings,
      compensationRange: row.compensationRange,
      compensationTypeLabel: row.compensationTypeLabel,
      status: RequisitionUiPlaceholder.text(_resolveDisplayStatus(requisition)),
      statusEnum: RequisitionStatus.fromApiValue(requisition.approvalStatusCode),
      openStatusCode: requisition.openStatusCode,
      openStatusEnum: RequisitionOpenStatus.fromApiValue(requisition.openStatusCode),
      approvalStatusLabel: RequisitionUiPlaceholder.text(
        RequisitionDisplayLabels.approvalStatus(requisition.approvalStatusCode),
      ),
      approvalCompleted: row.approvalCompleted,
      approvalTotal: row.approvalTotal,
      priorityLabel: row.priorityLabel,
      priorityKey: row.priorityKey,
      targetStart: row.targetStart,
      targetStartDisplay: row.targetStartDisplay,
      positionSummary: _dashText(positionDetail?.positionSummary),
      keyResponsibilities: _dashText(positionDetail?.keyResponsibilities),
      minimumQualifications: _dashText(positionDetail?.minimumQualifications),
      preferredQualifications: _dashText(positionDetail?.preferredQualifications),
      recruiterName: RequisitionUiPlaceholder.text(requisition.hiringTeam?.recruiterName),
      hrbpName: RequisitionUiPlaceholder.text(requisition.hiringTeam?.hrbpName),
      skills: requisition.skills
          .map((skill) => RequisitionSkillRowData(name: skill.skillName, typeCode: skill.skillTypeCode))
          .toList(),
    );
  }

  static String _dashText(String? raw) {
    final trimmed = raw?.trim();
    if (trimmed == null || trimmed.isEmpty) return '---';
    return trimmed;
  }

  static String _resolveDisplayStatus(RequisitionFull requisition) {
    final display = requisition.statusInfo?.displayStatus?.trim();
    if (display != null && display.isNotEmpty) return display;

    final openCode = requisition.openStatusCode?.trim();
    if (openCode != null && openCode.isNotEmpty) {
      final openLabel = RequisitionDisplayLabels.approvalStatus(openCode);
      if (openLabel.isNotEmpty) return openLabel;
    }

    return RequisitionDisplayLabels.approvalStatus(requisition.approvalStatusCode);
  }

  static Requisition _toRequisitionFromFull(RequisitionFull full) {
    final employmentCode = full.employmentTypeCode.isNotEmpty
        ? full.employmentTypeCode
        : full.detail.employmentTypeCode;

    return Requisition(
      requisitionGuid: full.requisitionGuid,
      requisitionNumber: full.requisitionNumber,
      requisitionTitle: full.requisitionTitle,
      employmentTypeCode: employmentCode,
      approvalStatusCode: full.approvalStatusCode,
      openStatusCode: full.openStatusCode,
      gradeLevelCode: full.jobLevelCode,
      grade: full.grade,
      position: full.position,
      orgStructure: full.orgStructure,
      hiringTeam: full.hiringTeam,
      detail: full.detail,
      budget: full.budget,
      approvalCompletedSteps: full.approvalCompletedSteps,
      approvalTotalSteps: full.approvalTotalSteps,
    );
  }

  static RequisitionTableRowData _toTableRow(Requisition requisition) {
    final detail = requisition.detail;
    final budget = requisition.budget;
    final employmentCode = requisition.employmentTypeCode.isNotEmpty
        ? requisition.employmentTypeCode
        : detail.employmentTypeCode;
    final priorityCode = detail.priorityCode;
    final workModeCode = detail.workModeCode;
    final departmentUnit = requisition.orgUnitForLevel('DEPARTMENT');

    return RequisitionTableRowData(
      id: requisition.requisitionGuid,
      requisitionCode: RequisitionUiPlaceholder.text(requisition.requisitionNumber),
      jobTitle: RequisitionUiPlaceholder.text(requisition.requisitionTitle),
      gradeNumber: RequisitionUiPlaceholder.text(requisition.displayGradeLabel),
      employmentTypeCode: RequisitionUiPlaceholder.text(employmentCode),
      employmentTypeLabel: RequisitionUiPlaceholder.text(RequisitionDisplayLabels.employmentType(employmentCode)),
      employmentTypeKey: RequisitionDisplayLabels.filterKey(employmentCode),
      department: RequisitionUiPlaceholder.text(requisition.departmentName),
      departmentKey: RequisitionDisplayLabels.filterKey(departmentUnit?.orgUnitCode ?? departmentUnit?.displayName),
      roleTitle: RequisitionUiPlaceholder.text(requisition.displayPositionName),
      hiringManager: RequisitionUiPlaceholder.text(requisition.resolvedHiringManagerName),
      location: RequisitionUiPlaceholder.text(detail.locationDisplay),
      workModeCode: RequisitionUiPlaceholder.text(workModeCode),
      workModeLabel: RequisitionUiPlaceholder.text(RequisitionDisplayLabels.workMode(workModeCode)),
      workModeKey: RequisitionDisplayLabels.filterKey(workModeCode),
      openings: detail.numberOfOpenings,
      compensationRange: RequisitionUiPlaceholder.text(budget?.compensationRange),
      compensationTypeLabel: RequisitionUiPlaceholder.text(
        RequisitionDisplayLabels.compensationType(budget?.compensationTypeCode),
      ),
      status: RequisitionUiPlaceholder.text(RequisitionDisplayLabels.approvalStatus(requisition.approvalStatusCode)),
      statusEnum: RequisitionStatus.fromApiValue(requisition.approvalStatusCode),
      openStatusCode: requisition.openStatusCode,
      openStatusEnum: RequisitionOpenStatus.fromApiValue(requisition.openStatusCode),
      approvalStatusLabel: RequisitionUiPlaceholder.text(
        RequisitionDisplayLabels.approvalStatus(requisition.approvalStatusCode),
      ),
      approvalCompleted: requisition.approvalCompletedSteps,
      approvalTotal: requisition.approvalTotalSteps,
      priorityLabel: RequisitionUiPlaceholder.text(RequisitionDisplayLabels.priority(priorityCode)),
      priorityKey: RequisitionDisplayLabels.filterKey(priorityCode),
      targetStart: detail.targetStartDate,
      targetStartDisplay: detail.targetStartDateDisplay,
    );
  }
}

class RequisitionStatusInfoDto {
  const RequisitionStatusInfoDto({
    this.approvalStatusCode,
    this.openStatusCode,
    this.displayStatus,
    this.submittedBy,
    this.submittedDate,
    this.approvedBy,
    this.approvedDate,
    this.openedBy,
    this.openedDate,
    this.closedBy,
    this.closedDate,
  });

  final String? approvalStatusCode;
  final String? openStatusCode;
  final String? displayStatus;
  final String? submittedBy;
  final DateTime? submittedDate;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? openedBy;
  final DateTime? openedDate;
  final String? closedBy;
  final DateTime? closedDate;

  factory RequisitionStatusInfoDto.fromJson(Map<String, dynamic> json) {
    return RequisitionStatusInfoDto(
      approvalStatusCode: json['approval_status_code'] as String?,
      openStatusCode: json['open_status_code'] as String?,
      displayStatus: json['display_status'] as String?,
      submittedBy: json['submitted_by'] as String?,
      submittedDate: _parseDateTime(json['submitted_date']),
      approvedBy: json['approved_by'] as String?,
      approvedDate: _parseDateTime(json['approved_date']),
      openedBy: json['opened_by'] as String?,
      openedDate: _parseDateTime(json['opened_date']),
      closedBy: json['closed_by'] as String?,
      closedDate: _parseDateTime(json['closed_date']),
    );
  }

  RequisitionStatusInfo toDomain() {
    return RequisitionStatusInfo(
      approvalStatusCode: approvalStatusCode,
      openStatusCode: openStatusCode,
      displayStatus: displayStatus,
      submittedBy: submittedBy,
      submittedDate: submittedDate,
      approvedBy: approvedBy,
      approvedDate: approvedDate,
      openedBy: openedBy,
      openedDate: openedDate,
      closedBy: closedBy,
      closedDate: closedDate,
    );
  }
}

class RequisitionPositionDetailDto {
  const RequisitionPositionDetailDto({
    this.positionSummary,
    this.keyResponsibilities,
    this.minimumQualifications,
    this.preferredQualifications,
    this.travelRequirementCode,
    this.requiredCertifications,
    this.physicalRequirements,
  });

  final String? positionSummary;
  final String? keyResponsibilities;
  final String? minimumQualifications;
  final String? preferredQualifications;
  final String? travelRequirementCode;
  final String? requiredCertifications;
  final String? physicalRequirements;

  factory RequisitionPositionDetailDto.fromJson(Map<String, dynamic> json) {
    final rawPositionSummary = json['position_summary'] as String?;
    final trimmedPositionSummary = rawPositionSummary?.trim();
    final normalizedPositionSummary = (trimmedPositionSummary == null || trimmedPositionSummary.isEmpty)
        ? '---'
        : trimmedPositionSummary;

    String normalize(String? raw) {
      final trimmed = raw?.trim();
      return (trimmed == null || trimmed.isEmpty) ? '---' : trimmed;
    }

    return RequisitionPositionDetailDto(
      positionSummary: normalizedPositionSummary,
      keyResponsibilities: normalize(json['key_responsibilities'] as String?),
      minimumQualifications: normalize(json['minimum_qualifications'] as String?),
      preferredQualifications: normalize(json['preferred_qualifications'] as String?),
      travelRequirementCode: json['travel_requirement_code'] as String?,
      requiredCertifications: json['required_certifications'] as String?,
      physicalRequirements: json['physical_requirements'] as String?,
    );
  }

  RequisitionPositionDetail toDomain() {
    return RequisitionPositionDetail(
      positionSummary: positionSummary,
      keyResponsibilities: keyResponsibilities,
      minimumQualifications: minimumQualifications,
      preferredQualifications: preferredQualifications,
      travelRequirementCode: travelRequirementCode,
      requiredCertifications: requiredCertifications,
      physicalRequirements: physicalRequirements,
    );
  }
}

class RequisitionEducationExperienceDto {
  const RequisitionEducationExperienceDto({
    this.minEducationLevelCode,
    this.experienceRequiredCode,
    this.preferredFieldOfStudy,
    this.managementExperienceCode,
  });

  final String? minEducationLevelCode;
  final String? experienceRequiredCode;
  final String? preferredFieldOfStudy;
  final String? managementExperienceCode;

  factory RequisitionEducationExperienceDto.fromJson(Map<String, dynamic> json) {
    return RequisitionEducationExperienceDto(
      minEducationLevelCode: json['min_education_level_code'] as String?,
      experienceRequiredCode: json['experience_required_code'] as String?,
      preferredFieldOfStudy: json['preferred_field_of_study'] as String?,
      managementExperienceCode: json['management_experience_code'] as String?,
    );
  }

  RequisitionEducationExperience toDomain() {
    return RequisitionEducationExperience(
      minEducationLevelCode: minEducationLevelCode,
      experienceRequiredCode: experienceRequiredCode,
      preferredFieldOfStudy: preferredFieldOfStudy,
      managementExperienceCode: managementExperienceCode,
    );
  }
}

class RequisitionSkillDto {
  const RequisitionSkillDto({required this.skillName, required this.skillTypeCode, this.displaySequence = 0});

  final String skillName;
  final String skillTypeCode;
  final int displaySequence;

  factory RequisitionSkillDto.fromJson(Map<String, dynamic> json) {
    return RequisitionSkillDto(
      skillName: json['skill_name'] as String? ?? '',
      skillTypeCode: json['skill_type_code'] as String? ?? '',
      displaySequence: _parseInt(json['display_sequence']),
    );
  }

  RequisitionSkill toDomain() {
    return RequisitionSkill(skillName: skillName, skillTypeCode: skillTypeCode, displaySequence: displaySequence);
  }
}

List<RequisitionInterviewPanelMemberDto> _parseInterviewPanel(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(RequisitionInterviewPanelMemberDto.fromJson).toList();
}

List<RequisitionSkillDto> _parseSkills(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(RequisitionSkillDto.fromJson).toList();
}

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}
