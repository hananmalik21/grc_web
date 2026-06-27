import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionDetailCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final bool? isActive;
  final Color? inactiveBackgroundColor;
  final bool isRtl;
  final double? width;

  const PositionDetailCard({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
    this.isActive,
    this.inactiveBackgroundColor,
    this.isRtl = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(label, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            Gap(6.h),
            highlight
                ? SizedBox(
                    height: 20.h,
                    child: DigifyCapsule(
                      label: value,
                      backgroundColor: isActive == true
                          ? AppColors.shiftActiveStatusBg
                          : (inactiveBackgroundColor ?? AppColors.inactiveStatusBg),
                      textColor: isActive == true ? AppColors.shiftActiveStatusText : AppColors.inactiveStatusText,
                    ),
                  )
                : Text(
                    value,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    style: context.textTheme.titleSmall?.copyWith(fontSize: 15.0, color: AppColors.dialogTitle),
                  ),
          ],
        ),
      ),
    );
  }
}

class PositionHighlightCard extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color valueColor;
  final Color? labelColor;
  final double? width;

  const PositionHighlightCard({
    super.key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    this.labelColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w500,
                color: labelColor ?? AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            Gap(6.h),
            Text(
              value,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: valueColor, height: 32 / 24),
            ),
          ],
        ),
      ),
    );
  }
}
