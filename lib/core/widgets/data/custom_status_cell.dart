import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Status badge widget for Active/Inactive states
class CustomStatusCell extends StatelessWidget {
  final bool isActive;
  final String? activeLabel;
  final String? inactiveLabel;

  const CustomStatusCell({super.key, required this.isActive, this.activeLabel, this.inactiveLabel});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final label = isActive ? (activeLabel ?? 'Active') : (inactiveLabel ?? 'Inactive');

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7))
            : (isDark ? AppColors.grayBgDark : AppColors.grayBg),
        borderRadius: BorderRadius.circular(100.r), // Pill shape
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isActive
              ? (isDark ? AppColors.successTextDark : const Color(0xFF016630))
              : (isDark ? AppColors.grayTextDark : AppColors.grayText),
          height: 16 / 12,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
