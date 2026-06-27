import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CheckboxWithRadioGroup extends StatelessWidget {
  final String checkboxLabel;
  final bool checkboxValue;
  final ValueChanged<bool>? onCheckboxChanged;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?>? onValueChanged;

  const CheckboxWithRadioGroup({
    super.key,
    required this.checkboxLabel,
    required this.checkboxValue,
    this.onCheckboxChanged,
    required this.options,
    required this.selectedValue,
    this.onValueChanged,
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
        if (checkboxValue)
          RadioGroup<String>(
            groupValue: selectedValue,
            onChanged: onValueChanged ?? (_) {},
            child: Row(
              children: options.map((option) {
                return Row(
                  children: [
                    Radio<String>(value: option, activeColor: AppColors.primary),
                    Text(option, style: context.textTheme.bodyMedium),
                    if (option != options.last) Gap(16.w),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
