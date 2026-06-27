import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HierarchyPreviewWidget extends StatelessWidget {
  final List<HierarchyPreviewLevel> levels;

  const HierarchyPreviewWidget({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final textTheme = context.textTheme;

    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.sidebarSearchBg,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewHeader(isDark: isDark, title: localizations.hierarchyPreview, textTheme: textTheme),
          Gap(12.h),
          ...levels.map(
            (level) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: 8.h),
              child: _PreviewLevelRow(level: level, isDark: isDark, textTheme: textTheme),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  final bool isDark;
  final String title;
  final TextTheme textTheme;

  const _PreviewHeader({required this.isDark, required this.title, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DigifyAsset(
          assetPath: Assets.icons.eyesIcon.path,
          width: 20,
          height: 20,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        Gap(8.w),
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontSize: 16.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _PreviewLevelRow extends StatelessWidget {
  final HierarchyPreviewLevel level;
  final bool isDark;
  final TextTheme textTheme;

  const _PreviewLevelRow({required this.level, required this.isDark, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: SizedBox(
        width: level.width.w,
        child: Row(
          children: [
            if (level.level > 1) ...[
              DigifyAsset(
                assetPath: Assets.icons.enterpriseStructure.hierarchyLevel.path,
                color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
              ),
              Gap(8.w),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                  border: Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DigifyAsset(assetPath: level.icon, width: 16, height: 16, color: AppColors.primary),
                    Gap(8.w),
                    Flexible(
                      child: Text(
                        level.name,
                        style: textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(8.w),
                    Text(
                      'Level ${level.level}',
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HierarchyPreviewLevel {
  final String name;
  final String icon;
  final int level;
  final double width;

  HierarchyPreviewLevel({required this.name, required this.icon, required this.level, required this.width});
}
