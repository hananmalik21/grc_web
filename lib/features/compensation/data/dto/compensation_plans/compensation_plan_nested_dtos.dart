import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';

class PlanOwnerDto {
  final int employeeId;
  final String employeeGuid;
  final int enterpriseId;
  final String firstNameEn;
  final String lastNameEn;
  final String fullNameEn;
  final String? email;
  final String? phone;
  final String? status;

  const PlanOwnerDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.enterpriseId,
    required this.firstNameEn,
    required this.lastNameEn,
    required this.fullNameEn,
    this.email,
    this.phone,
    this.status,
  });

  factory PlanOwnerDto.fromJson(Map<String, dynamic> json) {
    return PlanOwnerDto(
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: (json['employee_guid'] as String?) ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      firstNameEn: (json['first_name_en'] as String?) ?? '',
      lastNameEn: (json['last_name_en'] as String?) ?? '',
      fullNameEn: (json['full_name_en'] as String?) ?? '',
      email: json['email'] as String?,
      phone: json['phone_number'] as String?,
      status: json['status'] as String?,
    );
  }

  PlanOwner toDomain() {
    return PlanOwner(
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      enterpriseId: enterpriseId,
      firstNameEn: firstNameEn,
      lastNameEn: lastNameEn,
      fullNameEn: fullNameEn,
      email: email,
      phone: phone,
      status: status,
    );
  }
}

class PlanAttributeDto {
  final int attributeId;
  final String attributeGuid;
  final String attributeCode;
  final String attributeValue;
  final String activeFlag;

  const PlanAttributeDto({
    required this.attributeId,
    required this.attributeGuid,
    required this.attributeCode,
    required this.attributeValue,
    required this.activeFlag,
  });

  factory PlanAttributeDto.fromJson(Map<String, dynamic> json) {
    return PlanAttributeDto(
      attributeId: (json['plan_attribute_id'] as num?)?.toInt() ?? 0,
      attributeGuid: (json['plan_attribute_guid'] as String?) ?? '',
      attributeCode: (json['attribute_code'] as String?) ?? '',
      attributeValue: (json['attribute_value'] as String?) ?? '',
      activeFlag: (json['active_flag'] as String?) ?? 'N',
    );
  }

  PlanAttribute toDomain() {
    return PlanAttribute(
      attributeId: attributeId,
      attributeGuid: attributeGuid,
      attributeCode: attributeCode,
      attributeValue: attributeValue,
      activeFlag: activeFlag,
    );
  }
}

class PlanBudgetDto {
  final int budgetId;
  final double budgetAmount;
  final String currencyCode;

  const PlanBudgetDto({required this.budgetId, required this.budgetAmount, required this.currencyCode});

  factory PlanBudgetDto.fromJson(Map<String, dynamic> json) {
    return PlanBudgetDto(
      budgetId: (json['plan_budget_id'] as num?)?.toInt() ?? 0,
      budgetAmount: (json['budget_amount'] as num?)?.toDouble() ?? 0.0,
      currencyCode: (json['currency_code'] as String?) ?? 'KWD',
    );
  }

  PlanBudget toDomain() {
    return PlanBudget(budgetId: budgetId, budgetAmount: budgetAmount, currencyCode: currencyCode);
  }
}

class PlanBusinessUnitDto {
  final int id;
  final String guid;
  final String orgUnitId;
  final OrgUnitObjDto? orgUnit;

  const PlanBusinessUnitDto({required this.id, required this.guid, required this.orgUnitId, this.orgUnit});

  factory PlanBusinessUnitDto.fromJson(Map<String, dynamic> json) {
    return PlanBusinessUnitDto(
      id: (json['plan_business_unit_id'] as num?)?.toInt() ?? 0,
      guid: (json['plan_business_unit_guid'] as String?) ?? '',
      orgUnitId: (json['org_unit_id'] as String?) ?? '',
      orgUnit: json['org_unit_obj'] != null
          ? OrgUnitObjDto.fromJson(json['org_unit_obj'] as Map<String, dynamic>)
          : null,
    );
  }

  PlanBusinessUnit toDomain() {
    return PlanBusinessUnit(id: id, guid: guid, orgUnitId: orgUnitId, orgUnit: orgUnit?.toDomain());
  }
}

