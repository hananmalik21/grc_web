import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconActionButton extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? size;
  final double? height;

  const IconActionButton({
    super.key,
    this.iconPath,
    this.icon,
    required this.bgColor,
    required this.iconColor,
    this.onPressed,
    this.isLoading = false,
    this.size,
    this.height,
  }) : assert(iconPath != null || icon != null, 'Either iconPath or icon must be provided');

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 16.sp;

    return InkWell(
      onTap: isLoading || onPressed == null ? null : onPressed,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        height: height,
        padding: EdgeInsets.all(8.w).copyWith(top: 12.0, bottom: 12.0),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4.r)),
        child: isLoading
            ? AppLoadingIndicator(color: iconColor, size: effectiveSize)
            : iconPath != null
            ? DigifyAsset(assetPath: iconPath!, width: effectiveSize, height: effectiveSize, color: iconColor)
            : Icon(icon!, size: effectiveSize, color: iconColor),
      ),
    );
  }
}
