import 'package:grc/features/hiring/domain/models/requisitions/requisition.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_budget.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_detail.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_grade.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_hiring_team.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_position.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisition_org_unit.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisitions_page.dart';
import 'package:grc/features/hiring/domain/models/requisitions/requisitions_pagination.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/utils/requisition_display_labels.dart';
import 'package:grc/features/hiring/presentation/utils/requisition_ui_placeholder.dart';
import 'package:grc/core/enums/hiring_enums.dart';

class RequisitionsPageDto {
  const RequisitionsPageDto({required this.items, required this.pagination});

  final List<RequisitionDto> items;
  final RequisitionsPaginationDto? pagination;

  factory RequisitionsPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(RequisitionDto.fromJson)
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final paginationJson = metaJson?['pagination'];
    final pagination = paginationJson is Map<String, dynamic>
        ? RequisitionsPaginationDto.fromJson(paginationJson)
        : null;

    return RequisitionsPageDto(items: data, pagination: pagination);
  }

  RequisitionsPage toDomain() {
    return RequisitionsPage(items: items.map((dto) => dto.toDomain()).toList(), pagination: pagination?.toDomain());
  }

  List<RequisitionTableRowData> toTableRows() {
    return items.map((dto) => dto.toTableRowData()).toList();
  }
}

class RequisitionsPaginationDto {
  const RequisitionsPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory RequisitionsPaginationDto.fromJson(Map<String, dynamic> json) {
    return RequisitionsPaginationDto(
      page: _parseInt(json['page'], defaultValue: 1),
      pageSize: _parseInt(json['page_size'] ?? json['pageSize'], defaultValue: 10),
      total: _parseInt(json['total']),
      totalPages: _parseInt(json['total_pages'] ?? json['totalPages'], defaultValue: 1),
      hasNext: _parseBool(json['has_next'] ?? json['hasNext']),
      hasPrevious: _parseBool(json['has_previous'] ?? json['hasPrevious']),
    );
  }

