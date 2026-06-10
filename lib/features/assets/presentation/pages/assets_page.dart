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
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/assets/application/providers/assets_providers.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';
import 'package:grc_web/features/assets/presentation/widgets/add_asset_dialog.dart';
import 'package:grc_web/features/assets/presentation/widgets/asset_detail_dialog.dart';

class AssetsPage extends ConsumerWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dataAsync = ref.watch(assetsProvider);

    return dataAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: AppErrorView(
          message: error is Failure ? error.message : l10n.errorGeneric,
          onRetry: () => ref.invalidate(assetsProvider),
        ),
      ),
      data: (data) => _AssetsView(data: data),
    );
  }
}

class _AssetsView extends StatelessWidget {
  const _AssetsView({required this.data});

  final AssetsData data;

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
            const _AssetsTitleBar(),
            SizedBox(height: sectionGap),
            _AssetsStatsRow(summary: data.summary),
            SizedBox(height: sectionGap),
            const _AssetsFilterBar(),
            SizedBox(height: sectionGap),
            _AssetsTable(assets: data.assets),
          ],
        ),
      ),
    );
  }
}

class _AssetsTitleBar extends StatelessWidget {
  const _AssetsTitleBar();

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
          l10n.assetRegistryTitle,
          style: textTheme.displaySmall?.copyWith(
            fontSize: isMobile ? 20.sp : null,
          ),
          strutStyle: const StrutStyle(
            fontSize: 24,
            height: 32 / 24,
            forceStrutHeight: true,
          ),
          textHeightBehavior: _AssetsView._textHeight,
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.assetRegistrySubtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textBody,
            fontSize: isMobile ? 13.sp : null,
          ),
          strutStyle: const StrutStyle(
            fontSize: 14,
            height: 20 / 14,
            forceStrutHeight: true,
          ),
          textHeightBehavior: _AssetsView._textHeight,
        ),
      ],
    );

    final addButton = AppButton(
      label: l10n.addAsset,
      iconAsset: 'assets/figma/assets/svg/add_asset.svg',
      variant: AppButtonVariant.primary,
      iconSize: isMobile ? 20.r : 20.r,
      size: isMobile ? AppButtonSize.md : AppButtonSize.lg,
      fullWidth: isMobile,
      onPressed: () => showAddAssetDialog(context: context),
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

class _AssetStatCard extends StatelessWidget {
  const _AssetStatCard({
    required this.value,
    required this.label,
    required this.iconAsset,
    this.compactValue = false,
  });

  final String value;
  final String label;
  final String iconAsset;
  final bool compactValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueStyle = compactValue
        ? textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.46,
          )
        : textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.072,
          );

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: valueStyle,
                strutStyle: AppTextMetrics.strut(
                  fontSize: compactValue ? 20 : 24,
                  lineHeight: compactValue ? 28 : 32,
                ),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textBody,
                  fontWeight: FontWeight.w400,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ],
          ),
          Container(
            width: 55.r,
            height: 55.r,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconAsset,
                width: 30.r,
                height: 30.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetsStatsRow extends StatelessWidget {
  const _AssetsStatsRow({required this.summary});

  final AssetsSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final compact = layout.isCompact;

    final cards = [
      _AssetStatCard(
        value: '${summary.totalAssets}',
        label: l10n.statTotalAssets,
        iconAsset: 'assets/figma/assets/svg/stat_total_assets.svg',
      ),
      _AssetStatCard(
        value: '${summary.applications}',
        label: l10n.statApplications,
        iconAsset: 'assets/figma/assets/svg/stat_applications.svg',
      ),
      _AssetStatCard(
        value: '${summary.cloud}',
        label: l10n.statCloud,
        iconAsset: 'assets/figma/assets/svg/stat_cloud.svg',
      ),
      _AssetStatCard(
        value: '${summary.data}',
        label: l10n.statData,
        iconAsset: 'assets/figma/assets/svg/stat_data.svg',
      ),
      _AssetStatCard(
        value: summary.totalValue,
        label: l10n.statTotalValue,
        iconAsset: 'assets/figma/assets/svg/stat_total_value.svg',
        compactValue: true,
      ),
    ];

    if (compact) {
      final cardWidth = layout.isMobile
          ? MediaQuery.sizeOf(context).width * 0.86
          : ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 260,
              tablet: 280,
              web: 300,
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

class _AssetsFilterBar extends StatefulWidget {
  const _AssetsFilterBar();

  @override
  State<_AssetsFilterBar> createState() => _AssetsFilterBarState();
}

class _AssetsFilterBarState extends State<_AssetsFilterBar> {
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
      hint: l10n.searchAssetsPlaceholder,
    );

    final typeField = AppSelectField<String>(
      value: 'all',
      items: const ['all'],
      itemLabel: (_) => l10n.allTypes,
      onChanged: (_) {},
      contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
    );

    final filterButton = AppButton(
      label: l10n.moreFilters,
      iconAsset: 'assets/figma/assets/svg/filter.svg',
      variant: AppButtonVariant.outlined,
      iconSize: isMobile ? 20.r : 25.r,
      size: isMobile ? AppButtonSize.md : AppButtonSize.lg,
      fullWidth: isMobile,
      onPressed: () {},
    );

    final exportButton = AppButton(
      label: l10n.export,
      iconAsset: 'assets/figma/assets/svg/export.svg',
      variant: AppButtonVariant.outlined,
      iconSize: isMobile ? 20.r : 28.r,
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
                typeField,
                SizedBox(height: 12.h),
                filterButton,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 150.w, child: typeField),
                        SizedBox(width: 8.w),
                        Expanded(child: filterButton),
                        SizedBox(width: 8.w),
                        Expanded(child: exportButton),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: searchField),
                    SizedBox(width: 16.w),
                    SizedBox(width: 150.w, child: typeField),
                    SizedBox(width: 8.w),
                    filterButton,
                    SizedBox(width: 8.w),
                    exportButton,
                  ],
                ),
    );
  }
}

