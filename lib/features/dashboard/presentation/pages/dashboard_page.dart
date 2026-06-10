import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_loading_indicator.dart';
import 'package:grc_web/core/widgets/app_stat_card.dart';
import 'package:grc_web/features/dashboard/application/providers/dashboard_providers.dart';
import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:grc_web/features/dashboard/domain/entities/stat_card_item.dart';
import 'package:grc_web/features/dashboard/presentation/widgets/risk_by_category_chart.dart';
import 'package:grc_web/features/dashboard/presentation/widgets/risk_exposure_trend_chart.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return dashboardAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: AppErrorView(
          message: error is Failure ? error.message : l10n.errorGeneric,
          onRetry: () => ref.read(dashboardDataProvider.notifier).refresh(),
        ),
      ),
      data: (data) => _DashboardView(data: data),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({
    required this.data,
  });

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;
    final compact = layout.isCompact;

    return SingleChildScrollView(
      padding: compact ? ResponsiveHelper.getDetailScreenPadding(context) : EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: compact ? context.responsiveMaxContentWidth : 1512.w),
        child: Column(
          children: [
            _StatsGrid(items: data.stats),
            SizedBox(height: compact ? ResponsiveHelper.getTabSectionSpacing(context) : 24.h),
            const _ChartsRow(),
            SizedBox(height: compact ? ResponsiveHelper.getTabSectionSpacing(context) : 24.h),
            _TopRiskAssetsTable(rows: data.topRiskAssets),
            SizedBox(height: compact ? ResponsiveHelper.getTabSectionSpacing(context) : 24.h),
            _SummaryGrid(items: data.summaryCards),
            SizedBox(height: compact ? ResponsiveHelper.getResponsiveHeight(context, mobile: 32, tablet: 48, web: 66.5) : 66.5.h),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.items});

  final List<StatCardItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.screenLayout;

    final cardSize = layout.isCompact ? AppStatCardSize.compact : AppStatCardSize.standard;
    final cardWidth = layout.isCompact
        ? ResponsiveHelper.getResponsiveWidth(context, mobile: 260, tablet: 300, web: 354)
        : 354.w;
    final spacing = layout.isCompact
        ? context.responsive(mobile: 12.0, tablet: 14.0, desktop: 16.0)
        : 16.0;

    final cards = [
      for (final item in items)
        AppStatCard(
          value: item.value,
          label: _titleFor(l10n, item.type),
          iconAsset: _assetFor(item.type),
          trendLabel: item.trendLabel,
          size: cardSize,
        ),
    ];

    return AppStatCardsRow(
      scrollable: true,
      size: cardSize,
      cardWidth: cardWidth,
      spacing: spacing,
      cards: cards,
    );
  }

  String _titleFor(AppLocalizations l10n, StatCardType type) {
    return switch (type) {
      StatCardType.totalRiskExposure => l10n.statTotalRiskExposure,
      StatCardType.criticalRisks => l10n.statCriticalRisks,
      StatCardType.controlEffectiveness => l10n.statControlEffectiveness,
      StatCardType.vendorRiskScore => l10n.statVendorRiskScore,
    };
  }

  String _assetFor(StatCardType type) {
    return switch (type) {
      StatCardType.totalRiskExposure => 'assets/figma/dashboard/svg/dollar_icon.svg',
      StatCardType.criticalRisks => 'assets/figma/dashboard/svg/warning_icon.svg',
      StatCardType.controlEffectiveness => 'assets/figma/dashboard/svg/security_icon.svg',
      StatCardType.vendorRiskScore => 'assets/figma/dashboard/svg/users_icon.svg',
    };
  }
}

class _ChartsRow extends StatelessWidget {
  const _ChartsRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final compact = context.screenLayout.isCompact;
    final gap = compact ? ResponsiveHelper.getResponsiveWidth(context, mobile: 16, tablet: 20, web: 24) : 24.w;

