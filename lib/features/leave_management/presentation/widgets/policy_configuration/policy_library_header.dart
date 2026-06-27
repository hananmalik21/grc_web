import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyLibraryHeader extends StatelessWidget {
  const PolicyLibraryHeader({required this.isDark, required this.count, super.key});

  final bool isDark;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Policy Library',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(4.h),
              Text(
                'Choose a leave type to review eligibility, accrual, carry forward, forfeits, and encashment rules.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        Gap(10.w),
        CountPill(count: count, isDark: isDark),
      ],
    );
  }
}

class CountPill extends StatelessWidget {
  const CountPill({required this.count, required this.isDark, super.key});

  final int count;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.18) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        '$count total',
        style: context.textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
