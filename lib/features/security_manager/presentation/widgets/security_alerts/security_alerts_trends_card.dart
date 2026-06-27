import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SecurityAlertsTrendsCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const SecurityAlertsTrendsCard({super.key, required this.isDark, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: Assets.icons.analyticsIcon.path,
              width: 20,
              height: 20,
              color: AppColors.primary,
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View Alert Trends',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(3.h),
                Text(
                  'Open a quick trend overview for severity and resolution patterns.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Gap(12.w),
          AppButton(
            label: 'Open Trends',
            type: AppButtonType.outline,
            svgPath: Assets.icons.blueEyeIcon.path,
            height: 32.h,
            fontSize: 12.sp,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
            foregroundColor: AppColors.primary,
            borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
