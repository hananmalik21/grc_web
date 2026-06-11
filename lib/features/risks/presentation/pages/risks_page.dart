import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_horizontal_scroll_row.dart';
import 'package:grc_web/core/widgets/app_loading_indicator.dart';
import 'package:grc_web/core/widgets/app_responsive_table.dart';
import 'package:grc_web/features/risks/presentation/widgets/add_risk_dialog.dart';
import 'package:grc_web/features/risks/presentation/widgets/risk_detail_dialog.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/risks/application/providers/risks_providers.dart';
import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';

class RisksPage extends ConsumerWidget {
  const RisksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dataAsync = ref.watch(risksProvider);

    return dataAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: AppErrorView(
          message: error is Failure ? error.message : l10n.errorGeneric,
          onRetry: () => ref.invalidate(risksProvider),
        ),
      ),
      data: (data) => _RisksView(data: data),
    );
  }
}

// ---------------------------------------------------------------------------
// Root view
// ---------------------------------------------------------------------------

class _RisksView extends StatelessWidget {
  const _RisksView({required this.data});

  final RisksData data;

  static const _textHeight = AppTextMetrics.textHeight;

  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;
    final compact = layout.isCompact;
    final sectionGap = compact
        ? ResponsiveHelper.getTabSectionSpacing(context)
        : 24.h;

    return SingleChildScrollView(
      padding: compact
          ? ResponsiveHelper.getDetailScreenPadding(context)
          : EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: compact ? context.responsiveMaxContentWidth : 1512.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _RisksTitleBar(),
            SizedBox(height: sectionGap),
            _RisksStatsRow(summary: data.summary),
            SizedBox(height: sectionGap),
            _RiskHeatMap(heatMap: data.heatMap),
            SizedBox(height: sectionGap),
            const _RisksFilterBar(),
            SizedBox(height: sectionGap),
            _RisksTable(risks: data.risks),
            SizedBox(height: sectionGap),
            const _RiskManagementIntegration(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Title bar
// ---------------------------------------------------------------------------

class _RisksTitleBar extends StatelessWidget {
  const _RisksTitleBar();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.riskRegistryTitle,
          style: textTheme.displaySmall?.copyWith(
            fontSize: isMobile ? 20.sp : null,
          ),
          strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
          textHeightBehavior: _RisksView._textHeight,
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.riskRegistrySubtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textBody,
            fontSize: isMobile ? 13.sp : null,
          ),
          strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
          textHeightBehavior: _RisksView._textHeight,
        ),
      ],
    );

    final addButton = AppButton(
      label: l10n.addRisk,
      iconAsset: 'assets/figma/risks/svg/add_risk.svg',
      variant: AppButtonVariant.primary,
      iconSize: isMobile ? 20.r : 16.r,
      size: isMobile ? AppButtonSize.md : AppButtonSize.lg,
      fullWidth: isMobile,
      onPressed: () => showAddRiskDialog(context: context),
    );

    if (layout.isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleSection,
          SizedBox(height: 16.h),
          addButton,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: titleSection),
        addButton,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stats row — 4 cards
// ---------------------------------------------------------------------------

class _RisksStatsRow extends StatelessWidget {
  const _RisksStatsRow({required this.summary});

  final RisksSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final compact = layout.isCompact;

    final cards = [
      _RiskStatCard(
        value: summary.inherentRiskVar,
        label: l10n.statInherentRisk,
        iconAsset: 'assets/figma/risks/svg/stat_inherent_risk.svg',
      ),
      _RiskStatCard(
        value: summary.residualRiskVar,
        label: l10n.statResidualRisk,
        iconAsset: 'assets/figma/risks/svg/stat_residual_risk.svg',
      ),
      _RiskStatCard(
        value: summary.controlEffectiveness,
        label: l10n.statControlEffectiveness,
        iconAsset: 'assets/figma/risks/svg/stat_control_effectiveness.svg',
      ),
      _RiskStatCard(
        value: summary.riskReduction,
        label: l10n.statRiskReduction,
        iconAsset: 'assets/figma/risks/svg/stat_risk_reduction.svg',
      ),
    ];

