import 'package:grc/features/compensation/domain/models/employees/employee_list_item.dart';

class EmployeeOrgUnitDto {
  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String levelCode;
  final String status;

  const EmployeeOrgUnitDto({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.levelCode,
    required this.status,
  });

  factory EmployeeOrgUnitDto.fromJson(Map<String, dynamic> json) {
    return EmployeeOrgUnitDto(
      level: (json['level'] as num?)?.toInt() ?? 0,
      orgUnitId: (json['org_unit_id'] as String?) ?? '',
      orgUnitCode: (json['org_unit_code'] as String?) ?? '',
      orgUnitNameEn: (json['org_unit_name_en'] as String?) ?? '',
      levelCode: (json['level_code'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
    );
  }

  EmployeeOrgUnit toDomain() {
    return EmployeeOrgUnit(
      level: level,
      orgUnitId: orgUnitId,
      orgUnitCode: orgUnitCode,
      orgUnitNameEn: orgUnitNameEn,
      levelCode: levelCode,
      status: status,
    );
  }
}

class EmployeePositionDto {
  final String positionId;
  final String positionCode;
  final String status;
  final String positionTitleEn;

  const EmployeePositionDto({
    required this.positionId,
    required this.positionCode,
    required this.status,
    required this.positionTitleEn,
  });

  factory EmployeePositionDto.fromJson(Map<String, dynamic> json) {
    return EmployeePositionDto(
      positionId: (json['position_id'] as String?) ?? '',
      positionCode: (json['position_code'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      positionTitleEn: (json['position_title_en'] as String?) ?? '',
    );
  }

  EmployeePosition toDomain() {
    return EmployeePosition(
      positionId: positionId,
      positionCode: positionCode,
      status: status,
      positionTitleEn: positionTitleEn,
    );
  }
}

class EmployeeDto {
  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final String firstNameEn;
  final String? middleNameEn;
  final String lastNameEn;
  final String? email;
  final String employeeNumber;
  final String? employmentStatus;
  final String? assignmentStatus;
  final String? contractTypeCode;
  final List<EmployeeOrgUnitDto> orgStructureList;
  final EmployeePositionDto? position;

  const EmployeeDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
    required this.firstNameEn,
    this.middleNameEn,
    required this.lastNameEn,
    this.email,
    required this.employeeNumber,
    this.employmentStatus,
    this.assignmentStatus,
    this.contractTypeCode,
    required this.orgStructureList,
    this.position,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    final orgList = (json['org_structure_list'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(EmployeeOrgUnitDto.fromJson)
        .toList();

    final positionJson = json['position'];
    final position = positionJson is Map<String, dynamic> ? EmployeePositionDto.fromJson(positionJson) : null;

    return EmployeeDto(
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: (json['employee_guid'] as String?) ?? '',
      firstNameEn: (json['first_name_en'] as String?) ?? '',
      middleNameEn: json['middle_name_en'] as String?,
      lastNameEn: (json['last_name_en'] as String?) ?? '',
      email: json['email'] as String?,
      employeeNumber: (json['employee_number'] as String?) ?? '',
      employmentStatus: json['employment_status'] as String?,
      assignmentStatus: json['assignment_status'] as String?,
      contractTypeCode: json['contract_type_code'] as String?,
      orgStructureList: orgList,
      position: position,
    );
  }

  EmployeeListItem toDomain() {
    return EmployeeListItem(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      firstNameEn: firstNameEn,
      middleNameEn: middleNameEn,
      lastNameEn: lastNameEn,
      email: email,
      employeeNumber: employeeNumber,
      employmentStatus: employmentStatus,
      assignmentStatus: assignmentStatus,
      contractTypeCode: contractTypeCode,
      orgStructureList: orgStructureList.map((e) => e.toDomain()).toList(),
      position: position?.toDomain(),
    );
  }
}
