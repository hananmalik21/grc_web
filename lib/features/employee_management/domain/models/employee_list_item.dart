import 'package:grc/features/employee_management/domain/models/active_flag_enum.dart';
import 'package:grc/features/employee_management/domain/models/assignment_status_enum.dart';
import 'package:grc/features/employee_management/domain/models/contract_type_code_enum.dart';
import 'package:grc/features/employee_management/domain/models/employee_status_enum.dart';

class EmployeeListItem {
  final String id;
  final int? employeeIdNum;
  final String fullName;
  final String employeeNumber;
  final String position;
  final String department;
  final String status;
  final String? email;
  final String? phone;
  final EmployeeStatus? employeeStatus;
  final String? positionId;
  final int? assignmentId;
  final String? assignmentGuid;
  final String? orgUnitId;
  final ContractTypeCode? contractTypeCode;
  final AssignmentStatus? employmentStatus;
  final ActiveFlag? employeeIsActive;

  const EmployeeListItem({
    required this.id,
    this.employeeIdNum,
    required this.fullName,
    required this.employeeNumber,
    required this.position,
    required this.department,
    required this.status,
    this.email,
    this.phone,
    this.employeeStatus,
    this.positionId,
    this.assignmentId,
    this.assignmentGuid,
    this.orgUnitId,
    this.contractTypeCode,
    this.employmentStatus,
    this.employeeIsActive,
  });

  String get employeeId => employeeNumber;

  static const String emptyPlaceholder = '—';

  String get fullNameDisplay => fullName.trim().isEmpty ? emptyPlaceholder : fullName;
  String get employeeNumberDisplay => employeeNumber.trim().isEmpty ? emptyPlaceholder : employeeNumber;
  String get employeeIdDisplay => employeeNumberDisplay;
  String get positionDisplay => position.trim().isEmpty ? emptyPlaceholder : position;
  String get departmentDisplay => department.trim().isEmpty ? emptyPlaceholder : department;
  String get statusDisplay => status.trim().isEmpty ? emptyPlaceholder : status;
  String get emailDisplay => (email == null || email!.trim().isEmpty) ? emptyPlaceholder : email!;
  String get phoneDisplay => (phone == null || phone!.trim().isEmpty) ? emptyPlaceholder : phone!;

  factory EmployeeListItem.empty() =>
      const EmployeeListItem(id: '', fullName: '', employeeNumber: '', position: '', department: '', status: '');

  String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
}
