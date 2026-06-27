import 'package:grc/features/compensation/domain/models/adjustments/adjustment.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_types.dart';
import 'package:grc/gen/assets.gen.dart';

class AdjustmentStatCardData {
  final String title;
  final String value;
  final String iconPath;

  const AdjustmentStatCardData({required this.title, required this.value, required this.iconPath});
}

class AdjustmentsTabConfig {
  AdjustmentsTabConfig._();

  static const String allDepartmentsLabel = 'All Departments';
  static const String allRegionsLabel = 'All Regions';
  static const String allStatusesLabel = 'All Status';

  static const int pageSize = 6;

  static const String headerTitle = 'Salary Adjustments';
  static const String headerDescription =
      'Manage salary adjustments including promotions, merit increases, market adjustments, role changes, and retention increases with multi-stage approval workflows.';

  static const String tableTitle = 'Salary Adjustments';
  static const String tableDescription =
      'Track and manage all salary adjustments with approval workflows and budget impact tracking.';

  static const String searchHint = 'Search by employee, employee number, or department...';

  static const List<AdjustmentsTableColumn> defaultColumnOrder = [
    AdjustmentsTableColumn.employee,
    AdjustmentsTableColumn.department,
    AdjustmentsTableColumn.adjustmentType,
    AdjustmentsTableColumn.currentSalary,
    AdjustmentsTableColumn.newSalary,
    AdjustmentsTableColumn.increase,
    AdjustmentsTableColumn.effectiveDate,
    AdjustmentsTableColumn.reason,
    AdjustmentsTableColumn.status,
  ];

  static const List<String> createAdjustmentMethods = <String>['% Increase', 'Fixed Amount', 'New Value'];

  static const List<AdjustmentRowData> rows = [
    AdjustmentRowData(
      adjustmentId: 'ADJ-001',
      employeeName: 'Ahmed Ali',
      employeeId: 'EMP-1234',
      department: 'IT',
      region: 'Middle East',
      adjustmentType: 'Promotion',
      currentSalary: '\$5,000',
      adjustmentMethod: '% Increase',
      adjustmentValue: '10%',
      newSalary: '\$5,500',
      increaseAmount: '+\$500',
      increasePercent: '(10.0%)',
      effectiveDate: '2025-04-01',
      reasonCode: 'PROMO',
      status: AdjustmentStatus.pending,
      submittedBy: 'Manager IT',
      submittedDate: '2025-03-01',
    ),
    AdjustmentRowData(
      adjustmentId: 'ADJ-002',
      employeeName: 'Sara Khan',
      employeeId: 'EMP-1235',
      department: 'Finance',
      region: 'Asia Pacific',
      adjustmentType: 'Merit Increase',
      currentSalary: '\$6,000',
      adjustmentMethod: '% Increase',
      adjustmentValue: '6.5%',
      newSalary: '\$6,390',
      increaseAmount: '+\$390',
      increasePercent: '(6.5%)',
      effectiveDate: '2025-04-01',
      reasonCode: 'MERIT',
      status: AdjustmentStatus.approved,
      submittedBy: 'Finance Lead',
      submittedDate: '2025-03-08',
    ),
    AdjustmentRowData(
      adjustmentId: 'ADJ-003',
      employeeName: 'John Smith',
      employeeId: 'EMP-1236',
      department: 'Sales',
      region: 'North America',
      adjustmentType: 'Market Adjustment',
      currentSalary: '\$4,000',
      adjustmentMethod: 'Fixed Amount',
      adjustmentValue: '500',
      newSalary: '\$4,500',
      increaseAmount: '+\$500',
      increasePercent: '(12.5%)',
      effectiveDate: '2025-05-01',
      reasonCode: 'MARKET',
      status: AdjustmentStatus.pending,
      submittedBy: 'Sales Director',
      submittedDate: '2025-04-12',
    ),
    AdjustmentRowData(
      adjustmentId: 'ADJ-004',
      employeeName: 'Maria Garcia',
      employeeId: 'EMP-1237',
      department: 'Engineering',
      region: 'Europe',
      adjustmentType: 'Annual Review',
      currentSalary: '\$7,000',
      adjustmentMethod: '% Increase',
      adjustmentValue: '7%',
      newSalary: '\$7,490',
      increaseAmount: '+\$490',
      increasePercent: '(7.0%)',
      effectiveDate: '2025-04-01',
      reasonCode: 'ANNUAL',
      status: AdjustmentStatus.pending,
      submittedBy: 'Engineering VP',
      submittedDate: '2025-03-03',
    ),
    AdjustmentRowData(
      adjustmentId: 'ADJ-005',
      employeeName: 'David Lee',
      employeeId: 'EMP-1238',
      department: 'Marketing',
      region: 'Asia Pacific',
      adjustmentType: 'Role Change',
      currentSalary: '\$5,500',
      adjustmentMethod: '% Increase',
      adjustmentValue: '8%',
      newSalary: '\$5,940',
      increaseAmount: '+\$440',
      increasePercent: '(8.0%)',
      effectiveDate: '2025-06-01',
      reasonCode: 'ROLE_CHG',
      status: AdjustmentStatus.rejected,
      submittedBy: 'Marketing Head',
      submittedDate: '2025-05-18',
    ),
    AdjustmentRowData(
      adjustmentId: 'ADJ-006',
      employeeName: 'Emily Zhang',
      employeeId: 'EMP-1239',
      department: 'HR',
      region: 'Asia Pacific',
      adjustmentType: 'Retention Increase',
      currentSalary: '\$5,200',
      adjustmentMethod: 'Fixed Amount',
      adjustmentValue: '800',
      newSalary: '\$6,000',
      increaseAmount: '+\$800',
      increasePercent: '(15.4%)',
      effectiveDate: '2025-04-15',
      reasonCode: 'RETENTION',
      status: AdjustmentStatus.pending,
      submittedBy: 'HR Business Partner',
      submittedDate: '2025-03-22',
    ),
  ];

  static List<String> buildDepartmentOptions() => [
    allDepartmentsLabel,
    ...{for (final row in rows) row.department},
  ];

  static List<String> buildRegionOptions() => [
    allRegionsLabel,
    ...{for (final row in rows) row.region},
  ];

  static List<String> buildStatusOptions() => [
    allStatusesLabel,
    ...AdjustmentStatus.values.map((status) => status.label),
  ];

  static List<AdjustmentStatCardData> buildStatCards({
    required List<Adjustment> adjustments,
    required String budgetImpactValue,
  }) {
    return [
      AdjustmentStatCardData(
        title: 'Total Adjustments',
        value: '${adjustments.length}',
        iconPath: Assets.icons.compensation.fileList.path,
      ),
      AdjustmentStatCardData(
        title: 'Pending Approvals',
        value:
            '${adjustments.where((adj) => adj.status == 'PENDING' || adj.status == 'SUBMITTED' || adj.status == 'APPROVED').length}',
        iconPath: Assets.icons.clockIcon.path,
      ),
      AdjustmentStatCardData(
        title: 'Approved',
        value: '${adjustments.where((adj) => adj.status == 'APPROVED').length}',
        iconPath: Assets.icons.checkIconGreen.path,
      ),
      AdjustmentStatCardData(
        title: 'Budget Impact',
        value: budgetImpactValue,
        iconPath: Assets.icons.leaveManagement.dollar.path,
      ),
    ];
  }
}