    if (compact) {
      final cardWidth = layout.isMobile
          ? MediaQuery.sizeOf(context).width * 0.86
          : ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 220,
              tablet: 240,
              web: 260,
            );
      final spacing = context.responsive(
        mobile: 12.0,
        tablet: 14.0,
        desktop: 16.0,
      );

      return AppHorizontalScrollRow(
        spacing: spacing,
        children: [
          for (final card in cards)
            SizedBox(width: cardWidth, child: card),
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i != cards.length - 1) SizedBox(width: 16.w),
        ],
      ],
    );
  }
}

class _RiskStatCard extends StatelessWidget {
  const _RiskStatCard({
    required this.value,
    required this.label,
    required this.iconAsset,
  });

  final String value;
  final String label;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = context.screenLayout.isMobile;
    final padding = ResponsiveHelper.libraryCardPadding(context);
    final iconBoxSize = isMobile ? 36.r : 40.r;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconAsset,
                width: 20.r,
                height: 20.r,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.072,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textBody),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Risk Heat Map
// ---------------------------------------------------------------------------

class _RiskHeatMap extends StatelessWidget {
  const _RiskHeatMap({required this.heatMap});

  final RiskHeatMap heatMap;

  // Exact column widths from Figma node 1085-5895 (px at 1:1 scale).
  // [0]=Likelihood label col, [1-4]=impact band data cols.
  static const _colWidths = <double>[288.89, 229.95, 298.41, 277.45, 319.3];

  // Returns (bg, fg) for a heat-map badge given its matrix position.
  // rowIdx 0=VeryHigh…4=VeryLow, colIdx 0=Low(1-4)…3=Critical(15-25).
  static (Color bg, Color fg) _badgeColors(int rowIdx, int colIdx) {
    final combined = (5 - rowIdx) + (colIdx + 1);
    // VeryHigh×Critical = 9 → deepest red (unique Figma color)
    if (combined >= 9) {
      return (const Color(0xFFFFC9C9), const Color(0xFF82181A));
    }
    // High risk zone → standard critical palette
    if (combined >= 6) {
      return (AppColors.statusCriticalBg, AppColors.statusCriticalFg);
    }
    // Medium risk zone
    if (combined >= 4) {
      return (AppColors.statusMediumBg, AppColors.statusMediumFg);
    }
    // Low risk zone
    return (AppColors.statusLowBg, AppColors.statusLowFg);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    // Column header labels (for data cols 1-4).
    final colLabels = [
      l10n.heatMapColLow,
      l10n.heatMapColMedium,
      l10n.heatMapColHigh,
      l10n.heatMapColCritical,
    ];
    // Row header labels.
    final rowLabels = [
      l10n.heatMapRowVeryHigh,
      l10n.heatMapRowHigh,
      l10n.heatMapRowMedium,
      l10n.heatMapRowLow,
      l10n.heatMapRowVeryLow,
    ];

    final headerCellStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textLabel,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.154,
    );
    final rowLabelStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.154,
    );
    final padding = ResponsiveHelper.libraryCardPadding(context);
    final badgeSize = context.screenLayout.isMobile ? 40.r : 48.r;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title — 18px semibold, tracking -0.45
          Text(
            l10n.riskHeatMapTitle,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 16.h),
          // Table — horizontally scrollable so it never clips on small widths
          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth = _colWidths.fold<double>(0, (s, w) => s + w.w);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth.clamp(tableWidth, double.infinity),
                  ),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      for (int i = 0; i < _colWidths.length; i++)
                        i: FixedColumnWidth(_colWidths[i].w),
                    },
                    children: [
                      // ── Header row ──────────────────────────────────────────
                      TableRow(
                        children: [
                          // "Likelihood" left-aligned label
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: Text(
                              l10n.heatMapLikelihoodHeader,
                              style: headerCellStyle,
                            ),
                          ),
                          // 4 centered column headers
                          for (final label in colLabels)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              child: Text(
                                label,
                                style: headerCellStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                      // ── Body rows ────────────────────────────────────────────
                      for (int rowIdx = 0; rowIdx < 5; rowIdx++)
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.rowDivider),
                            ),
                          ),
                          children: [
                            // Row likelihood label
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                16.w, 26.25.h, 16.w, 26.75.h,
                              ),
                              child: Text(rowLabels[rowIdx], style: rowLabelStyle),
                            ),
                            // 4 data cells
                            for (int colIdx = 0; colIdx < 4; colIdx++)
                              _HeatCell(
                                count: heatMap[rowIdx][colIdx],
                                rowIdx: rowIdx,
                                colIdx: colIdx,
                                badgeColorsFn: _badgeColors,
                                badgeSize: badgeSize,
                              ),
                          ],
                        ),
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
}

