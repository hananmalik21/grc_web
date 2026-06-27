import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';

class MarkAttendanceNotesField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool readOnly;

  const MarkAttendanceNotesField({super.key, required this.controller, required this.onChanged, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fillColor = readOnly
        ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    return DigifyTextArea(
      controller: controller,
      labelText: 'Notes',
      hintText: 'Add notes about attendance (optional)',
      maxLines: 4,
      minLines: 4,
      readOnly: readOnly,
      fillColor: fillColor,
      onChanged: readOnly ? (_) {} : onChanged,
    );
  }
}
