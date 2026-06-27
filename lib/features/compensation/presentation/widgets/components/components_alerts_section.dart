import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentsAlertsSection extends StatelessWidget {
  const ComponentsAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16.w : 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: DigifyAsset(
                  assetPath: Assets.icons.infoCircleBlue.path,
                  color: AppColors.errorBorderDark,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
              Gap(isMobile ? 12.w : 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3 Components Need Attention',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.errorBorderDark,
                        fontSize: isMobile ? 15.sp : 16.sp,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      'Some components have validation issues that need to be resolved before they can be used in compensation plans.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.sidebarCategoryText,
                        fontSize: isMobile ? 13.sp : 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(isMobile ? 16.h : 24.h),
          Column(
            children: [
              _buildAlertItem(
                context,
                'High',
                AppColors.alertMedium,
                AppColors.alertMediumBgText,
                'Missing Payroll Mapping',
                3,
                isDark,
                isMobile,
              ),
              Gap(isMobile ? 12.h : 8.h),
              _buildAlertItem(
                context,
                'Critical',
                AppColors.errorBorderDark,
                AppColors.redBg,
                'Formula Validation Error',
                2,
                isDark,
                isMobile,
              ),
              Gap(isMobile ? 12.h : 8.h),
              _buildAlertItem(
                context,
                'Medium',
                AppColors.grayBorderDark,
                AppColors.cardBackgroundGrey,
                'Inactive Dependencies',
                1,
                isDark,
                isMobile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    String severityLabel,
    Color severityColor,
    Color severityBgColor,
    String message,
    int issuesCount,
    bool isDark,
    bool isMobile,
  ) {
    if (isMobile) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DigifyCapsule(label: severityLabel, backgroundColor: severityBgColor, textColor: severityColor),
                Text(
                  '$issuesCount issues',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppColors.errorBorderDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Gap(8.h),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontSize: 13.sp,
              ),
            ),
            Gap(12.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.outline(label: 'Review', height: 36.h, onPressed: () {}),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        DigifyCapsule(label: severityLabel, backgroundColor: severityBgColor, textColor: severityColor),
        Gap(12.w),
        Expanded(
          child: Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(color: isDark ? Colors.white : AppColors.textPrimary),
          ),
        ),
        Text('$issuesCount issues', style: context.textTheme.titleSmall?.copyWith(color: AppColors.errorBorderDark)),
        Gap(16.w),
        AppButton.outline(label: 'Review', height: 32.h, onPressed: () {}),
      ],
    );
  }
}
