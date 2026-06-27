import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_stats_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/utils/number_format_utils.dart';

class LeaveDetailsSummarySection extends StatelessWidget {
  const LeaveDetailsSummarySection({super.key, required this.summary, required this.isDark});

  final Map<String, dynamic> summary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Total Accrued',
            value: '${NumberFormatUtils.formatDays(summary['totalAccrued'] as num? ?? 0)} days',

            iconPath: Assets.icons.addBusinessUnitIcon.path,
            isDark: isDark,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Total Consumed',
            value: '${NumberFormatUtils.formatDays(summary['totalConsumed'] as num? ?? 0)} days',

            iconPath: Assets.icons.leaveManagement.minus.path,
            isDark: isDark,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Current Balance',
            value: '${NumberFormatUtils.formatDays(summary['currentBalance'] as num? ?? 0)} days',

            iconPath: Assets.icons.leaveManagementMainIcon.path,
            isDark: isDark,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Entitlement',
            value: (summary['entitlement'] as String?) ?? '0 days',
            iconPath: Assets.icons.workforce.fillRate.path,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
