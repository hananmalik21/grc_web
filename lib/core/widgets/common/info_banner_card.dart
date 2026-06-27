import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class InfoBannerCard extends StatelessWidget {
  final String? iconAssetPath;
  final Widget? icon;
  final String? message;
  final Widget? child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const InfoBannerCard({
    super.key,
    this.iconAssetPath,
    this.icon,
    this.message,
    this.child,
    this.borderRadius,
    this.padding,
  }) : assert(
         (icon != null || iconAssetPath != null) && (message != null || child != null),
         'Provide icon or iconAssetPath, and message or child',
       );

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
    final effectiveRadius = borderRadius ?? 10.r;
    final textStyle = context.textTheme.bodySmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.sidebarFooterTitle,
    );

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null || iconAssetPath != null) ...[
            icon ??
                DigifyAsset(
                  assetPath: iconAssetPath!,
                  width: 20,
                  height: 20,
                  color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                ),
            Gap(8.w),
          ],
          Expanded(child: child ?? Text(message!, style: textStyle)),
        ],
      ),
    );
  }
}
