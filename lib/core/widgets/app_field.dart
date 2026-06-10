import 'package:flutter/material.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';

export 'app_text_field.dart' show AppFieldLabel, AppTextArea;
export 'app_select_field.dart' show AppSelectField;

/// Unified form fields for dialogs and pages.
///
/// Use [AppField.text] for text inputs and [AppField.select] for dropdowns.
abstract final class AppField {
  const AppField._();

  static AppTextField text({
    Key? key,
    required TextEditingController controller,
    String? hint,
    String? label,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool readOnly = false,
    bool enabled = true,
    int minLines = 1,
    int? maxLines,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? helperText,
    double? labelSpacing,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      hint: hint,
      label: label,
      isRequired: isRequired,
      keyboardType: keyboardType,
      readOnly: readOnly,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      helperText: helperText,
      labelSpacing: labelSpacing,
    );
  }

  static AppSelectField<T> select<T>({
    Key? key,
    required T value,
    required List<T> items,
    required String Function(T value) itemLabel,
    required ValueChanged<T?> onChanged,
    String? label,
    bool isRequired = false,
    String? hint,
    Widget? prefixIcon,
    EdgeInsetsGeometry? contentPadding,
    bool enabled = true,
    double? labelSpacing,
  }) {
    return AppSelectField<T>(
      key: key,
      value: value,
      items: items,
      itemLabel: itemLabel,
      onChanged: onChanged,
      label: label,
      isRequired: isRequired,
      hint: hint,
      prefixIcon: prefixIcon,
      contentPadding: contentPadding,
      enabled: enabled,
      labelSpacing: labelSpacing,
    );
  }
}
