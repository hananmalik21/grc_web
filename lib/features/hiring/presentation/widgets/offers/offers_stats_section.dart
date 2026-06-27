import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OffersStatsSection extends StatefulWidget {
  const OffersStatsSection({super.key});

  @override
  State<OffersStatsSection> createState() => _OffersStatsSectionState();
}

class _OffersStatsSectionState extends State<OffersStatsSection> {
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
    final loc = AppLocalizations.of(context)!;
    final cards = HiringConfig.buildOfferStatCards(loc);
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

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
              SizedBox(
                width: cardWidth,
                child: _OfferStatCard(data: cards[index]),
              ),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

class _OfferStatCard extends StatelessWidget {
  final OfferStatCardData data;

  const _OfferStatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Gap(6.h),
                Row(
                  children: [
                    Text(
                      data.value,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Gap(4.h),
                Row(
                  children: [
                    if (data.trend != null) ...[
                      Gap(4.w),
                      DigifyAsset(
                        assetPath: Assets.icons.metricsIcon.path,
                        color: AppColors.success,
                        width: 13.w,
                        height: 13.w,
                      ),
                      Gap(4.w),
                    ],
                    Text(
                      data.subtitle,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: data.trend != null
                            ? AppColors.success
                            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(12.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.22) : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: data.iconPath, width: 20, height: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
