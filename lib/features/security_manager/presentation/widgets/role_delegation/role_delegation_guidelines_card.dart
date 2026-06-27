import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RoleDelegationGuidelinesCard extends StatelessWidget {
  final bool isDark;

  const RoleDelegationGuidelinesCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      _GuidelineTileData(
        title: 'Temporary Authority',
        subtitle: 'Delegations are time-bound and automatically expire',
        iconPath: Assets.icons.infoCircleBlue.path,
      ),
      _GuidelineTileData(
        title: 'Audit Trail',
        subtitle: "All delegated actions are logged with the delegate's identity",
        iconPath: Assets.icons.clockIcon.path,
      ),
      _GuidelineTileData(
        title: 'Revocable Access',
        subtitle: 'Delegations can be revoked at any time by the delegator or admin',
        iconPath: Assets.icons.closeIcon.path,
      ),
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
            'Delegation Guidelines',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(14.h),
          Column(
            spacing: 10.h,
            children: [for (final item in items) _GuidelineTile(item: item, isDark: isDark)],
          ),
        ],
      ),
    );
  }
}

class _GuidelineTileData {
  final String title;
  final String subtitle;
  final String iconPath;

  const _GuidelineTileData({
    required this.title,
    required this.subtitle,
    required this.iconPath,
  });
}

class _GuidelineTile extends StatelessWidget {
  final _GuidelineTileData item;
  final bool isDark;

  const _GuidelineTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.tableHeaderBackground : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(
            assetPath: item.iconPath,
            width: 18,
            height: 18,
            color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(3.h),
                Text(
                  item.subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
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