/// Single heat-map data cell — always shows a 48×48 badge.
class _HeatCell extends StatelessWidget {
  const _HeatCell({
    required this.count,
    required this.rowIdx,
    required this.colIdx,
    required this.badgeColorsFn,
    this.badgeSize = 48,
  });

  final int count;
  final int rowIdx;
  final int colIdx;
  final (Color, Color) Function(int row, int col) badgeColorsFn;
  final double badgeSize;

  @override
  Widget build(BuildContext context) {
    final isZero = count == 0;
    final (bg, fg) = isZero
        ? (AppColors.chipTagBg, const Color(0xFF99A1AF))
        : badgeColorsFn(rowIdx, colIdx);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.5.h),
      child: Center(
        child: Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 16.sp,
                height: 24 / 16,
                fontWeight: isZero ? FontWeight.w400 : FontWeight.w600,
                color: fg,
                letterSpacing: -0.32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bar
// ---------------------------------------------------------------------------

class _RisksFilterBar extends StatefulWidget {
  const _RisksFilterBar();

  @override
  State<_RisksFilterBar> createState() => _RisksFilterBarState();
}

class _RisksFilterBarState extends State<_RisksFilterBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;
    final isTabletSmall = layout.isTabletSmall;
    final padding = ResponsiveHelper.libraryCardPadding(context);

    final searchField = AppTextField.search(
      controller: _searchController,
      hint: l10n.searchRisksPlaceholder,
    );

    final categoryField = AppSelectField<String>(
      value: 'all',
      items: const ['all'],
      itemLabel: (_) => l10n.allCategories,
      onChanged: (_) {},
      contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
    );

    final statusField = AppSelectField<String>(
      value: 'all',
      items: const ['all'],
      itemLabel: (_) => l10n.allStatuses,
      onChanged: (_) {},
      contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
    );

    final exportButton = AppButton.export(
      label: l10n.export,
      iconAsset: 'assets/figma/assets/svg/export.svg',
      iconSize: isMobile ? 20.r : 20.r,
      size: isMobile ? AppButtonSize.md : AppButtonSize.lg,
      fullWidth: isMobile,
      onPressed: () {},
    );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchField,
                SizedBox(height: 12.h),
                categoryField,
                SizedBox(height: 12.h),
                statusField,
                SizedBox(height: 12.h),
                exportButton,
              ],
            )
          : isTabletSmall
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(child: categoryField),
                        SizedBox(width: 8.w),
                        Expanded(child: statusField),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    exportButton,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: searchField),
                    SizedBox(width: 16.w),
                    SizedBox(width: 170.w, child: categoryField),
                    SizedBox(width: 8.w),
                    SizedBox(width: 140.w, child: statusField),
                    SizedBox(width: 8.w),
                    exportButton,
                  ],
                ),
    );
  }
}

// ---------------------------------------------------------------------------
// Risk display helpers (shared by table + mobile cards)
// ---------------------------------------------------------------------------

(Color bg, Color fg, String label) _riskStatusProps(
  BuildContext context,
  RiskStatus status,
) {
  final l10n = context.l10n;
  return switch (status) {
    RiskStatus.assessed => (
        AppColors.statusHighBg,
        AppColors.statusHighFg,
        l10n.statusAssessed,
      ),
    RiskStatus.treated => (
        AppColors.primaryTint,
        AppColors.primary,
        l10n.statusTreated,
      ),
    RiskStatus.monitored => (
        AppColors.statusLowBg,
        AppColors.statusLowFg,
        l10n.statusMonitored,
      ),
    RiskStatus.open => (
        AppColors.statusCriticalBg,
        AppColors.statusCriticalFg,
        l10n.statusCritical,
      ),
  };
}

