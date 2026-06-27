import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveManagementStatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final String? iconPath;

  const LeaveManagementStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(8.h),
                Text(
                  value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (iconPath != null) ...[
            Gap(12.w),
            Container(
              width: 42.w,
              height: 42.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.jobRoleBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: DigifyAsset(assetPath: iconPath!, width: 21.w, height: 21.h, color: AppColors.statIconBlue),
            ),
          ],
        ],
      ),
    );
  }
}
