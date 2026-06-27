import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/breakpoints.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppButtonType { primary, secondary, outline, danger, dotted, text }

/// Legacy alias kept for existing GRC call sites.
enum AppButtonVariant { primary, secondary, outlined, ghost, danger, dotted, icon }

enum AppButtonSize { lg, md, sm, save, icon }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.icon,
    this.iconAsset,
    this.svgPath,
    this.trailing,
    this.iconColor,
    this.svgAssetColor,
    this.iconSize,
    this.borderColor,
    this.backgroundColor,
    this.foregroundColor,
    this.fullWidth = false,
    this.isLoading = false,
    this.width,
    this.height,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.bordered = true,
  });

  const AppButton.icon({
    super.key,
    required this.iconAsset,
    this.onPressed,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.bordered = true,
    this.iconSize,
    this.padding,
    this.size = AppButtonSize.icon,
    this.isLoading = false,
  }) : label = '',
       variant = AppButtonVariant.icon,
       type = null,
       icon = null,
       svgPath = null,
       trailing = null,
       svgAssetColor = null,
       foregroundColor = null,
       fullWidth = false,
       width = null,
       height = null,
       fontSize = null,
       borderRadius = null;

  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    Color? svgAssetColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.primary,
      icon: icon,
      svgPath: svgPath,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      svgAssetColor: svgAssetColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    Color? svgAssetColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.secondary,
      icon: icon,
      svgPath: svgPath,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      svgAssetColor: svgAssetColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.outline({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    Color? svgAssetColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.lg,
    Color? borderColor,
    Color? foregroundColor,
    Color? backgroundColor,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      icon: icon,
      svgPath: svgPath,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      svgAssetColor: svgAssetColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
      borderColor: borderColor,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  factory AppButton.danger({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    Color? svgAssetColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.danger,
      variant: AppButtonVariant.danger,
      icon: icon,
      svgPath: svgPath,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      svgAssetColor: svgAssetColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.dangerOutline({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    String? iconAsset,
    Widget? trailing,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      variant: AppButtonVariant.outlined,
      icon: icon,
      svgPath: svgPath,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: _EnhancedColors.deletePrimary,
      svgAssetColor: _EnhancedColors.deletePrimary,
      foregroundColor: _EnhancedColors.deletePrimary,
      borderColor: _EnhancedColors.deleteBorderRed,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      padding: padding,
      borderRadius: borderRadius,
      size: size,
    );
  }

  factory AppButton.dotted({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    Color? svgAssetColor,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? foregroundColor,
    Color? backgroundColor,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.dotted,
      variant: AppButtonVariant.dotted,
      icon: icon,
      svgPath: svgPath,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      svgAssetColor: svgAssetColor,
      width: width,
      height: height,
      fontSize: fontSize,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      iconSize: iconSize,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    Color? svgAssetColor,
    double? iconSize,
    double? width,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? foregroundColor,
  }) {
    return AppButton._text(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      svgPath: svgPath,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      svgAssetColor: svgAssetColor,
      iconSize: iconSize,
      width: width,
      fontSize: fontSize,
      padding: padding ?? EdgeInsets.zero,
      borderRadius: borderRadius,
      foregroundColor: foregroundColor,
    );
  }

  const AppButton._text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.svgPath,
    this.iconAsset,
    this.trailing,
    this.iconColor,
    this.svgAssetColor,
    this.iconSize,
    this.width,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.foregroundColor,
  }) : type = AppButtonType.text,
       variant = AppButtonVariant.primary,
       size = AppButtonSize.lg,
       borderColor = null,
       backgroundColor = null,
       fullWidth = false,
       height = null,
       bordered = true;

  factory AppButton.back({
    Key? key,
    required String iconAsset,
    required VoidCallback? onPressed,
    Color? borderColor,
    Color? iconColor,
  }) {
    return AppButton.icon(
      key: key,
      iconAsset: iconAsset,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      borderColor: borderColor ?? _EnhancedColors.borderInput,
      iconColor: iconColor ?? _EnhancedColors.textPrimary,
      iconSize: 20.r,
    );
  }

  factory AppButton.export({
    Key? key,
    required String label,
    required String iconAsset,
    VoidCallback? onPressed,
    double? iconSize,
    Color? foregroundColor,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton.outline(
      key: key,
      label: label,
      iconAsset: iconAsset,
      iconSize: iconSize ?? 16.r,
      foregroundColor: foregroundColor ?? _EnhancedColors.textDark,
      onPressed: onPressed,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.close({
    Key? key,
    required VoidCallback? onPressed,
    String iconAsset = 'assets/grc/figma/library/svg/close_white.svg',
    Color iconColor = Colors.white,
    double? iconSize,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton.icon(
      key: key,
      iconAsset: iconAsset,
      onPressed: onPressed,
      bordered: false,
      iconColor: iconColor,
      iconSize: iconSize ?? 28.r,
      padding: padding ?? EdgeInsets.all(8.r),
    );
  }

  factory AppButton.eye({
    Key? key,
    required String iconAsset,
    VoidCallback? onPressed,
    double? iconSize,
    bool compact = false,
  }) {
    return AppButton(
      key: key,
      label: '',
      type: AppButtonType.outline,
      variant: AppButtonVariant.outlined,
      iconAsset: iconAsset,
      iconSize: iconSize ?? 16.r,
      iconColor: _EnhancedColors.textPrimary,
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16.w : 17.w, vertical: compact ? 10.h : 12.h),
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType? type;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final String? iconAsset;
  final String? svgPath;
  final Widget? trailing;
  final Color? iconColor;
  final Color? svgAssetColor;
  final double? iconSize;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool fullWidth;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool bordered;

  String? get _assetPath => iconAsset ?? svgPath;

  Color? get _assetColor => iconColor ?? svgAssetColor;

  bool get _usesEnhancedLayout =>
      variant == AppButtonVariant.icon ||
      type == null ||
      iconAsset != null ||
      size != AppButtonSize.lg ||
      fullWidth ||
      variant != AppButtonVariant.primary;

  AppButtonType get _resolvedType {
    if (type != null) return type!;
    return switch (variant) {
      AppButtonVariant.primary => AppButtonType.primary,
      AppButtonVariant.secondary => AppButtonType.secondary,
      AppButtonVariant.outlined => AppButtonType.outline,
      AppButtonVariant.ghost => AppButtonType.text,
      AppButtonVariant.danger => AppButtonType.danger,
      AppButtonVariant.dotted => AppButtonType.dotted,
      AppButtonVariant.icon => AppButtonType.primary,
    };
  }

  AppButtonVariant get _styleVariant {
    if (variant != AppButtonVariant.primary || type == null) {
      return variant;
    }
    return switch (type!) {
      AppButtonType.secondary => AppButtonVariant.secondary,
      AppButtonType.outline => AppButtonVariant.outlined,
      AppButtonType.text => AppButtonVariant.ghost,
      AppButtonType.danger => AppButtonVariant.danger,
      AppButtonType.dotted => AppButtonVariant.dotted,
      _ => AppButtonVariant.primary,
    };
  }

  bool get _isTextButton => _resolvedType == AppButtonType.text;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.icon) {
      return _IconButtonView(
        iconAsset: _assetPath,
        onPressed: onPressed,
        iconColor: _assetColor,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        bordered: bordered,
        iconSize: iconSize,
        padding: padding,
        isLoading: isLoading,
      );
    }

    if (_isTextButton) {
      return _buildTextButton(context);
    }

    if (_usesEnhancedLayout) {
      return _buildEnhancedButton(context);
    }

    return _buildLegacyButton(context);
  }

  Widget _buildTextButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDisabled = isLoading || onPressed == null;
    final effectivePadding = padding ?? EdgeInsets.zero;
    final effectiveFontSize = fontSize ?? 14.sp;
    final resolvedIconSize = iconSize ?? 16.r;
    final baseForeground = foregroundColor ?? _assetColor ?? AppColors.primary;
    final contentColor = isDisabled ? AppColors.textMuted : baseForeground;

    final labelStyle = textTheme.bodySmall?.copyWith(
      color: contentColor,
      fontSize: effectiveFontSize,
      fontWeight: FontWeight.w500,
      height: 1.0,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_assetPath != null) ...[
          DigifyAsset(
            assetPath: _assetPath!,
            width: resolvedIconSize,
            height: resolvedIconSize,
            color: _assetColor ?? contentColor,
          ),
          if (label.isNotEmpty) SizedBox(width: 8.w),
        ] else if (icon != null) ...[
          Icon(icon, size: resolvedIconSize, color: _assetColor ?? contentColor),
          if (label.isNotEmpty) SizedBox(width: 8.w),
        ],
        if (label.isNotEmpty) Text(label, style: labelStyle),
        if (trailing != null) ...[if (label.isNotEmpty) SizedBox(width: 8.w), trailing!],
      ],
    );

    final child = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Opacity(opacity: isLoading ? 0.0 : 1.0, child: content),
        if (isLoading) AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: 16.sp),
      ],
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        child: Padding(
          padding: effectivePadding,
          child: width != null ? SizedBox(width: width?.w, child: child) : child,
        ),
      ),
    );
  }

  Widget _buildLegacyButton(BuildContext context) {
    final legacyType = _resolvedType;
    final effectiveHeight = height ?? 40.w;
    final effectiveWidth = width?.w;
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(10.r);
    final effectiveFontSize = fontSize ?? 15.sp;
    final isDisabled = isLoading || onPressed == null;
    final bgColor = _legacyBackgroundColor(legacyType, isDisabled);
    final contentColor = isDisabled
        ? (legacyType == AppButtonType.outline
              ? AppColors.textMuted
              : legacyType == AppButtonType.dotted
              ? AppColors.textMuted
              : Colors.white70)
        : _legacyTextColor(legacyType);
    final borderProp = _legacyBorder(legacyType);
    final dottedBorder = _legacyDottedBorder(legacyType);
    final displayLabel = legacyType == AppButtonType.dotted ? label.toUpperCase() : label;

    final children = _buildContentChildren(
      contentColor: contentColor,
      effectiveFontSize: effectiveFontSize,
      displayLabel: displayLabel,
      legacyType: legacyType,
      useLegacyLabelStyle: true,
    );

    return Material(
      color: Colors.transparent,
      child: legacyType == AppButtonType.dotted
          ? _buildLegacyDottedButton(
              effectiveHeight: effectiveHeight,
              effectiveWidth: effectiveWidth,
              effectivePadding: effectivePadding,
              effectiveBorderRadius: effectiveBorderRadius,
              bgColor: bgColor,
              contentColor: contentColor,
              dottedBorder: dottedBorder ?? const BorderSide(color: AppColors.cardBorder, width: 1.5),
              children: children,
              isDisabled: isDisabled,
            )
          : effectiveWidth != null
          ? SizedBox(
              width: effectiveWidth,
              height: effectiveHeight,
              child: Ink(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: effectiveBorderRadius,
                  border: borderProp != null ? Border.fromBorderSide(borderProp) : null,
                ),
                child: _buildInkWell(
                  legacyType: legacyType,
                  borderRadius: effectiveBorderRadius,
                  isDisabled: isDisabled,
                  child: Container(
                    padding: effectivePadding,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: isLoading ? 0.0 : 1.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          ),
                        ),
                        if (isLoading) AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: 20.sp),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Ink(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: effectiveBorderRadius,
                border: borderProp != null ? Border.fromBorderSide(borderProp) : null,
              ),
              child: _buildInkWell(
                legacyType: legacyType,
                borderRadius: effectiveBorderRadius,
                isDisabled: isDisabled,
                child: SizedBox(
                  height: effectiveHeight,
                  child: Padding(
                    padding: effectivePadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: isLoading
                          ? [AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: 20.sp)]
                          : children,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEnhancedButton(BuildContext context) {
    if (_resolvedType == AppButtonType.dotted) {
      return _buildEnhancedDottedButton(context);
    }

    final textTheme = Theme.of(context).textTheme;
    final isMobile = AppBreakpoints.fromContext(context).isMobile;
    final styleVariant = _styleVariant;
    final metrics = _resolveMetrics(styleVariant, size);
    final resolvedMetrics = isMobile && fullWidth
        ? _SizeMetrics(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
            fontSize: 15.sp,
            lineHeight: 22,
            iconSize: 20.r,
          )
        : metrics;
    final colors = _colorsFor(styleVariant);
    final isDisabled = isLoading || onPressed == null;
    final resolvedIconSize = iconSize ?? resolvedMetrics.iconSize;
    final resolvedBackground = _resolveBackground(backgroundColor ?? colors.background, styleVariant, isDisabled);
    final resolvedForeground = _resolveForeground(foregroundColor ?? colors.foreground, styleVariant, isDisabled);
    final resolvedBorder = borderColor ?? colors.border;
    final effectivePadding = padding ?? resolvedMetrics.padding;
    final effectiveFontSize = fontSize ?? resolvedMetrics.fontSize;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(10.r);

    final labelStyle =
        (_labelStyle(
                  textTheme: textTheme,
                  styleVariant: styleVariant,
                  color: resolvedForeground,
                  fontSize: effectiveFontSize,
                  lineHeight: resolvedMetrics.lineHeight,
                ) ??
                TextStyle(fontSize: effectiveFontSize, color: resolvedForeground))
            .copyWith(height: 1.0);

    Widget labelWidget(String text) => Text(
      text,
      style: labelStyle,
      maxLines: fullWidth ? 1 : null,
      overflow: fullWidth ? TextOverflow.ellipsis : null,
      textAlign: TextAlign.center,
    );

    final content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_assetPath != null) ...[
          DigifyAsset(
            assetPath: _assetPath!,
            width: resolvedIconSize,
            height: resolvedIconSize,
            color: _assetColor ?? resolvedForeground,
          ),
          if (label.isNotEmpty) SizedBox(width: 8.w),
        ] else if (icon != null) ...[
          Icon(icon, size: resolvedIconSize, color: _assetColor ?? resolvedForeground),
          if (label.isNotEmpty) SizedBox(width: 8.w),
        ],
        if (label.isNotEmpty) fullWidth ? Flexible(fit: FlexFit.loose, child: labelWidget(label)) : labelWidget(label),
        if (trailing != null) ...[if (label.isNotEmpty) SizedBox(width: 8.w), trailing!],
      ],
    );

    final child = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Opacity(opacity: isLoading ? 0.0 : 1.0, child: content),
        if (isLoading) AppLoadingIndicator(type: LoadingType.circle, color: resolvedForeground, size: 20.sp),
      ],
    );

    final effectiveHeight = height ?? 40.w;
    final effectiveWidth = fullWidth ? double.infinity : width?.w;
    final decoration = BoxDecoration(
      color: resolvedBackground,
      borderRadius: effectiveRadius,
      border: colors.borderWidth > 0 ? Border.all(color: resolvedBorder, width: colors.borderWidth) : null,
    );

    return Material(
      color: Colors.transparent,
      child: effectiveWidth != null
          ? SizedBox(
              width: effectiveWidth,
              height: effectiveHeight,
              child: Ink(
                decoration: decoration,
                child: InkWell(
                  onTap: isDisabled ? null : onPressed,
                  borderRadius: effectiveRadius,
                  child: Container(padding: effectivePadding, alignment: Alignment.center, child: child),
                ),
              ),
            )
          : Ink(
              decoration: decoration,
              child: InkWell(
                onTap: isDisabled ? null : onPressed,
                borderRadius: effectiveRadius,
                child: SizedBox(
                  height: effectiveHeight,
                  child: Padding(padding: effectivePadding, child: child),
                ),
              ),
            ),
    );
  }

  Widget _buildEnhancedDottedButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = _colorsFor(AppButtonVariant.dotted);
    final resolvedIconSize = iconSize ?? 24.r;
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(10.r);
    final resolvedForeground = foregroundColor ?? colors.foreground;
    final resolvedBackground = backgroundColor ?? colors.background;
    final resolvedBorder = borderColor ?? colors.border;
    final effectiveFontSize = fontSize ?? 16.sp;
    final isDisabled = isLoading || onPressed == null;
    final contentColor = isDisabled ? _EnhancedColors.textSecondary : resolvedForeground;

    final children = <Widget>[
      if (_assetPath != null) ...[
        DigifyAsset(
          assetPath: _assetPath!,
          width: resolvedIconSize,
          height: resolvedIconSize,
          color: _assetColor ?? contentColor,
        ),
        SizedBox(width: 8.w),
      ] else if (icon != null) ...[
        Icon(icon, size: resolvedIconSize, color: _assetColor ?? contentColor),
        SizedBox(width: 8.w),
      ],
      Text(
        label,
        style: textTheme.titleSmall?.copyWith(
          color: contentColor,
          fontWeight: FontWeight.w600,
          fontSize: effectiveFontSize,
          letterSpacing: -0.32,
        ),
        strutStyle: _buttonStrut(fontSize: effectiveFontSize, lineHeight: 24),
        textHeightBehavior: _buttonTextHeight,
      ),
    ];

    return SizedBox(
      width: fullWidth ? double.infinity : width?.w,
      height: height,
      child: CustomPaint(
        painter: _DottedBorderPainter(borderColor: resolvedBorder, borderRadius: effectiveRadius, strokeWidth: 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: effectiveRadius,
            child: Ink(
              decoration: BoxDecoration(
                color: isDisabled && !isLoading
                    ? resolvedBackground
                    : (isLoading ? resolvedBackground.withValues(alpha: 0.5) : resolvedBackground),
                borderRadius: effectiveRadius,
              ),
              padding: effectivePadding,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: isLoading ? 0.0 : 1.0,
                    child: Row(
                      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  ),
                  if (isLoading) AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: 20.sp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentChildren({
    required Color contentColor,
    required double effectiveFontSize,
    required String displayLabel,
    required AppButtonType legacyType,
    required bool useLegacyLabelStyle,
  }) {
    final children = <Widget>[];
    if (icon != null) {
      children.add(Icon(icon, size: iconSize ?? 20.sp, color: contentColor));
    } else if (_assetPath != null) {
      children.add(
        DigifyAsset(
          assetPath: _assetPath!,
          width: iconSize ?? 20,
          height: iconSize ?? 20,
          color: _assetColor ?? contentColor,
        ),
      );
    }
    if ((icon != null || _assetPath != null) && label.isNotEmpty) {
      children.add(SizedBox(width: 8.w));
    }
    if (label.isNotEmpty) {
      children.add(
        useLegacyLabelStyle
            ? Builder(
                builder: (context) => Text(
                  displayLabel,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: effectiveFontSize,
                    fontWeight: legacyType == AppButtonType.dotted ? FontWeight.w700 : FontWeight.w600,
                    color: contentColor,
                    height: 1.0,
                    letterSpacing: legacyType == AppButtonType.dotted ? 0.3 : null,
                  ),
                ),
              )
            : Text(displayLabel),
      );
    }
    if (trailing != null) {
      if (label.isNotEmpty) children.add(SizedBox(width: 8.w));
      children.add(trailing!);
    }
    return children;
  }

  Color _legacyBackgroundColor(AppButtonType legacyType, bool isDisabled) {
    if (isDisabled || onPressed == null) {
      switch (legacyType) {
        case AppButtonType.outline:
        case AppButtonType.text:
          return Colors.transparent;
        case AppButtonType.primary:
        case AppButtonType.secondary:
        case AppButtonType.danger:
        case AppButtonType.dotted:
          return _legacyBaseBackgroundColor(legacyType).withValues(alpha: 0.5);
      }
    }
    return _legacyBaseBackgroundColor(legacyType);
  }

  Color _legacyBaseBackgroundColor(AppButtonType legacyType) {
    if (backgroundColor != null) return backgroundColor!;
    return switch (legacyType) {
      AppButtonType.primary => AppColors.primary,
      AppButtonType.secondary => AppColors.cardBackgroundGrey,
      AppButtonType.outline => Colors.transparent,
      AppButtonType.danger => AppColors.error,
      AppButtonType.dotted || AppButtonType.text => backgroundColor ?? Colors.transparent,
    };
  }

  Color _legacyTextColor(AppButtonType legacyType) {
    if (foregroundColor != null) return foregroundColor!;
    return switch (legacyType) {
      AppButtonType.primary || AppButtonType.secondary || AppButtonType.danger => Colors.white,
      AppButtonType.outline => AppColors.blackTextColor,
      AppButtonType.text => foregroundColor ?? AppColors.primary,
      AppButtonType.dotted => foregroundColor ?? AppColors.sidebarCategoryText,
    };
  }

  BorderSide? _legacyBorder(AppButtonType legacyType) {
    if (legacyType == AppButtonType.outline) {
      return BorderSide(color: borderColor ?? AppColors.borderGrey, width: 1);
    }
    return null;
  }

  BorderSide? _legacyDottedBorder(AppButtonType legacyType) {
    if (legacyType != AppButtonType.dotted) return null;
    return BorderSide(color: borderColor ?? AppColors.cardBorder, width: 2);
  }

  Color _resolveBackground(Color base, AppButtonVariant styleVariant, bool isDisabled) {
    if (!isDisabled) return base;
    return switch (styleVariant) {
      AppButtonVariant.outlined || AppButtonVariant.ghost => base,
      _ => base.withValues(alpha: 0.5),
    };
  }

  Color _resolveForeground(Color base, AppButtonVariant styleVariant, bool isDisabled) {
    if (!isDisabled) return base;
    return switch (styleVariant) {
      AppButtonVariant.outlined || AppButtonVariant.ghost || AppButtonVariant.dotted => _EnhancedColors.textSecondary,
      _ => Colors.white70,
    };
  }

  TextStyle? _labelStyle({
    required TextTheme textTheme,
    required AppButtonVariant styleVariant,
    required Color color,
    required double fontSize,
    required double lineHeight,
  }) {
    final base = styleVariant == AppButtonVariant.ghost
        ? textTheme.bodySmall
        : size == AppButtonSize.sm
        ? textTheme.bodyLarge
        : textTheme.titleSmall;

    return base?.copyWith(
      color: color,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: styleVariant == AppButtonVariant.ghost ? FontWeight.w500 : null,
    );
  }

  _ButtonColors _colorsFor(AppButtonVariant styleVariant) {
    return switch (styleVariant) {
      AppButtonVariant.primary => const _ButtonColors(background: AppColors.primary, foreground: Colors.white),
      AppButtonVariant.secondary => const _ButtonColors(
        background: _EnhancedColors.primaryLightBg,
        foreground: _EnhancedColors.primaryDark,
        border: AppColors.primary,
        borderWidth: 2,
      ),
      AppButtonVariant.outlined => const _ButtonColors(
        background: _EnhancedColors.surface,
        foreground: _EnhancedColors.textDark,
        border: _EnhancedColors.borderInput,
      ),
      AppButtonVariant.ghost => const _ButtonColors(
        background: Colors.transparent,
        foreground: AppColors.primary,
        borderWidth: 0,
      ),
      AppButtonVariant.danger => const _ButtonColors(
        background: _EnhancedColors.deletePrimary,
        foreground: Colors.white,
      ),
      AppButtonVariant.dotted => const _ButtonColors(
        background: _EnhancedColors.surface,
        foreground: AppColors.primary,
        border: _EnhancedColors.borderInput,
      ),
      AppButtonVariant.icon => const _ButtonColors(),
    };
  }

  _SizeMetrics _resolveMetrics(AppButtonVariant styleVariant, AppButtonSize buttonSize) {
    final base = _sizeMetrics(buttonSize);

    return switch (styleVariant) {
      AppButtonVariant.secondary => base,
      AppButtonVariant.outlined => _SizeMetrics(
        padding: EdgeInsets.symmetric(
          horizontal: buttonSize == AppButtonSize.sm ? 12.w : 17.w,
          vertical: buttonSize == AppButtonSize.sm ? 6.h : 9.h,
        ),
        fontSize: base.fontSize,
        lineHeight: base.lineHeight,
        iconSize: base.iconSize,
      ),
      AppButtonVariant.ghost => _SizeMetrics(
        padding: EdgeInsets.zero,
        fontSize: base.fontSize,
        lineHeight: base.lineHeight,
        iconSize: base.iconSize,
      ),
      _ => base,
    };
  }

  _SizeMetrics _sizeMetrics(AppButtonSize buttonSize) {
    return switch (buttonSize) {
      AppButtonSize.lg => _SizeMetrics(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        fontSize: 16.sp,
        lineHeight: 24,
        iconSize: 20.r,
      ),
      AppButtonSize.md => _SizeMetrics(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        fontSize: 16.sp,
        lineHeight: 24,
        iconSize: 20.r,
      ),
      AppButtonSize.sm => _SizeMetrics(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        fontSize: 14.sp,
        lineHeight: 20,
        iconSize: 18.r,
      ),
      AppButtonSize.save => _SizeMetrics(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 9.h),
        fontSize: 16.sp,
        lineHeight: 24,
        iconSize: 24.r,
      ),
      AppButtonSize.icon => _SizeMetrics(padding: EdgeInsets.zero, fontSize: 14.sp, lineHeight: 20, iconSize: 24.r),
    };
  }

  Widget _buildInkWell({
    required AppButtonType legacyType,
    required BorderRadius borderRadius,
    required bool isDisabled,
    required Widget child,
  }) {
    final suppressSplash = legacyType == AppButtonType.text;

    return InkWell(
      onTap: isDisabled ? null : onPressed,
      borderRadius: borderRadius.resolve(TextDirection.ltr),
      splashFactory: suppressSplash ? NoSplash.splashFactory : null,
      highlightColor: suppressSplash ? Colors.transparent : null,
      hoverColor: suppressSplash ? Colors.transparent : null,
      child: child,
    );
  }

  Widget _buildLegacyDottedButton({
    required double effectiveHeight,
    required double? effectiveWidth,
    required EdgeInsetsGeometry effectivePadding,
    required BorderRadius effectiveBorderRadius,
    required Color bgColor,
    required Color contentColor,
    required BorderSide dottedBorder,
    required List<Widget> children,
    required bool isDisabled,
  }) {
    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: CustomPaint(
        painter: _DottedBorderPainter(
          borderColor: dottedBorder.color,
          borderRadius: effectiveBorderRadius,
          strokeWidth: dottedBorder.width,
        ),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: effectiveBorderRadius.resolve(TextDirection.ltr),
          child: Container(
            padding: effectivePadding,
            decoration: BoxDecoration(color: bgColor, borderRadius: effectiveBorderRadius),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: isLoading ? 0.0 : 1.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
                if (isLoading) AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButtonView extends StatelessWidget {
  const _IconButtonView({
    required this.iconAsset,
    this.onPressed,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.bordered = true,
    this.iconSize,
    this.padding,
    this.isLoading = false,
  });

  final String? iconAsset;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool bordered;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  Widget _iconContent(double resolvedSize) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0.0 : 1.0,
          child: iconAsset == null
              ? const SizedBox.shrink()
              : DigifyAsset(assetPath: iconAsset!, width: resolvedSize, height: resolvedSize, color: iconColor),
        ),
        if (isLoading)
          AppLoadingIndicator(
            type: LoadingType.circle,
            color: iconColor ?? AppColors.primary,
            size: resolvedSize * 0.65,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!bordered) {
      final resolvedSize = iconSize ?? 32.r;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(4.r),
          child: Padding(
            padding: padding ?? EdgeInsets.all(2.r),
            child: SizedBox(width: resolvedSize, height: resolvedSize, child: _iconContent(resolvedSize)),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: backgroundColor ?? _EnhancedColors.primaryLightBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: borderColor ?? _EnhancedColors.editBorderBlue),
          ),
          child: Center(child: _iconContent(iconSize ?? 24.r)),
        ),
      ),
    );
  }
}

