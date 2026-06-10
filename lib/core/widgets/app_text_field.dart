import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/services/responsive/breakpoints.dart';
import 'package:grc_web/core/theme/app_colors.dart';

extension _AppResponsive on BuildContext {
  T responsiveFine<T>({
    required T mobile,
    required T tabletSmall,
    required T tabletMedium,
    required T tabletLarge,
    required T desktop,
  }) {
    return switch (AppBreakpoints.fromContext(this)) {
      ScreenLayout.mobile => mobile,
      ScreenLayout.tabletSmall => tabletSmall,
      ScreenLayout.tabletMedium => tabletMedium,
      ScreenLayout.tabletLarge => tabletLarge,
      ScreenLayout.desktop => desktop,
    };
  }
}

/// Text field adapted from Digify HR `DigifyTextField`, using GRC theme tokens.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.isRequired = false,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.prefixIconAsset,
    this.suffixIcon,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.filled = true,
    this.showBorder = true,
    this.textInputAction,
    this.inputFormatters,
    this.autovalidateMode,
    this.focusNode,
    this.fontSize,
    this.helperText,
    this.labelSpacing,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.initialValue,
  });

  /// Search field with magnifier icon (Digify `DigifyTextField.search`).
  factory AppTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hint,
    String? label,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool filled = true,
    Color? fillColor,
    Color? borderColor,
    bool showBorder = true,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      hint: hint,
      label: label,
      filled: filled,
      fillColor: fillColor ?? Colors.transparent,
      borderColor: borderColor,
      showBorder: showBorder,
      prefixIconAsset: 'assets/figma/library/svg/search.svg',
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Standard single-line field (Digify `DigifyTextField.normal`).
  factory AppTextField.normal({
    Key? key,
    TextEditingController? controller,
    String? hint,
    String? label,
    bool isRequired = false,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    int? maxLines = 1,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    String? initialValue,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      hint: hint,
      label: label,
      isRequired: isRequired,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      textDirection: textDirection,
      textAlign: textAlign,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      initialValue: initialValue,
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  /// Numeric field (Digify `DigifyTextField.number`).
  factory AppTextField.number({
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
    bool? filled,
    Color? fillColor,
    Widget? prefixIcon,
    String? prefixIconAsset,
    double? labelSpacing,
    String? helperText,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
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
      prefixIcon: prefixIcon,
      prefixIconAsset: prefixIconAsset,
      labelSpacing: labelSpacing,
      helperText: helperText,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.8.w),
    );
  }

  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final int minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final String? prefixIconAsset;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final bool filled;
  final bool showBorder;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final double? fontSize;
  final String? helperText;
  final double? labelSpacing;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final String? initialValue;

  /// Legacy constant kept for layout references; prefer [fieldHeightFor].
  static const double fieldHeight = 50;

  static double fieldHeightFor(BuildContext context) {
    return context.responsiveFine<double>(
      mobile: 40,
      tabletSmall: 44,
      tabletMedium: 46,
      tabletLarge: 40,
      desktop: 50,
    );
  }

  static double fieldVerticalPaddingFor(BuildContext context) {
    return context.responsiveFine<double>(
      mobile: 13.8,
      tabletSmall: 14.5,
      tabletMedium: 15,
      tabletLarge: 15.5,
      desktop: 16,
    );
  }

  static double fontSizeFor(BuildContext context) => 15.sp;

  static EdgeInsets contentPaddingFor(
    BuildContext context, {
    bool hasPrefix = false,
  }) {
    final vertical = fieldVerticalPaddingFor(context);
    return EdgeInsets.symmetric(
      horizontal: hasPrefix ? 16.w : 16.w,
      vertical: vertical.w,
    );
  }

  static InputDecoration decoration({
    required BuildContext context,
    String? hint,
    String? prefixIconAsset,
    Widget? prefixIcon,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    bool filled = true,
    bool showBorder = true,
    bool fixedHeight = true,
    double? fontSize,
    Widget? suffixIcon,
  }) {
    final resolvedPrefix =
        prefixIcon ??
        (prefixIconAsset == null
            ? null
            : Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                child: SvgPicture.asset(
                  prefixIconAsset,
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ));

    final resolvedFontSize = fontSize ?? fontSizeFor(context);
    final fieldMinHeight = fieldHeightFor(context);
    final effectiveFillColor = fillColor ?? Colors.transparent;
    final effectiveBorderColor = borderColor ?? AppColors.borderInput;
    final effectiveFocusedColor = focusedBorderColor ?? AppColors.primary;

    InputBorder buildBorder(double radius, Color color, {double width = 1.0}) {
      if (!showBorder) return InputBorder.none;
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color, width: width.w),
      );
    }

    return InputDecoration(
      hintText: hint,
      prefixIcon: resolvedPrefix,
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: effectiveFillColor,
      isDense: true,
      constraints: fixedHeight
          ? BoxConstraints(
              minHeight: fieldMinHeight.w,
              maxHeight: fieldMinHeight.w,
            )
          : null,
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: fieldVerticalPaddingFor(context).w,
          ),
      hintStyle: TextStyle(
        fontSize: resolvedFontSize,
        height: 1.0,
        color: AppColors.textDark.withValues(alpha: 0.5),
      ),
      errorStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColors.deletePrimary,
        height: 1.2,
      ),
      border: buildBorder(10.r, effectiveBorderColor),
      enabledBorder: buildBorder(10.r, effectiveBorderColor),
      focusedBorder: buildBorder(10.r, effectiveFocusedColor, width: 1.5),
      errorBorder: buildBorder(10.r, AppColors.deletePrimary),
      focusedErrorBorder: buildBorder(10.r, AppColors.deletePrimary, width: 1.5),
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _effectiveController.dispose();
      }
      _bindController(initial: true);
      return;
    }
    if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue) {
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
      if (initial &&
          (widget.initialValue ?? '').isNotEmpty &&
          _effectiveController.text.isEmpty) {
        final value = widget.initialValue!;
        _effectiveController.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
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

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;
    if (widget.prefixIconAsset == null) return null;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: SvgPicture.asset(
        widget.prefixIconAsset!,
        width: 20.r,
        height: 20.r,
        colorFilter: const ColorFilter.mode(
          AppColors.textSecondary,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.obscureText && widget.suffixIcon == null) {
      final isMobile = AppBreakpoints.fromContext(context).isMobile;
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
      return IconButton(
        iconSize: obscureIconSize.w,
        padding: EdgeInsets.all(obscureIconPadding.w),
        constraints: BoxConstraints.tightFor(
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
        ),
        visualDensity: isMobile ? VisualDensity.compact : VisualDensity.standard,
        splashRadius: obscureIconSize.r,
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: obscureIconSize.sp,
          color: AppColors.textSecondary,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final isMultiline = widget.minLines > 1;
    final textSize = widget.fontSize ?? AppTextField.fontSizeFor(context);
    final fieldMinHeight = AppTextField.fieldHeightFor(context);

    final field = TextFormField(
      controller: _effectiveController,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.obscureText ? 1 : (isMultiline ? widget.maxLines : 1),
      minLines: isMultiline ? widget.minLines : widget.minLines,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      style: TextStyle(
        fontSize: textSize,
        color: AppColors.textPrimary,
      ),
      decoration: AppTextField.decoration(
        context: context,
        hint: widget.hint,
        prefixIcon: _buildPrefixIcon(),
        contentPadding: widget.contentPadding,
        fillColor: widget.fillColor,
        borderColor: widget.borderColor,
        focusedBorderColor: widget.focusedBorderColor,
        filled: widget.filled,
        showBorder: widget.showBorder,
        fixedHeight: !isMultiline,
        fontSize: textSize,
        suffixIcon: _buildSuffixIcon(context),
      ),
    );

    final wrappedField = isMultiline
        ? field
        : SizedBox(height: fieldMinHeight.w, child: field);

    if (widget.label == null && widget.helperText == null) {
      return wrappedField;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppFieldLabel(label: widget.label!, isRequired: widget.isRequired),
          SizedBox(height: (widget.labelSpacing ?? 8).h),
        ],
        wrappedField,
        if (widget.helperText != null) ...[
          SizedBox(height: 4.h),
          Text(
            widget.helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

/// Shared label for [AppTextField] and [AppSelectField].
class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textLabel,
              fontFamily: 'Inter',
            ),
          ),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.requiredAsterisk,
                fontFamily: 'Inter',
              ),
            ),
        ],
      ),
    );
  }
}

