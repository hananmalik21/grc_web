import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EssSurfaceCard extends StatelessWidget {
  final String? title;
  final String? titleIconPath;
  final Color? titleIconColor;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final bool expandChild;
  final Widget child;

  const EssSurfaceCard({
    super.key,
    this.title,
    this.titleIconPath,
    this.titleIconColor,
    this.trailing,
    this.padding,
    this.expandChild = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: padding ?? EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (titleIconPath != null) ...[
                  DigifyAsset(
                    assetPath: titleIconPath!,
                    width: 16,
                    height: 16,
                    color: titleIconColor ?? AppColors.sidebarActiveText,
                  ),
                  Gap(8.w),
                ],
                Expanded(
                  child: Text(
                    title!,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            Gap(14.h),
          ],
          if (expandChild) Expanded(child: child) else child,
        ],
      ),
    );
  }
}
