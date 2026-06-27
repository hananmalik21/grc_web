import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:gap/gap.dart';

class PositionDialogSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PositionDialogSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.titleSmall?.copyWith(fontSize: 15.0, color: AppColors.dialogTitle)),
        Gap(16.h),
        Wrap(spacing: 16.w, runSpacing: 16.h, children: children),
      ],
    );
  }
}

class PositionFormRow extends StatelessWidget {
  final List<Widget> children;

  const PositionFormRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    if (context.isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: entry.value,
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final isLast = entry.key == children.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 16.w),
            child: entry.value,
          ),
        );
      }).toList(),
    );
  }
}

class PositionLabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isRequired;
  final FontWeight? fontWeight;

  const PositionLabeledField({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    color: AppColors.deleteIconRed,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(6.h),
        child,
      ],
    );
  }
}
