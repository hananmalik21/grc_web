import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_switch.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionFormHelpers {
  static Widget buildDropdownField<T>({
    required T? value,
    required List<T> items,
    ValueChanged<T?>? onChanged,
    String Function(T)? itemLabelProvider,
    String? hint,
    bool readOnly = false,
  }) {
    return DigifySelectField<T>(
      value: value,
      items: items,
      onChanged: readOnly ? null : onChanged,
      itemLabelBuilder: (item) => itemLabelProvider?.call(item) ?? item.toString(),
      hint: hint,
    );
  }

  static Widget buildFormField({
    required TextEditingController controller,
    String? hint,
    TextDirection? textDirection,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return DigifyTextField.normal(
      controller: controller,
      hintText: hint,
      textDirection: textDirection,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
      textAlign: textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
    );
  }

  static Widget buildFormFieldFromValue({
    required String value,
    required ValueChanged<String> onChanged,
    String? hint,
    TextDirection? textDirection,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return _ControlledFormField(
      value: value,
      onChanged: onChanged,
      hint: hint,
      textDirection: textDirection,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
    );
  }

  static Widget buildStatusSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    FontWeight? fontWeight,
  }) {
    return PositionLabeledField(
      label: label,
      fontWeight: fontWeight,
      child: Container(
        height: 48.h,
        alignment: Alignment.centerLeft,
        child: DigifySwitch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.background,
          activeTrackColor: AppColors.success,
        ),
      ),
    );
  }
}

class _ControlledFormField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;

  const _ControlledFormField({
    required this.value,
    required this.onChanged,
    this.hint,
    this.textDirection,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  State<_ControlledFormField> createState() => _ControlledFormFieldState();
}

class _ControlledFormFieldState extends State<_ControlledFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_ControlledFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller
        ..text = widget.value
        ..selection = TextSelection.collapsed(offset: widget.value.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DigifyTextField.normal(
      controller: _controller,
      hintText: widget.hint,
      textDirection: widget.textDirection,
      inputFormatters: widget.inputFormatters,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      textAlign: widget.textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
      onChanged: widget.onChanged,
    );
  }
}
