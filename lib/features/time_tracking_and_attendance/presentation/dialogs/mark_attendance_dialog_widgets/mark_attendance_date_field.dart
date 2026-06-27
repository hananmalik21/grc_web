import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';

class MarkAttendanceDateField extends StatelessWidget {
  final DateTime? initialDate;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<DateTime>? onDateSelected;

  const MarkAttendanceDateField({
    super.key,
    required this.initialDate,
    this.enabled = true,
    this.readOnly = false,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isDisabled = !enabled || readOnly;
    final fillColor = isDisabled
        ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    return DigifyDateField(
      key: ValueKey<String>('${initialDate?.toIso8601String() ?? 'null'}_$enabled'),
      label: 'Date',
      isRequired: true,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      hintText: readOnly ? null : (enabled ? 'Select date' : 'Select employee first'),
      fillColor: fillColor,
      readOnly: !enabled || readOnly,
      onDateSelected: onDateSelected,
    );
  }
}
