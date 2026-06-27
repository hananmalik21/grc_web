import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_time_picker_dialog.dart';
import 'package:grc/core/widgets/forms/digify_date_picker_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' show DateFormat;

class DigifyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool isRequired;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final bool filled;
  final TextInputAction? textInputAction;
  final bool showBorder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final String? initialValue;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;
  final bool isArabicField;

  const DigifyTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.isRequired = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.filled = false,
    this.textInputAction,
    this.showBorder = true,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.autovalidateMode,
    this.focusNode,
    this.initialValue,
    this.fontSize,
    this.contentPadding,
    this.isArabicField = false,
  });

  /// Arabic text field with RTL input, right-aligned label, and trailing icon.
  factory DigifyTextField.arabic({
    Key? key,
    TextEditingController? controller,
    required String labelText,
    String? hintText,
    bool isRequired = false,
    Widget? suffixIcon,
    String? initialValue,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    bool readOnly = false,
    bool enabled = true,
    VoidCallback? onTap,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    Color? fillColor,
    Color? borderColor,
  }) {
    return DigifyTextField(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      isRequired: isRequired,
      suffixIcon: suffixIcon,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      readOnly: readOnly,
      enabled: enabled,
      onTap: onTap,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      fillColor: fillColor,
      borderColor: borderColor,
      filled: true,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      isArabicField: true,
    );
  }

  factory DigifyTextField.search({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    bool filled = false,
    Color? fillColor,
    Color? borderColor,
    bool showBorder = true,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return DigifyTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      filled: filled,
      fillColor: fillColor ?? Colors.transparent,
      borderColor: borderColor,
      showBorder: showBorder,
      focusNode: focusNode,
      prefixIcon: Padding(
        padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
        child: DigifyAsset(assetPath: Assets.icons.searchIcon.path, width: 20, height: 20, color: AppColors.textMuted),
      ),
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  factory DigifyTextField.normal({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    bool isRequired = false,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    int? maxLines = 1,
    bool readOnly = false,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return DigifyTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      isRequired: isRequired,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      textDirection: textDirection,
      textAlign: textAlign,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  factory DigifyTextField.number({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    bool isRequired = false,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    bool? filled,
    Color? fillColor,
  }) {
    return DigifyTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      isRequired: isRequired,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
      focusNode: focusNode,
      filled: filled ?? true,
      fillColor: fillColor ?? Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.8.w),
    );
  }

  @override
  State<DigifyTextField> createState() => _DigifyTextFieldState();
}

class _DigifyTextFieldState extends State<DigifyTextField> {
  late bool _obscureText;
  late TextEditingController _effectiveController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _bindController(initial: true);
  }

  @override
  void didUpdateWidget(covariant DigifyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _effectiveController.dispose();
      }
      _bindController(initial: true);
      return;
    }
    if (widget.controller == null && oldWidget.initialValue != widget.initialValue) {
      final nextValue = widget.initialValue ?? '';
      if (_effectiveController.text != nextValue) {
        _effectiveController.value = TextEditingValue(
          text: nextValue,
          selection: TextSelection.collapsed(offset: nextValue.length),
        );
      }
    }
  }

  void _bindController({required bool initial}) {
    if (widget.controller != null) {
      _effectiveController = widget.controller!;
      _ownsController = false;
      if (initial && (widget.initialValue ?? '').isNotEmpty && _effectiveController.text.isEmpty) {
        final v = widget.initialValue!;
        _effectiveController.value = TextEditingValue(
          text: v,
          selection: TextSelection.collapsed(offset: v.length),
        );
      }
      return;
    }
    _effectiveController = TextEditingController(text: widget.initialValue);
    _ownsController = true;
  }

  @override
  void dispose() {
    if (_ownsController) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;
    final effectiveFillColor = widget.fillColor ?? (isDark ? AppColors.inputBgDark : Colors.transparent);
    final effectiveBorderColor = widget.borderColor ?? (isDark ? AppColors.inputBorderDark : AppColors.inputBorder);
    final effectiveFocusedColor = widget.focusedBorderColor ?? AppColors.primary;
    final obscureIconSize = context.responsiveFine<double>(
      mobile: 16,
      tabletSmall: 16.5,
      tabletMedium: 17,
      tabletLarge: 17.5,
      desktop: 18,
    );
    final obscureIconPadding = context.responsiveFine<double>(
      mobile: 2,
      tabletSmall: 2,
      tabletMedium: 2.5,
      tabletLarge: 3,
      desktop: 3,
    );
    final obscureIconConstraints = BoxConstraints.tightFor(
      width: context.responsiveFine<double>(
        mobile: 28,
        tabletSmall: 30,
        tabletMedium: 32,
        tabletLarge: 32,
        desktop: 34,
      ),
      height: context.responsiveFine<double>(
        mobile: 28,
        tabletSmall: 30,
        tabletMedium: 32,
        tabletLarge: 32,
        desktop: 34,
      ),
    );
    final fieldMinHeight = 40.0;
    final fieldVerticalPadding = 12.5;

    final effectiveSuffixIcon = widget.isArabicField
        ? (widget.suffixIcon ?? _buildArabicFieldIcon(isDark))
        : widget.suffixIcon;

    Widget field = TextFormField(
      controller: _effectiveController,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: widget.fontSize ?? 15.sp,
        color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText && effectiveSuffixIcon == null
            ? IconButton(
                iconSize: obscureIconSize.w,
                padding: EdgeInsets.all(obscureIconPadding.w),
                constraints: obscureIconConstraints,
                visualDensity: isMobile ? VisualDensity.compact : VisualDensity.standard,
                splashRadius: obscureIconSize.r,
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: obscureIconSize.sp,
                  color: AppColors.textPlaceholder,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : effectiveSuffixIcon,
        prefixIconConstraints: widget.prefixIcon != null ? BoxConstraints(minWidth: 40.w, minHeight: 40.w) : null,
        suffixIconConstraints: effectiveSuffixIcon != null || widget.obscureText
            ? BoxConstraints(minWidth: 40.w, minHeight: 40.w)
            : null,
        filled: widget.filled,
        fillColor: effectiveFillColor,
        isDense: true,
        constraints: widget.maxLines == 1
            ? BoxConstraints(minHeight: fieldMinHeight.w, maxHeight: fieldMinHeight.w)
            : null,
        contentPadding:
            widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: fieldVerticalPadding.w),
        hintStyle: TextStyle(
          fontSize: widget.fontSize ?? 15.sp,
          height: 1.0,
          color: isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
        ),
        errorStyle: TextStyle(fontSize: 12.sp, color: AppColors.error, height: 1.2),
        border: _buildBorder(10.r, effectiveBorderColor),
        enabledBorder: _buildBorder(10.r, effectiveBorderColor),
        focusedBorder: _buildBorder(10.r, effectiveFocusedColor, width: 1.5),
        errorBorder: _buildBorder(10.r, AppColors.error),
        focusedErrorBorder: _buildBorder(10.r, AppColors.error, width: 1.5),
      ),
    );

    if (widget.labelText != null) {
      if (widget.isArabicField) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.labelText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (widget.isRequired)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.deleteIconRed,
                          fontFamily: 'Inter',
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Gap(8.h),
            SizedBox(height: 40.w, child: field),
          ],
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                    fontFamily: 'Inter',
                  ),
                ),
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.deleteIconRed,
                      fontFamily: 'Inter',
                    ),
                  ),
              ],
            ),
          ),
          Gap(8.h),
          SizedBox(height: 40.w, child: field),
        ],
      );
    }

    return SizedBox(height: 40.w, child: field);
  }

  Widget _buildArabicFieldIcon(bool isDark) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8.w, end: 12.w),
      child: DigifyAsset(
        assetPath: Assets.icons.userIcon.path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
  }

  InputBorder _buildBorder(double radius, Color color, {double width = 1.0}) {
    if (!widget.showBorder) return InputBorder.none;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width.w),
    );
  }
}

