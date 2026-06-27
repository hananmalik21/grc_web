import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftTimePickerField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TimeOfDay? time;
  final VoidCallback onTap;
  final bool isDark;
  final bool isRequired;

  const ShiftTimePickerField({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
    required this.isDark,
    this.hintText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 13.8,
                color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: 4.w),
              Text(
                '*',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 13.8,
                  color: AppColors.deleteIconRed,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
              borderRadius: BorderRadius.circular(10.r),
              color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    time?.format(context) ?? (hintText ?? 'Select Time'),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.7.sp,
                      fontWeight: FontWeight.w400,
                      color: time != null
                          ? (isDark ? context.themeTextPrimary : AppColors.textPrimary)
                          : (isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
