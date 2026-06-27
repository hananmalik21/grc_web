import 'package:grc/features/compensation/domain/models/employees/employee_compensation_list_item.dart';

class EmployeeCompensationOrgUnitDto {
  const EmployeeCompensationOrgUnitDto({required this.levelCode, required this.orgUnitNameEn});

  final String levelCode;
  final String orgUnitNameEn;

  factory EmployeeCompensationOrgUnitDto.fromJson(Map<String, dynamic> json) {
    return EmployeeCompensationOrgUnitDto(
      levelCode: (json['level_code'] as String?) ?? '',
      orgUnitNameEn: (json['org_unit_name_en'] as String?) ?? '',
    );
  }

  EmployeeCompensationOrgUnit toDomain() {
    return EmployeeCompensationOrgUnit(levelCode: levelCode, orgUnitNameEn: orgUnitNameEn);
  }
}

class EmployeeCompensationListItemDto {
  const EmployeeCompensationListItemDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeNumber,
    required this.employeeName,
    required this.employeeGuid,
    required this.positionName,
    required this.gradeNumber,
    required this.gradeCategory,
    required this.planId,
    required this.planGuid,
    required this.planCode,
    required this.planName,
    required this.statusCode,
    required this.structureId,
    required this.structureCode,
    required this.structureName,
    required this.totalCompensation,
    required this.totalRetroAmount,
    required this.totalBaseSalary,
    required this.totalAllowance,
    required this.totalBenefits,
    required this.orgStructureList,
  });

  final int enterpriseId;
  final int employeeId;
  final String employeeNumber;
  final String employeeName;
  final String employeeGuid;
  final String positionName;
  final String gradeNumber;
  final String gradeCategory;
  final int planId;
  final String planGuid;
  final String planCode;
  final String planName;
  final String statusCode;
  final int structureId;
  final String structureCode;
  final String structureName;
  final double totalCompensation;
  final double totalRetroAmount;
  final double totalBaseSalary;
  final double totalAllowance;
  final double totalBenefits;
  final List<EmployeeCompensationOrgUnitDto> orgStructureList;

  factory EmployeeCompensationListItemDto.fromJson(Map<String, dynamic> json) {
    final orgList = (json['org_structure_list'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(EmployeeCompensationOrgUnitDto.fromJson)
        .toList();

    return EmployeeCompensationListItemDto(
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeNumber: (json['employee_number'] as String?) ?? '',
      employeeName: (json['employee_name'] as String?) ?? '',
      employeeGuid: (json['employee_guid'] as String?) ?? '',
      positionName: (json['position_name'] as String?) ?? '',
      gradeNumber: (json['grade_number'] as String?) ?? '',
      gradeCategory: (json['grade_category'] as String?) ?? '',
      planId: (json['plan_id'] as num?)?.toInt() ?? 0,
      planGuid: (json['plan_guid'] as String?) ?? '',
      planCode: (json['plan_code'] as String?) ?? '',
      planName: (json['plan_name'] as String?) ?? '',
      statusCode: (json['status_code'] as String?) ?? '',
      structureId: (json['structure_id'] as num?)?.toInt() ?? 0,
      structureCode: (json['structure_code'] as String?) ?? '',
      structureName: (json['structure_name'] as String?) ?? '',
      totalCompensation: (json['total_compensation'] as num?)?.toDouble() ?? 0,
      totalRetroAmount: (json['total_retro_amount'] as num?)?.toDouble() ?? 0,
      totalBaseSalary: (json['total_base_salary'] as num?)?.toDouble() ?? 0,
      totalAllowance: (json['total_allowance'] as num?)?.toDouble() ?? 0,
      totalBenefits: (json['total_benefits'] as num?)?.toDouble() ?? 0,
      orgStructureList: orgList,
    );
  }

  EmployeeCompensationListItem toDomain() {
    return EmployeeCompensationListItem(
      enterpriseId: enterpriseId,
      employeeName: employeeName,
      employeeId: employeeNumber,
      employeeGuid: employeeGuid,
      planGuid: planGuid,
      positionName: positionName,
      gradeNumber: gradeNumber,
      gradeCategory: gradeCategory,
      planCode: planCode,
      planName: planName,
      structureCode: structureCode,
      structureName: structureName,
      totalCompensation: totalCompensation,
      totalRetroAmount: totalRetroAmount,
      totalBaseSalary: totalBaseSalary,
      totalAllowance: totalAllowance,
      totalBenefits: totalBenefits,
      statusCode: statusCode,
      orgStructureList: orgStructureList.map((e) => e.toDomain()).toList(),
    );
  }
}

class EmployeeCompensationListDto {
  const EmployeeCompensationListDto({
    required this.items,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<EmployeeCompensationListItemDto> items;
  final int page;
  final int limit;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;

  factory EmployeeCompensationListDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(EmployeeCompensationListItemDto.fromJson)
        .toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    final pagination = meta['pagination'] as Map<String, dynamic>? ?? const {};

    return EmployeeCompensationListDto(
      items: data,
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      limit: (pagination['limit'] as num?)?.toInt() ?? 10,
      totalPages: (pagination['totalPages'] as num?)?.toInt() ?? (pagination['total_pages'] as num?)?.toInt() ?? 1,
      totalItems: (pagination['total'] as num?)?.toInt() ?? data.length,
      hasNext: (pagination['hasNext'] as bool?) ?? (pagination['has_next'] as bool?) ?? false,
      hasPrevious: (pagination['hasPrev'] as bool?) ?? (pagination['has_prev'] as bool?) ?? false,
    );
  }
}
