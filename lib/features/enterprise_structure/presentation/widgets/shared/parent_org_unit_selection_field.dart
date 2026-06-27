import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:flutter/material.dart';

class ParentOrgUnitSelectionField extends StatelessWidget {
  final String? parentName;
  final VoidCallback? onTap;
  final bool isLoading;
  final String label;
  final bool isRequired;

  const ParentOrgUnitSelectionField({
    super.key,
    this.parentName,
    this.onTap,
    this.isLoading = false,
    this.label = 'Parent',
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return DigifySelectionFieldWithLabel(
      label: label,
      hint: 'Select parent org unit',
      value: parentName,
      onTap: onTap,
      isRequired: isRequired,
      isEnabled: !isLoading,
    );
  }
}
