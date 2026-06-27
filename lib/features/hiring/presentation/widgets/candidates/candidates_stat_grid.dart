import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/hiring/presentation/models/candidate_stat_data.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidatesStatCard extends StatelessWidget {
  const CandidatesStatCard({super.key, required this.data});

  final CandidateStatData data;

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
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(color: titleColor, fontSize: 14.sp),
                ),
                Gap(8.h),
                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 30.sp,
                    height: 36 / 30,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
                if (data.subtext != null) ...[
                  Gap(6.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data.showTrendIcon) ...[
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
                          data.subtext!,
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
            child: DigifyAsset(assetPath: data.iconPath, width: 20, height: 20, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class CandidatesStatGrid extends ConsumerStatefulWidget {
  const CandidatesStatGrid({super.key});

  @override
  ConsumerState<CandidatesStatGrid> createState() => _CandidatesStatGridState();
}

class _CandidatesStatGridState extends ConsumerState<CandidatesStatGrid> {
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
    ref.watch(candidatesTabEnterpriseIdProvider);
    ref.watch(candidatesTabRefreshTickProvider);

    final loc = AppLocalizations.of(context)!;
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 16);

    final statData = CandidatesTabConfig.buildStatCards(loc);

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
            for (var index = 0; index < statData.length; index++) ...[
              SizedBox(
                width: cardWidth,
                child: CandidatesStatCard(data: statData[index]),
              ),
              if (index < statData.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}