class DigifyTextArea extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool isRequired;
  final int maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool enabled;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCharacterCount;
  final int? maxLength;
  final String Function(int)? characterCountFormatter;
  final String? initialValue;
  final Color? fillColor;

  const DigifyTextArea({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.isRequired = false,
    this.maxLines = 3,
    this.minLines,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.showCharacterCount = false,
    this.maxLength,
    this.characterCountFormatter,
    this.initialValue,
    this.fillColor,
  });

  @override
  State<DigifyTextArea> createState() => _DigifyTextAreaState();
}

class _DigifyTextAreaState extends State<DigifyTextArea> {
  late TextEditingController _internalController;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
      _isInternalController = true;
    } else {
      _internalController = widget.controller!;
    }
    if (widget.showCharacterCount) {
      _internalController.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    if (widget.showCharacterCount) {
      _internalController.removeListener(_onTextChanged);
    }
    if (_isInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.showCharacterCount) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveMinLines = widget.minLines ?? widget.maxLines;
    final currentLength = _internalController.text.length;
    final maxLength = widget.maxLength;
    final isOverLimit = maxLength != null && currentLength > maxLength;
    final fieldVerticalPadding = context.responsiveFine<double>(
      mobile: 13.8,
      tabletSmall: 14.5,
      tabletMedium: 15,
      tabletLarge: 15.5,
      desktop: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                    fontFamily: 'Inter',
                  ),
                ),
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.deleteIconRed,
                      fontFamily: 'Inter',
                    ),
                  ),
              ],
            ),
          ),
        if (widget.labelText != null) SizedBox(height: 8.w),
        TextFormField(
          controller: _internalController,
          maxLines: widget.maxLines,
          minLines: effectiveMinLines,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          onChanged: (value) {
            if (widget.showCharacterCount) {
              setState(() {});
            }
            widget.onChanged?.call(value);
          },
          textAlign: widget.textDirection == TextDirection.rtl ? TextAlign.right : widget.textAlign,
          textDirection: widget.textDirection,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(fontSize: 15.sp, color: isDark ? context.themeTextPrimary : AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.fillColor ?? (isDark ? AppColors.inputBgDark : Colors.transparent),
            isDense: false,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: fieldVerticalPadding.w),
            hintStyle: TextStyle(
              fontSize: 15.sp,
              height: 1.0,
              color: isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
            ),
            border: _buildBorder(isDark, AppColors.inputBorder),
            enabledBorder: _buildBorder(isDark, isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
            focusedBorder: _buildBorder(isDark, AppColors.primary, width: 1.5),
            errorBorder: _buildBorder(isDark, AppColors.error),
            focusedErrorBorder: _buildBorder(isDark, AppColors.error, width: 1.5),
            counterText: widget.showCharacterCount ? '' : null,
          ),
          validator: widget.validator,
        ),
        if (widget.showCharacterCount) ...[
          SizedBox(height: 2.h),
          Text(
            widget.characterCountFormatter != null
                ? widget.characterCountFormatter!(currentLength)
                : maxLength != null
                ? '$currentLength / $maxLength'
                : '$currentLength',
            style: context.textTheme.bodySmall?.copyWith(
              color: isOverLimit ? AppColors.error : AppColors.textSecondary,
              fontSize: 11.8.sp,
            ),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _buildBorder(bool isDark, Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(
        color: isDark && color == AppColors.inputBorder ? AppColors.inputBorderDark : color,
        width: width.w,
      ),
    );
  }
}

