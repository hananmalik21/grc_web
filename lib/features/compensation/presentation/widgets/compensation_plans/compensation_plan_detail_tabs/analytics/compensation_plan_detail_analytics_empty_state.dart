import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanDetailAnalyticsEmptyState extends StatelessWidget {
  final VoidCallback? onViewFullAnalytics;

  const CompensationPlanDetailAnalyticsEmptyState({super.key, this.onViewFullAnalytics});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark
        ? AppColors.borderGreyDark.withValues(alpha: 0.55)
        : AppColors.sidebarSecondaryText.withValues(alpha: 0.30);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 396.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detailed Analytics',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontSize: 18.sp,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        'Comprehensive compensation analytics and insights',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16.w),
                const SizedBox.shrink(),
              ],
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 16.w),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 982.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.compensation.fileList.path,
                      width: 48.w,
                      height: 48.w,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
                    ),
                    Gap(8.h),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'Advanced Analytics Available',
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontSize: 18.sp,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Gap(8.h),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Text(
                        'Access detailed compensation analytics, benchmarking data, and trend analysis',
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    AppButton.primary(label: 'View Full Analytics', onPressed: onViewFullAnalytics),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
