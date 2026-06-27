import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_list_providers.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdjustmentsStatsSection extends ConsumerStatefulWidget {
  AdjustmentsStatsSection({AdjustmentsListProviders? providers, super.key})
    : providers = providers ?? adjustmentsListProviders;

  final AdjustmentsListProviders providers;

  @override
  ConsumerState<AdjustmentsStatsSection> createState() => _AdjustmentsStatsSectionState();
}

class _AdjustmentsStatsSectionState extends ConsumerState<AdjustmentsStatsSection> {
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
    final adjustmentsAsync = ref.watch(widget.providers.dataPageProvider);
    final adjustments = adjustmentsAsync.valueOrNull?.adjustments ?? [];
    final isLoading = adjustmentsAsync.isLoading;

    final cards = AdjustmentsTabConfig.buildStatCards(adjustments: adjustments, budgetImpactValue: '\$3.1K');
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    return Skeletonizer(
      enabled: isLoading,
      child: Scrollbar(
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
                  child: _AdjustmentStatCard(data: cards[index]),
                ),
                if (index < cards.length - 1) Gap(spacing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AdjustmentStatCard extends StatelessWidget {
  final AdjustmentStatCardData data;

  const _AdjustmentStatCard({required this.data});

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
                Text(
                  data.value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
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
