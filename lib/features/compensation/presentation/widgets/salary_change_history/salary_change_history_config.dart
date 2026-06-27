import 'package:grc/gen/assets.gen.dart';

class SalaryChangeHistoryConfig {
  SalaryChangeHistoryConfig._();

  static const String placeholderGrade = '-';
  static const String placeholderSubmissionDate = '-';
  static const String reasonNote = 'Annual performance review - Exceeds expectations';
  static const String reviewerComment = 'Outstanding performance in Q4 2023';
  static const String unchangedValue = 'No change';
  static const String unchangedStatus = 'Unchanged';
  static const String unchangedPercent = '-';
  static const String unchangedAmount = 'AED 0';

  static final List<SalaryChangeHistoryStatCardData> mockStats = [
    SalaryChangeHistoryStatCardData(
      title: 'Total Changes',
      value: '12',
      iconPath: Assets.icons.compensation.history.path,
    ),
    SalaryChangeHistoryStatCardData(title: 'Approved', value: '3', iconPath: Assets.icons.activeCheckIcon.path),
    SalaryChangeHistoryStatCardData(title: 'Pending', value: '3', iconPath: Assets.icons.clockIcon.path),
    SalaryChangeHistoryStatCardData(
      title: 'Rejected',
      value: '3',
      iconPath: Assets.icons.leaveManagement.rejected.path,
    ),
    SalaryChangeHistoryStatCardData(
      title: 'Total Impact',
      value: 'AED2925',
      iconPath: Assets.icons.departmentMetric3Icon.path,
    ),
    SalaryChangeHistoryStatCardData(title: 'Avg Increase', value: 'AED2925', iconPath: Assets.icons.metricsIcon.path),
  ];

  static final List<SalaryChangeHistoryTableRowData> mockTableRows = [
    SalaryChangeHistoryTableRowData(
      employeeName: 'Sarah Johnson',
      employeeId: 'EMP-2024-1234',
      changeId: 'CHG-2024-001',
      changeDate: '2023-12-15',
      department: 'Engineering',
      jobTitle: 'Senior Software Engineer',
      gradeName: 'Grade 5',
      changeType: 'Annual Review',
      effectiveDate: '2024-01-01',
      previousSalaryLabel: 'AED 8,000',
      newSalaryLabel: 'AED 8,500',
      changeAmountLabel: 'AED 500',
      changePercentLabel: '6.25%',
      isIncrease: true,
      isDecrease: false,
      status: 'Approved',
    ),
    SalaryChangeHistoryTableRowData(
      employeeName: 'Omar Al-Khalifa',
      employeeId: 'EMP-10303',
      changeId: 'CHG-1002',
      changeDate: '2026-04-10',
      department: 'Finance',
      jobTitle: 'Financial Analyst',
      gradeName: 'Grade 3',
      changeType: 'Merit',
      effectiveDate: '2026-04-25',
      previousSalaryLabel: 'AED 12,000',
      newSalaryLabel: 'AED 12,650',
      changeAmountLabel: 'AED 650',
      changePercentLabel: '5.42%',
      isIncrease: true,
      isDecrease: false,
      status: 'Pending',
    ),
    SalaryChangeHistoryTableRowData(
      employeeName: 'Sara Khan',
      employeeId: 'EMP-10477',
      changeId: 'CHG-1003',
      changeDate: '2026-04-20',
      department: 'Product',
      jobTitle: 'Product Manager',
      gradeName: 'Grade 4',
      changeType: 'Promotion',
      effectiveDate: '2026-05-02',
      previousSalaryLabel: 'AED 15,000',
      newSalaryLabel: 'AED 15,000',
      changeAmountLabel: 'AED 0',
      changePercentLabel: '0%',
      isIncrease: false,
      isDecrease: false,
      status: 'Rejected',
    ),
  ];

  static final List<SalaryChangeHistoryApproverData> mockApprovers = [
    SalaryChangeHistoryApproverData(
      name: 'John Smith',
      title: 'HR Manager',
      date: '2023-12-15',
      status: 'Initiated By',
      assetPath: Assets.icons.userIcon.path,
    ),
    SalaryChangeHistoryApproverData(
      name: 'David Lee',
      title: 'Engineering Director',
      date: '2023-12-18',
      status: 'Level 1 Approver',
      assetPath: Assets.icons.userIcon.path,
    ),
    SalaryChangeHistoryApproverData(
      name: 'Robert Anderson',
      title: 'CEO',
      date: '2023-12-20',
      status: 'Level 2 Approver',
      assetPath: Assets.icons.userIcon.path,
    ),
  ];

  static const List<SalaryChangeHistoryComponentTemplate> staticComponentTemplates = [
    SalaryChangeHistoryComponentTemplate(
      name: 'Allowances',
      previousValue: unchangedAmount,
      currentValue: unchangedAmount,
      changeValue: unchangedValue,
      changePercent: unchangedPercent,
      status: 'Unchanged',
      statusColorKey: 'info',
    ),
    SalaryChangeHistoryComponentTemplate(
      name: 'Benefits',
      previousValue: unchangedAmount,
      currentValue: unchangedAmount,
      changeValue: unchangedValue,
      changePercent: unchangedPercent,
      status: 'Unchanged',
      statusColorKey: 'info',
    ),
    SalaryChangeHistoryComponentTemplate(
      name: 'Bonuses',
      previousValue: unchangedAmount,
      currentValue: unchangedAmount,
      changeValue: unchangedValue,
      changePercent: unchangedPercent,
      status: 'Unchanged',
      statusColorKey: 'info',
    ),
  ];
}

class SalaryChangeHistoryStatCardData {
  final String title;
  final String value;
  final String iconPath;

  const SalaryChangeHistoryStatCardData({required this.title, required this.value, required this.iconPath});
}

class SalaryChangeHistoryTableRowData {
  final String employeeName;
  final String employeeId;
  final String changeId;
  final String changeDate;
  final String department;
  final String jobTitle;
  final String gradeName;
  final String changeType;
  final String effectiveDate;
  final String previousSalaryLabel;
  final String newSalaryLabel;
  final String changeAmountLabel;
  final String changePercentLabel;
  final bool isIncrease;
  final bool isDecrease;
  final String status;

  const SalaryChangeHistoryTableRowData({
    required this.employeeName,
    required this.employeeId,
    required this.changeId,
    required this.changeDate,
    required this.department,
    required this.jobTitle,
    required this.gradeName,
    required this.changeType,
    required this.effectiveDate,
    required this.previousSalaryLabel,
    required this.newSalaryLabel,
    required this.changeAmountLabel,
    required this.changePercentLabel,
    required this.isIncrease,
    required this.isDecrease,
    required this.status,
  });
}

class SalaryChangeHistoryApproverData {
  final String name;
  final String title;
  final String date;
  final String status;
  final String assetPath;

  const SalaryChangeHistoryApproverData({
    required this.name,
    required this.title,
    required this.date,
    required this.status,
    required this.assetPath,
  });
}

class SalaryChangeHistoryComponentTemplate {
  final String name;
  final String previousValue;
  final String currentValue;
  final String changeValue;
  final String changePercent;
  final String status;
  final String statusColorKey;

  const SalaryChangeHistoryComponentTemplate({
    required this.name,
    required this.previousValue,
    required this.currentValue,
    required this.changeValue,
    required this.changePercent,
    required this.status,
    required this.statusColorKey,
  });
}
