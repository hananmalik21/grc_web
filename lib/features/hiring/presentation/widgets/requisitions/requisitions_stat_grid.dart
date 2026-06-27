import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionsStatCard extends StatelessWidget {
  const RequisitionsStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtext,
    required this.iconPath,
    this.showTrendIcon = false,
  });

  final String title;
  final String value;
  final String? subtext;
  final String iconPath;
  final bool showTrendIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    const iconColor = AppColors.statIconBlue;
    const iconBgColor = AppColors.infoBg;
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.dashboardStatLabel;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.dashboardStatValue;
    final subtextColor = AppColors.statIconBlue;
    final iconBackgroundColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
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
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(color: titleColor, fontSize: 14.sp),
                ),
                Gap(8.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 30.sp,
                    height: 36 / 30,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
                if (subtext != null) ...[
                  Gap(6.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showTrendIcon) ...[
                        DigifyAsset(
                          assetPath: Assets.icons.priceUpItem.path,
                          width: 14,
                          height: 14,
                          color: subtextColor,
                        ),
                        Gap(4.w),
                      ],
                      Flexible(
                        child: Text(
                          subtext!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.labelSmall?.copyWith(color: subtextColor, fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Gap(16.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: iconBackgroundColor, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, width: 20, height: 20, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class RequisitionsStatGrid extends ConsumerStatefulWidget {
  const RequisitionsStatGrid({super.key});

  @override
  ConsumerState<RequisitionsStatGrid> createState() => _RequisitionsStatGridState();
}

class _RequisitionsStatGridState extends ConsumerState<RequisitionsStatGrid> {
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
    ref.watch(requisitionsTabEnterpriseIdProvider);
    ref.watch(requisitionsTabRefreshTickProvider);

    final loc = AppLocalizations.of(context)!;
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 16);

    final cards = [
      RequisitionsStatCard(
        title: loc.hiringRequisitionsStatTotal,
        value: '3',
        subtext: loc.hiringRequisitionsStatTotalSubtext,
        iconPath: Assets.icons.sectionIconSmall.path,
        showTrendIcon: true,
      ),
      RequisitionsStatCard(
        title: loc.hiringRequisitionsStatOpenings,
        value: '4',
        subtext: loc.hiringRequisitionsStatOpeningsSubtext,
        iconPath: Assets.icons.employeeListIcon.path,
      ),
      RequisitionsStatCard(
        title: loc.hiringRequisitionsStatPending,
        value: '1',
        subtext: loc.hiringRequisitionsStatPendingSubtext,
        iconPath: Assets.icons.clockIcon.path,
      ),
      RequisitionsStatCard(
        title: loc.hiringRequisitionsStatPriority,
        value: '2',
        subtext: loc.hiringRequisitionsStatPrioritySubtext,
        iconPath: Assets.icons.priceUpItem.path,
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
