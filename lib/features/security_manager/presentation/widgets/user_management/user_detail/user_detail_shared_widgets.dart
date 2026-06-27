import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/digify_divider.dart';

class UserDetailSectionCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Widget child;

  const UserDetailSectionCard({super.key, required this.title, required this.iconPath, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 27.w,
                height: 27.w,
                decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: DigifyAsset(assetPath: iconPath, width: 16.w, height: 16.w, color: AppColors.primary),
              ),
              Gap(7.w),
              Text(
                title,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 11.w)),
          child,
        ],
      ),
    );
  }
}

class UserDetailInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String? svgPath;
  final String? subLabel;

  const UserDetailInfoTile({super.key, required this.label, required this.value, this.svgPath, this.subLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.grayBorderDark),
        ),
        Gap(5.h),
        Text(value, style: context.textTheme.titleSmall?.copyWith(fontSize: 16.sp)),
        if (subLabel != null) ...[
          Gap(4.h),
          Text(
            subLabel!,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.grayBorderDark),
          ),
        ],
      ],
    );
  }
}
