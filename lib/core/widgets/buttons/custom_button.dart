import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final String? svgIcon;

  final bool isLoading;
  final double? loadingSize;

  final bool isExpanded;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;
  final bool showShadow;
  final IconPosition iconPosition;

  const CustomButton({
    super.key,
    this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.svgIcon,
    this.isLoading = false,
    this.loadingSize, // ✅ NEW
    this.isExpanded = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconSize,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.height,
    this.width,
    this.fontWeight,
    this.showShadow = false,
    this.iconPosition = IconPosition.left,
  }) : assert(
         label != null || icon != null || svgIcon != null,
         'CustomButton must have either label, icon, or svgIcon',
       );

  /// Factory for primary action buttons
  factory CustomButton.primary({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    double? loadingSize, // ✅ NEW
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
      loadingSize: loadingSize,
    );
  }

  /// Factory for secondary action buttons
  factory CustomButton.secondary({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    double? loadingSize, // ✅ NEW
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
      loadingSize: loadingSize,
    );
  }

  /// Factory for outlined buttons
  factory CustomButton.outlined({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    double? loadingSize, // ✅ NEW
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.outlined,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
      loadingSize: loadingSize,
    );
  }

  /// Factory for text-only buttons
  factory CustomButton.text({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.text,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
    );
  }

  /// Factory for icon (or icon + text) buttons ✅ (text + isLoading + loadingSize)
  factory CustomButton.icon({
    IconData? icon,
    String? svgIcon,
    String? text,
    required VoidCallback? onPressed,
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.medium,
    double? iconSize,
    bool isLoading = false,
    double? loadingSize, // ✅ NEW
  }) {
    return CustomButton(
      label: text,
      onPressed: onPressed,
      variant: variant,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      iconSize: iconSize,
      isLoading: isLoading,
      loadingSize: loadingSize,
    );
  }

  /// Factory for danger/destructive action buttons
  factory CustomButton.danger({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    double? loadingSize, // ✅ NEW
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.danger,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
      loadingSize: loadingSize,
    );
  }

  /// Factory for success/confirmation action buttons
  factory CustomButton.success({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    double? loadingSize, // ✅ NEW
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.success,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
      loadingSize: loadingSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null && !isLoading;

    final colors = _getButtonColors(isDark, isDisabled);
    final dimensions = _getButtonDimensions();

    final content = _buildButtonContent(colors, dimensions);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading || isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius ?? dimensions.borderRadius),
        child: Container(
          height: height ?? dimensions.height,
          width: width ?? (isExpanded ? double.infinity : null),
          padding: padding ?? dimensions.padding,
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? dimensions.borderRadius),
            border: colors.borderColor != null ? Border.all(color: colors.borderColor!) : null,
            boxShadow: showShadow && !isDisabled
                ? [
                    BoxShadow(
                      color: colors.backgroundColor.withValues(alpha: 0.35),
                      blurRadius: 12.r,
                      offset: Offset(0, 6.h),
                    ),
                  ]
                : null,
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildButtonContent(_ButtonColors colors, _ButtonDimensions dimensions) {
    if (isLoading) {
      return Center(
        child: AppLoadingIndicator(
          type: LoadingType.circle,
          color: colors.foregroundColor,
          size: loadingSize ?? dimensions.iconSize,
        ),
      );
    }

    final hasIcon = icon != null || svgIcon != null;

    // ✅ Icon-only button
    if (label == null && hasIcon) {
      return Center(child: _buildIcon(colors, dimensions));
    }

    // ✅ Text-only button
    if (label != null && !hasIcon) {
      return Center(
        child: Text(
          label!,
          style: TextStyle(
            fontSize: fontSize ?? dimensions.fontSize,
            fontWeight: fontWeight ?? FontWeight.w400,
            color: colors.foregroundColor,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    }

    // ✅ Icon + Text => text ALWAYS centered, icon pinned left/right
    final gap = 8.w;
    final reservedSide = (iconSize ?? dimensions.iconSize) + gap; // reserve space so text stays truly centered

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered label
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: iconPosition == IconPosition.left ? reservedSide : 0,
              end: iconPosition == IconPosition.right ? reservedSide : 0,
            ),
            child: Transform.translate(
              offset: const Offset(0, -0.5), // 👈 perfect for buttons
              child: Text(
                label!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize ?? dimensions.fontSize,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  color: colors.foregroundColor,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),

          // Pinned icon
          PositionedDirectional(
            start: iconPosition == IconPosition.left ? 0 : null,
            end: iconPosition == IconPosition.right ? 0 : null,
            child: _buildIcon(colors, dimensions),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(_ButtonColors colors, _ButtonDimensions dimensions) {
    final effectiveIconSize = iconSize ?? dimensions.iconSize;

    if (svgIcon != null) {
      return DigifyAsset(
        assetPath: svgIcon!,
        width: effectiveIconSize,
        height: effectiveIconSize,
        color: colors.foregroundColor,
      );
    }

    if (icon != null) {
      return Icon(icon, size: effectiveIconSize, color: colors.foregroundColor);
    }

    return const SizedBox.shrink();
  }

  _ButtonColors _getButtonColors(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return _ButtonColors(
        backgroundColor: isDark ? AppColors.grayBgDark.withValues(alpha: 0.3) : AppColors.grayBg.withValues(alpha: 0.5),
        foregroundColor: isDark ? AppColors.textMutedDark : AppColors.textMuted,
        borderColor: variant == ButtonVariant.outlined
            ? (isDark ? AppColors.borderGreyDark : AppColors.borderGrey)
            : null,
      );
    }

    // Custom colors override
    if (backgroundColor != null || foregroundColor != null) {
      return _ButtonColors(
        backgroundColor:
            backgroundColor ??
            (variant == ButtonVariant.text || variant == ButtonVariant.outlined
                ? Colors.transparent
                : AppColors.primary),
        foregroundColor: foregroundColor ?? Colors.white,
        borderColor: borderColor ?? (variant == ButtonVariant.outlined ? (foregroundColor ?? AppColors.primary) : null),
      );
    }

    // Variant-specific colors
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonColors(backgroundColor: AppColors.primary, foregroundColor: Colors.white);

      case ButtonVariant.secondary:
        return _ButtonColors(
          backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundGrey,
          foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
        );

      case ButtonVariant.outlined:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.primary,
          borderColor: isDark ? AppColors.borderGreyDark : AppColors.primary,
        );

      case ButtonVariant.text:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.primary,
        );

      case ButtonVariant.danger:
        return _ButtonColors(backgroundColor: AppColors.redButton, foregroundColor: Colors.white);

      case ButtonVariant.success:
        return _ButtonColors(backgroundColor: AppColors.greenButton, foregroundColor: Colors.white);

      case ButtonVariant.icon:
        return _ButtonColors(
          backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          borderColor: isDark ? AppColors.borderGreyDark : AppColors.borderGrey,
        );

      case ButtonVariant.gradient:
        return _ButtonColors(backgroundColor: backgroundColor ?? AppColors.primary, foregroundColor: Colors.white);
    }
  }

  _ButtonDimensions _getButtonDimensions() {
    switch (size) {
      case ButtonSize.small:
        return _ButtonDimensions(
          height: 32.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 6.h),
          fontSize: 13.sp,
          iconSize: 16.sp,
          borderRadius: 8.r,
        );

      case ButtonSize.medium:
        return _ButtonDimensions(
          height: 40.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 8.h),
          fontSize: 15.sp,
          iconSize: 20.sp,
          borderRadius: 10.r,
        );

      case ButtonSize.large:
        return _ButtonDimensions(
          height: 48.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
          fontSize: 16.sp,
          iconSize: 24.sp,
          borderRadius: 12.r,
        );
    }
  }
}

// Button variant types
enum ButtonVariant { primary, secondary, outlined, text, danger, success, icon, gradient }

// Button size types
enum ButtonSize { small, medium, large }

// Icon position
enum IconPosition { left, right }

// Internal helper classes
class _ButtonColors {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  _ButtonColors({required this.backgroundColor, required this.foregroundColor, this.borderColor});
}

class _ButtonDimensions {
  final double height;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  _ButtonDimensions({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
  });
}
