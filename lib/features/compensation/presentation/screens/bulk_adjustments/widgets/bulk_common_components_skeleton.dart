import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_component_adjustment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _skeletonGroup = BulkComponentAdjustmentGroup(
  componentId: 0,
  componentCode: 'EARN-BASIC-01',
  componentName: 'Basic Salary',
  employeeEdits: [
    BulkEmployeeComponentEdit(
      employeeGuid: 'skeleton-1',
      employeeId: 0,
      employeeName: 'Employee Name',
      planId: 0,
      currentAmount: 3000,
      currencyCode: 'KWD',
      newAmount: 3000,
    ),
    BulkEmployeeComponentEdit(
      employeeGuid: 'skeleton-2',
      employeeId: 0,
      employeeName: 'Employee Name',
      planId: 0,
      currentAmount: 5000,
      currencyCode: 'KWD',
      newAmount: 5000,
    ),
  ],
);

class BulkCommonComponentsSkeleton extends StatelessWidget {
  const BulkCommonComponentsSkeleton({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          BulkComponentAdjustmentCard(group: _skeletonGroup, isDark: isDark),
          Gap(12.h),
          BulkComponentAdjustmentCard(group: _skeletonGroup, isDark: isDark),
        ],
      ),
    );
  }
}
