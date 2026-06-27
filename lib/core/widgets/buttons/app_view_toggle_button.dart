import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Icon-only toggle button with border and rounded corners.
/// Used for view mode (grid/list) and similar toggle actions.
class AppViewToggleButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;

  const AppViewToggleButton({
    super.key,
    required this.svgPath,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveWidth = width ?? 39.w;
    final effectiveHeight = height ?? 39.w;
    final effectiveBg = backgroundColor ?? (isDark ? AppColors.cardBackgroundDark : Colors.white);
    final effectiveFg = foregroundColor ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final effectiveBorder = borderColor ?? (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    final isDisabled = isLoading || onPressed == null;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: Ink(
          decoration: BoxDecoration(
            color: isDisabled ? Colors.transparent : effectiveBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: effectiveBorder, width: 1),
          ),
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.all(9.w),
              child: Center(
                child: isLoading
                    ? AppLoadingIndicator(type: LoadingType.circle, color: effectiveFg, size: 18.sp)
                    : DigifyAsset(
                        assetPath: svgPath,
                        width: 18,
                        height: 18,
                        color: isDisabled ? AppColors.textMuted : effectiveFg,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
