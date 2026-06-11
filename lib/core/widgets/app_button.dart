import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/services/responsive/breakpoints.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';

enum AppButtonType { primary, secondary, outline, danger, dotted, text }

/// Legacy alias kept for existing call sites.
enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  ghost,
  danger,
  dotted,
  icon,
}

enum AppButtonSize { lg, md, sm, save, icon }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.iconAsset,
    this.icon,
    this.iconColor,
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
  }) : label = '',
       variant = AppButtonVariant.icon,
       type = null,
       icon = null,
       foregroundColor = null,
       fullWidth = false,
       isLoading = false,
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
    String? iconAsset,
    Color? iconColor,
    double? iconSize,
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
      iconAsset: iconAsset,
      iconColor: iconColor,
      iconSize: iconSize,
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
    String? iconAsset,
    Color? iconColor,
    double? iconSize,
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
      iconAsset: iconAsset,
      iconColor: iconColor,
      iconSize: iconSize,
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
    String? iconAsset,
    Color? iconColor,
    double? iconSize,
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
      iconAsset: iconAsset,
      iconColor: iconColor,
      iconSize: iconSize,
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
    String? iconAsset,
    Color? iconColor,
    double? iconSize,
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
      iconAsset: iconAsset,
      iconColor: iconColor,
      iconSize: iconSize,
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
    String? iconAsset,
    double? iconSize,
    AppButtonSize size = AppButtonSize.lg,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      variant: AppButtonVariant.outlined,
      icon: icon,
      iconAsset: iconAsset,
      iconColor: AppColors.deletePrimary,
      foregroundColor: AppColors.deletePrimary,
      borderColor: AppColors.deleteBorderRed,
      size: size,
      fontSize: fontSize,
      iconSize: iconSize,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  factory AppButton.dotted({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Color? iconColor,
    double? iconSize,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.lg,
    double? height,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? foregroundColor,
    Color? backgroundColor,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.dotted,
      variant: AppButtonVariant.dotted,
      icon: icon,
      iconAsset: iconAsset,
      iconColor: iconColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
      fullWidth: fullWidth,
      size: size,
      height: height,
      fontSize: fontSize,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

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
      borderColor: borderColor ?? AppColors.borderInput,
      iconColor: iconColor ?? AppColors.textPrimary,
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
      foregroundColor: foregroundColor ?? AppColors.textDark,
      onPressed: onPressed,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.close({
    Key? key,
    required VoidCallback? onPressed,
    String iconAsset = 'assets/figma/library/svg/close_white.svg',
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
      iconColor: AppColors.textPrimary,
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16.w : 17.w,
        vertical: compact ? 10.h : 12.h,
      ),
    );
  }

  factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Color? iconColor,
    double? iconSize,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    Color? foregroundColor,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.text,
      variant: AppButtonVariant.ghost,
      icon: icon,
      iconAsset: iconAsset,
      iconColor: iconColor,
      iconSize: iconSize,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      padding: padding ?? EdgeInsets.zero,
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType? type;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final String? iconAsset;
  final IconData? icon;
  final Color? iconColor;
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

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.icon) {
      return _IconButtonView(
        iconAsset: iconAsset,
        onPressed: onPressed,
        iconColor: iconColor,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        bordered: bordered,
        iconSize: iconSize,
        padding: padding,
      );
    }

    if (_resolvedType == AppButtonType.dotted) {
      return _buildDottedButton(context);
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
    final enabled = onPressed != null && !isLoading;
    final resolvedIconSize = iconSize ?? resolvedMetrics.iconSize;
    final resolvedBackground = backgroundColor ?? colors.background;
    final resolvedForeground = foregroundColor ?? colors.foreground;
    final resolvedBorder = borderColor ?? colors.border;
    final effectivePadding = padding ?? resolvedMetrics.padding;
    final effectiveFontSize = fontSize ?? resolvedMetrics.fontSize;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(10.r);

    final labelStyle = _labelStyle(
      textTheme: textTheme,
      styleVariant: styleVariant,
      color: resolvedForeground,
      fontSize: effectiveFontSize,
      lineHeight: resolvedMetrics.lineHeight,
    );
    final labelStrut = AppTextMetrics.strut(
      fontSize: effectiveFontSize,
      lineHeight: resolvedMetrics.lineHeight,
    );

    Widget labelWidget(String text) => Text(
      text,
      style: labelStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      strutStyle: labelStrut,
      textHeightBehavior: AppTextMetrics.textHeight,
    );

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: resolvedIconSize,
            height: resolvedIconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: resolvedForeground,
            ),
          ),
        ] else if (iconAsset != null) ...[
          SvgPicture.asset(
            iconAsset!,
            width: resolvedIconSize,
            height: resolvedIconSize,
            colorFilter: ColorFilter.mode(
              iconColor ?? resolvedForeground,
              BlendMode.srcIn,
            ),
          ),
          if (label.isNotEmpty) SizedBox(width: 8.w),
        ] else if (icon != null) ...[
          Icon(
            icon,
            size: resolvedIconSize,
            color: iconColor ?? resolvedForeground,
          ),
          if (label.isNotEmpty) SizedBox(width: 8.w),
        ],
        if (label.isNotEmpty)
          fullWidth
              ? Flexible(
                  fit: FlexFit.loose,
                  child: labelWidget(label),
                )
              : labelWidget(label),
      ],
    );

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: effectiveRadius,
        child: Ink(
          width: fullWidth ? double.infinity : width?.w,
          height: height,
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: resolvedBackground,
            borderRadius: effectiveRadius,
            border: colors.borderWidth > 0
                ? Border.all(color: resolvedBorder, width: colors.borderWidth)
                : null,
          ),
          child: child,
        ),
      ),
    );

    return button;
  }

  Widget _buildDottedButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = _colorsFor(AppButtonVariant.dotted);
    final resolvedIconSize = iconSize ?? 24.r;
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(10.r);
    final resolvedForeground = foregroundColor ?? colors.foreground;
    final resolvedBackground = backgroundColor ?? colors.background;
    final resolvedBorder = borderColor ?? colors.border;
    final effectiveFontSize = fontSize ?? 16.sp;
    final enabled = onPressed != null && !isLoading;

    final children = <Widget>[
      if (iconAsset != null) ...[
        SvgPicture.asset(
          iconAsset!,
          width: resolvedIconSize,
          height: resolvedIconSize,
          colorFilter: ColorFilter.mode(
            iconColor ?? resolvedForeground,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
      ] else if (icon != null) ...[
        Icon(icon, size: resolvedIconSize, color: iconColor ?? resolvedForeground),
        SizedBox(width: 8.w),
      ],
      Text(
        label,
        style: textTheme.titleSmall?.copyWith(
          color: resolvedForeground,
          fontWeight: FontWeight.w600,
          fontSize: effectiveFontSize,
          height: 24 / effectiveFontSize,
          letterSpacing: -0.32,
        ),
        strutStyle: AppTextMetrics.strut(fontSize: effectiveFontSize, lineHeight: 24),
        textHeightBehavior: AppTextMetrics.textHeight,
      ),
    ];

    return SizedBox(
      width: fullWidth ? double.infinity : width?.w,
      height: height,
      child: CustomPaint(
        painter: _DottedBorderPainter(
          borderColor: resolvedBorder,
          borderRadius: effectiveRadius,
          strokeWidth: 2,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: effectiveRadius,
            child: Ink(
              decoration: BoxDecoration(
                color: resolvedBackground,
                borderRadius: effectiveRadius,
              ),
              padding: effectivePadding,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
      fontWeight: styleVariant == AppButtonVariant.ghost
          ? FontWeight.w500
          : null,
    );
  }

  _ButtonColors _colorsFor(AppButtonVariant styleVariant) {
    return switch (styleVariant) {
      AppButtonVariant.primary => const _ButtonColors(
        background: AppColors.primary,
        foreground: Colors.white,
      ),
      AppButtonVariant.secondary => const _ButtonColors(
        background: AppColors.primaryLightBg,
        foreground: AppColors.primaryDark,
        border: AppColors.primary,
        borderWidth: 2,
      ),
      AppButtonVariant.outlined => const _ButtonColors(
        background: AppColors.surface,
        foreground: AppColors.textDark,
        border: AppColors.borderInput,
      ),
      AppButtonVariant.ghost => const _ButtonColors(
        background: Colors.transparent,
        foreground: AppColors.primary,
      ),
      AppButtonVariant.danger => const _ButtonColors(
        background: AppColors.deletePrimary,
        foreground: Colors.white,
      ),
      AppButtonVariant.dotted => const _ButtonColors(
        background: AppColors.surface,
        foreground: AppColors.primary,
        border: AppColors.borderInput,
      ),
      AppButtonVariant.icon => const _ButtonColors(),
    };
  }

  _SizeMetrics _resolveMetrics(AppButtonVariant styleVariant, AppButtonSize size) {
    final base = _sizeMetrics(size);

    return switch (styleVariant) {
      AppButtonVariant.secondary => _SizeMetrics(
        padding: base.padding,
        fontSize: base.fontSize,
        lineHeight: base.lineHeight,
        iconSize: base.iconSize,
      ),
      AppButtonVariant.outlined => _SizeMetrics(
        padding: EdgeInsets.symmetric(
          horizontal: size == AppButtonSize.sm ? 12.w : 17.w,
          vertical: size == AppButtonSize.sm ? 6.h : 9.h,
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

  _SizeMetrics _sizeMetrics(AppButtonSize size) {
    return switch (size) {
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
      AppButtonSize.icon => _SizeMetrics(
        padding: EdgeInsets.zero,
        fontSize: 14.sp,
        lineHeight: 20,
        iconSize: 24.r,
      ),
    };
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
  });

  final String? iconAsset;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool bordered;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (!bordered) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4.r),
          child            : Padding(
                padding: padding ?? EdgeInsets.all(2.r),
                child: iconAsset == null
                ? const SizedBox.shrink()
                : SvgPicture.asset(
                    iconAsset!,
                    width: iconSize ?? 32.r,
                    height: iconSize ?? 32.r,
                    colorFilter: iconColor == null
                        ? null
                        : ColorFilter.mode(iconColor!, BlendMode.srcIn),
                  ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.primaryLightBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: borderColor ?? AppColors.editBorderBlue),
          ),
          child: Center(
            child: iconAsset == null
                ? const SizedBox.shrink()
                : SvgPicture.asset(
                    iconAsset!,
                    width: iconSize ?? 24.r,
                    height: iconSize ?? 24.r,
                    colorFilter: iconColor == null
                        ? null
                        : ColorFilter.mode(iconColor!, BlendMode.srcIn),
                  ),
          ),
        ),
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  const _DottedBorderPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.strokeWidth,
  });

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

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path()..addRRect(borderRadius.toRRect(rect));
    const dashLength = 6.0;
    const dashGap = 4.0;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
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

class _ButtonColors {
  const _ButtonColors({
    this.background = Colors.transparent,
    this.foreground = AppColors.textPrimary,
    this.border = AppColors.borderInput,
    this.borderWidth = 1,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;
}

class _SizeMetrics {
  const _SizeMetrics({
    required this.padding,
    required this.fontSize,
    required this.lineHeight,
    required this.iconSize,
  });

  final EdgeInsets padding;
  final double fontSize;
  final double lineHeight;
  final double iconSize;
}
