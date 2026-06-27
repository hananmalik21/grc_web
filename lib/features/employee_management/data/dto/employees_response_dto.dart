import 'package:grc/features/employee_management/domain/models/active_flag_enum.dart';
import 'package:grc/features/employee_management/domain/models/assignment_status_enum.dart';
import 'package:grc/features/employee_management/domain/models/contract_type_code_enum.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/domain/models/employee_status_enum.dart';
import 'package:grc/features/employee_management/domain/models/manage_employees_page_result.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class EmployeesResponseDto {
  final bool success;
  final String? message;
  final PaginationMetaDto meta;
  final List<EmployeeListItemDto> data;

  const EmployeesResponseDto({required this.success, this.message, required this.meta, required this.data});

  factory EmployeesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List<dynamic>? ?? [];
    return EmployeesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: PaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => EmployeeListItemDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  ManageEmployeesPageResult toDomain() {
    return ManageEmployeesPageResult(
      items: data.map((e) => e.toDomain()).toList(),
      pagination: meta.toPaginationInfo(),
    );
  }
}

class PaginationMetaDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationMetaDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationMetaDto.fromJson(Map<String, dynamic> json) {
    return PaginationMetaDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }

  PaginationInfo toPaginationInfo() {
    return PaginationInfo(
      currentPage: page,
      totalPages: totalPages,
      totalItems: total,
      pageSize: pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class OrgStructureItemDto {
  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String? orgUnitNameEn;
  final String? orgUnitNameAr;
  final String levelCode;
  final String? status;
  final String? isActive;

  const OrgStructureItemDto({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    this.orgUnitNameEn,
    this.orgUnitNameAr,
    required this.levelCode,
    this.status,
    this.isActive,
  });

  factory OrgStructureItemDto.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic value) {
      if (value == null || value == 'null') return null;
      if (value is String) return value.trim().isEmpty ? null : value.trim();
      return value.toString().trim();
    }

    return OrgStructureItemDto(
      level: (json['level'] as num?)?.toInt() ?? 0,
      orgUnitId: parseString(json['org_unit_id']) ?? '',
      orgUnitCode: parseString(json['org_unit_code']) ?? '',
      orgUnitNameEn: parseString(json['org_unit_name_en']),
      orgUnitNameAr: parseString(json['org_unit_name_ar']),
      levelCode: parseString(json['level_code']) ?? '',
      status: parseString(json['status']),
      isActive: parseString(json['is_active']),
    );
  }
}

class PositionObjDto {
  final String? positionId;
  final String? positionCode;
  final String? positionTitleEn;
  final String? positionTitleAr;
  final String? status;

  const PositionObjDto({this.positionId, this.positionCode, this.positionTitleEn, this.positionTitleAr, this.status});

  factory PositionObjDto.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic value) {
      if (value == null || value == 'null') return null;
      if (value is String) return value.trim().isEmpty ? null : value.trim();
      return value.toString().trim();
    }

    return PositionObjDto(
      positionId: parseString(json['position_id']),
      positionCode: parseString(json['position_code']),
      positionTitleEn: parseString(json['position_title_en']),
      positionTitleAr: parseString(json['position_title_ar']),
      status: parseString(json['status']),
    );
  }
}

class EmployeeListItemDto {
  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final String? firstNameEn;
  final String? middleNameEn;
  final String? lastNameEn;
  final String? fourthNameEn;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String? fourthNameAr;
  final String? familyNameAr;
  final String? email;
  final String? phoneNumber;
  final String? mobileNumber;
  final String? dateOfBirth;
  final String? employeeStatus;
  final String? employeeIsActive;
  final String? creationDate;
  final String? lastUpdateDate;
  final int? assignmentId;
  final String? assignmentGuid;
  final String? employeeNumber;
  final String? orgUnitId;
  final List<OrgStructureItemDto> orgStructureList;
  final int? workLocationId;
  final String? positionId;
  final PositionObjDto? positionObj;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final String? enterpriseHireDate;
  final String? contractTypeCode;
  final int? probationDays;
  final int? reportingToEmpId;
  final String? employmentStatus;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? assignmentStatus;
  final String? assignmentIsActive;
  final int? rn;

