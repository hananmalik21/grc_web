import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/date_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/leave_management/domain/models/employee_leave_stats.dart';
import 'package:grc/features/leave_management/presentation/providers/employee_leave_stats_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeDetailLeaveStatsCards extends ConsumerWidget {
  const EmployeeDetailLeaveStatsCards({
    super.key,
    required this.employeeGuid,
    required this.isDark,
    required this.localizations,
  });

  final String employeeGuid;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(employeeLeaveStatsProvider(employeeGuid));

    return statsAsync.when(
      data: (stats) => _buildCardsRow(context, stats: stats),
      loading: () => Skeletonizer(enabled: true, child: _buildCardsRow(context)),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildCardsRow(BuildContext context, {EmployeeLeaveStats? stats}) {
    final cards = [
      _EmployeeLeaveStatCard(
        label: localizations.totalRequests,
        value: stats?.totalDisplay ?? '0',
        iconPath: Assets.icons.calendarIcon.path,
        isDark: isDark,
        iconBgColor: AppColors.infoBg,
        iconColor: AppColors.statIconBlue,
      ),
      _EmployeeLeaveStatCard(
        label: localizations.leaveFilterApproved,
        value: stats?.approvedDisplay ?? '0',
        iconPath: Assets.icons.checkIconGreen.path,
        isDark: isDark,
        iconBgColor: AppColors.successBg,
        iconColor: AppColors.success,
      ),
      _EmployeeLeaveStatCard(
        label: localizations.leaveFilterPending,
        value: stats?.pendingDisplay ?? '0',
        iconPath: Assets.icons.clockIcon.path,
        isDark: isDark,
        iconBgColor: AppColors.warningBg,
        iconColor: AppColors.warning,
      ),
      _EmployeeLeaveStatCard(
        label: localizations.rejected,
        value: stats?.rejectedDisplay ?? '0',
        iconPath: Assets.icons.closeIcon.path,
        isDark: isDark,
        iconBgColor: AppColors.errorBg,
        iconColor: AppColors.error,
      ),
    ];

    if (context.responsiveData.isTablet && context.isPortrait) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              Gap(12.w),
              Expanded(child: cards[1]),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(child: cards[2]),
              Gap(12.w),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    }

    const cardCount = 4;
    const gap = 12.0;
    const minCardWidth = 160.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalGaps = gap * (cardCount - 1);
        final availableWidth = constraints.maxWidth - totalGaps;
        final naturalCardWidth = availableWidth / cardCount;
        final cardWidth = naturalCardWidth >= minCardWidth ? naturalCardWidth : minCardWidth;
        final needsScroll = cardWidth == minCardWidth;

        final row = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cards.length; i++)
              Padding(
                padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? gap : 0),
                child: SizedBox(width: cardWidth, child: cards[i]),
              ),
          ],
        );

        if (needsScroll) {
          return SingleChildScrollView(scrollDirection: Axis.horizontal, child: row);
        }
        return row;
      },
    );
  }
}

class _EmployeeLeaveStatCard extends StatelessWidget {
  const _EmployeeLeaveStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
    required this.iconBgColor,
    required this.iconColor,
  });

  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconBgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 160;
        final padding = isCompact ? 12.0 : 22.w;
        final iconSize = isCompact ? 32.0 : 42.w;
        final iconInnerSize = isCompact ? 16.0 : 21.0;
        final valueFontSize = isCompact ? 18.sp : 26.sp;

        return Container(
          padding: EdgeInsetsDirectional.all(padding),
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
                      label.toTitleCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: titleColor,
                        fontSize: isCompact ? 11.sp : null,
                      ),
                    ),
                    Gap(7.h),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.displaySmall?.copyWith(fontSize: valueFontSize, color: valueColor),
                    ),
                  ],
                ),
              ),
              Gap(4.w),
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(7.r)),
                alignment: Alignment.center,
                child: DigifyAsset(assetPath: iconPath, color: iconColor, width: iconInnerSize, height: iconInnerSize),
              ),
            ],
          ),
        );
      },
    );
  }
}
