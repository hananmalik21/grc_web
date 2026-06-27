import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SubmitPayrollFlowReviewField extends StatelessWidget {
  const SubmitPayrollFlowReviewField({required this.label, required this.value, this.isRequired = false, super.key});

  final String label;
  final String value;
  final bool isRequired;

  static const emptyValue = '—';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final fieldBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final fieldBorder = isDark ? AppColors.cardBorderDark : AppColors.grayBg;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(17.w, 13.h, 17.w, 13.h),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label.toUpperCase(),
                  style: context.textTheme.labelLarge?.copyWith(fontSize: 11.sp, color: labelColor),
                ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: context.textTheme.labelLarge?.copyWith(fontSize: 11.sp, color: AppColors.error),
                  ),
              ],
            ),
          ),
          Gap(4.h),
          Text(
            value,
            style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: valueColor),
          ),
        ],
      ),
    );
  }
}