class OrgUnitObjDto {
  final String id;
  final String code;
  final String nameEn;
  final String nameAr;
  final String levelCode;
  final String? parentOrgUnitId;

  const OrgUnitObjDto({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.levelCode,
    this.parentOrgUnitId,
  });

  factory OrgUnitObjDto.fromJson(Map<String, dynamic> json) {
    return OrgUnitObjDto(
      id: (json['org_unit_id'] as String?) ?? '',
      code: (json['org_unit_code'] as String?) ?? '',
      nameEn: (json['org_unit_name_en'] as String?) ?? '',
      nameAr: (json['org_unit_name_ar'] as String?) ?? '',
      levelCode: (json['level_code'] as String?) ?? '',
      parentOrgUnitId: json['parent_org_unit_id'] as String?,
    );
  }

  OrgUnitObj toDomain() {
    return OrgUnitObj(
      id: id,
      code: code,
      nameEn: nameEn,
      nameAr: nameAr,
      levelCode: levelCode,
      parentOrgUnitId: parentOrgUnitId,
    );
  }
}

class PlanComponentAdvancedSettingsDto {
  final bool prorated;
  final bool taxable;
  final bool pensionable;
  final bool statutory;
  final bool includeInCtc;
  final bool optional;
  final bool amortizable;
  final bool recurring;
  final bool isActive;
  final String? payBasis;

  const PlanComponentAdvancedSettingsDto({
    required this.prorated,
    required this.taxable,
    required this.pensionable,
    required this.statutory,
    required this.includeInCtc,
    required this.optional,
    required this.amortizable,
    required this.recurring,
    required this.isActive,
    this.payBasis,
  });

  factory PlanComponentAdvancedSettingsDto.fromJson(Map<String, dynamic> json) {
    bool flag(String key) => (json[key] as String?)?.trim().toUpperCase() == 'Y';
    return PlanComponentAdvancedSettingsDto(
      prorated: flag('prorated_flag'),
      taxable: flag('taxable_flag'),
      pensionable: flag('pensionable_flag'),
      statutory: flag('statutory_flag'),
      includeInCtc: flag('include_in_ctc_flag'),
      optional: flag('optional_flag'),
      amortizable: flag('amortizable_flag'),
      recurring: flag('recurring_flag'),
      isActive: flag('active_flag'),
      payBasis: json['pay_basis'] as String?,
    );
  }

  PlanComponentAdvancedSettings toDomain() => PlanComponentAdvancedSettings(
    prorated: prorated,
    taxable: taxable,
    pensionable: pensionable,
    statutory: statutory,
    includeInCtc: includeInCtc,
    optional: optional,
    amortizable: amortizable,
    recurring: recurring,
    isActive: isActive,
    payBasis: payBasis,
  );
}

class PlanComponentDto {
  final int id;
  final int componentId;
  final int displaySequence;
  final String mandatoryFlag;
  final String? frequencyCode;
  final String? activeFlag;
  final ComponentObjDto? component;
  final PlanComponentAdvancedSettingsDto? advancedSettings;

  const PlanComponentDto({
    required this.id,
    required this.componentId,
    required this.displaySequence,
    required this.mandatoryFlag,
    this.frequencyCode,
    this.activeFlag,
    this.component,
    this.advancedSettings,
  });

  factory PlanComponentDto.fromJson(Map<String, dynamic> json) {
    return PlanComponentDto(
      id: (json['plan_component_id'] as num?)?.toInt() ?? (json['component_id'] as num?)?.toInt() ?? 0,
      componentId: (json['component_id'] as num?)?.toInt() ?? 0,
      displaySequence: (json['display_sequence'] as num?)?.toInt() ?? 0,
      mandatoryFlag: (json['mandatory_flag'] as String?) ?? 'N',
      frequencyCode: json['frequency_code'] as String?,
      activeFlag: json['active_flag'] as String?,
      component: json['component_obj'] != null
          ? ComponentObjDto.fromJson(json['component_obj'] as Map<String, dynamic>)
          : (json['component_guid'] != null || json['component_code'] != null ? ComponentObjDto.fromJson(json) : null),
      advancedSettings: json['plan_component_advanced_settings'] != null
          ? PlanComponentAdvancedSettingsDto.fromJson(json['plan_component_advanced_settings'] as Map<String, dynamic>)
          : null,
    );
  }

