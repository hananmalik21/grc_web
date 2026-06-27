import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/employee_self_service/presentation/providers/time_attendance/time_attendance_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TimeAttendanceStatCard extends StatelessWidget {
  const TimeAttendanceStatCard({super.key, required this.stat});

  final TimeAttendanceSummaryStat stat;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
                    letterSpacing: 0.4,
                  ),
                ),
                Gap(6.h),
                Text(
                  stat.value,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontSize: 18.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(8.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: stat.iconPath, width: 18, height: 18, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
