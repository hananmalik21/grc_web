import 'package:grc/features/workforce_structure/domain/models/employee.dart';

class EmployeeDto {
  final int employeeId;
  final String employeeGuid;
  final int enterpriseId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String email;
  final String? employeeNumber;
  final String? phoneNumber;
  final String? mobileNumber;
  final DateTime? dateOfBirth;
  final String status;
  final String isActive;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? positionTitleEn;
  final String? departmentNameEn;

  const EmployeeDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.enterpriseId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    required this.email,
    this.employeeNumber,
    this.phoneNumber,
    this.mobileNumber,
    this.dateOfBirth,
    required this.status,
    required this.isActive,
    required this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.positionTitleEn,
    this.departmentNameEn,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    String? departmentNameEn;
    final orgList = json['org_structure_list'];
    if (orgList is List) {
      for (final item in orgList) {
        if (item is Map<String, dynamic>) {
          final levelCode = (item['level_code'] as String?) ?? '';
          if (levelCode.toUpperCase() == 'DEPARTMENT') {
            departmentNameEn = item['org_unit_name_en'] as String?;
            break;
          }
        }
      }
    }

    String? positionTitleEn;
    final positionJson = json['position'] as Map<String, dynamic>?;
    if (positionJson != null) {
      positionTitleEn = positionJson['position_title_en'] as String?;
    }

    return EmployeeDto(
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: json['employee_guid'] as String? ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      firstName: (json['first_name_en'] ?? json['first_name']) as String? ?? '',
      middleName: (json['middle_name_en'] ?? json['middle_name']) as String?,
      lastName: (json['last_name_en'] ?? json['last_name']) as String? ?? '',
      firstNameAr: json['first_name_ar'] as String?,
      middleNameAr: json['middle_name_ar'] as String?,
      lastNameAr: json['last_name_ar'] as String?,
      email: json['email'] as String? ?? '',
      employeeNumber: json['employee_number'] as String?,
      phoneNumber: json['phone_number'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      dateOfBirth: json['date_of_birth'] != null ? DateTime.tryParse(json['date_of_birth'] as String) : null,
      status: (json['employee_status'] ?? json['status']) as String? ?? '',
      isActive: (json['employee_is_active'] ?? json['is_active']) as String? ?? 'N',
      createdAt: json['creation_date'] != null
          ? (DateTime.tryParse(json['creation_date'] as String) ?? DateTime.now())
          : (json['created_at'] != null
                ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
                : DateTime.now()),
      createdBy: json['created_by'] as String?,
      updatedAt: json['last_update_date'] != null
          ? DateTime.tryParse(json['last_update_date'] as String)
          : (json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null),
      updatedBy: (json['last_updated_by'] ?? json['updated_by']) as String?,
      positionTitleEn: positionTitleEn,
      departmentNameEn: departmentNameEn,
    );
  }

  Employee toDomain() {
    return Employee(
      id: employeeId,
      guid: employeeGuid,
      enterpriseId: enterpriseId,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      firstNameAr: firstNameAr,
      middleNameAr: middleNameAr,
      lastNameAr: lastNameAr,
      email: email,
      employeeNumber: employeeNumber,
      phoneNumber: phoneNumber,
      mobileNumber: mobileNumber,
      dateOfBirth: dateOfBirth,
      status: status,
      isActive: isActive == 'Y',
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      positionTitle: positionTitleEn,
      departmentName: departmentNameEn,
    );
  }
}
