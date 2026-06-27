import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:grc/features/compensation/domain/models/adjustments/employee_component_history.dart';
import 'compensation_history_section.dart';

const _skeletonItems = [
  EmployeeComponentHistory(
    componentId: 0,
    componentGuid: '',
    componentCode: '',
    componentName: 'Basic Salary Component',
    componentTypeCode: '',
    isActive: true,
    effectiveStartDate: '',
    latestHistory: LatestComponentHistory(
      historyId: 0,
      eventType: '',
      eventTitle: 'SALARY_INCREASE',
      eventDescription: '',
      currencyCode: 'PKR',
      effectiveDate: '2026-04-18',
      approvedBy: '',
      approverName: 'System Administrator',
      approverRole: 'HR Director',
      changeReason: '',
      oldAmount: 4000,
      newAmount: 4500,
    ),
  ),
  EmployeeComponentHistory(
    componentId: 1,
    componentGuid: '',
    componentCode: '',
    componentName: 'Housing Allowance',
    componentTypeCode: '',
    isActive: true,
    effectiveStartDate: '',
    latestHistory: LatestComponentHistory(
      historyId: 1,
      eventType: '',
      eventTitle: 'PERCENTAGE_INCREASE',
      eventDescription: '',
      currencyCode: 'PKR',
      effectiveDate: '2026-04-19',
      approvedBy: '',
      approverName: 'Compensation Manager',
      approverRole: 'HR Manager',
      changeReason: '',
      oldAmount: 2000,
      newAmount: 2400,
    ),
  ),
  EmployeeComponentHistory(
    componentId: 2,
    componentGuid: '',
    componentCode: '',
    componentName: 'Fuel Allowance',
    componentTypeCode: '',
    isActive: true,
    effectiveStartDate: '',
    latestHistory: LatestComponentHistory(
      historyId: 2,
      eventType: '',
      eventTitle: 'SALARY_INCREASE',
      eventDescription: '',
      currencyCode: 'PKR',
      effectiveDate: '2026-05-01',
      approvedBy: '',
      approverName: 'System Admin',
      approverRole: 'System',
      changeReason: '',
      oldAmount: 1000,
      newAmount: 1000,
    ),
  ),
];

class CompensationHistorySkeleton extends StatelessWidget {
  const CompensationHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: HistoryList(items: _skeletonItems),
    );
  }
}