class _AssetsTable extends StatelessWidget {
  const _AssetsTable({required this.assets});

  final List<AssetItem> assets;

  static final _layout = AppResponsiveTableLayout(
    columns: [
      AppTableColumnSpec(minWidth: 108.09, dropPriority: 0), // Asset ID
      AppTableColumnSpec(minWidth: 249.39, dropPriority: 0), // Name
      AppTableColumnSpec(minWidth: 141.38, dropPriority: 4), // Type
      AppTableColumnSpec(minWidth: 154.32, dropPriority: 2), // Business Value
      AppTableColumnSpec(minWidth: 150.52, dropPriority: 5), // Owner
      AppTableColumnSpec(minWidth: 135.13, dropPriority: 7), // Environment
      AppTableColumnSpec(minWidth: 152.59, dropPriority: 8), // Cloud Provider
      AppTableColumnSpec(minWidth: 115.45, dropPriority: 3), // Risk Level
      AppTableColumnSpec(minWidth: 142.13, dropPriority: 6), // Classification
      AppTableColumnSpec(minWidth: 113.01, dropPriority: 0), // Actions
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
                for (int i = 0; i < assets.length; i++) ...[
                  _AssetMobileCard(asset: assets[i]),
                  if (i != assets.length - 1)
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
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: _layout.columnWidthsForIndices(visible),
                      children: [
                        _headerRow(context, visible),
                        for (final asset in assets)
                          _dataRow(context, asset, visible),
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
    final textTheme = Theme.of(context).textTheme;
    final headerStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textLabel,
      fontWeight: FontWeight.w500,
    );

    final cells = [
      _headerCell(l10n.tableAssetId, headerStyle),
      _headerCell(l10n.tableName, headerStyle),
      _headerCell(l10n.tableType, headerStyle),
      _headerCell(l10n.tableBusinessValue, headerStyle),
      _headerCell(l10n.tableOwner, headerStyle),
      _headerCell(l10n.tableEnvironment, headerStyle),
      _headerCell(l10n.tableCloudProvider, headerStyle),
      _headerCell(l10n.tableRiskLevel, headerStyle),
      _headerCell(l10n.tableClassification, headerStyle),
      _headerCell(l10n.tableActions, headerStyle),
    ];

    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: _layout.cellsForIndices(cells, visible),
    );
  }

  TableRow _dataRow(BuildContext context, AssetItem asset, List<int> visible) {
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textLabel,
      fontWeight: FontWeight.w400,
    );

    final cells = [
      _tappableDataCell(
        context,
        asset,
        asset.id,
        textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      _tappableDataCell(
        context,
        asset,
        asset.name,
        textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      _dataCell(_typeLabel(context, asset.type), bodyStyle),
      _dataCell(
        asset.businessValue,
        textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      _dataCell(asset.owner, bodyStyle),
      _dataCell(asset.environment, bodyStyle),
      _dataCell(asset.cloudProvider, bodyStyle),
      _riskCell(context, asset.riskLevel),
      _dataCell(_classificationLabel(context, asset.classification), bodyStyle),
      _actionsCell(context, asset),
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: style),
      ),
    );
  }

  Widget _dataCell(String text, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.25.h, 16.w, 16.75.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: style),
      ),
    );
  }

  Widget _riskCell(BuildContext context, AssetRiskLevel level) {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.bodySmall?.copyWith(
      color: _riskFg(level),
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      height: 16 / 12,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 15.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: _riskBg(level),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(_riskLabel(context, level), style: style),
        ),
      ),
    );
  }

  Widget _tappableDataCell(
    BuildContext context,
    AssetItem asset,
    String text,
    TextStyle? style,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.25.h, 16.w, 16.75.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => showAssetDetailDialog(context: context, asset: asset),
          borderRadius: BorderRadius.circular(4.r),
          child: Text(text, style: style),
        ),
      ),
    );
  }

  Widget _actionsCell(BuildContext context, AssetItem asset) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TableIconButton(
            iconAsset: 'assets/figma/assets/svg/edit_asset.svg',
            onPressed: () => showAssetDetailDialog(context: context, asset: asset),
          ),
          SizedBox(width: 8.w),
          _TableIconButton(
            iconAsset: 'assets/figma/assets/svg/delete_asset.svg',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  String _typeLabel(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    return switch (type) {
      AssetType.data => l10n.assetTypeData,
      AssetType.application => l10n.assetTypeApplication,
      AssetType.infrastructure => l10n.assetTypeInfrastructure,
      AssetType.cloud => l10n.assetTypeCloud,
    };
  }

  String _classificationLabel(BuildContext context, AssetClassification classification) {
    final l10n = context.l10n;
    return switch (classification) {
      AssetClassification.confidential => l10n.classificationConfidential,
      AssetClassification.internal => l10n.classificationInternal,
    };
  }

  String _riskLabel(BuildContext context, AssetRiskLevel level) {
    final l10n = context.l10n;
    return switch (level) {
      AssetRiskLevel.critical => l10n.statusCritical,
      AssetRiskLevel.high => l10n.statusHigh,
      AssetRiskLevel.medium => l10n.statusMedium,
      AssetRiskLevel.low => l10n.likelihoodLow,
    };
  }

  Color _riskBg(AssetRiskLevel level) => switch (level) {
        AssetRiskLevel.critical => AppColors.statusCriticalBg,
        AssetRiskLevel.high => AppColors.statusHighBg,
        AssetRiskLevel.medium => AppColors.statusMediumBg,
        AssetRiskLevel.low => AppColors.statusLowBg,
      };

  Color _riskFg(AssetRiskLevel level) => switch (level) {
        AssetRiskLevel.critical => AppColors.statusCriticalFg,
        AssetRiskLevel.high => AppColors.statusHighFg,
        AssetRiskLevel.medium => AppColors.statusMediumFg,
        AssetRiskLevel.low => AppColors.statusLowFg,
      };
}

