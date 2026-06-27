import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OverviewShellCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final double? minBodyHeight;

  const OverviewShellCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.minBodyHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey.withValues(alpha: 0.8)),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleSmall?.copyWith(fontSize: 18.sp)),
                Gap(4.h),
                Text(
                  subtitle,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          DigifyDivider.horizontal(height: 1.h),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: minBodyHeight == null
                ? child
                : ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minBodyHeight!),
                    child: child,
                  ),
          ),
        ],
      ),
    );
  }
}
