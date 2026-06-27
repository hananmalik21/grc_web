import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';

class EmployeeCompensationOrgUnitDto {
  const EmployeeCompensationOrgUnitDto({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    required this.levelCode,
    required this.status,
    required this.isActive,
  });

  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String levelCode;
  final String status;
  final String isActive;

  factory EmployeeCompensationOrgUnitDto.fromJson(Map<String, dynamic> json) {
    return EmployeeCompensationOrgUnitDto(
      level: (json['level'] as num?)?.toInt() ?? 0,
      orgUnitId: (json['org_unit_id'] as String?) ?? '',
      orgUnitCode: (json['org_unit_code'] as String?) ?? '',
      orgUnitNameEn: (json['org_unit_name_en'] as String?) ?? '',
      orgUnitNameAr: (json['org_unit_name_ar'] as String?) ?? '',
      levelCode: (json['level_code'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      isActive: (json['is_active'] as String?) ?? '',
    );
  }

  EmployeeCompensationOrgUnit toDomain() {
    return EmployeeCompensationOrgUnit(
      level: level,
      orgUnitId: orgUnitId,
      orgUnitCode: orgUnitCode,
      orgUnitNameEn: orgUnitNameEn,
      orgUnitNameAr: orgUnitNameAr,
      levelCode: levelCode,
      status: status,
      isActive: isActive,
    );
  }
}

class EmployeeCompensationComponentDto {
  const EmployeeCompensationComponentDto({
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.componentTypeCode,
    required this.compCategoryCode,
    required this.amount,
    required this.currencyCode,
  });

  final int componentId;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String compCategoryCode;
  final double amount;
  final String currencyCode;

  factory EmployeeCompensationComponentDto.fromJson(Map<String, dynamic> json) {
    return EmployeeCompensationComponentDto(
      componentId: (json['component_id'] as num?)?.toInt() ?? 0,
      componentCode: (json['component_code'] as String?) ?? '',
      componentName: (json['component_name'] as String?) ?? '',
      componentTypeCode: (json['component_type_code'] as String?) ?? '',
      compCategoryCode: (json['comp_category_code'] as String?) ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currencyCode: (json['currency_code'] as String?) ?? '',
    );
  }

  EmployeeCompensationComponent toDomain() {
    return EmployeeCompensationComponent(
      componentId: componentId,
      componentCode: componentCode,
      componentName: componentName,
      componentTypeCode: componentTypeCode,
      compCategoryCode: compCategoryCode,
      amount: amount,
      currencyCode: currencyCode,
    );
  }
}

class EmployeeCompensationPlanDetailsDto {
  const EmployeeCompensationPlanDetailsDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeName,
    required this.employeeNumber,
    required this.contractTypeCode,
    required this.enterpriseHireDate,
    required this.positionId,
    required this.positionName,
    required this.gradeId,
    required this.gradeNumber,
    required this.gradeCategory,
    required this.planTypeCode,
    required this.planId,
    required this.planGuid,
    required this.planCode,
    required this.planName,
    required this.structureId,
    required this.structureGuid,
    required this.structureCode,
    required this.structureName,
    required this.structureCurrencyCode,
    required this.structureEffectiveFrom,
    required this.structureEffectiveTo,
    required this.orgStructureList,
    required this.components,
  });

  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final String employeeName;
  final String employeeNumber;
  final String contractTypeCode;
  final String enterpriseHireDate;
  final String positionId;
  final String positionName;
  final int gradeId;
  final String gradeNumber;
  final String gradeCategory;
  final String planTypeCode;
  final int planId;
  final String planGuid;
  final String planCode;
  final String planName;
  final int structureId;
  final String structureGuid;
  final String structureCode;
  final String structureName;
  final String structureCurrencyCode;
  final String structureEffectiveFrom;
  final String structureEffectiveTo;
  final List<EmployeeCompensationOrgUnitDto> orgStructureList;
  final List<EmployeeCompensationComponentDto> components;

  factory EmployeeCompensationPlanDetailsDto.fromJson(Map<String, dynamic> json) {
    final orgList = (json['org_structure_list'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(EmployeeCompensationOrgUnitDto.fromJson)
        .toList();

    final componentsList = (json['components_json'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(EmployeeCompensationComponentDto.fromJson)
        .toList();

    return EmployeeCompensationPlanDetailsDto(
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: (json['employee_guid'] as String?) ?? '',
      employeeName: (json['employee_name'] as String?) ?? '',
      employeeNumber: (json['employee_number'] as String?) ?? '',
      contractTypeCode: (json['contract_type_code'] as String?) ?? '',
      enterpriseHireDate: (json['enterprise_hire_date'] as String?) ?? '',
      positionId: (json['position_id'] as String?) ?? '',
      positionName: (json['position_name'] as String?) ?? '',
      gradeId: (json['grade_id'] as num?)?.toInt() ?? 0,
      gradeNumber: (json['grade_number'] as String?) ?? '',
      gradeCategory: (json['grade_category'] as String?) ?? '',
      planTypeCode: (json['plan_type_code'] as String?) ?? '',
      planId: (json['plan_id'] as num?)?.toInt() ?? 0,
      planGuid: (json['plan_guid'] as String?) ?? '',
      planCode: (json['plan_code'] as String?) ?? '',
      planName: (json['plan_name'] as String?) ?? '',
      structureId: (json['structure_id'] as num?)?.toInt() ?? 0,
      structureGuid: (json['structure_guid'] as String?) ?? '',
      structureCode: (json['structure_code'] as String?) ?? '',
      structureName: (json['structure_name'] as String?) ?? '',
      structureCurrencyCode: (json['structure_currency_code'] as String?) ?? '',
      structureEffectiveFrom: (json['structure_effective_from'] as String?) ?? '',
      structureEffectiveTo: (json['structure_effective_to'] as String?) ?? '',
      orgStructureList: orgList,
      components: componentsList,
    );
  }

  EmployeeCompensationPlanDetails toDomain() {
    return EmployeeCompensationPlanDetails(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      employeeName: employeeName,
      employeeNumber: employeeNumber,
      contractTypeCode: contractTypeCode,
      enterpriseHireDate: enterpriseHireDate,
      positionId: positionId,
      positionName: positionName,
      gradeId: gradeId,
      gradeNumber: gradeNumber,
      gradeCategory: gradeCategory,
      planTypeCode: planTypeCode,
      planId: planId,
      planGuid: planGuid,
      planCode: planCode,
      planName: planName,
      structureId: structureId,
      structureGuid: structureGuid,
      structureCode: structureCode,
      structureName: structureName,
      structureCurrencyCode: structureCurrencyCode,
      structureEffectiveFrom: structureEffectiveFrom,
      structureEffectiveTo: structureEffectiveTo,
      orgStructureList: orgStructureList.map((e) => e.toDomain()).toList(),
      components: components.map((e) => e.toDomain()).toList(),
    );
  }
}
