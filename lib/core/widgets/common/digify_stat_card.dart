import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyStatCard extends StatelessWidget {
  final String label;
  final String? value;
  final String description;
  final String? iconPath;
  final IconData? icon;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? valueColor;
  final bool isDark;

  const DigifyStatCard({
    super.key,
    required this.label,
    this.value,
    required this.description,
    this.iconPath,
    this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    this.valueColor,
    required this.isDark,
  }) : assert(iconPath == null || icon == null, 'Cannot provide both iconPath and icon');

  @override
  Widget build(BuildContext context) {
    final effectiveIconBgColor = iconBackgroundColor ?? AppColors.jobRoleBg;
    final effectiveIconColor = iconColor ?? AppColors.statIconBlue;
    final effectiveValueColor = valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconPath != null || icon != null)
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(color: effectiveIconBgColor, borderRadius: BorderRadius.circular(7.r)),
              alignment: Alignment.center,
              child: iconPath != null
                  ? DigifyAsset(assetPath: iconPath!, color: effectiveIconColor, width: 21, height: 21)
                  : Icon(icon, size: 21.sp, color: effectiveIconColor),
            ),
          if (iconPath != null || icon != null) Gap(14.h),
          Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.shiftExportButton,
            ),
          ),
          if (value != null) ...[
            Gap(7.h),
            Text(
              value!,
              style: context.textTheme.displaySmall?.copyWith(fontSize: 26.sp, color: effectiveValueColor),
            ),
          ],
          Gap(7.h),
          Text(
            description,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
            ),
          ),
        ],
      ),
    );
  }
}
