import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A reusable widget for handling any type of asset (SVG, PNG, JPEG, etc.)
/// with proper error handling and customization options
class DigifyAsset extends StatelessWidget {
  /// The asset path (can be local asset or network URL)
  final String assetPath;

  /// Width of the asset
  final double? width;

  /// Height of the asset
  final double? height;

  /// BoxFit for the asset
  final BoxFit fit;

  /// Color to apply to SVG assets (tinting)
  final Color? color;

  /// Placeholder widget to show while loading or on error
  final Widget? placeholder;

  /// Error widget to show when asset fails to load
  final Widget? errorWidget;

  /// Border radius for the asset
  final BorderRadius? borderRadius;

  /// Whether to use cached network images (for network assets)
  final bool useCache;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Custom blend mode for color application
  final BlendMode colorBlendMode;

  const DigifyAsset({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.useCache = true,
    this.semanticLabel,
    this.colorBlendMode = BlendMode.srcIn,
  });

  /// Factory constructor for square assets
  factory DigifyAsset.square({
    required String assetPath,
    required double size,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    bool useCache = true,
    String? semanticLabel,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) {
    return DigifyAsset(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: fit,
      color: color,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: borderRadius,
      useCache: useCache,
      semanticLabel: semanticLabel,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Factory constructor for circular assets
  factory DigifyAsset.circular({
    required String assetPath,
    required double size,
    BoxFit fit = BoxFit.cover,
    Color? color,
    Widget? placeholder,
    Widget? errorWidget,
    bool useCache = true,
    String? semanticLabel,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) {
    return DigifyAsset(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: fit,
      color: color,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: BorderRadius.circular(size / 2),
      useCache: useCache,
      semanticLabel: semanticLabel,
      colorBlendMode: colorBlendMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _buildAssetWidget();

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }

  Widget _buildAssetWidget() {
    // Check if it's an SVG asset
    if (_isSvgAsset(assetPath)) {
      return _buildSvgWidget();
    }

    // Check if it's a network asset
    if (_isNetworkAsset(assetPath)) {
      return _buildNetworkImageWidget();
    }

    // Default to local asset image
    return _buildLocalImageWidget();
  }

  Widget _buildSvgWidget() {
    if (_isNetworkAsset(assetPath)) {
      return SvgPicture.network(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode) : null,
        placeholderBuilder: (context) => _buildPlaceholder(),
        semanticsLabel: semanticLabel,
      );
    }

    return SvgPicture.asset(
      assetPath,
      width: width?.sp,
      height: height?.sp,
      fit: fit,
      colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode) : null,
      placeholderBuilder: (context) => _buildPlaceholder(),
      semanticsLabel: semanticLabel,
    );
  }

  Widget _buildNetworkImageWidget() {
    return Image.network(
      assetPath,
      width: width?.w,
      height: height?.w,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildLocalImageWidget() {
    return Image.asset(
      assetPath,
      width: width?.w,
      height: height?.w,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;

    return Skeletonizer(
      enabled: true,
      child: Container(
        width: width?.w,
        height: height?.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: borderRadius ?? BorderRadius.circular(4.r),
        ),
        child: (width != null && height != null && (width! > 24 || height! > 24))
            ? Icon(
                Icons.image_outlined,
                size: (width! < height! ? width! * 0.4 : height! * 0.4).sp,
                color: Colors.grey.shade400,
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width?.w,
      height: height?.w,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: (width != null && height != null) ? (width! < height! ? width! * 0.4 : height! * 0.4).sp : 24.sp,
        color: Colors.red.shade400,
      ),
    );
  }

  bool _isSvgAsset(String path) {
    return path.toLowerCase().endsWith('.svg');
  }

  bool _isNetworkAsset(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }
}
