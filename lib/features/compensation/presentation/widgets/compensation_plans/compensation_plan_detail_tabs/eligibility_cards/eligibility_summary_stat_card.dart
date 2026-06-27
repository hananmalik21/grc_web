import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'eligibility_tab_data.dart';

class EligibilitySummaryStatCard extends StatelessWidget {
  final EligibilitySummaryItem item;

  const EligibilitySummaryStatCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      constraints: BoxConstraints(minHeight: 100.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.lightDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.grayBorder),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.sidebarSecondaryText,
            ),
          ),
          Gap(4.h),
          Text(
            item.value,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: 24.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(4.h),
          Text(
            item.helperText,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.infoTextDark : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
