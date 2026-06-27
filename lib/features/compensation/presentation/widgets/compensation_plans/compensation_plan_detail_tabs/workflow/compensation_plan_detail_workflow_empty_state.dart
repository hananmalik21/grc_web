import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanDetailWorkflowEmptyState extends StatelessWidget {
  const CompensationPlanDetailWorkflowEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 16.w),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 982.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.compensation.history.path,
                width: 48.w,
                height: 48.w,
                color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
              ),
              Gap(16.h),
              Text(
                'No workflow activity yet',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(8.h),
              Text(
                'Approval steps will appear here once the plan is submitted for review.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
