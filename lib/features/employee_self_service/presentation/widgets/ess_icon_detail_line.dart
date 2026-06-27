import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EssIconDetailLine extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const EssIconDetailLine({super.key, required this.iconPath, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.sidebarSearchBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: AppColors.sidebarCategoryText),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(color: AppColors.sidebarCategoryText, fontSize: 12.sp),
              ),
              Gap(2.h),
              Text(
                value,
                style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, color: context.themeTextPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
