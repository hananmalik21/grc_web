import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DependencyRulesCard extends StatelessWidget {
  const DependencyRulesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return CompensationSectionCard(
      title: 'Dependency Rules',
      titleIconPath: Assets.icons.infoCircleBlue.path,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Housing Allowance',
                      style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Gap(4.h),
                Text(
                  '= 25% of Base Salary',
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                Gap(8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(4.r)),
                  child: Text(
                    'Required',
                    style: context.textTheme.labelSmall?.copyWith(color: AppColors.error, fontSize: 10.sp),
                  ),
                ),
              ],
            ),
          ),
          Gap(8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Performance Bonus', style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                Gap(4.h),
                Text(
                  '= 15% of Base Salary',
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