/// Multiline field adapted from Digify `DigifyTextArea`.
class AppTextArea extends StatefulWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.isRequired = false,
    this.minLines = 3,
    this.maxLines,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.contentPadding,
    this.fillColor,
    this.initialValue,
    this.showCharacterCount = false,
    this.maxLength,
    this.characterCountFormatter,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final bool isRequired;
  final int minLines;
  final int? maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final String? initialValue;
  final bool showCharacterCount;
  final int? maxLength;
  final String Function(int)? characterCountFormatter;

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
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
    final effectiveMinLines = widget.minLines;
    final effectiveMaxLines = widget.maxLines ?? widget.minLines;
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

    final field = TextFormField(
      controller: _internalController,
      maxLines: effectiveMaxLines,
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
      validator: widget.validator,
      style: TextStyle(fontSize: 15.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: widget.fillColor ?? Colors.transparent,
        isDense: false,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: fieldVerticalPadding.w,
            ),
        hintStyle: TextStyle(
          fontSize: 15.sp,
          height: 1.0,
          color: AppColors.textDark.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.borderInput),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.borderInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.deletePrimary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.deletePrimary, width: 1.5),
        ),
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.deletePrimary,
          height: 1.2,
        ),
        counterText: widget.showCharacterCount ? '' : null,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppFieldLabel(label: widget.label!, isRequired: widget.isRequired),
          SizedBox(height: 8.h),
        ],
        field,
        if (widget.showCharacterCount) ...[
          SizedBox(height: 2.h),
          Text(
            widget.characterCountFormatter != null
                ? widget.characterCountFormatter!(currentLength)
                : maxLength != null
                ? '$currentLength / $maxLength'
                : '$currentLength',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isOverLimit ? AppColors.deletePrimary : AppColors.textSecondary,
              fontSize: 11.8.sp,
            ),
          ),
        ],
      ],
    );
  }
}
