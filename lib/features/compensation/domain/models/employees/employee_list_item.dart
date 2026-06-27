import 'package:grc/features/compensation/presentation/models/employee_compensation_table_row_data.dart';

class EmployeeOrgUnit {
  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String levelCode;
  final String status;

  const EmployeeOrgUnit({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.levelCode,
    required this.status,
  });
}

class EmployeePosition {
  final String positionId;
  final String positionCode;
  final String status;
  final String positionTitleEn;

  const EmployeePosition({
    required this.positionId,
    required this.positionCode,
    required this.status,
    required this.positionTitleEn,
  });
}

class EmployeeListItem {
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
  final List<EmployeeOrgUnit> orgStructureList;
  final EmployeePosition? position;

  const EmployeeListItem({
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

  String get fullNameEn {
    final parts = [firstNameEn, if (middleNameEn != null) middleNameEn, lastNameEn];
    return parts.join(' ');
  }

  String get departmentName {
    const departmentLevel = 4;
    final dept = orgStructureList.where((u) => u.level == departmentLevel).firstOrNull;
    return dept?.orgUnitNameEn ?? '';
  }

  String get companyName {
    const companyLevel = 1;
    final company = orgStructureList.where((u) => u.level == companyLevel).firstOrNull;
    return company?.orgUnitNameEn ?? '';
  }

  EmployeeCompensationTableRowData toTableRowData() {
    final positionTitle = (position?.positionTitleEn ?? '').isNotEmpty ? position!.positionTitleEn : '—';

    return EmployeeCompensationTableRowData(
      employeeName: fullNameEn,
      employeeId: employeeNumber,
      employeeGuid: employeeGuid,
      planGuid: '',
      department: departmentName.isNotEmpty ? departmentName : '—',
      region: companyName.isNotEmpty ? companyName : '—',
      position: positionTitle,
      compensationPlan: '—',
      salaryStructure: '—',
      grade: '—',
      baseSalary: 0,
      allowances: 0,
      benefits: 0,
      status: _resolveStatus(employmentStatus),
    );
  }

  String _resolveStatus(String? raw) {
    if (raw == null) return 'Unknown';
    return switch (raw.toUpperCase()) {
      'ACTIVE' => 'Active',
      'PROBATION' => 'Probation',
      'TERMINATED' => 'Terminated',
      'INACTIVE' => 'Inactive',
      _ => raw,
    };
  }
}
