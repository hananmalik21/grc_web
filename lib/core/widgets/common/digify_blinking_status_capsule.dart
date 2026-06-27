import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'blinking_status_dot.dart';

class DigifyBlinkingStatusCapsule extends StatelessWidget {
  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;

  const DigifyBlinkingStatusCapsule({
    super.key,
    required this.isActive,
    required this.activeLabel,
    required this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final textColor = isActive
        ? (isDark ? AppColors.successTextDark : AppColors.successText)
        : (isDark ? AppColors.errorTextDark : AppColors.errorText);
    final bgColor = isActive
        ? (isDark ? AppColors.successBgDark.withValues(alpha: 0.24) : AppColors.successBg)
        : (isDark ? AppColors.errorBgDark.withValues(alpha: 0.24) : AppColors.errorBg);
    final borderColor = isActive
        ? (isDark ? AppColors.successBorderDark : AppColors.successBorder)
        : (isDark ? AppColors.errorBorderDark : AppColors.errorBorder);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlinkingStatusDot(color: isActive ? AppColors.success : AppColors.error, size: 6),
          Gap(6.w),
          Text(
            isActive ? activeLabel : inactiveLabel,
            style: context.textTheme.labelMedium?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
