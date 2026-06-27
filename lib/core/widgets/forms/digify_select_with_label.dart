import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifySelectWithLabel<T> extends StatelessWidget {
  const DigifySelectWithLabel({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    this.value,
    this.hint,
    this.onChanged,
    this.isRequired = false,
    this.fillColor,
  });

  final String label;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final T? value;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final bool isRequired;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: context.textTheme.labelMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.inputLabel,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
            children: [
              TextSpan(text: label),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.deleteIconRed,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
            ],
          ),
        ),
        Gap(8.h),
        DigifySelectField<T>(
          value: value,
          items: items,
          itemLabelBuilder: itemLabelBuilder,
          hint: hint,
          onChanged: onChanged,
          fillColor: fillColor,
        ),
      ],
    );
  }
}
