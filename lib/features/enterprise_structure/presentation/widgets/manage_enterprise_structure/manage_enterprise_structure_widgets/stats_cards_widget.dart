import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise_stats.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprise_stats_providers.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsCardsWidget extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const StatsCardsWidget({super.key, required this.localizations, required this.isDark});

  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;

  @override
  ConsumerState<StatsCardsWidget> createState() => _StatsCardsWidgetState();
}

class _StatsCardsWidgetState extends ConsumerState<StatsCardsWidget> {
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
    final statsAsync = ref.watch(enterpriseStatsNotifierProvider);

    if (statsAsync.isLoading) {
      return _buildLayout(context, isSkeleton: true);
    }

    if (statsAsync.hasError) {
      return DigifyErrorState(
        message: widget.localizations.somethingWentWrong,
        retryLabel: widget.localizations.retry,
        onRetry: () => ref.read(enterpriseStatsNotifierProvider.notifier).refresh(),
      );
    }

    final stats = statsAsync.valueOrNull;
    return _buildLayout(context, stats: stats);
  }

  Widget _buildLayout(BuildContext context, {EnterpriseStats? stats, bool isSkeleton = false}) {
    final displayStats = stats ?? EnterpriseStats.empty;
    final cards = [
      _EnterpriseStatCard(
        label: widget.localizations.totalStructures,
        value: displayStats.formattedTotalStructures,
        iconPath: Assets.icons.totalStructuresIcon.path,
        isDark: widget.isDark,
        iconColor: StatsCardsWidget._iconColor,
        iconBgLight: StatsCardsWidget._iconBackgroundLight,
      ),
      _EnterpriseStatCard(
        label: widget.localizations.activeStructure,
        value: displayStats.formattedActiveStructures,
        iconPath: Assets.icons.activeStructureIcon.path,
        isDark: widget.isDark,
        iconColor: StatsCardsWidget._iconColor,
        iconBgLight: StatsCardsWidget._iconBackgroundLight,
      ),
      _EnterpriseStatCard(
        label: widget.localizations.componentsInUse,
        value: displayStats.formattedComponentsInUse,
        iconPath: Assets.icons.componentsIcon.path,
        isDark: widget.isDark,
        iconColor: StatsCardsWidget._iconColor,
        iconBgLight: StatsCardsWidget._iconBackgroundLight,
      ),
      _EnterpriseStatCard(
        label: widget.localizations.employeesAssigned,
        value: displayStats.formattedEmployeesAssigned,
        iconPath: Assets.icons.employeesAssignedIcon.path,
        isDark: widget.isDark,
        iconColor: StatsCardsWidget._iconColor,
        iconBgLight: StatsCardsWidget._iconBackgroundLight,
      ),
    ];

    final content = _buildScrollableLayout(context, cards);
    return isSkeleton ? Skeletonizer(enabled: true, child: content) : content;
  }

  Widget _buildScrollableLayout(BuildContext context, List<Widget> cards) {
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
              SizedBox(width: cardWidth, child: cards[index]),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

class _EnterpriseStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconColor;
  final Color iconBgLight;

  const _EnterpriseStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
    required this.iconColor,
    required this.iconBgLight,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBgColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgLight;

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
                  style: context.textTheme.displaySmall?.copyWith(fontSize: 26.sp, color: valueColor),
                ),
              ],
            ),
          ),
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, color: iconColor, width: 21, height: 21),
          ),
        ],
      ),
    );
  }
}
