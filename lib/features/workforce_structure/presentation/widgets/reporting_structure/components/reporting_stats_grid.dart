import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReportingStatsGrid extends StatelessWidget {
  final ReportingStats stats;
  final AppLocalizations localizations;
  final bool isDark;

  const ReportingStatsGrid({super.key, required this.stats, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ReportingStatCard(
        label: localizations.totalPositions,
        value: stats.totalPositions.toString(),
        iconPath: Assets.icons.workforce.totalPosition.path,
        isDark: isDark,
        iconBgColor: AppColors.infoBg,
        iconColor: AppColors.statIconBlue,
      ),
      _ReportingStatCard(
        label: localizations.topLevelPositions,
        value: stats.topLevelCount.toString(),
        iconPath: Assets.icons.hierarchyIconDepartment.path,
        isDark: isDark,
        iconBgColor: AppColors.purpleBg,
        iconColor: AppColors.purple,
      ),
      _ReportingStatCard(
        label: localizations.directReports,
        value: stats.withReportsCount.toString(),
        iconPath: Assets.icons.workforce.filledPosition.path,
        isDark: isDark,
        iconBgColor: AppColors.greenBg,
        iconColor: AppColors.statIconGreen,
      ),
      _ReportingStatCard(
        label: localizations.departments,
        value: stats.departmentsCount.toString(),
        iconPath: Assets.icons.divisionIcon.path,
        isDark: isDark,
        iconBgColor: AppColors.orangeBg,
        iconColor: AppColors.statIconOrange,
      ),
    ];

    return _buildResponsiveLayout(context, cards);
  }

  Widget _buildResponsiveLayout(BuildContext context, List<Widget> cards) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: i < cards.length - 1 ? 12.h : 0),
              child: cards[i],
            ),
        ],
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards
            .map((card) => SizedBox(width: (MediaQuery.of(context).size.width - 48.w - 12.w) / 2, child: card))
            .toList(),
      );
    } else {
      return Row(
        children: [
          for (var i = 0; i < cards.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 21.w : 0),
                child: cards[i],
              ),
            ),
        ],
      );
    }
  }
}

class _ReportingStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconBgColor;
  final Color iconColor;

  const _ReportingStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
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
                  style: context.textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
                ),
                Gap(7.h),
                Text(
                  value,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, color: iconColor, width: 21, height: 21),
          ),
        ],
      ),
    );
  }
}
