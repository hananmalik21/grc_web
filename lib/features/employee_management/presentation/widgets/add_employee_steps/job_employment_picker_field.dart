import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:flutter/material.dart';

class JobEmploymentPickerField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? value;
  final String hint;
  final VoidCallback? onTap;
  final bool isEnabled;

  const JobEmploymentPickerField({
    super.key,
    required this.label,
    required this.hint,
    this.onTap,
    this.isRequired = false,
    this.value,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DigifySelectionFieldWithLabel(
      label: label,
      isRequired: isRequired,
      hint: hint,
      value: value,
      onTap: onTap,
      isEnabled: isEnabled && onTap != null,
      backgroundColor: Colors.white,
      borderColor: AppColors.borderGrey,
      hintColor: AppColors.textSecondary.withValues(alpha: 0.6),
      valueColor: AppColors.textPrimary,
    );
  }
}