  RequisitionsPagination toDomain() {
    return RequisitionsPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class RequisitionDto {
  const RequisitionDto({
    required this.requisitionGuid,
    required this.requisitionNumber,
    required this.requisitionTitle,
    required this.employmentTypeCode,
    this.hiringManagerName,
    this.approvalStatusCode,
    this.gradeLevelCode,
    this.grade,
    this.position,
    this.positionTitle,
    this.orgStructure = const [],
    this.hiringTeam,
    this.detail = const RequisitionDetailDto(
      employmentTypeCode: '',
      numberOfOpenings: 0,
      priorityCode: '',
      workModeCode: '',
    ),
    this.budget,
    this.approvalCompletedSteps = 0,
    this.approvalTotalSteps = 0,
  });

  final String requisitionGuid;
  final String requisitionNumber;
  final String requisitionTitle;
  final String employmentTypeCode;
  final String? hiringManagerName;
  final String? approvalStatusCode;
  final String? gradeLevelCode;
  final RequisitionGradeDto? grade;
  final RequisitionPositionDto? position;
  final String? positionTitle;
  final List<RequisitionOrgUnitDto> orgStructure;
  final RequisitionHiringTeamDto? hiringTeam;
  final RequisitionDetailDto detail;
  final RequisitionBudgetDto? budget;
  final int approvalCompletedSteps;
  final int approvalTotalSteps;

  factory RequisitionDto.fromJson(Map<String, dynamic> json) {
    final detailJson = json['requisition_detail'];
    final budgetJson = json['budget'];
    final hiringTeamJson = json['hiring_team'];
    final gradeJson = json['grade'];
    final positionJson = json['position'];

    return RequisitionDto(
      requisitionGuid: json['requisition_guid'] as String? ?? '',
      requisitionNumber: json['requisition_number'] as String? ?? '',
      requisitionTitle: json['requisition_title'] as String? ?? '',
      employmentTypeCode: json['employment_type_code'] as String? ?? '',
      hiringManagerName: json['hiring_manager_name'] as String?,
      approvalStatusCode: json['approval_status_code'] as String?,
      gradeLevelCode:
          json['grade_level_code'] as String? ?? json['job_level_code'] as String? ?? json['grade_code'] as String?,
      grade: gradeJson is Map<String, dynamic> ? RequisitionGradeDto.fromJson(gradeJson) : null,
      position: positionJson is Map<String, dynamic> ? RequisitionPositionDto.fromJson(positionJson) : null,
      positionTitle: json['position_title'] as String? ?? json['role_title'] as String? ?? json['job_title'] as String?,
      orgStructure: _parseOrgStructure(json),
      hiringTeam: hiringTeamJson is Map<String, dynamic> ? RequisitionHiringTeamDto.fromJson(hiringTeamJson) : null,
      detail: detailJson is Map<String, dynamic>
          ? RequisitionDetailDto.fromJson(detailJson)
          : const RequisitionDetailDto(employmentTypeCode: '', numberOfOpenings: 0, priorityCode: '', workModeCode: ''),
      budget: budgetJson is Map<String, dynamic> ? RequisitionBudgetDto.fromJson(budgetJson) : null,
      approvalCompletedSteps: _parseInt(
        json['approval_completed_steps'] ?? json['approval_steps_completed'] ?? json['completed_approval_steps'],
      ),
      approvalTotalSteps: _parseInt(
        json['approval_total_steps'] ?? json['total_approval_steps'] ?? json['approval_steps_total'],
      ),
    );
  }

  Requisition toDomain() {
    return Requisition(
      requisitionGuid: requisitionGuid,
      requisitionNumber: requisitionNumber,
      requisitionTitle: requisitionTitle,
      employmentTypeCode: employmentTypeCode,
      hiringManagerName: hiringManagerName,
      approvalStatusCode: approvalStatusCode,
      gradeLevelCode: gradeLevelCode,
      grade: grade?.toDomain(),
      position: position?.toDomain(),
      positionTitle: positionTitle,
      orgStructure: orgStructure.map((dto) => dto.toDomain()).toList(),
      hiringTeam: hiringTeam?.toDomain(),
      detail: detail.toDomain(),
      budget: budget?.toDomain(),
      approvalCompletedSteps: approvalCompletedSteps,
      approvalTotalSteps: approvalTotalSteps,
    );
  }

  RequisitionTableRowData toTableRowData() {
    final requisition = toDomain();

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

class RequisitionPositionDto {
  const RequisitionPositionDto({this.positionId, this.positionCode, this.positionName});

  final String? positionId;
  final String? positionCode;
  final String? positionName;

  factory RequisitionPositionDto.fromJson(Map<String, dynamic> json) {
    return RequisitionPositionDto(
      positionId: json['position_id']?.toString(),
      positionCode: json['position_code'] as String?,
      positionName: json['position_name'] as String?,
    );
  }

  RequisitionPosition toDomain() {
    return RequisitionPosition(positionId: positionId, positionCode: positionCode, positionName: positionName);
  }
}

class RequisitionGradeDto {
  const RequisitionGradeDto({this.gradeId, this.gradeNumber, this.gradeCategory});

  final String? gradeId;
  final String? gradeNumber;
  final String? gradeCategory;

  factory RequisitionGradeDto.fromJson(Map<String, dynamic> json) {
    return RequisitionGradeDto(
      gradeId: json['grade_id']?.toString(),
      gradeNumber: json['grade_number'] as String?,
      gradeCategory: json['grade_category'] as String?,
    );
  }

  RequisitionGrade toDomain() {
    return RequisitionGrade(gradeId: gradeId, gradeNumber: gradeNumber, gradeCategory: gradeCategory);
  }
}

class RequisitionOrgUnitDto {
  const RequisitionOrgUnitDto({
    required this.levelCode,
    this.orgUnitId,
    this.orgStructureId,
    this.parentOrgUnitId,
    this.orgUnitName,
    this.orgUnitNameEn,
    this.orgUnitNameAr,
    this.orgUnitCode,
    this.hierarchyLevel,
  });

  final String levelCode;
  final String? orgUnitId;
  final String? orgStructureId;
  final String? parentOrgUnitId;
  final String? orgUnitName;
  final String? orgUnitNameEn;
  final String? orgUnitNameAr;
  final String? orgUnitCode;
  final int? hierarchyLevel;

  factory RequisitionOrgUnitDto.fromJson(Map<String, dynamic> json) {
    return RequisitionOrgUnitDto(
      levelCode: json['level_code'] as String? ?? '',
      orgUnitId: json['org_unit_id']?.toString(),
      orgStructureId: json['org_structure_id']?.toString(),
      parentOrgUnitId: json['parent_org_unit_id']?.toString(),
      orgUnitName: json['org_unit_name'] as String?,
      orgUnitNameEn: json['org_unit_name_en'] as String?,
      orgUnitNameAr: json['org_unit_name_ar'] as String?,
      orgUnitCode: json['org_unit_code'] as String?,
      hierarchyLevel: _parseNullableInt(json['hierarchy_level']),
    );
  }

  RequisitionOrgUnit toDomain() {
    return RequisitionOrgUnit(
      levelCode: levelCode,
      orgUnitName: orgUnitName,
      orgUnitNameEn: orgUnitNameEn,
      orgUnitCode: orgUnitCode,
    );
  }
}

class RequisitionJobFamilyDto {
  const RequisitionJobFamilyDto({this.jobFamilyId, this.jobFamilyCode, this.jobFamilyName});

  final String? jobFamilyId;
  final String? jobFamilyCode;
  final String? jobFamilyName;

  factory RequisitionJobFamilyDto.fromJson(Map<String, dynamic> json) {
    return RequisitionJobFamilyDto(
      jobFamilyId: json['job_family_id']?.toString(),
      jobFamilyCode: json['job_family_code'] as String?,
      jobFamilyName: json['job_family_name'] as String?,
    );
  }
}

class RequisitionJobLevelDto {
  const RequisitionJobLevelDto({this.jobLevelId, this.levelCode, this.levelName});

  final int? jobLevelId;
  final String? levelCode;
  final String? levelName;

  factory RequisitionJobLevelDto.fromJson(Map<String, dynamic> json) {
    return RequisitionJobLevelDto(
      jobLevelId: _parseNullableInt(json['job_level_id']),
      levelCode: json['level_code'] as String?,
      levelName: json['level_name'] as String?,
    );
  }
}

class RequisitionJustificationDto {
  const RequisitionJustificationDto({
    this.positionTypeCode,
    this.businessJustification,
    this.impactIfNotFilled,
    this.reportsToPositionId,
    this.reportsToPositionCode,
    this.reportsToPositionName,
    this.costCenterId,
  });

  final String? positionTypeCode;
  final String? businessJustification;
  final String? impactIfNotFilled;
  final String? reportsToPositionId;
  final String? reportsToPositionCode;
  final String? reportsToPositionName;
  final String? costCenterId;

  factory RequisitionJustificationDto.fromJson(Map<String, dynamic> json) {
    return RequisitionJustificationDto(
      positionTypeCode: json['position_type_code'] as String?,
      businessJustification: json['business_justification'] as String?,
      impactIfNotFilled: json['impact_if_not_filled'] as String?,
      reportsToPositionId: json['reports_to_position_id']?.toString(),
      reportsToPositionCode: json['reports_to_position_code'] as String?,
      reportsToPositionName: json['reports_to_position_name'] as String?,
      costCenterId: json['cost_center_id'] as String?,
    );
  }
}

class RequisitionInterviewPanelMemberDto {
  const RequisitionInterviewPanelMemberDto({
    this.interviewerEmployeeId,
    this.interviewerName,
    this.displaySequence = 0,
  });

  final int? interviewerEmployeeId;
  final String? interviewerName;
  final int displaySequence;

  factory RequisitionInterviewPanelMemberDto.fromJson(Map<String, dynamic> json) {
    return RequisitionInterviewPanelMemberDto(
      interviewerEmployeeId: _parseNullableInt(json['interviewer_employee_id']),
      interviewerName: json['interviewer_name'] as String?,
      displaySequence: _parseInt(json['display_sequence']),
    );
  }
}

List<RequisitionOrgUnitDto> parseRequisitionOrgUnitList(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(RequisitionOrgUnitDto.fromJson).toList();
}

class RequisitionHiringTeamDto {
  const RequisitionHiringTeamDto({
    this.reqHiringTeamId,
    this.reqHiringTeamGuid,
    this.hiringManagerEmployeeId,
    this.hiringManagerName,
    this.recruiterEmployeeId,
    this.recruiterName,
    this.hrbpEmployeeId,
    this.hrbpName,
  });

  final int? reqHiringTeamId;
  final String? reqHiringTeamGuid;
  final int? hiringManagerEmployeeId;
  final String? hiringManagerName;
  final int? recruiterEmployeeId;
  final String? recruiterName;
  final int? hrbpEmployeeId;
  final String? hrbpName;

  factory RequisitionHiringTeamDto.fromJson(Map<String, dynamic> json) {
    return RequisitionHiringTeamDto(
      reqHiringTeamId: _parseNullableInt(json['req_hiring_team_id']),
      reqHiringTeamGuid: json['req_hiring_team_guid'] as String?,
      hiringManagerEmployeeId: _parseNullableInt(json['hiring_manager_employee_id']),
      hiringManagerName: json['hiring_manager_name'] as String?,
      recruiterEmployeeId: _parseNullableInt(json['recruiter_employee_id']),
      recruiterName: json['recruiter_name'] as String?,
      hrbpEmployeeId: _parseNullableInt(json['hrbp_employee_id']),
      hrbpName: json['hrbp_name'] as String?,
    );
  }

  RequisitionHiringTeam toDomain() {
    return RequisitionHiringTeam(
      reqHiringTeamId: reqHiringTeamId,
      reqHiringTeamGuid: reqHiringTeamGuid,
      hiringManagerEmployeeId: hiringManagerEmployeeId,
      hiringManagerName: hiringManagerName,
      recruiterEmployeeId: recruiterEmployeeId,
      recruiterName: recruiterName,
      hrbpEmployeeId: hrbpEmployeeId,
      hrbpName: hrbpName,
    );
  }
}

class RequisitionDetailDto {
  const RequisitionDetailDto({
    required this.employmentTypeCode,
    required this.numberOfOpenings,
    required this.priorityCode,
    required this.workModeCode,
    this.primaryLocationId,
    this.primaryLocationName,
    this.primaryLocationText,
    this.targetStartDate,
    this.targetStartDateDisplay,
    this.expectedEndDate,
    this.expectedEndDateDisplay,
  });

  final String employmentTypeCode;
  final int numberOfOpenings;
  final String priorityCode;
  final String workModeCode;
  final String? primaryLocationId;
  final String? primaryLocationName;
  final String? primaryLocationText;
  final DateTime? targetStartDate;
  final String? targetStartDateDisplay;
  final DateTime? expectedEndDate;
  final String? expectedEndDateDisplay;

  factory RequisitionDetailDto.fromJson(Map<String, dynamic> json) {
    return RequisitionDetailDto(
      employmentTypeCode: json['employment_type_code'] as String? ?? '',
      numberOfOpenings: _parseInt(json['number_of_openings']),
      priorityCode: json['priority_code'] as String? ?? '',
      workModeCode: json['work_mode_code'] as String? ?? '',
      primaryLocationId: json['primary_location_id'] as String?,
      primaryLocationName: json['primary_location_name'] as String?,
      primaryLocationText: json['primary_location_text'] as String?,
      targetStartDate: _parseDate(json['target_start_date']),
      targetStartDateDisplay: json['target_start_date_display'] as String?,
      expectedEndDate: _parseDate(json['expected_end_date']),
      expectedEndDateDisplay: json['expected_end_date_display'] as String?,
    );
  }

  RequisitionDetail toDomain() {
    return RequisitionDetail(
      employmentTypeCode: employmentTypeCode,
      numberOfOpenings: numberOfOpenings,
      priorityCode: priorityCode,
      workModeCode: workModeCode,
      primaryLocationId: primaryLocationId,
      primaryLocationName: primaryLocationName,
      primaryLocationText: primaryLocationText,
      targetStartDate: targetStartDate,
      targetStartDateDisplay: targetStartDateDisplay,
      expectedEndDate: expectedEndDate,
      expectedEndDateDisplay: expectedEndDateDisplay,
    );
  }
}

class RequisitionBudgetDto {
  const RequisitionBudgetDto({
    this.reqBudgetId,
    this.reqBudgetGuid,
    required this.currencyCode,
    required this.compensationTypeCode,
    this.minimumSalary,
    this.maximumSalary,
    required this.compensationRange,
    this.bonusEligibleFlag,
    this.equityEligibleFlag,
    this.additionalBenefits,
    this.budgetCode,
    this.approvedBudgetAmount,
  });

  final int? reqBudgetId;
  final String? reqBudgetGuid;
  final String currencyCode;
  final String compensationTypeCode;
  final double? minimumSalary;
  final double? maximumSalary;
  final String compensationRange;
  final String? bonusEligibleFlag;
  final String? equityEligibleFlag;
  final String? additionalBenefits;
  final String? budgetCode;
  final double? approvedBudgetAmount;

  factory RequisitionBudgetDto.fromJson(Map<String, dynamic> json) {
    return RequisitionBudgetDto(
      reqBudgetId: _parseNullableInt(json['req_budget_id']),
      reqBudgetGuid: json['req_budget_guid'] as String?,
      currencyCode: json['currency_code'] as String? ?? '',
      compensationTypeCode: json['compensation_type_code'] as String? ?? '',
      minimumSalary: _parseDouble(json['minimum_salary']),
      maximumSalary: _parseDouble(json['maximum_salary']),
      compensationRange: json['compensation_range'] as String? ?? '',
      bonusEligibleFlag: json['bonus_eligible_flag'] as String?,
      equityEligibleFlag: json['equity_eligible_flag'] as String?,
      additionalBenefits: json['additional_benefits'] as String?,
      budgetCode: json['budget_code'] as String?,
      approvedBudgetAmount: _parseDouble(json['approved_budget_amount']),
    );
  }

  RequisitionBudget toDomain() {
    return RequisitionBudget(
      reqBudgetId: reqBudgetId,
      reqBudgetGuid: reqBudgetGuid,
      currencyCode: currencyCode,
      compensationTypeCode: compensationTypeCode,
      minimumSalary: minimumSalary,
      maximumSalary: maximumSalary,
      compensationRange: compensationRange,
      bonusEligibleFlag: bonusEligibleFlag,
      equityEligibleFlag: equityEligibleFlag,
      additionalBenefits: additionalBenefits,
      budgetCode: budgetCode,
      approvedBudgetAmount: approvedBudgetAmount,
    );
  }
}

List<RequisitionOrgUnitDto> _parseOrgStructure(Map<String, dynamic> json) {
  final units = <RequisitionOrgUnitDto>[];

  void addFromList(dynamic raw) {
    if (raw is! List<dynamic>) return;
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        units.add(RequisitionOrgUnitDto.fromJson(item));
      }
    }
  }

  addFromList(json['justification_org_hierarchy']);
  addFromList(json['org_structure_list']);

  return units;
}

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool _parseBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  if (value is num) return value != 0;
  return defaultValue;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}
