import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/services/responsive/breakpoints.dart';
import 'package:grc_web/core/theme/app_colors.dart';

/// Text field adapted from Digify HR `DigifyTextField`, using GRC theme tokens.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hint,
    this.label,
    this.isRequired = false,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines,
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
  });

  /// Search field with magnifier icon (Digify `DigifyTextField.search`).
  factory AppTextField.search({
    Key? key,
    required TextEditingController controller,
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
      fillColor: fillColor ?? AppColors.surface,
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
    required TextEditingController controller,
    String? hint,
    String? label,
    bool isRequired = false,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
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
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      filled: true,
      fillColor: AppColors.surface,
    );
  }

  final TextEditingController controller;
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

  static const double fieldHeight = 55;

  static double fieldHeightFor(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isMobile) return 48;
    if (layout.isCompact) return 50;
    return fieldHeight;
  }

  static double fontSizeFor(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isMobile) return 15.sp;
    if (layout.isCompact) return 14.sp;
    return 16.sp;
  }

  static double prefixIconSizeFor(BuildContext context) {
    return AppBreakpoints.fromContext(context).isMobile ? 20.r : 16.r;
  }

  static EdgeInsets contentPaddingFor(
    BuildContext context, {
    bool hasPrefix = false,
  }) {
    final layout = AppBreakpoints.fromContext(context);
    final vertical = layout.isMobile ? 12.h : 11.5.h;
    return EdgeInsets.fromLTRB(
      hasPrefix ? 44.w : (layout.isMobile ? 14.w : 13.w),
      vertical,
      layout.isMobile ? 14.w : 13.w,
      vertical,
    );
  }

  static BoxConstraints prefixIconConstraintsFor(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isMobile) {
      return BoxConstraints(minWidth: 44.w, minHeight: 24.h);
    }
    return BoxConstraints(minWidth: 40.w, minHeight: 20.h);
  }

  static InputDecoration decoration({
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
    double? height,
    double? fontSize,
    BoxConstraints? prefixIconConstraints,
  }) {
    final hasPrefix = prefixIcon != null || prefixIconAsset != null;
    final resolvedPrefix =
        prefixIcon ??
        (prefixIconAsset == null
            ? null
            : Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                child: SvgPicture.asset(
                  prefixIconAsset,
                  width: 16.r,
                  height: 16.r,
                ),
              ));

    final resolvedHeight = height ?? fieldHeight;
    final resolvedFontSize = fontSize ?? 16.sp;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textDark.withValues(alpha: 0.5),
        fontSize: resolvedFontSize,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.32,
        height: 1,
      ),
      contentPadding:
          contentPadding ??
          EdgeInsets.fromLTRB(hasPrefix ? 41.w : 13.w, 11.5.h, 13.w, 11.5.h),
      prefixIcon: resolvedPrefix,
      prefixIconConstraints:
          prefixIconConstraints ??
          BoxConstraints(minWidth: 40.w, minHeight: 20.h),
      filled: filled,
      fillColor: fillColor ?? AppColors.surface,
      isDense: fixedHeight,
      constraints: fixedHeight
          ? BoxConstraints(
              minHeight: resolvedHeight.h,
              maxHeight: resolvedHeight.h,
            )
          : null,
      enabledBorder: showBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.borderInput,
              ),
            )
          : InputBorder.none,
      focusedBorder: showBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: focusedBorderColor ?? AppColors.primary,
                width: 2,
              ),
            )
          : InputBorder.none,
      border: showBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.borderInput,
              ),
            )
          : InputBorder.none,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: AppColors.deletePrimary),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: AppColors.deletePrimary, width: 2),
      ),
      errorStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColors.deletePrimary,
        height: 1.2,
      ),
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  Widget? _buildPrefixIcon(BuildContext context) {
    if (widget.prefixIcon != null) return widget.prefixIcon;
    if (widget.prefixIconAsset == null) return null;
    final iconSize = AppTextField.prefixIconSizeFor(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: SvgPicture.asset(
        widget.prefixIconAsset!,
        width: iconSize,
        height: iconSize,
      ),
    );
  }

  InputDecoration _buildDecoration(bool isMultiline, BuildContext context) {
    final prefixIcon = _buildPrefixIcon(context);
    final hasPrefix = prefixIcon != null;
    final height = isMultiline ? null : AppTextField.fieldHeightFor(context);
    final padding =
        widget.contentPadding ??
        (isMultiline
            ? EdgeInsets.fromLTRB(13.w, 9.h, 13.w, 9.h)
            : AppTextField.contentPaddingFor(context, hasPrefix: hasPrefix));

    return AppTextField.decoration(
      hint: widget.hint,
      prefixIcon: prefixIcon,
      contentPadding: padding,
      fillColor: widget.fillColor,
      borderColor: widget.borderColor,
      focusedBorderColor: widget.focusedBorderColor,
      filled: widget.filled,
      showBorder: widget.showBorder,
      fixedHeight: !isMultiline,
      height: height,
      fontSize: widget.fontSize ?? AppTextField.fontSizeFor(context),
      prefixIconConstraints: AppTextField.prefixIconConstraintsFor(context),
    ).copyWith(suffixIcon: _suffixIcon);
  }

  Widget? get _suffixIcon {
    if (widget.obscureText && widget.suffixIcon == null) {
      return IconButton(
        iconSize: 18.r,
        padding: EdgeInsets.all(3.r),
        constraints: BoxConstraints.tightFor(width: 34.w, height: 34.h),
        splashRadius: 18.r,
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 18.sp,
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

    final field = TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.obscureText ? 1 : (isMultiline ? widget.maxLines : 1),
      minLines: isMultiline ? widget.minLines : 1,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppColors.textDark,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.32,
        fontSize: textSize,
        height: isMultiline ? 24 / 16 : 24 / 16,
      ),
      decoration: _buildDecoration(isMultiline, context),
    );

    if (widget.label == null && widget.helperText == null) {
      return field;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppFieldLabel(label: widget.label!, isRequired: widget.isRequired),
          SizedBox(height: (widget.labelSpacing ?? 8).h),
        ],
        field,
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
    final textTheme = Theme.of(context).textTheme;
    final layout = AppBreakpoints.fromContext(context);

    return Text.rich(
      TextSpan(
        text: isRequired ? '$label ' : label,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.textLabel,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.154,
          fontSize: layout.isMobile ? 13.sp : 14.sp,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: '*',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.requiredAsterisk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]
            : null,
      ),
    );
  }
}

/// Multiline field adapted from Digify `DigifyTextArea`.
class AppTextArea extends StatefulWidget {
  const AppTextArea({
    super.key,
    required this.controller,
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
  });

  final TextEditingController controller;
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

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: widget.controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? widget.minLines,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppColors.textDark,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.32,
        height: 24 / 16,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: AppColors.textDark.withValues(alpha: 0.5),
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.32,
        ),
        filled: true,
        fillColor: widget.fillColor ?? AppColors.surface,
        contentPadding:
            widget.contentPadding ?? EdgeInsets.fromLTRB(13.w, 9.h, 13.w, 9.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.borderInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.borderInput),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.deletePrimary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: AppColors.deletePrimary,
            width: 2,
          ),
        ),
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.deletePrimary,
          height: 1.2,
        ),
      ),
    );

    if (widget.label == null) {
      return field;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(label: widget.label!, isRequired: widget.isRequired),
        SizedBox(height: 8.h),
        field,
      ],
    );
  }
}
