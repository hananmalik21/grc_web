import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RangeWarningCard extends StatelessWidget {
  const RangeWarningCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    const warningColor = AppColors.warning;
    final bgColor = isDark ? const Color(0xFF2D2410) : const Color(0xFFFFFBEB);
    final borderColor = warningColor.withValues(alpha: 0.4);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 14.w, color: warningColor),
          Gap(6.w),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 11.sp,
                color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