  const EmployeeListItemDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
    this.firstNameEn,
    this.middleNameEn,
    this.lastNameEn,
    this.fourthNameEn,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    this.fourthNameAr,
    this.familyNameAr,
    this.email,
    this.phoneNumber,
    this.mobileNumber,
    this.dateOfBirth,
    this.employeeStatus,
    this.employeeIsActive,
    this.creationDate,
    this.lastUpdateDate,
    this.assignmentId,
    this.assignmentGuid,
    this.employeeNumber,
    this.orgUnitId,
    this.orgStructureList = const [],
    this.workLocationId,
    this.positionId,
    this.positionObj,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.enterpriseHireDate,
    this.contractTypeCode,
    this.probationDays,
    this.reportingToEmpId,
    this.employmentStatus,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.assignmentStatus,
    this.assignmentIsActive,
    this.rn,
  });

  factory EmployeeListItemDto.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic value) {
      if (value == null || value == 'null') return null;
      if (value is String) return value.trim().isEmpty ? null : value.trim();
      return value.toString().trim();
    }

    final orgList = json['org_structure_list'] as List<dynamic>? ?? [];
    final positionObjJson = json['position'] as Map<String, dynamic>?;
    return EmployeeListItemDto(
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: parseString(json['employee_guid']) ?? '',
      firstNameEn: parseString(json['first_name_en']),
      middleNameEn: parseString(json['middle_name_en']),
      lastNameEn: parseString(json['last_name_en']),
      fourthNameEn: parseString(json['fourth_name_en']),
      firstNameAr: parseString(json['first_name_ar']),
      middleNameAr: parseString(json['middle_name_ar']),
      lastNameAr: parseString(json['last_name_ar']),
      fourthNameAr: parseString(json['fourth_name_ar']),
      familyNameAr: parseString(json['family_name_ar']),
      email: parseString(json['email']),
      phoneNumber: parseString(json['phone_number']),
      mobileNumber: parseString(json['mobile_number']),
      dateOfBirth: parseString(json['date_of_birth']),
      employeeStatus: parseString(json['employee_status']),
      employeeIsActive: parseString(json['employee_is_active']),
      creationDate: parseString(json['creation_date']),
      lastUpdateDate: parseString(json['last_update_date']),
      assignmentId: (json['assignment_id'] as num?)?.toInt(),
      assignmentGuid: parseString(json['assignment_guid']),
      employeeNumber: parseString(json['employee_number']),
      orgUnitId: parseString(json['org_unit_id']),
      orgStructureList: orgList.map((e) => OrgStructureItemDto.fromJson(e as Map<String, dynamic>)).toList(),
      workLocationId: (json['work_location_id'] as num?)?.toInt(),
      positionId: parseString(json['position_id']),
      positionObj: positionObjJson != null ? PositionObjDto.fromJson(positionObjJson) : null,
      jobFamilyId: (json['job_family_id'] as num?)?.toInt(),
      jobLevelId: (json['job_level_id'] as num?)?.toInt(),
      gradeId: (json['grade_id'] as num?)?.toInt(),
      enterpriseHireDate: parseString(json['enterprise_hire_date']),
      contractTypeCode: parseString(json['contract_type_code']),
      probationDays: (json['probation_days'] as num?)?.toInt(),
      reportingToEmpId: (json['reporting_to_emp_id'] as num?)?.toInt(),
      employmentStatus: parseString(json['employment_status']),
      effectiveStartDate: parseString(json['effective_start_date']),
      effectiveEndDate: parseString(json['effective_end_date']),
      assignmentStatus: parseString(json['assignment_status']),
      assignmentIsActive: parseString(json['assignment_is_active']),
      rn: (json['rn'] as num?)?.toInt(),
    );
  }

  EmployeeListItem toDomain() {
    final nameParts = [
      firstNameEn,
      middleNameEn,
      lastNameEn,
      fourthNameEn,
    ].whereType<String>().where((s) => s.trim().isNotEmpty);
    final fullName = nameParts.join(' ').trim();
    final status = EmployeeStatus.fromRaw(employeeStatus ?? employmentStatus);
    final department = _departmentFromOrgStructure();
    final position = positionObj?.positionTitleEn?.trim() ?? '';
    return EmployeeListItem(
      id: employeeGuid.isNotEmpty ? employeeGuid : '$employeeId',
      employeeIdNum: employeeId,
      fullName: fullName.isEmpty ? 'Employee $employeeId' : fullName,
      employeeNumber: employeeNumber ?? 'EMP-$employeeId',
      position: position,
      positionId: positionId,
      department: department,
      status: status.raw.isEmpty ? (employeeStatus ?? employmentStatus ?? '') : status.raw,
      employeeStatus: status,
      email: email,
      phone: phoneNumber ?? mobileNumber,
      assignmentId: assignmentId,
      assignmentGuid: assignmentGuid,
      orgUnitId: orgUnitId,
      contractTypeCode: ContractTypeCode.fromRaw(contractTypeCode),
      employmentStatus: AssignmentStatus.fromRaw(employmentStatus ?? employeeStatus),
      employeeIsActive: ActiveFlag.fromRaw(employeeIsActive),
    );
  }

  String _departmentFromOrgStructure() {
    const departmentLevel = 'DEPARTMENT';
    for (final item in orgStructureList) {
      if (item.levelCode == departmentLevel && (item.orgUnitNameEn?.trim().isNotEmpty ?? false)) {
        return item.orgUnitNameEn!.trim();
      }
    }
    if (orgStructureList.isNotEmpty) {
      final last = orgStructureList.last;
      return last.orgUnitNameEn?.trim() ?? '';
    }
    return '';
  }
}