  PlanComponent toDomain() {
    return PlanComponent(
      id: id,
      componentId: componentId,
      displaySequence: displaySequence,
      mandatoryFlag: mandatoryFlag,
      frequencyCode: frequencyCode,
      activeFlag: activeFlag,
      component: component?.toDomain(),
      advancedSettings: advancedSettings?.toDomain(),
    );
  }
}

class ComponentObjDto {
  final int id;
  final String guid;
  final String code;
  final String name;
  final String typeCode;
  final String calculationMethod;
  final String status;
  final String categoryCode;
  final String? description;
  final double? minValue;
  final double? maxValue;
  final String? currencyCode;

  const ComponentObjDto({
    required this.id,
    required this.guid,
    required this.code,
    required this.name,
    required this.typeCode,
    required this.calculationMethod,
    required this.status,
    required this.categoryCode,
    this.description,
    this.minValue,
    this.maxValue,
    this.currencyCode,
  });

  factory ComponentObjDto.fromJson(Map<String, dynamic> json) {
    return ComponentObjDto(
      id: (json['component_id'] as num?)?.toInt() ?? 0,
      guid: (json['component_guid'] as String?) ?? '',
      code: (json['component_code'] as String?) ?? '',
      name: (json['component_name'] as String?) ?? '',
      typeCode: (json['component_type_code'] as String?) ?? '',
      calculationMethod: (json['calculation_method_code'] as String?) ?? '',
      status: (json['status_code'] as String?) ?? 'ACTIVE',
      categoryCode: (json['component_category_code'] as String?) ?? (json['comp_category_code'] as String?) ?? '',
      description: json['description'] as String?,
      minValue: (json['min_value'] as num?)?.toDouble(),
      maxValue: (json['max_value'] as num?)?.toDouble(),
      currencyCode: json['currency_code'] as String?,
    );
  }

  ComponentObj toDomain() {
    return ComponentObj(
      id: id,
      guid: guid,
      code: code,
      name: name,
      typeCode: typeCode,
      calculationMethod: calculationMethod,
      status: status,
      categoryCode: categoryCode,
      description: description,
      minValue: minValue,
      maxValue: maxValue,
      currencyCode: currencyCode,
    );
  }
}

class PlanEmploymentTypeDto {
  final int id;
  final String guid;
  final String typeCode;

  const PlanEmploymentTypeDto({required this.id, required this.guid, required this.typeCode});

  factory PlanEmploymentTypeDto.fromJson(Map<String, dynamic> json) {
    return PlanEmploymentTypeDto(
      id: (json['plan_employment_type_id'] as num?)?.toInt() ?? 0,
      guid: (json['plan_employment_type_guid'] as String?) ?? '',
      typeCode: (json['employment_type_code'] as String?) ?? '',
    );
  }

  PlanEmploymentType toDomain() {
    return PlanEmploymentType(id: id, guid: guid, typeCode: typeCode);
  }
}

class PlanGradeDto {
  final int id;
  final int gradeId;
  final GradeObjDto? grade;

  const PlanGradeDto({required this.id, required this.gradeId, this.grade});

  factory PlanGradeDto.fromJson(Map<String, dynamic> json) {
    return PlanGradeDto(
      id: (json['plan_grade_id'] as num?)?.toInt() ?? 0,
      gradeId: (json['grade_id'] as num?)?.toInt() ?? 0,
      grade: json['grade_obj'] != null ? GradeObjDto.fromJson(json['grade_obj'] as Map<String, dynamic>) : null,
    );
  }

  PlanGrade toDomain() {
    return PlanGrade(id: id, gradeId: gradeId, grade: grade?.toDomain());
  }
}

class GradeObjDto {
  final int id;
  final String number;
  final String category;
  final String currencyCode;
  final double? step1Salary;
  final double? step2Salary;
  final double? step3Salary;
  final double? step4Salary;
  final double? step5Salary;