// ---------------------------------------------------------------------------
// Risks table
// ---------------------------------------------------------------------------

class _RisksTable extends StatelessWidget {
  const _RisksTable({required this.risks});

  final List<RiskItem> risks;

  static final _layout = AppResponsiveTableLayout(
    columns: [
      AppTableColumnSpec(minWidth: 82.59, dropPriority: 0), // Risk ID
      AppTableColumnSpec(minWidth: 265.79, dropPriority: 0), // Title
      AppTableColumnSpec(minWidth: 78.91, dropPriority: 7), // Assets
      AppTableColumnSpec(minWidth: 140.91, dropPriority: 6), // Category
      AppTableColumnSpec(minWidth: 114.54, dropPriority: 2), // Status
      AppTableColumnSpec(minWidth: 111.91, dropPriority: 9), // Likelihood
      AppTableColumnSpec(minWidth: 104.22, dropPriority: 8), // Impact
      AppTableColumnSpec(minWidth: 95.83, dropPriority: 3), // Inherent
      AppTableColumnSpec(minWidth: 97.16, dropPriority: 4), // Residual
      AppTableColumnSpec(minWidth: 102.98, dropPriority: 10), // Treatment
      AppTableColumnSpec(minWidth: 143.19, dropPriority: 5), // Owner
      AppTableColumnSpec(minWidth: 123.96, dropPriority: 0), // Actions
    ],
  );

