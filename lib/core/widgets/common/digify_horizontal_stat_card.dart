import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyHorizontalStatCard extends StatelessWidget {
  const DigifyHorizontalStatCard({
    required this.title,
    required this.value,
    required this.iconPath,
    required this.iconColor,
    required this.iconBgColor,
    super.key,
    this.subtext,
    this.subtextColor,
    this.valueColor,
    this.expandVertically = false,
  });

  final String title;
  final String value;
  final String? subtext;
  final String iconPath;
  final Color iconColor;
  final Color iconBgColor;
  final Color? subtextColor;
  final Color? valueColor;
  final bool expandVertically;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.dashboardStatLabel;
    final effectiveValueColor = valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.dashboardStatValue);
    final effectiveSubtextColor = subtextColor ?? AppColors.statIconBlue;
    final iconBackgroundColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return Container(
      height: expandVertically ? double.infinity : null,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(color: titleColor, fontSize: 14.sp),
                ),
                Gap(2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(fontSize: 22.sp, color: effectiveValueColor),
                ),
                if (subtext != null) ...[
                  Gap(6.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (subtext!.contains('+') || subtext!.toLowerCase().contains('month'))
                        DigifyAsset(
                          assetPath: Assets.icons.priceUpItem.path,
                          width: 12,
                          height: 12,
                          color: effectiveSubtextColor,
                        ),
                      if (subtext!.contains('+') || subtext!.toLowerCase().contains('month')) Gap(4.w),
                      Flexible(
                        child: Text(
                          subtext!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.labelSmall?.copyWith(color: effectiveSubtextColor, fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Gap(16.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: iconBackgroundColor, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, width: 20, height: 20, color: iconColor),
          ),
        ],
      ),
    );
  }
}
