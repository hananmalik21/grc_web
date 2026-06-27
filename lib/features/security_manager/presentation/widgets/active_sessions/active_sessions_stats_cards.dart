import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSessionsStatsCards extends StatelessWidget {
  final bool isDark;
  final int activeCount;
  final int idleCount;
  final int lockedCount;
  final int totalCount;

  const ActiveSessionsStatsCards({
    super.key,
    required this.isDark,
    required this.activeCount,
    required this.idleCount,
    required this.lockedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final cards = [
      _StatCard(label: 'Active Sessions', value: '$activeCount', isDark: isDark),
      _StatCard(label: 'Idle Sessions', value: '$idleCount', isDark: isDark),
      _StatCard(label: 'Locked Sessions', value: '$lockedCount', isDark: isDark),
      _StatCard(label: 'Total Sessions', value: '$totalCount', isDark: isDark),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: i < cards.length - 1 ? 12.h : 0),
              child: cards[i],
            ),
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 14.w : 0),
              child: cards[i],
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatCard({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.cardBackgroundDark : AppColors.infoBg;
    final border = isDark ? AppColors.cardBorderDark : AppColors.infoBorderDark;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.grayText;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.grayText;

    return Container(
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: border, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(color: labelColor),
          ),
          Gap(8.h),
          Text(
            value,
            style: context.textTheme.displaySmall?.copyWith(fontSize: 32.sp, color: valueColor),
          ),
        ],
      ),
    );
  }
}
