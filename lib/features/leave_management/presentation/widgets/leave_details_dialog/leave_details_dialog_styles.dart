import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double leaveDetailsSectionGap = 20.0;

BoxDecoration leaveDetailsStatsCardCardDecoration(bool isDark, {Color? color}) {
  return BoxDecoration(
    color: color ?? (isDark ? AppColors.cardBackgroundDark : Colors.white),
    borderRadius: BorderRadius.circular(10.r),
    border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
  );
}

BoxDecoration leaveDetailsCardDecoration(bool isDark, {Color? color}) {
  return BoxDecoration(
    color: color ?? (isDark ? AppColors.cardBackgroundDark : Colors.white),
    borderRadius: BorderRadius.circular(10.r),
  );
}
