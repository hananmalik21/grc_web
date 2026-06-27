import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import '../../models/compensation_plan_table_row_data.dart';

class CompensationPlansInsightAlert {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final String iconPath;

  const CompensationPlansInsightAlert({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.iconPath,
  });
}

class CompensationPlansConfig {
  CompensationPlansConfig._();

  static const statusDistributionLegend = <({String label, String value, Color color})>[
    (label: 'Active', value: '5', color: AppColors.success),
    (label: 'Archived', value: '2', color: AppColors.grayText),
    (label: 'Draft', value: '1', color: AppColors.warning),
    (label: 'Pending', value: '1', color: AppColors.error),
  ];

  static const monthlyCostTrendValues = <double>[1240000, 1260000, 1280000, 1295000, 1300000, 1320000];

  static const monthlyCostTrendLabels = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  static const plansByTypeValues = <double>[8, 4, 3, 1];

  static const plansByTypeLabels = <String>['Salary', 'Benefits', 'Bonus', 'Incentive'];

  static const planTypeOptions = <String>['All Types', 'Salary Structure', 'Bonus Plan', 'Benefits Plan'];

  static const statusOptions = <String>['All Status', 'Active', 'InActive'];

  static const currencyOptions = <String>['All Currency', 'KWD', 'USD', 'EUR'];

  static final insightAlerts = <CompensationPlansInsightAlert>[
    CompensationPlansInsightAlert(
      title: '1 plan pending approval for 5+ days',
      subtitle: 'Quarterly Performance Bonus requires review',
      backgroundColor: AppColors.payrollManagerBg,
      borderColor: AppColors.payrollManagerBorder,
      iconColor: AppColors.informationIconColor,
      iconPath: Assets.icons.leaveManagement.warning.path,
    ),
    CompensationPlansInsightAlert(
      title: '1 plan missing payroll mapping',
      subtitle: 'Sales Commission Structure needs payroll integration',
      backgroundColor: AppColors.redBg,
      borderColor: AppColors.delegationRevokeBorder,
      iconColor: AppColors.redButton,
      iconPath: Assets.icons.leaveManagement.rejected.path,
    ),
    CompensationPlansInsightAlert(
      title: '5 plans ready for payroll',
      subtitle: 'All active plans properly configured',
      backgroundColor: AppColors.alertNewBg,
      borderColor: AppColors.alertNewBorder,
      iconColor: AppColors.alertNewText,
      iconPath: Assets.icons.attendance.leave.path,
    ),
  ];

  static const tableRows = <CompensationPlanTableRowData>[
    CompensationPlanTableRowData(
      name: '2026 Executive Compensation Plan',
      code: 'EXEC-COMP-2026',
      type: 'Salary Structure',
      status: 'Active',
      currency: 'KWD',
      planGuid: '4E260233339CAB99E0633519000A1001',
    ),
    CompensationPlanTableRowData(
      name: 'Standard Salary Structure 2026',
      code: 'STD-SAL-2026',
      type: 'Salary Structure',
      status: 'Active',
      currency: 'KWD',
      planGuid: '4E260233339CAB99E0633519000A1002',
    ),
    CompensationPlanTableRowData(
      name: 'Technology Department Plan',
      code: 'TECH-COMP-2026',
      type: 'Salary Structure',
      status: 'Active',
      currency: 'KWD',
      planGuid: '4E260233339CAB99E0633519000A1003',
    ),
    CompensationPlanTableRowData(
      name: 'Sales Incentive Plan 2026',
      code: 'SALES-INC-2026',
      type: 'Bonus Plan',
      status: 'Active',
      currency: 'KWD',
      planGuid: '4E260233339CAB99E0633519000A1004',
    ),
    CompensationPlanTableRowData(
      name: 'Annual Benefits Package',
      code: 'BEN-PKG-2026',
      type: 'Benefits Plan',
      status: 'Active',
      currency: 'KWD',
      planGuid: '4E260233339CAB99E0633519000A1005',
    ),
    CompensationPlanTableRowData(
      name: 'Q1 Performance Bonus Draft',
      code: 'Q1-PERF-2026',
      type: 'Bonus Plan',
      status: 'Draft',
      currency: 'KWD',
      planGuid: '4E260233339CAB99E0633519000A1006',
    ),
  ];
}
