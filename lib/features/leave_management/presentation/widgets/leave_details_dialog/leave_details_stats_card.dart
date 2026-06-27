import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsStatsCard extends StatelessWidget {
  const LeaveDetailsStatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
  });

  final String label;
  final String value;
  final String iconPath;
  final bool isDark;

  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textPrimary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBgColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : _iconBackgroundLight;

    return Container(
      padding: EdgeInsetsDirectional.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(7.r)),
                      alignment: Alignment.center,
                      child: DigifyAsset(assetPath: iconPath, color: _iconColor, width: 21, height: 21),
                    ),
                    Gap(10.w),
                    Text(label, style: context.textTheme.titleSmall?.copyWith(color: titleColor)),
                  ],
                ),
                Gap(7.h),
                Text(value, style: context.textTheme.headlineMedium?.copyWith(color: valueColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
