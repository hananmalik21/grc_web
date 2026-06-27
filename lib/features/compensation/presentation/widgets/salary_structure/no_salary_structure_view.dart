import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NoSalaryStructureView extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const NoSalaryStructureView({super.key, required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.inputBgDark.withValues(alpha: 0.3)
                  : AppColors.sidebarSearchBg,
              shape: BoxShape.circle,
            ),
            child: DigifyAsset(
              assetPath: Assets.icons.reportsMainIcon.path,
              width: 48.w,
              height: 48.w,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.sidebarCategoryText,
            ),
          ),
          Gap(24.h),
          Text(
            'No Salary Structures',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),
          SizedBox(
            width: 400.w,
            child: Text(
              'Get started by creating your first salary structure. Define compensation components, grades, and rules for your organization.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          Gap(32.h),
          AppButton.primary(
            label: 'Create First Structure',
            icon: Icons.add,
            onPressed: onCreatePressed,
          ),
        ],
      ),
    );
  }
}
