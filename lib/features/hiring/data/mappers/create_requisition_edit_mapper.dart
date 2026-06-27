import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/hiring/data/dto/requisition_full_dto.dart';
import 'package:grc/features/hiring/data/dto/requisitions_dto.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_state.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';

class CreateRequisitionEditResult {
  const CreateRequisitionEditResult({
    required this.state,
    required this.basicInfoOrgPath,
    required this.justificationOrgPath,
  });

  final CreateRequisitionState state;
  final List<OrgUnit> basicInfoOrgPath;
  final List<OrgUnit> justificationOrgPath;
}

abstract final class CreateRequisitionEditMapper {
  CreateRequisitionEditMapper._();

  static CreateRequisitionEditResult fromFullDto({
    required RequisitionFullDto dto,
    required List<EmplLookupValue> contractTypes,
    required int enterpriseId,
  }) {
    final detail = dto.detail;
    final justification = dto.justification;
    final positionDetail = dto.positionDetail;
    final education = dto.educationExperience;
    final budget = dto.budget;
    final hiringTeam = dto.hiringTeam;

    final employmentCode = detail.employmentTypeCode.isNotEmpty ? detail.employmentTypeCode : dto.employmentTypeCode;

    final selectedPosition = _positionFromDto(dto.position, dto.requisitionTitle);
    final selectedJobFamily = _jobFamilyFromDto(dto.jobFamily);
    final selectedJobLevel = _jobLevelFromDto(dto.jobLevel, dto.jobLevelCode);
    final selectedGrade = _gradeFromDto(dto.grade, budget?.currencyCode);
    final selectedContractType = _matchContractType(contractTypes, employmentCode);

    final basicHierarchy = _resolveOrgHierarchy(dto.orgHierarchy, dto.rootOrgUnit);
    final justificationHierarchy = _resolveOrgHierarchy(dto.justificationOrgHierarchy, dto.rootOrgUnit);

    final basicInfoOrgPath = _orgPathFromHierarchy(basicHierarchy, enterpriseId);
    final justificationOrgPath = _orgPathFromHierarchy(justificationHierarchy, enterpriseId);
    final deepestBasic = basicInfoOrgPath.isNotEmpty ? basicInfoOrgPath.last : null;
    final deepestJustification = justificationOrgPath.isNotEmpty ? justificationOrgPath.last : null;

    final departmentLabel = deepestBasic != null ? _orgUnitLabel(deepestBasic) : null;

    final reportsToPosition = _reportsToPosition(justification);
    final hiringManager = _employeeStub(
      id: hiringTeam?.hiringManagerEmployeeId,
      name: hiringTeam?.hiringManagerName,
      enterpriseId: enterpriseId,
    );
    final recruiter = _employeeStub(
      id: hiringTeam?.recruiterEmployeeId,
      name: hiringTeam?.recruiterName,
      enterpriseId: enterpriseId,
    );
    final hrbp = _employeeStub(id: hiringTeam?.hrbpEmployeeId, name: hiringTeam?.hrbpName, enterpriseId: enterpriseId);

    final panelMembers = dto.interviewPanel.isEmpty
        ? const <Employee?>[null]
        : dto.interviewPanel
              .map(
                (m) => _employeeStub(id: m.interviewerEmployeeId, name: m.interviewerName, enterpriseId: enterpriseId),
              )
              .toList();

    final skillCodes = dto.skills
        .where((s) => s.skillTypeCode.trim().toUpperCase() == 'REQUIRED')
        .map((s) => s.skillName.trim())
        .where((code) => code.isNotEmpty)
        .toList();

    final state = CreateRequisitionState(
      selectedPosition: selectedPosition,
      jobTitle: selectedPosition?.titleEnglish ?? dto.requisitionTitle,
      department: departmentLabel,
      selectedDepartmentOrgUnit: deepestBasic,
      selectedJustificationOrgUnit: deepestJustification,
      selectedJobFamily: selectedJobFamily,
      selectedJobLevel: selectedJobLevel,
      selectedGrade: selectedGrade,
      selectedContractType: selectedContractType,
      numberOfOpenings: detail.numberOfOpenings > 0 ? detail.numberOfOpenings : 1,
      priority: _nonEmptyCode(detail.priorityCode),
      primaryLocation: _nonEmptyCode(detail.primaryLocationId),
      workMode: _nonEmptyCode(detail.workModeCode),
      targetStartDate: detail.targetStartDate,
      expectedEndDate: detail.expectedEndDate,
      positionType: _nonEmptyCode(justification?.positionTypeCode),
      businessJustification: justification?.businessJustification,
      impactIfNotFilled: justification?.impactIfNotFilled,
      reportsTo: reportsToPosition?.titleEnglish,
      reportsToPosition: reportsToPosition,
      costCenter: justification?.costCenterId,
      positionSummary: _cleanDetailText(positionDetail?.positionSummary),
      keyResponsibilities: _cleanDetailText(positionDetail?.keyResponsibilities),
      minimumQualifications: _cleanDetailText(positionDetail?.minimumQualifications),
      preferredQualifications: _cleanDetailText(positionDetail?.preferredQualifications),
      travelRequirement: _nonEmptyCode(positionDetail?.travelRequirementCode),
      requiredCertifications: _nonEmptyCode(positionDetail?.requiredCertifications),
      physicalRequirements: _nonEmptyCode(positionDetail?.physicalRequirements),
      requiredSkills: skillCodes,
      minimumEducationLevel: _nonEmptyCode(education?.minEducationLevelCode),
      yearsOfExperience: _nonEmptyCode(education?.experienceRequiredCode),
      preferredFieldOfStudy: _nonEmptyCode(education?.preferredFieldOfStudy),
      managementExperience: _nonEmptyCode(education?.managementExperienceCode),
      hiringManager: hiringTeam?.hiringManagerName,
      recruiter: hiringTeam?.recruiterName,
      hrBusinessPartner: hiringTeam?.hrbpName,
      hiringManagerEmployee: hiringManager,
      recruiterEmployee: recruiter,
      hrBusinessPartnerEmployee: hrbp,
      interviewPanelMembers: panelMembers,
      currency: _nonEmptyCode(budget?.currencyCode),
      compensationType: _nonEmptyCode(budget?.compensationTypeCode),
      salaryRangeMin: budget?.minimumSalary?.toString(),
      salaryRangeMax: budget?.maximumSalary?.toString(),
      bonusEligible: _flagIsYes(budget?.bonusEligibleFlag),
      equityEligible: _flagIsYes(budget?.equityEligibleFlag),
      additionalBenefits: budget?.additionalBenefits,
      budgetCode: budget?.budgetCode,
      approvedBudgetAmount: budget?.approvedBudgetAmount?.toString(),
    );

    return CreateRequisitionEditResult(
      state: state,
      basicInfoOrgPath: basicInfoOrgPath,
      justificationOrgPath: justificationOrgPath,
    );
  }

