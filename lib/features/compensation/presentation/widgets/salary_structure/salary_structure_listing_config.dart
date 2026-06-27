class SalaryStructureListItem {
  final String name;
  final String code;
  final String type;
  final String status;
  final String location;
  final String modifiedDate;

  const SalaryStructureListItem({
    required this.name,
    required this.code,
    required this.type,
    required this.status,
    required this.location,
    required this.modifiedDate,
  });
}

class SalaryStructureListingConfig {
  SalaryStructureListingConfig._();

  static const pageSize = 6;

  static const items = <SalaryStructureListItem>[
    SalaryStructureListItem(
      name: 'Kuwait Standard Salary Structure 2026',
      code: 'KWT-STD-2026',
      type: 'Standard',
      status: 'Active',
      location: 'Kuwait',
      modifiedDate: '4/6/2026',
    ),
    SalaryStructureListItem(
      name: 'Executive Compensation Structure',
      code: 'EXEC-CORE-01',
      type: 'Executive',
      status: 'Active',
      location: 'Kuwait',
      modifiedDate: '4/5/2026',
    ),
    SalaryStructureListItem(
      name: 'Technology Department Structure',
      code: 'TECH-GRID-02',
      type: 'Department',
      status: 'Active',
      location: 'Kuwait',
      modifiedDate: '4/4/2026',
    ),
    SalaryStructureListItem(
      name: 'Sales Incentive Structure',
      code: 'SALES-INC-03',
      type: 'Incentive',
      status: 'Draft',
      location: 'Kuwait',
      modifiedDate: '4/3/2026',
    ),
    SalaryStructureListItem(
      name: 'Shared Services Salary Structure',
      code: 'SHARED-SVC-04',
      type: 'Shared Services',
      status: 'Inactive',
      location: 'UAE',
      modifiedDate: '4/2/2026',
    ),
    SalaryStructureListItem(
      name: 'Regional GCC Structure',
      code: 'GCC-REG-05',
      type: 'Regional',
      status: 'Active',
      location: 'Saudi Arabia',
      modifiedDate: '4/1/2026',
    ),
    SalaryStructureListItem(
      name: 'Operations Shift Structure',
      code: 'OPS-SHIFT-06',
      type: 'Operational',
      status: 'Active',
      location: 'Kuwait',
      modifiedDate: '3/31/2026',
    ),
    SalaryStructureListItem(
      name: 'Graduate Program Structure',
      code: 'GRAD-07',
      type: 'Graduate',
      status: 'Draft',
      location: 'Bahrain',
      modifiedDate: '3/30/2026',
    ),
    SalaryStructureListItem(
      name: 'Support Functions Structure',
      code: 'SUP-FUNC-08',
      type: 'Support',
      status: 'Active',
      location: 'Qatar',
      modifiedDate: '3/29/2026',
    ),
  ];
}