  @override
  Widget build(BuildContext context) {
    final useMobileCards = context.screenLayout.isMobile;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: useMobileCards
          ? Column(
              children: [
                for (int i = 0; i < risks.length; i++) ...[
                  _RiskMobileCard(risk: risks[i]),
                  if (i != risks.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.rowDivider.withValues(alpha: 0.8),
                    ),
                ],
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final visible = _layout.visibleIndicesForWidth(
                  constraints.maxWidth,
                );
                final tableMinWidth = _layout.minWidthForIndices(visible);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth.clamp(
                        tableMinWidth,
                        double.infinity,
                      ),
                    ),
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: _layout.columnWidthsForIndices(visible),
                      children: [
                        _headerRow(context, visible),
                        for (final risk in risks)
                          _dataRow(context, risk, visible),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  TableRow _headerRow(BuildContext context, List<int> visible) {
    final l10n = context.l10n;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textLabel,
          fontWeight: FontWeight.w500,
        );

    final cells = [
      _headerCell(l10n.tableRiskId, style),
      _headerCell(l10n.tableRiskTitle, style),
      _headerCell(l10n.tableRiskAssets, style),
      _headerCell(l10n.tableRiskCategory, style),
      _headerCell(l10n.tableStatus, style),
      _headerCell(l10n.tableLikelihood, style),
      _headerCell(l10n.tableImpactDollar, style),
      _headerCell(l10n.tableInherent, style),
      _headerCell(l10n.tableResidual, style),
      _headerCell(l10n.tableTreatment, style),
      _headerCell(l10n.tableOwner, style),
      _headerCell(l10n.tableActions, style),
    ];

    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: _layout.cellsForIndices(cells, visible),
    );
  }

  TableRow _dataRow(BuildContext context, RiskItem risk, List<int> visible) {
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textLabel,
      fontWeight: FontWeight.w400,
    );

    final cells = [
      _idCell(
        context,
        risk.id,
        () => showRiskDetailDialog(context: context, risk: risk),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Text(
          risk.title,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      _assetsCell(context, risk.assetCount),
      Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Text(risk.category, style: bodyStyle),
      ),
      _statusCell(context, risk.status),
      _likelihoodCell(context, risk.likelihood),
      Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Text(
          risk.impactValue,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      _twoLineRiskCell(context, risk.inherentValue, risk.inherentSeverity),
      _twoLineRiskCell(context, risk.residualValue, risk.residualSeverity),
      Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Text(_treatmentLabel(context, risk.treatment), style: bodyStyle),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Text(risk.owner, style: bodyStyle),
      ),
      _actionsCell(context, risk),
    ];

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.rowDivider)),
      ),
      children: _layout.cellsForIndices(cells, visible),
    );
  }

  Widget _headerCell(String text, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Text(text, style: style),
    );
  }

  Widget _idCell(BuildContext context, String id, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 22.5.h, 16.w, 22.5.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Text(
          id,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget _assetsCell(BuildContext context, int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 22.5.h, 16.w, 22.5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/figma/risks/svg/assets_link.svg',
                  width: 12.r,
                  height: 12.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '$count',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCell(BuildContext context, RiskStatus status) {
    final (bg, fg, label) = _riskStatusProps(context, status);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 22.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                height: 16 / 12,
              ),
        ),
      ),
    );
  }

  Widget _likelihoodCell(BuildContext context, RiskLikelihood likelihood) {
    final (bg, fg, label) = _likelihoodProps(context, likelihood);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 22.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                height: 16 / 12,
              ),
        ),
      ),
    );
  }

  Widget _twoLineRiskCell(BuildContext context, String value, RiskSeverity severity) {
    final textTheme = Theme.of(context).textTheme;
    final (bg, fg, label) = _severityProps(context, severity);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.5.h, 16.w, 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                height: 16 / 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsCell(BuildContext context, RiskItem risk) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton.icon(
            iconAsset: 'assets/figma/assets/svg/edit_asset.svg',
            onPressed: () {},
            bordered: false,
          ),
          SizedBox(width: 4.w),
          AppButton.icon(
            iconAsset: 'assets/figma/risks/svg/view_risk.svg',
            onPressed: () => showRiskDetailDialog(context: context, risk: risk),
            bordered: false,
          ),
          SizedBox(width: 4.w),
          AppButton.icon(
            iconAsset: 'assets/figma/assets/svg/delete_asset.svg',
            onPressed: () {},
            bordered: false,
          ),
        ],
      ),
    );
  }

  (Color bg, Color fg, String label) _likelihoodProps(BuildContext context, RiskLikelihood likelihood) {
    final l10n = context.l10n;
    return switch (likelihood) {
      RiskLikelihood.veryHigh => (AppColors.statusCriticalBg, AppColors.statusCriticalFg, l10n.likelihoodVeryHigh),
      RiskLikelihood.high => (AppColors.statusHighBg, AppColors.statusHighFg, l10n.likelihoodHigh),
      RiskLikelihood.medium => (AppColors.statusMediumBg, AppColors.statusMediumFg, l10n.likelihoodMedium),
      RiskLikelihood.low => (AppColors.statusLowBg, AppColors.statusLowFg, l10n.likelihoodLow),
      RiskLikelihood.veryLow => (AppColors.statusLowBg, AppColors.statusLowFg, l10n.likelihoodVeryLow),
    };
  }

  (Color bg, Color fg, String label) _severityProps(BuildContext context, RiskSeverity severity) {
    final l10n = context.l10n;
    return switch (severity) {
      RiskSeverity.critical => (AppColors.statusCriticalBg, AppColors.statusCriticalFg, l10n.statusCritical),
      RiskSeverity.high => (AppColors.statusHighBg, AppColors.statusHighFg, l10n.statusHigh),
      RiskSeverity.medium => (AppColors.statusMediumBg, AppColors.statusMediumFg, l10n.statusMedium),
      RiskSeverity.low => (AppColors.statusLowBg, AppColors.statusLowFg, l10n.likelihoodLow),
    };
  }

  String _treatmentLabel(BuildContext context, RiskTreatment treatment) {
    final l10n = context.l10n;
    return switch (treatment) {
      RiskTreatment.mitigate => l10n.treatmentMitigate,
      RiskTreatment.transfer => l10n.treatmentTransfer,
      RiskTreatment.accept => l10n.treatmentAccept,
      RiskTreatment.avoid => l10n.treatmentAvoid,
    };
  }
}

class _RiskMobileCard extends StatelessWidget {
  const _RiskMobileCard({required this.risk});

