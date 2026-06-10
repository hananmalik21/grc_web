import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';

export 'app_text_field.dart' show AppFieldLabel, AppTextArea, AppTextField;
export 'app_select_field.dart' show AppSelectField;

/// Unified form fields for dialogs and pages.
///
/// Use [AppField.text] for text inputs and [AppField.select] for dropdowns.
abstract final class AppField {
  const AppField._();

  static AppTextField text({
    Key? key,
    TextEditingController? controller,
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
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    Widget? prefixIcon,
    String? prefixIconAsset,
    String? initialValue,
    VoidCallback? onTap,
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
      validator: validator,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      prefixIcon: prefixIcon,
      prefixIconAsset: prefixIconAsset,
      initialValue: initialValue,
      onTap: onTap,
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  static AppTextField search({
    Key? key,
    required TextEditingController controller,
    String? hint,
    String? label,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return AppTextField.search(
      key: key,
      controller: controller,
      hint: hint,
      label: label,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static AppTextField number({
    Key? key,
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isRequired = false,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    Widget? prefixIcon,
    String? prefixIconAsset,
  }) {
    return AppTextField.number(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      isRequired: isRequired,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      prefixIcon: prefixIcon,
      prefixIconAsset: prefixIconAsset,
    );
  }

  static AppTextArea area({
    Key? key,
    TextEditingController? controller,
    String? hint,
    String? label,
    bool isRequired = false,
    int minLines = 3,
    int? maxLines,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    String? initialValue,
    bool showCharacterCount = false,
    int? maxLength,
  }) {
    return AppTextArea(
      key: key,
      controller: controller,
      hint: hint,
      label: label,
      isRequired: isRequired,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      showCharacterCount: showCharacterCount,
      maxLength: maxLength,
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