  const GradeObjDto({
    required this.id,
    required this.number,
    required this.category,
    required this.currencyCode,
    this.step1Salary,
    this.step2Salary,
    this.step3Salary,
    this.step4Salary,
    this.step5Salary,
  });

  factory GradeObjDto.fromJson(Map<String, dynamic> json) {
    return GradeObjDto(
      id: (json['grade_id'] as num?)?.toInt() ?? 0,
      number: (json['grade_number'] as String?) ?? '',
      category: (json['grade_category'] as String?) ?? '',
      currencyCode: (json['currency_code'] as String?) ?? '',
      step1Salary: (json['step_1_salary'] as num?)?.toDouble(),
      step2Salary: (json['step_2_salary'] as num?)?.toDouble(),
      step3Salary: (json['step_3_salary'] as num?)?.toDouble(),
      step4Salary: (json['step_4_salary'] as num?)?.toDouble(),
      step5Salary: (json['step_5_salary'] as num?)?.toDouble(),
    );
  }

  GradeObj toDomain() {
    return GradeObj(
      id: id,
      number: number,
      category: category,
      currencyCode: currencyCode,
      step1Salary: step1Salary,
      step2Salary: step2Salary,
      step3Salary: step3Salary,
      step4Salary: step4Salary,
      step5Salary: step5Salary,
    );
  }
}

class PlanJobFamilyDto {
  final int id;
  final String guid;
  final int jobFamilyId;
  final JobFamilyObjDto? jobFamily;

  const PlanJobFamilyDto({required this.id, required this.guid, required this.jobFamilyId, this.jobFamily});

  factory PlanJobFamilyDto.fromJson(Map<String, dynamic> json) {
    return PlanJobFamilyDto(
      id: (json['plan_job_family_id'] as num?)?.toInt() ?? 0,
      guid: (json['plan_job_family_guid'] as String?) ?? '',
      jobFamilyId: (json['job_family_id'] as num?)?.toInt() ?? 0,
      jobFamily: json['job_family_obj'] != null
          ? JobFamilyObjDto.fromJson(json['job_family_obj'] as Map<String, dynamic>)
          : null,
    );
  }

  PlanJobFamily toDomain() {
    return PlanJobFamily(id: id, guid: guid, jobFamilyId: jobFamilyId, jobFamily: jobFamily?.toDomain());
  }
}

class JobFamilyObjDto {
  final int id;
  final String code;
  final String nameEn;
  final String nameAr;

  const JobFamilyObjDto({required this.id, required this.code, required this.nameEn, required this.nameAr});

  factory JobFamilyObjDto.fromJson(Map<String, dynamic> json) {
    return JobFamilyObjDto(
      id: (json['job_family_id'] as num?)?.toInt() ?? 0,
      code: (json['job_family_code'] as String?) ?? '',
      nameEn: (json['job_family_name_en'] as String?) ?? '',
      nameAr: (json['job_family_name_ar'] as String?) ?? '',
    );
  }

  JobFamilyObj toDomain() {
    return JobFamilyObj(id: id, code: code, nameEn: nameEn, nameAr: nameAr);
  }
}

class PlanLocationDto {
  final int id;
  final String guid;
  final int countryId;
  final LocationObjDto? location;

  const PlanLocationDto({required this.id, required this.guid, required this.countryId, this.location});

  factory PlanLocationDto.fromJson(Map<String, dynamic> json) {
    return PlanLocationDto(
      id: (json['plan_location_id'] as num?)?.toInt() ?? 0,
      guid: (json['plan_location_guid'] as String?) ?? '',
      countryId: (json['country_id'] as num?)?.toInt() ?? 0,
      location: json['location_obj'] != null
          ? LocationObjDto.fromJson(json['location_obj'] as Map<String, dynamic>)
          : (json['country_obj'] != null ? LocationObjDto.fromJson(json['country_obj'] as Map<String, dynamic>) : null),
    );
  }

  PlanLocation toDomain() {
    return PlanLocation(id: id, guid: guid, countryId: countryId, location: location?.toDomain());
  }
}

class LocationObjDto {
  final String name;
  final String type;

  const LocationObjDto({required this.name, required this.type});

