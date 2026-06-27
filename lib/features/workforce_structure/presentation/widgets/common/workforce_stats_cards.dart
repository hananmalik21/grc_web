import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_stats_providers.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkforceStatsCards extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const WorkforceStatsCards({super.key, required this.localizations, required this.isDark});

  @override
  ConsumerState<WorkforceStatsCards> createState() => _WorkforceStatsCardsState();
}

class _WorkforceStatsCardsState extends ConsumerState<WorkforceStatsCards> {
  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;
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
    final statsAsync = ref.watch(workforceStatsNotifierProvider);

    if (statsAsync.isLoading) {
      return _buildScrollableLayout(context, isSkeleton: true);
    }

    if (statsAsync.hasError) {
      return DigifyErrorState(
        message: 'Failed to load workforce statistics',
        onRetry: () => ref.read(workforceStatsNotifierProvider.notifier).refresh(),
      );
    }

    final stats = statsAsync.valueOrNull;
    final positionsStats = stats?.positionsStats;
    final cards = [
      _WorkforceStatCard(
        label: widget.localizations.totalPositions,
        value: positionsStats?.formattedTotalPositions ?? '0',
        iconPath: Assets.icons.workforce.totalPosition.path,
        isDark: widget.isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _WorkforceStatCard(
        label: widget.localizations.filledPositions,
        value: positionsStats?.formattedFilledPositions ?? '0',
        iconPath: Assets.icons.workforce.filledPosition.path,
        isDark: widget.isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _WorkforceStatCard(
        label: widget.localizations.vacantPositions,
        value: positionsStats?.formattedVacantPositions ?? '0',
        iconPath: Assets.icons.workforce.warning.path,
        isDark: widget.isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _WorkforceStatCard(
        label: widget.localizations.fillRate,
        value: positionsStats?.formattedFillRate ?? '0%',
        iconPath: Assets.icons.workforce.fillRate.path,
        isDark: widget.isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
    ];

    return _buildScrollableLayout(context, cards: cards);
  }

  Widget _buildScrollableLayout(BuildContext context, {List<Widget>? cards, bool isSkeleton = false}) {
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    final content = Skeletonizer(
      enabled: isSkeleton,
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
              if (cards != null) ...[
                for (var index = 0; index < cards.length; index++) ...[
                  SizedBox(width: cardWidth, child: cards[index]),
                  if (index < cards.length - 1) Gap(spacing),
                ],
              ] else ...[
                for (var i = 0; i < 4; i++) ...[
                  SizedBox(width: cardWidth, child: const _WorkforceStatCardSkeleton()),
                  if (i < 3) Gap(spacing),
                ],
              ],
            ],
          ),
        ),
      ),
    );

    return content;
  }
}

class _WorkforceStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconBgColor;
  final Color iconColor;

  const _WorkforceStatCard({
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
    final iconBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.22) : iconBgColor;

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
                Text(label, style: context.textTheme.bodyMedium?.copyWith(color: titleColor)),
                Gap(6.h),
                Text(
                  value,
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 20.sp, color: valueColor),
                ),
              ],
            ),
          ),
          Gap(12.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, width: 20, height: 20, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class _WorkforceStatCardSkeleton extends StatelessWidget {
  const _WorkforceStatCardSkeleton();

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
                Container(height: 12.h, width: 80.w, color: Colors.grey),
                Gap(6.h),
                Container(height: 20.h, width: 120.w, color: Colors.grey),
              ],
            ),
          ),
          Gap(12.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.r)),
          ),
        ],
      ),
    );
  }
}