class _AssetMobileCard extends StatelessWidget {
  const _AssetMobileCard({required this.asset});

  final AssetItem asset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

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
                          showAssetDetailDialog(context: context, asset: asset),
                      borderRadius: BorderRadius.circular(4.r),
                      child: Text(
                        asset.id,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    InkWell(
                      onTap: () =>
                          showAssetDetailDialog(context: context, asset: asset),
                      borderRadius: BorderRadius.circular(4.r),
                      child: Text(
                        asset.name,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _RiskBadge(level: asset.riskLevel),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _MobileField(
                  label: l10n.tableType,
                  value: _typeLabel(context, asset.type),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MobileField(
                  label: l10n.tableBusinessValue,
                  value: asset.businessValue,
                  valueStyle: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _MobileField(label: l10n.tableOwner, value: asset.owner),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MobileField(
                  label: l10n.tableEnvironment,
                  value: asset.environment,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _MobileField(
                  label: l10n.tableCloudProvider,
                  value: asset.cloudProvider,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MobileField(
                  label: l10n.tableClassification,
                  value: _classificationLabel(context, asset.classification),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _TableIconButton(
                iconAsset: 'assets/figma/assets/svg/edit_asset.svg',
                onPressed: () =>
                    showAssetDetailDialog(context: context, asset: asset),
              ),
              SizedBox(width: 8.w),
              _TableIconButton(
                iconAsset: 'assets/figma/assets/svg/delete_asset.svg',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _typeLabel(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    return switch (type) {
      AssetType.data => l10n.assetTypeData,
      AssetType.application => l10n.assetTypeApplication,
      AssetType.infrastructure => l10n.assetTypeInfrastructure,
      AssetType.cloud => l10n.assetTypeCloud,
    };
  }

  String _classificationLabel(
    BuildContext context,
    AssetClassification classification,
  ) {
    final l10n = context.l10n;
    return switch (classification) {
      AssetClassification.confidential => l10n.classificationConfidential,
      AssetClassification.internal => l10n.classificationInternal,
    };
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

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.level});

  final AssetRiskLevel level;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final label = switch (level) {
      AssetRiskLevel.critical => l10n.statusCritical,
      AssetRiskLevel.high => l10n.statusHigh,
      AssetRiskLevel.medium => l10n.statusMedium,
      AssetRiskLevel.low => l10n.likelihoodLow,
    };

    final bg = switch (level) {
      AssetRiskLevel.critical => AppColors.statusCriticalBg,
      AssetRiskLevel.high => AppColors.statusHighBg,
      AssetRiskLevel.medium => AppColors.statusMediumBg,
      AssetRiskLevel.low => AppColors.statusLowBg,
    };

    final fg = switch (level) {
      AssetRiskLevel.critical => AppColors.statusCriticalFg,
      AssetRiskLevel.high => AppColors.statusHighFg,
      AssetRiskLevel.medium => AppColors.statusMediumFg,
      AssetRiskLevel.low => AppColors.statusLowFg,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ),
    );
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
          padding: EdgeInsets.all(6.r),
          child: SvgPicture.asset(
            iconAsset,
            width: 25.r,
            height: 25.r,
          ),
        ),
      ),
    );
  }
}