  factory LocationObjDto.fromJson(Map<String, dynamic> json) {
    final name =
        (json['country_name'] as String?) ??
        (json['location_name'] as String?) ??
        (json['name_en'] as String?) ??
        (json['name'] as String?) ??
        '';

    final type = (json['region_type'] as String?) ?? (json['type_code'] as String?) ?? (json['type'] as String?) ?? '';

    return LocationObjDto(name: name, type: type);
  }

  LocationObj toDomain() {
    return LocationObj(name: name, type: type);
  }
}

class PlanPositionDto {
  final int id;
  final String positionId;
  final PositionObjDto? position;

  const PlanPositionDto({required this.id, required this.positionId, this.position});

  factory PlanPositionDto.fromJson(Map<String, dynamic> json) {
    return PlanPositionDto(
      id: (json['plan_position_id'] as num?)?.toInt() ?? 0,
      positionId: (json['position_id'] as String?) ?? '',
      position: json['position_obj'] != null
          ? PositionObjDto.fromJson(json['position_obj'] as Map<String, dynamic>)
          : null,
    );
  }

  PlanPosition toDomain() {
    return PlanPosition(id: id, positionId: positionId, position: position?.toDomain());
  }
}

class PositionObjDto {
  final String id;
  final String code;
  final String titleEn;
  final String titleAr;
  final double? salaryAmount;

  const PositionObjDto({
    required this.id,
    required this.code,
    required this.titleEn,
    required this.titleAr,
    this.salaryAmount,
  });

  factory PositionObjDto.fromJson(Map<String, dynamic> json) {
    return PositionObjDto(
      id: (json['position_id'] as String?) ?? '',
      code: (json['position_code'] as String?) ?? '',
      titleEn: (json['position_title_en'] as String?) ?? '',
      titleAr: (json['position_title_ar'] as String?) ?? '',
      salaryAmount: (json['salary_amount'] as num?)?.toDouble(),
    );
  }

  PositionObj toDomain() {
    return PositionObj(id: id, code: code, titleEn: titleEn, titleAr: titleAr, salaryAmount: salaryAmount);
  }
}

class PlanSalaryStructureDto {
  final int id;
  final String guid;
  final int structureId;
  final SalaryStructureObjDto? structure;

  const PlanSalaryStructureDto({required this.id, required this.guid, required this.structureId, this.structure});

  factory PlanSalaryStructureDto.fromJson(Map<String, dynamic> json) {
    return PlanSalaryStructureDto(
      id: (json['plan_salary_structure_id'] as num?)?.toInt() ?? 0,
      guid: (json['plan_salary_structure_guid'] as String?) ?? '',
      structureId: (json['structure_id'] as num?)?.toInt() ?? 0,
      structure: json['salary_structure_obj'] != null
          ? SalaryStructureObjDto.fromJson(json['salary_structure_obj'] as Map<String, dynamic>)
          : null,
    );
  }

  PlanSalaryStructure toDomain() {
    return PlanSalaryStructure(id: id, guid: guid, structureId: structureId, structure: structure?.toDomain());
  }
}

class SalaryStructureObjDto {
  final int id;
  final String guid;
  final String code;
  final String name;
  final String currencyCode;
  final String structureTypeCode;

  const SalaryStructureObjDto({
    required this.id,
    required this.guid,
    required this.code,
    required this.name,
    required this.currencyCode,
    required this.structureTypeCode,
  });

  factory SalaryStructureObjDto.fromJson(Map<String, dynamic> json) {
    return SalaryStructureObjDto(
      id: (json['structure_id'] as num?)?.toInt() ?? 0,
      guid: (json['structure_guid'] as String?) ?? '',
      code: (json['structure_code'] as String?) ?? '',
      name: (json['structure_name'] as String?) ?? '',
      currencyCode: (json['currency_code'] as String?) ?? '',
      structureTypeCode: (json['structure_type_code'] as String?) ?? '',
    );
  }

  SalaryStructureObj toDomain() {
    return SalaryStructureObj(
      id: id,
      guid: guid,
      code: code,
      name: name,
      currencyCode: currencyCode,
      structureTypeCode: structureTypeCode,
    );
  }
}
