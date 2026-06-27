import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/digify_stat_card.dart';
import 'package:grc/features/leave_management/domain/models/team_leave_risk_employee.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamLeaveRiskStatCards extends StatelessWidget {
  final TeamLeaveRiskStats stats;
  final bool isDark;

  const TeamLeaveRiskStatCards({super.key, required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final cards = [
      DigifyStatCard(
        label: 'Team Members',
        value: stats.teamMembers.toString(),
        description: 'Active employees',
        iconPath: Assets.icons.employeeListIcon.path,
        isDark: isDark,
      ),
      DigifyStatCard(
        label: 'Employees at Risk',
        value: stats.employeesAtRisk.toString(),
        description: '${(stats.employeesAtRisk / stats.teamMembers * 100).toStringAsFixed(1)}% of team',
        iconPath: Assets.icons.leaveManagement.warning.path,
        isDark: isDark,
      ),
      DigifyStatCard(
        label: 'Total At-Risk Days',
        value: stats.totalAtRiskDays.toString(),
        description: 'Across all team members',
        iconPath: Assets.icons.leaveManagement.downfall.path,
        isDark: isDark,
      ),
      DigifyStatCard(
        label: 'Avg At-Risk per Employee',
        value: stats.avgAtRiskPerEmployee.toStringAsFixed(1),
        description: 'Days per employee',
        iconPath: Assets.icons.leaveManagementIcon.path,
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((card) {
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: card != cards.last ? 12.h : 0),
            child: card,
          );
        }).toList(),
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards.map((card) {
          return SizedBox(width: (MediaQuery.of(context).size.width - 48.w - 12.w) / 2, child: card);
        }).toList(),
      );
    } else {
      return Row(
        children: cards.map((card) {
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: card != cards.last ? 21.w : 0),
              child: card,
            ),
          );
        }).toList(),
      );
    }
  }
}
