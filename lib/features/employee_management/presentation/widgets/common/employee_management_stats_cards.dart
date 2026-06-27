import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeManagementStatsCards extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const EmployeeManagementStatsCards({super.key, required this.localizations, required this.isDark});

  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;

  @override
  Widget build(BuildContext context) {
    final isDesktop = !ResponsiveHelper.isMobile(context) && !ResponsiveHelper.isTablet(context);

    final cardData = [
      (label: localizations.totalEmployees, value: '0', iconPath: Assets.icons.employeesBlueIcon.path),
      (label: localizations.active, value: '0', iconPath: Assets.icons.checkIconGreen.path),
      (label: localizations.onProbation, value: '0', iconPath: Assets.icons.clockIcon.path),
      (label: localizations.departments, value: '0', iconPath: Assets.icons.departmentsIcon.path),
    ];

    if (!isDesktop) {
      return SizedBox(
        height: 80.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          itemCount: cardData.length,
          separatorBuilder: (_, _) => Gap(12.w),
          itemBuilder: (context, i) {
            final c = cardData[i];
            return _EmployeeStatCard(label: c.label, value: c.value, iconPath: c.iconPath, isDark: isDark);
          },
        ),
      );
    }

    final desktopCards = cardData
        .map((c) => _EmployeeStatCard(label: c.label, value: c.value, iconPath: c.iconPath, isDark: isDark))
        .toList();

    return Row(
      children: [
        for (var i = 0; i < desktopCards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i < desktopCards.length - 1 ? 21.w : 0),
              child: desktopCards[i],
            ),
          ),
      ],
    );
  }
}

class _EmployeeStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final bool isDark;

  const _EmployeeStatCard({required this.label, required this.value, required this.iconPath, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTablet(context);
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBgColor = isDark
        ? AppColors.infoBgDark.withValues(alpha: 0.5)
        : EmployeeManagementStatsCards._iconBackgroundLight;

    return Container(
      width: isCompact ? 180.w : null,
      padding: isCompact
          ? EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 12.h)
          : EdgeInsetsDirectional.all(22.w),
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
                Text(label, style: context.textTheme.titleSmall?.copyWith(color: titleColor)),
                Gap(4.h),
                Text(
                  value,
                  style: context.textTheme.displaySmall?.copyWith(fontSize: 26.sp, color: valueColor),
                ),
              ],
            ),
          ),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: iconPath,
              color: EmployeeManagementStatsCards._iconColor,
              width: 16.w,
              height: 16.w,
            ),
          ),
        ],
      ),
    );
  }
}
