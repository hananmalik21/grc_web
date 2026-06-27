import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentCreationPanel extends StatelessWidget {
  final Widget child;

  const ComponentCreationPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: child,
    );
  }
}

class ComponentCreationResponsiveRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double breakpoint;

  const ComponentCreationResponsiveRow({super.key, required this.left, required this.right, this.breakpoint = 700});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > breakpoint;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              Gap(24.w),
              Expanded(child: right),
            ],
          );
        }
        return Column(children: [left, Gap(20.h), right]);
      },
    );
  }
}

class ComponentCreationField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;
  final String? helpText;
  final Widget? helpWidget;
  final IconData? leadingIcon;

  const ComponentCreationField({
    super.key,
    required this.label,
    required this.child,
    this.helpText,
    this.helpWidget,
    this.leadingIcon,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelStyle = (context.textTheme.labelMedium ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w600,
      color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
    );
    final helpStyle = context.textTheme.bodySmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? context.themeTextMuted : AppColors.textSecondary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Row(
            children: [
              if (leadingIcon != null) ...[Icon(leadingIcon, size: 16.sp, color: AppColors.textSecondary), Gap(8.w)],
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: label, style: labelStyle),
                      if (isRequired)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: AppColors.error),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(8.h),
        ],
        child,
        if (helpText != null || helpWidget != null) ...[Gap(6.h), helpWidget ?? Text(helpText!, style: helpStyle)],
      ],
    );
  }
}
