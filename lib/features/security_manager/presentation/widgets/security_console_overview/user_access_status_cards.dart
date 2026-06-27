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

/// Stats cards for the Security Manager Overview screen.
class UserAccessStatusCards extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const UserAccessStatusCards({
    super.key,
    required this.localizations,
    required this.isDark,
  });

  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final cards = [
      _SecurityStatCard(
        label: localizations.active,
        value: '0',
        iconPath: Assets.icons.checkIconGreen.path,
        isDark: isDark,
      ),
      _SecurityStatCard(
        label: localizations.inactive,
        value: '0',
        iconPath: Assets.icons.clockIcon.path,
        isDark: isDark,
      ),
      _SecurityStatCard(
        label: localizations.withRoles,
        value: '0',
        iconPath: Assets.icons.employeesBlueIcon.path,
        isDark: isDark,
      ),
      _SecurityStatCard(
        label: localizations.mfaEnabled,
        value: '0',
        iconPath: Assets.icons.securityIcon.path,
        isDark: isDark,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.userAccessStatus,
          style: context.textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        Gap(12.h),
        Builder(
          builder: (_) {
            if (isMobile) {
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
            } else if (isTablet) {
              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: cards
                    .map(
                      (card) => SizedBox(
                        width:
                            (MediaQuery.of(context).size.width - 48.w - 12.w) /
                            2,
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
          },
        ),
      ],
    );
  }
}

class _SecurityStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final bool isDark;

  const _SecurityStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
    final valueColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final iconBgColor = isDark
        ? AppColors.infoBgDark.withValues(alpha: 0.5)
        : UserAccessStatusCards._iconBackgroundLight;

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
                    fontWeight: FontWeight.w500,
                  ),
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
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(7.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: iconPath,
              color: UserAccessStatusCards._iconColor,
              width: 21,
              height: 21,
            ),
          ),
        ],
      ),
    );
  }
}
