import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/services/responsive/breakpoints.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';

enum AppButtonVariant { primary, secondary, outlined, ghost, icon }

enum AppButtonSize { lg, md, sm, save, icon }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.iconAsset,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.borderColor,
    this.backgroundColor,
    this.fullWidth = false,
    this.isLoading = false,
  });

  const AppButton.icon({
    super.key,
    required this.iconAsset,
    this.onPressed,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.size = AppButtonSize.icon,
  }) : label = '',
       variant = AppButtonVariant.icon,
       icon = null,
       iconSize = null,
       fullWidth = false,
       isLoading = false;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final String? iconAsset;
  final IconData? icon;
  final Color? iconColor;

  /// Optional override for the icon size; falls back to the variant/size metric.
  final double? iconSize;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool fullWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.icon) {
      return _IconButtonView(
        iconAsset: iconAsset,
        onPressed: onPressed,
        iconColor: iconColor,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final isMobile = AppBreakpoints.fromContext(context).isMobile;
    final metrics = _resolveMetrics(variant, size);
    final resolvedMetrics = isMobile && fullWidth
        ? _SizeMetrics(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
            fontSize: 15.sp,
            lineHeight: 22,
            iconSize: 20.r,
          )
        : metrics;
    final colors = _colorsFor(variant);
    final enabled = onPressed != null && !isLoading;
    final resolvedIconSize = iconSize ?? resolvedMetrics.iconSize;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: fullWidth
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: resolvedIconSize,
            height: resolvedIconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.foreground,
            ),
          ),
        ] else if (iconAsset != null) ...[
          SvgPicture.asset(
            iconAsset!,
            width: resolvedIconSize,
            height: resolvedIconSize,
            colorFilter: ColorFilter.mode(
              iconColor ?? colors.foreground,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 8.w),
        ] else if (icon != null) ...[
          Icon(
            icon,
            size: resolvedIconSize,
            color: iconColor ?? colors.foreground,
          ),
          SizedBox(width: 8.w),
        ],
        if (label.isNotEmpty)
          fullWidth
              ? Flexible(
                  child: Text(
                    label,
                    style:
                        (variant == AppButtonVariant.ghost
                                ? textTheme.bodySmall
                                : size == AppButtonSize.sm
                                ? textTheme.bodyLarge
                                : textTheme.titleSmall)
                            ?.copyWith(
                              color: colors.foreground,
                              fontSize: resolvedMetrics.fontSize,
                              height:
                                  resolvedMetrics.lineHeight /
                                  resolvedMetrics.fontSize,
                              fontWeight: variant == AppButtonVariant.ghost
                                  ? FontWeight.w500
                                  : null,
                            ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    strutStyle: AppTextMetrics.strut(
                      fontSize: resolvedMetrics.fontSize,
                      lineHeight: resolvedMetrics.lineHeight,
                    ),
                    textHeightBehavior: AppTextMetrics.textHeight,
                  ),
                )
              : Text(
                  label,
                  style:
                      (variant == AppButtonVariant.ghost
                              ? textTheme.bodySmall
                              : size == AppButtonSize.sm
                              ? textTheme.bodyLarge
                              : textTheme.titleSmall)
                          ?.copyWith(
                            color: colors.foreground,
                            fontSize: resolvedMetrics.fontSize,
                            height:
                                resolvedMetrics.lineHeight /
                                resolvedMetrics.fontSize,
                            fontWeight: variant == AppButtonVariant.ghost
                                ? FontWeight.w500
                                : null,
                          ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: AppTextMetrics.strut(
                    fontSize: resolvedMetrics.fontSize,
                    lineHeight: resolvedMetrics.lineHeight,
                  ),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          width: fullWidth ? double.infinity : null,
          padding: resolvedMetrics.padding,
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(10.r),
            border: colors.borderWidth > 0
                ? Border.all(color: colors.border, width: colors.borderWidth)
                : null,
          ),
          child: child,
        ),
      ),
    );
  }

  _ButtonColors _colorsFor(AppButtonVariant variant) {
    return switch (variant) {
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
      AppButtonVariant.icon => const _ButtonColors(),
    };
  }

  _SizeMetrics _resolveMetrics(AppButtonVariant variant, AppButtonSize size) {
    final base = _sizeMetrics(size);

    return switch (variant) {
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
  });

  final String? iconAsset;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
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
                    width: 24.r,
                    height: 24.r,
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