class DigifyDateField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isRequired;
  final String? calendarIconPath;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Color? fillColor;
  final bool readOnly;
  final Widget? suffixIcon;

  final String? displayTextOverride;

  const DigifyDateField({
    super.key,
    required this.label,
    this.hintText,
    this.isRequired = true,
    this.calendarIconPath,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.fillColor,
    this.readOnly = false,
    this.suffixIcon,
    this.displayTextOverride,
  });

  @override
  State<DigifyDateField> createState() => _DigifyDateFieldState();
}

class _DigifyDateFieldState extends State<DigifyDateField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _date;

  bool get _pickerSuppressed {
    final o = widget.displayTextOverride?.trim();
    return o != null && o.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _syncFromWidget();
  }

  @override
  void didUpdateWidget(covariant DigifyDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate || widget.displayTextOverride != oldWidget.displayTextOverride) {
      _syncFromWidget();
    }
  }

  void _syncFromWidget() {
    final override = widget.displayTextOverride?.trim();
    if (override != null && override.isNotEmpty) {
      _controller.text = override;
      return;
    }
    if (widget.initialDate != null) {
      _date = widget.initialDate;
      _controller.text = DateFormat('dd/MM/yyyy').format(widget.initialDate!);
    } else {
      _date = null;
      _controller.text = '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDatePicker() async {
    final firstDate = widget.firstDate ?? DateTime(1900);
    final lastDate = widget.lastDate ?? DateTime.now();
    DateTime initialDate = _date ?? DateTime.now();

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final picked = await DigifyDatePickerDialog.show(
      context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && mounted) {
      setState(() {
        _date = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final iconPath = widget.calendarIconPath ?? Assets.icons.leaveManagementIcon.path;

    return DigifyTextField(
      labelText: widget.label,
      isRequired: widget.isRequired,
      controller: _controller,
      hintText: widget.hintText,
      readOnly: true,
      onTap: widget.readOnly || _pickerSuppressed ? null : _openDatePicker,
      filled: widget.fillColor != null,
      fillColor: widget.fillColor,
      suffixIcon: widget.suffixIcon,
      prefixIcon: Padding(
        padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
        child: DigifyAsset(
          assetPath: iconPath,
          width: 20,
          height: 20,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
        ),
      ),
    );
  }
}

class DigifyTimePickerField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isRequired;
  final TimeOfDay? value;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final Color? fillColor;
  final bool readOnly;

  const DigifyTimePickerField({
    super.key,
    required this.label,
    this.hintText,
    this.isRequired = true,
    this.value,
    this.initialTime = const TimeOfDay(hour: 8, minute: 0),
    this.onTimeSelected,
    this.fillColor,
    this.readOnly = false,
  });

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  State<DigifyTimePickerField> createState() => _DigifyTimePickerFieldState();
}

class _DigifyTimePickerFieldState extends State<DigifyTimePickerField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant DigifyTimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _syncController();
    }
  }

  void _syncController() {
    if (widget.value != null) {
      _controller.text = DigifyTimePickerField.formatTimeOfDay(widget.value!);
    } else {
      _controller.text = '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openTimePicker() async {
    final picked = await DigifyTimePickerDialog.show(context, initialTime: widget.value ?? widget.initialTime);
    if (picked != null && mounted) {
      widget.onTimeSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return DigifyTextField(
      labelText: widget.label,
      isRequired: widget.isRequired,
      controller: _controller,
      hintText: widget.hintText ?? 'Select Time',
      readOnly: true,
      onTap: widget.readOnly ? null : _openTimePicker,
      filled: widget.fillColor != null,
      fillColor: widget.fillColor,
      prefixIcon: Padding(
        padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
        child: DigifyAsset(
          assetPath: Assets.icons.clockIcon.path,
          width: 20,
          height: 20,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
        ),
      ),
    );
  }
}