  static String? _nonEmptyCode(String? code) {
    if (code == null) return null;
    final trimmed = code.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static List<RequisitionOrgUnitDto> _resolveOrgHierarchy(
    List<RequisitionOrgUnitDto> hierarchy,
    RequisitionOrgUnitDto? root,
  ) {
    if (hierarchy.isNotEmpty) return hierarchy;
    if (root != null) return [root];
    return const [];
  }

  static List<OrgUnit> _orgPathFromHierarchy(List<RequisitionOrgUnitDto> hierarchy, int enterpriseId) {
    final sorted = List<RequisitionOrgUnitDto>.of(hierarchy)
      ..sort((a, b) => (a.hierarchyLevel ?? 0).compareTo(b.hierarchyLevel ?? 0));

    return sorted
        .where((u) => u.orgUnitId != null && u.orgUnitId!.trim().isNotEmpty)
        .map((u) => _orgUnitFromDto(u, enterpriseId))
        .toList();
  }

  static OrgUnit _orgUnitFromDto(RequisitionOrgUnitDto dto, int enterpriseId) {
    return OrgUnit(
      orgUnitId: dto.orgUnitId ?? '',
      orgStructureId: dto.orgStructureId ?? '',
      enterpriseId: enterpriseId,
      levelCode: dto.levelCode,
      orgUnitCode: dto.orgUnitCode ?? '',
      orgUnitNameEn: dto.orgUnitNameEn ?? dto.orgUnitName ?? '',
      orgUnitNameAr: dto.orgUnitNameAr ?? '',
      parentOrgUnitId: dto.parentOrgUnitId,
      isActive: true,
    );
  }

  static String _orgUnitLabel(OrgUnit unit) {
    final nameEn = unit.orgUnitNameEn.trim();
    if (nameEn.isNotEmpty) return nameEn;
    final nameAr = unit.orgUnitNameAr.trim();
    if (nameAr.isNotEmpty) return nameAr;
    return unit.orgUnitCode;
  }

  static Position? _positionFromDto(RequisitionPositionDto? dto, String title) {
    if (dto == null) return null;
    final id = dto.positionId?.trim();
    if (id == null || id.isEmpty) return null;
    final name = dto.positionName?.trim() ?? title.trim();
    return Position.empty().copyWith(id: id, code: dto.positionCode ?? '', titleEnglish: name, titleArabic: name);
  }

  static Position? _reportsToPosition(RequisitionJustificationDto? justification) {
    if (justification == null) return null;
    final id = justification.reportsToPositionId?.trim();
    if (id == null || id.isEmpty) return null;
    final name = justification.reportsToPositionName?.trim() ?? '';
    return Position.empty().copyWith(
      id: id,
      code: justification.reportsToPositionCode ?? '',
      titleEnglish: name,
      titleArabic: name,
    );
  }

  static JobFamily? _jobFamilyFromDto(RequisitionJobFamilyDto? dto) {
    if (dto == null) return null;
    final id = int.tryParse(dto.jobFamilyId ?? '');
    if (id == null) return null;
    return JobFamily(
      id: id,
      code: dto.jobFamilyCode ?? '',
      nameEnglish: dto.jobFamilyName ?? '',
      nameArabic: dto.jobFamilyName ?? '',
      description: '',
      totalPositions: 0,
      filledPositions: 0,
      fillRate: 0,
      isActive: true,
    );
  }

  static JobLevel? _jobLevelFromDto(RequisitionJobLevelDto? dto, String? fallbackCode) {
    if (dto?.jobLevelId != null) {
      return JobLevel(
        id: dto!.jobLevelId!,
        nameEn: dto.levelName ?? '',
        code: dto.levelCode ?? fallbackCode ?? '',
        description: '',
        minGradeId: 0,
        maxGradeId: 0,
        status: 'ACTIVE',
      );
    }
    return null;
  }

  static Grade? _gradeFromDto(RequisitionGradeDto? dto, String? currencyCode) {
    if (dto == null) return null;
    final id = int.tryParse(dto.gradeId ?? '');
    if (id == null) return null;
    final now = DateTime.now();
    return Grade(
      id: id,
      gradeNumber: dto.gradeNumber ?? '',
      gradeCategory: dto.gradeCategory ?? '',
      currencyCode: currencyCode ?? '',
      step1Salary: 0,
      step2Salary: 0,
      step3Salary: 0,
      step4Salary: 0,
      step5Salary: 0,
      description: '',
      status: 'ACTIVE',
      createdBy: '',
      createdDate: now,
      lastUpdatedBy: '',
      lastUpdatedDate: now,
      lastUpdateLogin: '',
    );
  }

  static EmplLookupValue? _matchContractType(List<EmplLookupValue> contractTypes, String? code) {
    if (code == null || code.trim().isEmpty) return null;
    final normalized = code.trim().toUpperCase();
    for (final value in contractTypes) {
      if (value.lookupCode.trim().toUpperCase() == normalized) return value;
    }
    return null;
  }

  static Employee? _employeeStub({required int? id, required String? name, required int enterpriseId}) {
    if (id == null || id <= 0) return null;
    final trimmedName = name?.trim() ?? '';
    final parts = trimmedName.split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : 'Employee';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Employee(
      id: id,
      guid: '',
      enterpriseId: enterpriseId,
      firstName: firstName,
      lastName: lastName,
      email: '',
      status: 'ACTIVE',
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  static String? _cleanDetailText(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty || trimmed == '---') return null;
    return trimmed;
  }

  static bool _flagIsYes(String? flag) {
    if (flag == null) return false;
    return flag.trim().toUpperCase() == 'Y';
  }
}
