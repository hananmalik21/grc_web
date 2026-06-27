import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_stats.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/active_structure_stats_providers.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ComponentValuesStatCardData {
  const ComponentValuesStatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final Color color;
}

String _labelForLevelCode(String levelCode, AppLocalizations l10n) {
  switch (levelCode.toUpperCase()) {
    case 'COMPANY':
      return l10n.companies;
    case 'DIVISION':
      return l10n.divisions;
    case 'BUSINESS_UNIT':
      return l10n.businessUnits;
    case 'DEPARTMENT':
      return l10n.departments;
    case 'SECTION':
      return l10n.sections;
    default:
      return levelCode;
  }
}

String _iconForLevelCode(String levelCode) {
  switch (levelCode.toUpperCase()) {
    case 'COMPANY':
      return Assets.icons.companyStatIcon.path;
    case 'DIVISION':
      return Assets.icons.divisionStatIcon.path;
    case 'BUSINESS_UNIT':
      return Assets.icons.businessUnitStatIcon.path;
    case 'DEPARTMENT':
      return Assets.icons.departmentStatIcon.path;
    case 'SECTION':
      return Assets.icons.sectionStatIcon.path;
    default:
      return Assets.icons.companyStatIcon.path;
  }
}

List<ComponentValuesStatCardData> _placeholderCards(AppLocalizations localizations) {
  const iconColor = AppColors.statIconBlue;
  return [
    ComponentValuesStatCardData(
      label: localizations.companies,
      value: '0',
      icon: Assets.icons.companyStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.businessUnits,
      value: '0',
      icon: Assets.icons.businessUnitStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.divisions,
      value: '0',
      icon: Assets.icons.divisionStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.departments,
      value: '0',
      icon: Assets.icons.departmentStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.sections,
      value: '0',
      icon: Assets.icons.sectionStatIcon.path,
      color: iconColor,
    ),
  ];
}

List<ComponentValuesStatCardData> _buildCardsFromLevels(
  List<LevelWithComponents> levels,
  AppLocalizations localizations,
) {
  const iconColor = AppColors.statIconBlue;
  final sorted = List<LevelWithComponents>.from(levels)..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  return sorted
      .map(
        (level) => ComponentValuesStatCardData(
          label: _labelForLevelCode(level.levelCode, localizations),
          value: level.formattedComponentCount,
          icon: _iconForLevelCode(level.levelCode),
          color: iconColor,
        ),
      )
      .toList();
}

class ComponentValuesStatCards extends ConsumerStatefulWidget {
  const ComponentValuesStatCards({super.key});

  @override
  ConsumerState<ComponentValuesStatCards> createState() => _ComponentValuesStatCardsState();
}

class _ComponentValuesStatCardsState extends ConsumerState<ComponentValuesStatCards> {
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
    final statsAsync = ref.watch(activeStructureStatsNotifierProvider);
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    if (statsAsync.hasError) {
      return DigifyErrorState(
        message: localizations.somethingWentWrong,
        retryLabel: localizations.retry,
        onRetry: () => ref.read(activeStructureStatsNotifierProvider.notifier).refresh(),
      );
    }

    final isLoading = statsAsync.isLoading;
    final cards = isLoading
        ? _placeholderCards(localizations)
        : _buildCardsFromLevels(statsAsync.valueOrNull?.levelsWithComponents ?? [], localizations);

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
                  child: _ComponentValuesStatCard(card: cards[index], isDark: isDark),
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

class _ComponentValuesStatCard extends StatelessWidget {
  const _ComponentValuesStatCard({required this.card, required this.isDark});

  final ComponentValuesStatCardData card;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBgColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg;

    final cardPadding = context.responsive<double>(mobile: 16, tablet: 18, desktop: 22);
    final iconBoxSize = context.responsive<double>(mobile: 38, tablet: 40, desktop: 42);
    final iconSize = context.responsive<double>(mobile: 19, tablet: 20, desktop: 21);
    final valueFontSize = context.responsive<double>(mobile: 22, tablet: 24, desktop: 26);

    return Container(
      padding: EdgeInsetsDirectional.all(cardPadding),
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
                  card.label,
                  style: context.textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
                ),
                const Gap(7),
                Text(
                  card.value,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: card.icon, color: card.color, width: iconSize, height: iconSize),
          ),
        ],
      ),
    );
  }
}
