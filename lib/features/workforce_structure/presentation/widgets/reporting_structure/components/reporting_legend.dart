import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReportingLegend extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ReportingLegend({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenLayout.isMobile;
    final outerPadding = isMobile ? EdgeInsets.all(16.w) : EdgeInsets.all(20.w);
    final sectionGap = isMobile ? 12.h : 16.h;

    final cards = [
      _LegendCard(
        title: localizations.topLevelPositions,
        subtitle: localizations.noReportingManager,
        isMobile: isMobile,
      ),
      _LegendCard(
        title: localizations.managementPositions,
        subtitle: localizations.hasDirectReports,
        isMobile: isMobile,
      ),
      _LegendCard(
        title: localizations.individualContributors,
        subtitle: localizations.noDirectReports,
        isMobile: isMobile,
      ),
    ];

    return Container(
      padding: outerPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.positionTypes,
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(sectionGap),
          if (isMobile) ...[
            cards[0],
            Gap(12.h),
            cards[1],
            Gap(12.h),
            cards[2],
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                Gap(16.w),
                Expanded(child: cards[1]),
                Gap(16.w),
                Expanded(child: cards[2]),
              ],
            ),
        ],
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isMobile;

  const _LegendCard({required this.title, required this.subtitle, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.textTheme.labelMedium?.copyWith(
      color: AppColors.textPrimary,
      fontSize: isMobile ? 14.sp : 15.sp,
    );
    final subtitleStyle = context.textTheme.labelSmall?.copyWith(color: AppColors.shiftExportButton, fontSize: 12.sp);

    return Container(
      width: isMobile ? double.infinity : null,
      padding: EdgeInsets.all(isMobile ? 14.w : 12.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.ingobgBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.workforce.totalPosition.path,
            color: AppColors.primary,
            width: isMobile ? 22.w : 20.w,
            height: isMobile ? 22.h : 20.h,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: titleStyle, maxLines: isMobile ? 3 : 1, overflow: TextOverflow.ellipsis),
                Gap(2.h),
                Text(subtitle, style: subtitleStyle, maxLines: isMobile ? 4 : 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
