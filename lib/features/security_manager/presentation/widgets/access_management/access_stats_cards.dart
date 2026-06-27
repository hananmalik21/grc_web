import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';

class AccessStatsCards extends ConsumerWidget {
  const AccessStatsCards({super.key});

  static const Color _iconColor = AppColors.statIconBlue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final cards = [
      _AssetStatCard(
        label: 'Total Roles',
        value: '4',
        subtitle: 'Active roles configured',
        iconPath: Assets.icons.positionsIcon.path,
        isDark: isDark,
        iconBgColor: const Color(0xFFE3F2FD),
      ),
      _AssetStatCard(
        label: 'Admin Roles',
        value: '12',
        subtitle: 'Administrator level access',
        iconPath: Assets.icons.securityIcon.path,
        isDark: isDark,
        iconBgColor: const Color(0xFFE1F5FE),
      ),
      _AssetStatCard(
        label: 'Custom Roles',
        value: '5',
        subtitle: 'Organization specific roles',
        iconPath: Assets
            .icons
            .settingsIcon
            .path, // Using settings as placeholder for custom
        isDark: isDark,
        iconBgColor: const Color(0xFFE8EAF6),
      ),
      _AssetStatCard(
        label: 'Active Users',
        value: '6',
        subtitle: 'Total users with roles',
        iconPath: Assets.icons.employeesBlueIcon.path,
        isDark: isDark,
        iconBgColor: const Color(0xFFE3F2FD),
      ),
    ];

    if (context.isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: i < cards.length - 1 ? 12.h : 0,
              ),
              child: cards[i],
            ),
        ],
      );
    } else if (context.isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards
            .map(
              (card) => SizedBox(
                width: (MediaQuery.of(context).size.width - 48.w - 12.w) / 2,
                child: card,
              ),
            )
            .toList(),
      );
    } else {
      return Row(
        children: [
          for (var i = 0; i < cards.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: i < cards.length - 1 ? 21.w : 0,
                ),
                child: cards[i],
              ),
            ),
        ],
      );
    }
  }
}

class _AssetStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final String iconPath;
  final bool isDark;
  final Color iconBgColor;

  const _AssetStatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.iconPath,
    required this.isDark,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final valueColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final subtitleColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.statIconBlue;

    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(4.h),
                Text(
                  value,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
                Gap(4.h),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: isDark ? iconBgColor.withValues(alpha: 0.1) : iconBgColor,
              borderRadius: BorderRadius.circular(7.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: iconPath,
              color: AccessStatsCards._iconColor,
              width: 21,
              height: 21,
            ),
          ),
        ],
      ),
    );
  }
}
