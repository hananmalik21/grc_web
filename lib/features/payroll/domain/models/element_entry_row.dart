class ElementEntryRow {
  const ElementEntryRow({
    required this.elementName,
    required this.primaryEntryValue,
    required this.valueName,
    required this.source,
    required this.employmentLevel,
    required this.seq,
    required this.reason,
    required this.classification,
    required this.ldg,
    required this.empNumber,
    required this.status,
  });

  final String elementName;
  final String primaryEntryValue;
  final String valueName;
  final String source;
  final String employmentLevel;
  final int seq;
  final String reason;
  final String classification;
  final String ldg;
  final String empNumber;
  final String status;
}

const kMockElementEntries = <ElementEntryRow>[
  ElementEntryRow(
    elementName: 'Basic Salary KW',
    primaryEntryValue: '1,700.000',
    valueName: 'Amount',
    source: 'Element Entry Page',
    employmentLevel: 'Assignment',
    seq: 1,
    reason: '—',
    classification: 'Standard Earnings',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Active',
  ),
  ElementEntryRow(
    elementName: 'Housing Allowance KW',
    primaryEntryValue: '300.000',
    valueName: 'Amount',
    source: 'Element Entry Page',
    employmentLevel: 'Assignment',
    seq: 2,
    reason: '—',
    classification: 'Standard Earnings',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Recurring',
  ),
  ElementEntryRow(
    elementName: 'Transport Allowance KW',
    primaryEntryValue: '75.000',
    valueName: 'Amount',
    source: 'Element Entry Page',
    employmentLevel: 'Assignment',
    seq: 3,
    reason: '—',
    classification: 'Standard Earnings',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Active',
  ),
  ElementEntryRow(
    elementName: 'Air Ticket Information KW',
    primaryEntryValue: '—',
    valueName: '—',
    source: 'HR Admin',
    employmentLevel: 'Payroll Relationship',
    seq: 4,
    reason: '—',
    classification: 'Information',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Inactive',
  ),
  ElementEntryRow(
    elementName: 'BONUS_INFORMATION',
    primaryEntryValue: '—',
    valueName: '—',
    source: 'HR Admin',
    employmentLevel: 'Assignment',
    seq: 5,
    reason: 'Bonus Information Update',
    classification: 'Information',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Pending',
  ),
  ElementEntryRow(
    elementName: 'Social Insurance Employee KW',
    primaryEntryValue: '51.000',
    valueName: 'Amount',
    source: 'Element Entry Page',
    employmentLevel: 'Payroll Relationship',
    seq: 6,
    reason: '—',
    classification: 'Employee Tax Deductions',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Active',
  ),
  ElementEntryRow(
    elementName: 'Annual Leave Accrual',
    primaryEntryValue: '—',
    valueName: 'Days',
    source: 'Absence Module',
    employmentLevel: 'Assignment',
    seq: 7,
    reason: '—',
    classification: 'Absences',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Processed',
  ),
  ElementEntryRow(
    elementName: 'Overtime Pay KW',
    primaryEntryValue: '120.000',
    valueName: 'Amount',
    source: 'Time & Labour',
    employmentLevel: 'Assignment',
    seq: 8,
    reason: 'Q2 Overtime',
    classification: 'Supplemental Earnings',
    ldg: 'Kuwait LDG',
    empNumber: 'E0000042-1',
    status: 'Pending',
  ),
];
