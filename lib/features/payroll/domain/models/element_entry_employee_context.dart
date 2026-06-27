import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';

class ElementEntryEmployeeContext {
  const ElementEntryEmployeeContext({
    required this.employeeName,
    required this.departmentLine,
    required this.personNumber,
    required this.payrollRelationship,
    required this.assignmentNumber,
    this.employeeId,
    this.employeeGuid,
  });

  final String employeeName;
  final String departmentLine;
  final String personNumber;
  final String payrollRelationship;
  final String assignmentNumber;
  final int? employeeId;
  final String? employeeGuid;

  factory ElementEntryEmployeeContext.mock() {
    return const ElementEntryEmployeeContext(
      employeeName: 'KHURAM KHALID PERVAIZ SHAHZAD',
      departmentLine: 'Person Management · Operations',
      personNumber: 'PN-100042',
      payrollRelationship: 'PR-2026-KW',
      assignmentNumber: 'E0000042-1',
      employeeId: 42,
      employeeGuid: '',
    );
  }

  factory ElementEntryEmployeeContext.fromEmployee(Employee employee) {
    return _fromEmployeeData(
      employeeId: employee.id,
      employeeGuid: employee.guid,
      employeeName: employee.fullName,
      positionTitle: employee.positionTitle,
      departmentName: employee.departmentName,
      personNumber: employee.employeeNumber,
      enterpriseId: employee.enterpriseId,
      assignmentNumber: employee.employeeNumber,
    );
  }

  factory ElementEntryEmployeeContext.fromFullDetails(EmployeeFullDetails details, {Employee? employee}) {
    final emp = details.employee;
    final asg = details.assignment;

    return _fromEmployeeData(
      employeeId: emp.employeeId,
      employeeGuid: emp.employeeGuid,
      employeeName: employee?.fullName ?? emp.fullNameEn,
      positionTitle: asg.position?.positionNameEn ?? asg.positionNameEn ?? employee?.positionTitle,
      departmentName: employee?.departmentName ?? _departmentFromOrgStructure(asg.orgStructureList),
      personNumber: emp.employeeNumber ?? employee?.employeeNumber,
      enterpriseId: emp.enterpriseId,
      assignmentNumber: resolveAssignmentNumber(
        assignmentEmployeeNumber: asg.employeeNumber,
        employeeNumber: emp.employeeNumber ?? employee?.employeeNumber,
      ),
    );
  }

  static String resolveAssignmentNumber({String? assignmentEmployeeNumber, String? employeeNumber}) {
    for (final value in [assignmentEmployeeNumber, employeeNumber]) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return '';
  }

  static ElementEntryEmployeeContext _fromEmployeeData({
    required int employeeId,
    String? employeeGuid,
    required String employeeName,
    String? positionTitle,
    String? departmentName,
    String? personNumber,
    required int enterpriseId,
    String? assignmentNumber,
  }) {
    final departmentParts = [
      if (positionTitle != null && positionTitle.isNotEmpty) positionTitle,
      if (departmentName != null && departmentName.isNotEmpty) departmentName,
    ];

    final resolvedPersonNumber = personNumber?.trim();
    final resolvedAssignmentNumber = resolveAssignmentNumber(employeeNumber: assignmentNumber);

    return ElementEntryEmployeeContext(
      employeeId: employeeId,
      employeeGuid: employeeGuid?.trim().isNotEmpty == true ? employeeGuid!.trim() : null,
      employeeName: employeeName.toUpperCase(),
      departmentLine: departmentParts.isEmpty ? '—' : departmentParts.join(' · '),
      personNumber: resolvedPersonNumber?.isNotEmpty == true ? resolvedPersonNumber! : 'PN-$employeeId',
      payrollRelationship: 'PR-$enterpriseId',
      assignmentNumber: resolvedAssignmentNumber,
    );
  }

  static String? _departmentFromOrgStructure(List<OrgStructureItem> orgStructureList) {
    for (final item in orgStructureList) {
      final levelCode = item.levelCode?.trim().toUpperCase();
      final name = item.orgUnitNameEn?.trim();
      if (levelCode == 'DEPARTMENT' && name != null && name.isNotEmpty) return name;
    }

    if (orgStructureList.isEmpty) return null;
    final last = orgStructureList.last.orgUnitNameEn?.trim();
    return last?.isNotEmpty == true ? last : null;
  }

  ElementEntryEmployeeContext copyWith({
    String? employeeName,
    String? departmentLine,
    String? personNumber,
    String? payrollRelationship,
    String? assignmentNumber,
    int? employeeId,
    String? employeeGuid,
  }) {
    return ElementEntryEmployeeContext(
      employeeName: employeeName ?? this.employeeName,
      departmentLine: departmentLine ?? this.departmentLine,
      personNumber: personNumber ?? this.personNumber,
      payrollRelationship: payrollRelationship ?? this.payrollRelationship,
      assignmentNumber: assignmentNumber ?? this.assignmentNumber,
      employeeId: employeeId ?? this.employeeId,
      employeeGuid: employeeGuid ?? this.employeeGuid,
    );
  }
}
