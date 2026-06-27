import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataClassificationStatsCards extends StatelessWidget {
  final bool isDark;
  final List<DataClassificationStat> stats;

  const DataClassificationStatsCards({super.key, required this.isDark, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1100.w;
        final cards = [
          for (final stat in stats)
            _DataClassificationStatCard(
              title: stat.title,
              value: stat.value,
              iconPath: stat.iconPath,
              iconColor: stat.iconColor,
              isDark: isDark,
            ),
        ];

        if (!isWide) {
          return Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              for (final card in cards)
                SizedBox(
                  width: constraints.maxWidth >= 650.w ? (constraints.maxWidth - 12.w) / 2 : constraints.maxWidth,
                  child: card,
                ),
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 14.w : 0),
                  child: cards[i],
                ),
              ),
          ],
        );
      },
    );
  }
}

class DataClassificationStat {
  final String title;
  final String value;
  final String iconPath;
  final Color iconColor;

  const DataClassificationStat({
    required this.title,
    required this.value,
    required this.iconPath,
    this.iconColor = AppColors.primary,
  });
}

class _DataClassificationStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath;
  final Color iconColor;
  final bool isDark;

  const _DataClassificationStatCard({
    required this.title,
    required this.value,
    required this.iconPath,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 85.h),
      padding: EdgeInsets.symmetric(horizontal: 12.5.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 26.sp,
                    height: 34 / 26,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.25) : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, width: 18, height: 18, color: iconColor),
          ),
        ],
      ),
    );
  }
}
