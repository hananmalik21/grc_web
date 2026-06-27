import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/employee_self_service/presentation/providers/leave_absence/leave_absence_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveAbsenceSummaryStatCard extends StatelessWidget {
  const LeaveAbsenceSummaryStatCard({super.key, required this.stat});

  final LeaveBalanceOverview stat;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final progress = stat.totalDays == 0 ? 1.0 : (stat.remainingDays / stat.totalDays).clamp(0.0, 1.0);

    return EssSurfaceCard(
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(4.h),
          Text(
            '${stat.remainingDays}',
            style: context.textTheme.displaySmall?.copyWith(fontSize: 30.sp),
          ),
          Gap(2.h),
          Text(
            'of ${stat.totalDays} days',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
          Gap(12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5.h,
              backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
