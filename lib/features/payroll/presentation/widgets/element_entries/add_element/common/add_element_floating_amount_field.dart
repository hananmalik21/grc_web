import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddElementFloatingAmountField extends StatelessWidget {
  const AddElementFloatingAmountField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.isRequired = false,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return DigifyTextField(
      initialValue: value,
      labelText: label,
      hintText: hintText,
      isRequired: isRequired,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      filled: true,
      onChanged: onChanged,
    );
  }
}
