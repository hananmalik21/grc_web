import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/leave_management/presentation/widgets/common/leave_management_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class ForfeitPolicyStatCards extends StatelessWidget {
  final bool isDark;

  const ForfeitPolicyStatCards({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    final cards = [
      LeaveManagementStatCard(
        label: 'Total Policies',
        value: '8',
        iconPath: Assets.icons.leaveManagement.forfeitReports.path,
        isDark: isDark,
      ),
      LeaveManagementStatCard(
        label: 'Compliant Policies',
        value: '7',
        iconPath: Assets.icons.checkIconGreen.path,
        isDark: isDark,
      ),
      LeaveManagementStatCard(
        label: 'Encashment Enabled',
        value: '1',
        iconPath: Assets.icons.clockIcon.path,
        isDark: isDark,
      ),
      LeaveManagementStatCard(
        label: 'Active Policies',
        value: '1',
        iconPath: Assets.icons.leaveManagement.dollar.path,
        isDark: isDark,
      ),
      LeaveManagementStatCard(
        label: 'Affected Employees',
        value: '1',
        iconPath: Assets.icons.employeeListIcon.path,
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards.map((card) {
          return SizedBox(width: (context.deviceWidth - 48.w - 12.w) / 2, child: card);
        }).toList(),
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards.map((card) {
          return SizedBox(width: (context.deviceWidth - 48.w - 12.w) / 2, child: card);
        }).toList(),
      );
    } else {
      return Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[Expanded(child: cards[i]), if (i < cards.length - 1) Gap(21.w)],
        ],
      );
    }
  }
}
