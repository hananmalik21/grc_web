import 'system_user.dart';

class EmployeeDetails {
  final int id;
  final String name;
  final String email;
  final String employeeNumber;
  final String department;
  final String designation;
  final SystemUserStatus status;
  final String? secondaryEmail;
  final String? workPhone;
  final String? mobilePhone;
  final String? extension;
  final String? officeLocation;
  final String? mailingAddress;
  final String? employeeType;
  final String? reportToManager;
  final int? workLocationId;
  final String? workLocation;
  final DateTime? hireDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? departmentId;
  final String? jobTitleId;
  final int? reportsToEmployeeId;

  const EmployeeDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeNumber,
    required this.department,
    required this.designation,
    required this.status,
    this.secondaryEmail,
    this.workPhone,
    this.mobilePhone,
    this.extension,
    this.officeLocation,
    this.mailingAddress,
    this.employeeType,
    this.reportToManager,
    this.workLocationId,
    this.workLocation,
    this.hireDate,
    this.startDate,
    this.endDate,
    this.departmentId,
    this.jobTitleId,
    this.reportsToEmployeeId,
  });
}
