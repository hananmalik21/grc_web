import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RoleDelegationUseCasesCard extends StatelessWidget {
  final bool isDark;

  const RoleDelegationUseCasesCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      _UseCaseTileData(title: 'Vacation Coverage', subtitle: 'Delegate approval rights during planned absences'),
      _UseCaseTileData(title: 'Project Handover', subtitle: 'Temporary role transfer for project transitions'),
      _UseCaseTileData(title: 'Emergency Access', subtitle: 'Quick authorization for urgent business needs'),
    ];

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Common Use Cases',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(14.h),
          Column(
            spacing: 10.h,
            children: [for (final item in items) _UseCaseTile(item: item, isDark: isDark)],
          ),
        ],
      ),
    );
  }
}

class _UseCaseTileData {
  final String title;
  final String subtitle;

  const _UseCaseTileData({required this.title, required this.subtitle});
}

class _UseCaseTile extends StatelessWidget {
  final _UseCaseTileData item;
  final bool isDark;

  const _UseCaseTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.25) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.infoCircleBlue.path,
            width: 18,
            height: 18,
            color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(2.h),
                Text(
                  item.subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
