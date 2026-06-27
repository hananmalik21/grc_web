import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';

class MarkAttendanceLocationField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool readOnly;

  const MarkAttendanceLocationField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fillColor = readOnly
        ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    return DigifyTextField(
      controller: controller,
      labelText: 'Location',
      hintText: 'Enter location',
      isRequired: true,
      readOnly: readOnly,
      fillColor: fillColor,
      filled: true,
      onChanged: readOnly ? (_) {} : onChanged,
    );
  }
}
