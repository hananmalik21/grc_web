import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxWithFields extends StatelessWidget {
  final String checkboxLabel;
  final bool checkboxValue;
  final ValueChanged<bool>? onCheckboxChanged;
  final List<Widget> fields;

  const CheckboxWithFields({
    super.key,
    required this.checkboxLabel,
    required this.checkboxValue,
    this.onCheckboxChanged,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    final callback = onCheckboxChanged;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        DigifyCheckbox(
          value: checkboxValue,
          onChanged: callback != null ? (value) => callback(value ?? false) : null,
          label: checkboxLabel,
        ),
        if (checkboxValue) Row(spacing: 12.w, children: fields),
      ],
    );
  }
}
