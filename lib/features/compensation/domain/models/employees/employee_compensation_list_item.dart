import 'package:grc/features/compensation/presentation/models/employee_compensation_table_row_data.dart';

class EmployeeCompensationOrgUnit {
  const EmployeeCompensationOrgUnit({required this.levelCode, required this.orgUnitNameEn});

  final String levelCode;
  final String orgUnitNameEn;
}

class EmployeeCompensationListItem {
  const EmployeeCompensationListItem({
    required this.enterpriseId,
    required this.employeeName,
    required this.employeeId,
    required this.employeeGuid,
    required this.positionName,
    required this.gradeNumber,
    required this.gradeCategory,
    required this.planGuid,
    required this.planCode,
    required this.planName,
    required this.structureCode,
    required this.structureName,
    required this.totalCompensation,
    required this.totalRetroAmount,
    required this.totalBaseSalary,
    required this.totalAllowance,
    required this.totalBenefits,
    required this.statusCode,
    required this.orgStructureList,
  });

  final int enterpriseId;
  final String employeeName;
  final String employeeId;
  final String employeeGuid;
  final String positionName;
  final String gradeNumber;
  final String gradeCategory;
  final String planGuid;
  final String planCode;
  final String planName;
  final String structureCode;
  final String structureName;
  final double totalCompensation;
  final double totalRetroAmount;
  final double totalBaseSalary;
  final double totalAllowance;
  final double totalBenefits;
  final String statusCode;
  final List<EmployeeCompensationOrgUnit> orgStructureList;

  String get departmentName {
    final department = orgStructureList
        .where((u) => u.levelCode.toUpperCase() == 'DEPARTMENT')
        .cast<EmployeeCompensationOrgUnit>()
        .firstOrNull;
    return department?.orgUnitNameEn ?? '';
  }

  String get companyName {
    final company = orgStructureList
        .where((u) => u.levelCode.toUpperCase() == 'COMPANY')
        .cast<EmployeeCompensationOrgUnit>()
        .firstOrNull;
    return company?.orgUnitNameEn ?? '';
  }

  EmployeeCompensationTableRowData toTableRowData() {
    return EmployeeCompensationTableRowData(
      employeeName: employeeName,
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      planGuid: planGuid,
      department: departmentName.isNotEmpty ? departmentName : '—',
      region: companyName.isNotEmpty ? companyName : '—',
      position: positionName.isNotEmpty ? positionName : '—',
      compensationPlan: planName.isNotEmpty ? planName : planCode,
      salaryStructure: structureName.isNotEmpty ? structureName : structureCode,
      grade: gradeNumber.isNotEmpty ? gradeNumber : gradeCategory,
      baseSalary: totalBaseSalary,
      allowances: totalAllowance,
      benefits: totalBenefits,
      apiTotalCompensation: totalCompensation,
      status: statusCode,
    );
  }
}
