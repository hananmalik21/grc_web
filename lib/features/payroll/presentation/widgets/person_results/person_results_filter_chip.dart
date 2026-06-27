import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonResultsFilterChip extends StatelessWidget {
  const PersonResultsFilterChip({required this.label, this.onTap, super.key});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark
        ? AppColors.inputBorderDark.withValues(alpha: 0.6)
        : AppColors.textTertiary.withValues(alpha: 0.3);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF111827),
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
