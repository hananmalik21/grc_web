import '../../models/employee_compensation_table_row_data.dart';

class EmployeeCompensationSkeleton {
  static List<EmployeeCompensationTableRowData> get rows => List.generate(
    10,
    (i) => const EmployeeCompensationTableRowData(
      employeeName: 'Hanan Malik',
      employeeId: 'EMP-1001',
      employeeGuid: 'EMP-1001',
      planGuid: '',
      department: 'Engineering',
      region: 'Middle East',
      position: 'Senior Flutter Developer',
      compensationPlan: 'Enterprise Merit Plan',
      salaryStructure: 'Standard Corporate',
      grade: 'G12',
      baseSalary: 2500,
      allowances: 450,
      benefits: 300,
      status: 'Active',
    ),
  );
}