    if (!compact) {
      return Row(
        children: [
          Expanded(
            child: _ChartCard(
              title: l10n.riskExposureTrend,
              child: const RiskExposureTrendChart(),
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: _ChartCard(
              title: l10n.riskByCategory,
              child: const RiskByCategoryChart(),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _ChartCard(
          title: l10n.riskExposureTrend,
          child: const RiskExposureTrendChart(),
        ),
        SizedBox(height: gap),
        _ChartCard(
          title: l10n.riskByCategory,
          child: const RiskByCategoryChart(),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final compact = context.screenLayout.isCompact;
    final padding = compact ? ResponsiveHelper.getCardPadding(context) : 25.w;
    final titleSpacing = compact ? ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 40) : 40.h;
    final chartHeight = compact ? ResponsiveHelper.getResponsiveHeight(context, mobile: 220, tablet: 300, web: 450) : 450.h;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleMedium),
          SizedBox(height: titleSpacing),
          SizedBox(height: chartHeight, width: double.infinity, child: child),
        ],
      ),
    );
  }
}

class _TopRiskAssetsTable extends StatelessWidget {
  const _TopRiskAssetsTable({required this.rows});

  final List<RiskAssetRow> rows;

  static const _columnWidthValues = <double>[198.12, 409.37, 301.4, 254.04, 251.08];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final compact = context.screenLayout.isCompact;
    final padding = compact ? ResponsiveHelper.getCardPadding(context) : 25.w;
    final useMobileCards = context.screenLayout.isMobile;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.topRiskAssetsTitle,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                l10n.viewAll,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: compact ? ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 18, web: 20) : 20.h),
          if (useMobileCards)
            Column(
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  _RiskAssetMobileCard(row: rows[i]),
                  if (i != rows.length - 1)
                    Divider(height: 1, thickness: 1, color: AppColors.rowDivider.withValues(alpha: 0.8)),
                ],
              ],
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final tableMinWidth = _columnWidthValues.fold<double>(0, (sum, width) => sum + width.w);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth.clamp(tableMinWidth, double.infinity)),
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: {
                        for (int i = 0; i < _columnWidthValues.length; i++)
                          i: FixedColumnWidth(_columnWidthValues[i].w),
                      },
                      children: [
                        _headerRow(context),
                        for (final row in rows) _dataRow(context, row),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  TableRow _headerRow(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: [
        _cellText(l10n.tableRiskId, textTheme.bodyLarge),
        _cellText(l10n.tableAsset, textTheme.bodyLarge),
        _cellText(l10n.tableImpactVar, textTheme.bodyLarge),
        _cellText(l10n.tableLikelihood, textTheme.bodyLarge),
        _cellText(l10n.tableStatus, textTheme.bodyLarge),
      ],
    );
  }

  TableRow _dataRow(BuildContext context, RiskAssetRow row) {
    final textTheme = Theme.of(context).textTheme;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.rowDivider)),
      ),
      children: [
        _cellText(row.riskId, textTheme.bodyLarge),
        _cellText(row.asset, textTheme.bodyMedium),
        _cellText(row.impactVar, textTheme.bodyLarge),
        _cellText(_likelihoodLabel(context, row.likelihood), textTheme.bodyMedium),
        _statusCell(context, row.status),
      ],
    );
  }

  Widget _statusCell(BuildContext context, RiskStatus status) {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.bodySmall?.copyWith(color: _statusFg(status));

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 13.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: _statusBg(status),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(_statusLabel(context, status), style: style),
        ),
      ),
    );
  }

  Widget _cellText(String text, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Text(text, style: style),
    );
  }

  String _likelihoodLabel(BuildContext context, Likelihood l) {
    final l10n = context.l10n;
    return switch (l) {
      Likelihood.high => l10n.likelihoodHigh,
      Likelihood.medium => l10n.likelihoodMedium,
      Likelihood.low => l10n.likelihoodLow,
    };
  }

  String _statusLabel(BuildContext context, RiskStatus s) {
    final l10n = context.l10n;
    return switch (s) {
      RiskStatus.critical => l10n.statusCritical,
      RiskStatus.high => l10n.statusHigh,
      RiskStatus.medium => l10n.statusMedium,
    };
  }

  Color _statusBg(RiskStatus s) {
    return switch (s) {
      RiskStatus.critical => AppColors.statusCriticalBg,
      RiskStatus.high => AppColors.statusHighBg,
      RiskStatus.medium => AppColors.statusMediumBg,
    };
  }

  Color _statusFg(RiskStatus s) {
    return switch (s) {
      RiskStatus.critical => AppColors.statusCriticalFg,
      RiskStatus.high => AppColors.statusHighFg,
      RiskStatus.medium => AppColors.statusMediumFg,
    };
  }
}

