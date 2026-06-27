import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMobileButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final String? svgPath;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const AppMobileButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.svgPath,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  }) : assert(icon != null || svgPath != null, 'Must provide either icon or svgPath');

  factory AppMobileButton.primary({VoidCallback? onPressed, bool isLoading = false, IconData? icon, String? svgPath}) =>
      AppMobileButton(
        onPressed: onPressed,
        isLoading: isLoading,
        type: AppButtonType.primary,
        icon: icon,
        svgPath: svgPath,
      );

  factory AppMobileButton.secondary({
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
  }) => AppMobileButton(
    onPressed: onPressed,
    isLoading: isLoading,
    type: AppButtonType.secondary,
    icon: icon,
    svgPath: svgPath,
  );

  factory AppMobileButton.outline({VoidCallback? onPressed, bool isLoading = false, IconData? icon, String? svgPath}) =>
      AppMobileButton(
        onPressed: onPressed,
        isLoading: isLoading,
        type: AppButtonType.outline,
        icon: icon,
        svgPath: svgPath,
      );

  factory AppMobileButton.danger({VoidCallback? onPressed, bool isLoading = false, IconData? icon, String? svgPath}) =>
      AppMobileButton(
        onPressed: onPressed,
        isLoading: isLoading,
        type: AppButtonType.danger,
        icon: icon,
        svgPath: svgPath,
      );

  factory AppMobileButton.text({
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    Color? foregroundColor,
  }) => AppMobileButton(
    onPressed: onPressed,
    isLoading: isLoading,
    type: AppButtonType.text,
    icon: icon,
    svgPath: svgPath,
    foregroundColor: foregroundColor,
  );

  Color _getBaseBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.cardBackgroundGrey;
      case AppButtonType.outline:
      case AppButtonType.text:
      case AppButtonType.dotted:
        return Colors.transparent;
      case AppButtonType.danger:
        return AppColors.error;
    }
  }

  Color _getTextColor() {
    if (foregroundColor != null) return foregroundColor!;
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return Colors.white;
      case AppButtonType.outline:
        return AppColors.blackTextColor;
      case AppButtonType.text:
      case AppButtonType.dotted:
        return AppColors.primary;
    }
  }

  BorderSide? _getBorder() {
    if (type == AppButtonType.outline) {
      final color = borderColor ?? AppColors.borderGrey;
      return BorderSide(color: color, width: 1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || onPressed == null;
    final bgColor = isDisabled
        ? (type == AppButtonType.outline || type == AppButtonType.text)
              ? Colors.transparent
              : _getBaseBackgroundColor().withValues(alpha: 0.5)
        : _getBaseBackgroundColor();

    final contentColor = isDisabled
        ? (type == AppButtonType.outline || type == AppButtonType.dotted)
              ? AppColors.textMuted
              : Colors.white70
        : _getTextColor();

    final borderProp = _getBorder();

    final buttonSize = 40.w;
    final iconSize = 20.w;

    return Material(
      color: Colors.transparent,
      child: Ink(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
          border: borderProp != null ? Border.fromBorderSide(borderProp) : null,
        ),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(10.r),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: isLoading ? 0.0 : 1.0,
                child: icon != null
                    ? Icon(icon, color: contentColor, size: iconSize)
                    : DigifyAsset(assetPath: svgPath!, width: iconSize, height: iconSize, color: contentColor),
              ),
              if (isLoading) AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: iconSize),
            ],
          ),
        ),
      ),
    );
  }
}