  final RiskItem risk;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final (statusBg, statusFg, statusLabel) =
        _riskStatusProps(context, risk.status);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () =>
                          showRiskDetailDialog(context: context, risk: risk),
                      borderRadius: BorderRadius.circular(4.r),
                      child: Text(
                        risk.id,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      risk.title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: statusLabel,
                backgroundColor: statusBg,
                foregroundColor: statusFg,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _MobileField(
                  label: l10n.tableRiskCategory,
                  value: risk.category,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MobileField(
                  label: l10n.tableRiskAssets,
                  value: '${risk.assetCount}',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _MobileField(
                  label: l10n.tableInherent,
                  value: risk.inherentValue,
                  valueStyle: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MobileField(
                  label: l10n.tableResidual,
                  value: risk.residualValue,
                  valueStyle: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _MobileField(label: l10n.tableOwner, value: risk.owner),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.icon(
                iconAsset: 'assets/figma/assets/svg/edit_asset.svg',
                onPressed: () {},
                bordered: false,
              ),
              SizedBox(width: 4.w),
              AppButton.icon(
                iconAsset: 'assets/figma/risks/svg/view_risk.svg',
                onPressed: () =>
                    showRiskDetailDialog(context: context, risk: risk),
                bordered: false,
              ),
              SizedBox(width: 4.w),
              AppButton.icon(
                iconAsset: 'assets/figma/assets/svg/delete_asset.svg',
                onPressed: () {},
                bordered: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileField extends StatelessWidget {
  const _MobileField({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: valueStyle ?? textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Risk Management Integration footer
// ---------------------------------------------------------------------------

class _RiskManagementIntegration extends StatelessWidget {
  const _RiskManagementIntegration();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final items = [
      (
        icon: 'assets/figma/risks/svg/integration_assets.svg',
        title: l10n.integrationLinkedToAssets,
        desc: l10n.integrationLinkedToAssetsDesc,
      ),
      (
        icon: 'assets/figma/risks/svg/integration_controls.svg',
        title: l10n.integrationControlMapping,
        desc: l10n.integrationControlMappingDesc,
      ),
      (
        icon: 'assets/figma/risks/svg/integration_assessment.svg',
        title: l10n.integrationAssessmentFramework,
        desc: l10n.integrationAssessmentFrameworkDesc,
      ),
      (
        icon: 'assets/figma/risks/svg/integration_programs.svg',
        title: l10n.integrationMitigationPrograms,
        desc: l10n.integrationMitigationProgramsDesc,
      ),
    ];

    final layout = context.screenLayout;
    final padding = ResponsiveHelper.libraryCardPadding(context);
    final gap = layout.isMobile ? 16.h : 16.w;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.primaryLightBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.riskManagementIntegration,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
              fontSize: layout.isMobile ? 16.sp : null,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 16.h),
          if (layout.isMobile)
            Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _IntegrationItem(
                    iconAsset: items[i].icon,
                    title: items[i].title,
                    description: items[i].desc,
                  ),
                  if (i != items.length - 1) SizedBox(height: gap),
                ],
              ],
            )
          else if (layout.isCompact)
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _IntegrationItem(
                        iconAsset: items[0].icon,
                        title: items[0].title,
                        description: items[0].desc,
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: _IntegrationItem(
                        iconAsset: items[1].icon,
                        title: items[1].title,
                        description: items[1].desc,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: gap),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _IntegrationItem(
                        iconAsset: items[2].icon,
                        title: items[2].title,
                        description: items[2].desc,
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: _IntegrationItem(
                        iconAsset: items[3].icon,
                        title: items[3].title,
                        description: items[3].desc,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0) SizedBox(width: gap),
                  Expanded(
                    child: _IntegrationItem(
                      iconAsset: items[i].icon,
                      title: items[i].title,
                      description: items[i].desc,
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _IntegrationItem extends StatelessWidget {
  const _IntegrationItem({
    required this.iconAsset,
    required this.title,
    required this.description,
  });

  final String iconAsset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon bg: 32×32, rounded-10, #155DFC; icon: 16×16 white
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: 16.r,
              height: 16.r,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title: 14px semibold #101828, tracking -0.154
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.154,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              // Description: 12px regular #4A5565
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textBody,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
