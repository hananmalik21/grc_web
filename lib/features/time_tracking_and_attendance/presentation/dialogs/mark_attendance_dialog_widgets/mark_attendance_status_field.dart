import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_text_theme.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/mark_attendance_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceStatusField extends StatelessWidget {
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final TextEditingController controller;

  const MarkAttendanceStatusField({super.key, required this.state, required this.notifier, required this.controller});

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
                text: 'Status',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ' *',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Gap(6.h),
        DigifyTextField(
          controller: controller,
          readOnly: true,
          fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
          filled: true,
          hintText: 'Status',
        ),
      ],
    );
  }
}
