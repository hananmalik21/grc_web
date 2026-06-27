import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';

class WorkforceFilterChip extends StatelessWidget {
  final String label;
  final bool isDark;
  final double? width;

  const WorkforceFilterChip({
    super.key,
    required this.label,
    required this.isDark,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
        ),
        color: isDark ? AppColors.inputBgDark : Colors.white,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            height: 19 / 15.3,
          ),
        ),
      ),
    );
  }
}
