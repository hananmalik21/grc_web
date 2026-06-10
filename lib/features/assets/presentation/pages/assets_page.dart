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
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1512.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AssetsTitleBar(),
            SizedBox(height: 24.h),
            _AssetsStatsRow(summary: data.summary),
            SizedBox(height: 24.h),
            const _AssetsFilterBar(),
            SizedBox(height: 24.h),
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

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.assetRegistryTitle,
                style: textTheme.displaySmall,
                strutStyle: const StrutStyle(fontSize: 24, height: 32 / 24, forceStrutHeight: true),
                textHeightBehavior: _AssetsView._textHeight,
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.assetRegistrySubtitle,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textBody),
                strutStyle: const StrutStyle(fontSize: 14, height: 20 / 14, forceStrutHeight: true),
                textHeightBehavior: _AssetsView._textHeight,
              ),
            ],
          ),
        ),
        AppButton(
          label: l10n.addAsset,
          iconAsset: 'assets/figma/assets/svg/add_asset.svg',
          variant: AppButtonVariant.primary,
          iconSize: 20.r,
          onPressed: () => showAddAssetDialog(context: context),
        ),
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

    return Row(
      children: [
        Expanded(
          child: _AssetStatCard(
            value: '${summary.totalAssets}',
            label: l10n.statTotalAssets,
            iconAsset: 'assets/figma/assets/svg/stat_total_assets.svg',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _AssetStatCard(
            value: '${summary.applications}',
            label: l10n.statApplications,
            iconAsset: 'assets/figma/assets/svg/stat_applications.svg',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _AssetStatCard(
            value: '${summary.cloud}',
            label: l10n.statCloud,
            iconAsset: 'assets/figma/assets/svg/stat_cloud.svg',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _AssetStatCard(
            value: '${summary.data}',
            label: l10n.statData,
            iconAsset: 'assets/figma/assets/svg/stat_data.svg',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _AssetStatCard(
            value: summary.totalValue,
            label: l10n.statTotalValue,
            iconAsset: 'assets/figma/assets/svg/stat_total_value.svg',
            compactValue: true,
          ),
        ),
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
              hint: l10n.searchAssetsPlaceholder,
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
            width: 150.w,
            child: AppSelectField<String>(
              value: 'all',
              items: const ['all'],
              itemLabel: (_) => l10n.allTypes,
              onChanged: (_) {},
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
          ),
          SizedBox(width: 8.w),
          AppButton(
            label: l10n.moreFilters,
            iconAsset: 'assets/figma/assets/svg/filter.svg',
            variant: AppButtonVariant.outlined,
            iconSize: 25.r,
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
          AppButton(
            label: l10n.export,
            iconAsset: 'assets/figma/assets/svg/export.svg',
            variant: AppButtonVariant.outlined,
            iconSize: 28.r,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _AssetsTable extends StatelessWidget {
  const _AssetsTable({required this.assets});

  final List<AssetItem> assets;

  static const _columnWidthValues = <double>[
    108.09,
    249.39,
    141.38,
    154.32,
    150.52,
    135.13,
    152.59,
    115.45,
    142.13,
    113.01,
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
                  for (final asset in assets) _dataRow(context, asset),
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
    final textTheme = Theme.of(context).textTheme;
    final headerStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textLabel,
      fontWeight: FontWeight.w500,
    );

    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: [
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
      ],
    );
  }

  TableRow _dataRow(BuildContext context, AssetItem asset) {
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
      ],
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
