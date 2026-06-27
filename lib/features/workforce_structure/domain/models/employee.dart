import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';

class Employee {
  final int id;
  final String guid;
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
  final bool isActive;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? positionTitle;
  final String? departmentName;

  const Employee({
    required this.id,
    required this.guid,
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
    this.positionTitle,
    this.departmentName,
  });

  factory Employee.fromFullDetails(EmployeeFullDetails details) {
    final emp = details.employee;
    final asg = details.assignment;
    final createdAt = DateTime.tryParse(emp.creationDate?.trim() ?? '') ?? DateTime.now();

    return Employee(
      id: emp.employeeId,
      guid: emp.employeeGuid,
      enterpriseId: emp.enterpriseId,
      firstName: emp.firstNameEn?.trim() ?? '',
      middleName: emp.middleNameEn?.trim(),
      lastName: emp.lastNameEn?.trim() ?? '',
      firstNameAr: emp.firstNameAr?.trim(),
      middleNameAr: emp.middleNameAr?.trim(),
      lastNameAr: emp.lastNameAr?.trim(),
      email: emp.email?.trim() ?? '',
      employeeNumber: emp.employeeNumber?.trim(),
      phoneNumber: emp.phoneNumber?.trim(),
      mobileNumber: emp.mobileNumber?.trim(),
      status: emp.employeeStatus?.trim() ?? 'ACTIVE',
      isActive: _parseIsActive(emp.employeeIsActive),
      createdAt: createdAt,
      positionTitle: _positionTitleFromAssignment(asg),
      departmentName: null,
    );
  }

  String get fullName => [firstName, middleName, lastName].where((n) => n != null && n.isNotEmpty).join(' ').trim();

  String get fullNameAr =>
      [firstNameAr, middleNameAr, lastNameAr].where((n) => n != null && n.isNotEmpty).join(' ').trim();
}

String? _positionTitleFromAssignment(AssignmentDetailSection asg) {
  final fromPosition = asg.position?.positionNameEn.trim() ?? '';
  if (fromPosition.isNotEmpty) return fromPosition;
  final fromAssignment = asg.positionNameEn?.trim() ?? '';
  return fromAssignment.isNotEmpty ? fromAssignment : null;
}

bool _parseIsActive(String? raw) {
  final value = raw?.trim().toLowerCase() ?? '';
  if (value.isEmpty) return true;
  return value == 'true' || value == 'y' || value == 'yes' || value == '1';
}