abstract final class _EnhancedColors {
  static const Color primaryDark = Color(0xFF1447E6);
  static const Color primaryLightBg = Color(0xFFEFF6FF);
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF6A7282);
  static const Color textDark = Color(0xFF0A0A0A);
  static const Color borderInput = AppColors.borderGrey;
  static const Color surface = AppColors.cardBackground;
  static const Color deletePrimary = AppColors.brandRed;
  static const Color deleteBorderRed = AppColors.redBorder;
  static const Color editBorderBlue = Color(0xFF8EC5FF);
}

class _ButtonColors {
  const _ButtonColors({
    this.background = Colors.transparent,
    this.foreground = _EnhancedColors.textPrimary,
    this.border = _EnhancedColors.borderInput,
    this.borderWidth = 1,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;
}

class _SizeMetrics {
  const _SizeMetrics({required this.padding, required this.fontSize, required this.lineHeight, required this.iconSize});

  final EdgeInsets padding;
  final double fontSize;
  final double lineHeight;
  final double iconSize;
}

class _DottedBorderPainter extends CustomPainter {
  const _DottedBorderPainter({required this.borderColor, required this.borderRadius, required this.strokeWidth});

  final Color borderColor;
  final BorderRadius borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);
    final path = Path()..addRRect(borderRadius.toRRect(rect));
    const dashLength = 6.0;
    const dashGap = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

const _buttonTextHeight = TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false);

StrutStyle _buttonStrut({required double fontSize, required double lineHeight}) {
  return StrutStyle(fontSize: fontSize, height: lineHeight / fontSize, forceStrutHeight: true);
}
