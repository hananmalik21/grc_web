import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ExpandableConfigSection extends StatefulWidget {
  final String title;
  final String iconPath;
  final Widget child;
  final Color? warningBackgroundColor;

  const ExpandableConfigSection({
    super.key,
    required this.title,
    required this.iconPath,
    required this.child,
    this.warningBackgroundColor,
  });

  @override
  State<ExpandableConfigSection> createState() => _ExpandableConfigSectionState();
}

class _ExpandableConfigSectionState extends State<ExpandableConfigSection> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: widget.warningBackgroundColor ?? (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(21.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DigifyAsset(assetPath: widget.iconPath, width: 20, height: 20, color: AppColors.primary),
                Gap(7.w),
                Text(
                  widget.title,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Gap(14.h),
            widget.child,
          ],
        ),
      ),
    );
  }
}