class _RiskAssetMobileCard extends StatelessWidget {
  const _RiskAssetMobileCard({required this.row});

  final RiskAssetRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(row.riskId, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              ),
              _StatusBadge(status: row.status),
            ],
          ),
          SizedBox(height: 8.h),
          _MobileField(label: l10n.tableAsset, value: row.asset, textTheme: textTheme),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: _MobileField(label: l10n.tableImpactVar, value: row.impactVar, textTheme: textTheme),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MobileField(
                  label: l10n.tableLikelihood,
                  value: _likelihoodLabel(context, row.likelihood),
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _likelihoodLabel(BuildContext context, Likelihood l) {
    final l10n = context.l10n;
    return switch (l) {
      Likelihood.high => l10n.likelihoodHigh,
      Likelihood.medium => l10n.likelihoodMedium,
      Likelihood.low => l10n.likelihoodLow,
    };
  }
}

class _MobileField extends StatelessWidget {
  const _MobileField({
    required this.label,
    required this.value,
    required this.textTheme,
  });

  final String label;
  final String value;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 2.h),
        Text(value, style: textTheme.bodyMedium),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final RiskStatus status;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final label = switch (status) {
      RiskStatus.critical => l10n.statusCritical,
      RiskStatus.high => l10n.statusHigh,
      RiskStatus.medium => l10n.statusMedium,
    };

    final bg = switch (status) {
      RiskStatus.critical => AppColors.statusCriticalBg,
      RiskStatus.high => AppColors.statusHighBg,
      RiskStatus.medium => AppColors.statusMediumBg,
    };

    final fg = switch (status) {
      RiskStatus.critical => AppColors.statusCriticalFg,
      RiskStatus.high => AppColors.statusHighFg,
      RiskStatus.medium => AppColors.statusMediumFg,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(color: fg),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.items});

  final List<SummaryCardItem> items;

  @override
  Widget build(BuildContext context) {
    final compact = context.screenLayout.isCompact;
    final gap = compact ? 12.w : 16.w;

    if (compact) {
      return Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SummaryCard(item: items[i]),
            if (i != items.length - 1) SizedBox(height: gap),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(child: _SummaryCard(item: items[i])),
          if (i != items.length - 1) SizedBox(width: gap),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.item});

  final SummaryCardItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final compact = context.screenLayout.isCompact;

    final (title, subtitle) = switch (item.type) {
      SummaryCardType.cloudWorkloads => (l10n.summaryCloudWorkloads, l10n.summaryAcrossProviders),
      SummaryCardType.activeControls => (l10n.summaryActiveControls, l10n.summaryEffectivePercent),
      SummaryCardType.securityEvents => (l10n.summarySecurityEvents, l10n.summaryLast30Days),
    };

    return Container(
      padding: EdgeInsets.all(compact ? 17.w : 25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 55.r,
            height: 55.r,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                item.iconAsset,
                width: 30.r,
                height: 30.r,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.value,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.sp,
                  height: 32 / 24,
                  letterSpacing: 0.072,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textBody,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 16 / 12,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
