import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EssLabeledValue extends StatelessWidget {
  final String label;
  final String value;
  final TextAlign valueAlign;
  final CrossAxisAlignment alignment;

  const EssLabeledValue({
    super.key,
    required this.label,
    required this.value,
    this.valueAlign = TextAlign.left,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
        ),
        Gap(4.h),
        Text(
          value,
          textAlign: valueAlign,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
