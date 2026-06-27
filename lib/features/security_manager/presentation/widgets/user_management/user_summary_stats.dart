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

class UserSummaryStats extends StatefulWidget {
  const UserSummaryStats({super.key});

  @override
  State<UserSummaryStats> createState() => _UserSummaryStatsState();
}

class _UserSummaryStatsState extends State<UserSummaryStats> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    final cards = [
      _UserStatCard(
        label: localizations.totalUsers,
        value: '0',
        subtext: 'All registered users',
        iconPath: Assets.icons.employeesBlueIcon.path,
      ),
      _UserStatCard(
        label: localizations.activeUsers,
        value: '0',
        subtext: 'Currently active',
        iconPath: Assets.icons.checkIconGreen.path,
      ),
      _UserStatCard(
        label: localizations.inactiveUsers,
        value: '0',
        subtext: 'Disabled accounts',
        iconPath: Assets.icons.clockIcon.path,
      ),
      _UserStatCard(
        label: localizations.lockedUsers,
        value: '0',
        subtext: 'Require unlock',
        iconPath: Assets.icons.lockIcon.path,
      ),
    ];

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < cards.length; index++) ...[
              SizedBox(width: cardWidth, child: cards[index]),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

class _UserStatCard extends StatelessWidget {
  const _UserStatCard({required this.label, required this.value, this.subtext, required this.iconPath});

  final String label;
  final String value;
  final String? subtext;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.dashboardStatLabel;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.dashboardStatValue;
    final iconBgColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(color: titleColor, fontSize: 14.sp),
                ),
                Gap(2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(fontSize: 22.sp, color: valueColor),
                ),
                if (subtext != null) ...[
                  Gap(6.h),
                  Text(
                    subtext!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(color: AppColors.statIconBlue, fontSize: 12.sp),
                  ),
                ],
              ],
            ),
          ),
          Gap(16.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, color: AppColors.statIconBlue, width: 20, height: 20),
          ),
        ],
      ),
    );
  }
}
