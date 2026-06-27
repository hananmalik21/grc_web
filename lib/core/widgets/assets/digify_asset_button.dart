import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifyAssetButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final double? padding;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final Color? splashColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final bool isLoading;

  const DigifyAssetButton({
    super.key,
    required this.assetPath,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.padding,
    this.borderRadius,
    this.customBorder,
    this.splashColor,
    this.hoverColor,
    this.highlightColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = padding ?? 4.w;
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(100.r);
    final effectiveWidth = width ?? 20;
    final effectiveHeight = height ?? 20;
    final loadingSize = (effectiveWidth < effectiveHeight ? effectiveWidth : effectiveHeight) * 0.8;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: customBorder != null ? null : defaultBorderRadius,
        customBorder: customBorder,
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: isLoading
              ? SizedBox(
                  width: effectiveWidth,
                  height: effectiveHeight,
                  child: AppLoadingIndicator(type: LoadingType.circle, size: loadingSize),
                )
              : DigifyAsset(assetPath: assetPath, width: width, height: height, color: color, fit: fit),
        ),
      ),
    );
  }
}
