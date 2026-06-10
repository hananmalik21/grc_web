import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_loading_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1512.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _RisksTitleBar(),
            SizedBox(height: 24.h),
            _RisksStatsRow(summary: data.summary),
            SizedBox(height: 24.h),
            _RiskHeatMap(heatMap: data.heatMap),
            SizedBox(height: 24.h),
            const _RisksFilterBar(),
            SizedBox(height: 24.h),
            _RisksTable(risks: data.risks),
            SizedBox(height: 24.h),
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

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.riskRegistryTitle,
                style: textTheme.displaySmall,
                strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.riskRegistrySubtitle,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textBody),
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ],
          ),
        ),
        AppButton(
          label: l10n.addRisk,
          iconAsset: 'assets/figma/risks/svg/add_risk.svg',
          variant: AppButtonVariant.primary,
          iconSize: 16.r,
          onPressed: () => showAddRiskDialog(context: context),
        ),
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

    return Row(
      children: [
        Expanded(
          child: _RiskStatCard(
            value: summary.inherentRiskVar,
            label: l10n.statInherentRisk,
            iconAsset: 'assets/figma/risks/svg/stat_inherent_risk.svg',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _RiskStatCard(
            value: summary.residualRiskVar,
            label: l10n.statResidualRisk,
            iconAsset: 'assets/figma/risks/svg/stat_residual_risk.svg',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _RiskStatCard(
            value: summary.controlEffectiveness,
            label: l10n.statControlEffectiveness,
            iconAsset: 'assets/figma/risks/svg/stat_control_effectiveness.svg',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _RiskStatCard(
            value: summary.riskReduction,
            label: l10n.statRiskReduction,
            iconAsset: 'assets/figma/risks/svg/stat_risk_reduction.svg',
          ),
        ),
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

    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
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

    return Container(
      padding: EdgeInsets.all(25.w),
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
  });

  final int count;
  final int rowIdx;
  final int colIdx;
  final (Color, Color) Function(int row, int col) badgeColorsFn;

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
          width: 48.r,
          height: 48.r,
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

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AppTextField(
              controller: _searchController,
              hint: l10n.searchRisksPlaceholder,
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 9.w),
                child: SvgPicture.asset(
                  'assets/figma/assets/svg/search.svg',
                  width: 20.r,
                  height: 20.r,
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(41.w, 11.5.h, 17.w, 11.5.h),
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 170.w,
            child: AppSelectField<String>(
              value: 'all',
              items: const ['all'],
              itemLabel: (_) => l10n.allCategories,
              onChanged: (_) {},
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 140.w,
            child: AppSelectField<String>(
              value: 'all',
              items: const ['all'],
              itemLabel: (_) => l10n.allStatuses,
              onChanged: (_) {},
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
          ),
          SizedBox(width: 8.w),
          AppButton(
            label: l10n.export,
            iconAsset: 'assets/figma/assets/svg/export.svg',
            variant: AppButtonVariant.outlined,
            iconSize: 20.r,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Risks table
// ---------------------------------------------------------------------------

class _RisksTable extends StatelessWidget {
  const _RisksTable({required this.risks});

  final List<RiskItem> risks;

  // Pixel-perfect column widths from Figma node 1085-6007 header cells (total ~1462px).
  static const _colWidths = <double>[
    82.59,  // Risk ID
    265.79, // Title
    78.91,  // Assets
    140.91, // Category  (Figma: x=427.295, w=140.91)
    114.54, // Status
    111.91, // Likelihood
    104.22, // Impact ($)
    95.83,  // Inherent
    97.16,  // Residual
    102.98, // Treatment
    143.19, // Owner
    123.96, // Actions   (Figma: x=1338.035, w=123.96)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableMinWidth = _colWidths.fold<double>(0, (s, w) => s + w.w);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth.clamp(tableMinWidth, double.infinity),
              ),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  for (int i = 0; i < _colWidths.length; i++)
                    i: FixedColumnWidth(_colWidths[i].w),
                },
                children: [
                  _headerRow(context),
                  for (final risk in risks) _dataRow(context, risk),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow _headerRow(BuildContext context) {
    final l10n = context.l10n;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textLabel,
          fontWeight: FontWeight.w500,
        );

    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: [
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
      ],
    );
  }

  TableRow _dataRow(BuildContext context, RiskItem risk) {
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textLabel,
      fontWeight: FontWeight.w400,
    );

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.rowDivider)),
      ),
      children: [
        // Risk ID
        _idCell(context, risk.id, () => showRiskDetailDialog(context: context, risk: risk)),
        // Title
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
        // Assets count chip
        _assetsCell(context, risk.assetCount),
        // Category
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Text(risk.category, style: bodyStyle),
        ),
        // Status badge
        _statusCell(context, risk.status),
        // Likelihood badge
        _likelihoodCell(context, risk.likelihood),
        // Impact ($)
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
        // Inherent (value + severity badge stacked)
        _twoLineRiskCell(context, risk.inherentValue, risk.inherentSeverity),
        // Residual (value + severity badge stacked)
        _twoLineRiskCell(context, risk.residualValue, risk.residualSeverity),
        // Treatment
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Text(_treatmentLabel(context, risk.treatment), style: bodyStyle),
        ),
        // Owner
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Text(risk.owner, style: bodyStyle),
        ),
        // Actions
        _actionsCell(context, risk),
      ],
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
    final (bg, fg, label) = _statusProps(context, status);
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
          _TableIconButton(
            iconAsset: 'assets/figma/assets/svg/edit_asset.svg',
            onPressed: () {},
          ),
          SizedBox(width: 4.w),
          _TableIconButton(
            iconAsset: 'assets/figma/risks/svg/view_risk.svg',
            onPressed: () => showRiskDetailDialog(context: context, risk: risk),
          ),
          SizedBox(width: 4.w),
          _TableIconButton(
            iconAsset: 'assets/figma/assets/svg/delete_asset.svg',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  (Color bg, Color fg, String label) _statusProps(BuildContext context, RiskStatus status) {
    final l10n = context.l10n;
    return switch (status) {
      RiskStatus.assessed => (AppColors.statusHighBg, AppColors.statusHighFg, l10n.statusAssessed),
      RiskStatus.treated => (AppColors.primaryTint, AppColors.primary, l10n.statusTreated),
      RiskStatus.monitored => (AppColors.statusLowBg, AppColors.statusLowFg, l10n.statusMonitored),
      RiskStatus.open => (AppColors.statusCriticalBg, AppColors.statusCriticalFg, l10n.statusCritical),
    };
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

class _TableIconButton extends StatelessWidget {
  const _TableIconButton({
    required this.iconAsset,
    this.onPressed,
  });

  final String iconAsset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(2.r),
          child: SvgPicture.asset(
            iconAsset,
            width: 24.r,
            height: 24.r,
          ),
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

    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        // Figma: bg-[#eff6ff] border border-[#bedbff]
        color: AppColors.primaryLightBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title — 18px semibold, tracking -0.45
          Text(
            l10n.riskManagementIntegration,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 16.h),
          // 4-column grid with 16.w gap between items
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(width: 16.w),
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
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
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
