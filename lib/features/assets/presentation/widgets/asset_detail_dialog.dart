import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_responsive_dialog_metrics.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';

Future<void> showAssetDetailDialog({
  required BuildContext context,
  required AssetItem asset,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => AssetDetailDialog(asset: asset),
  );
}

class AssetDetailDialog extends StatelessWidget {
  const AssetDetailDialog({super.key, required this.asset});

  final AssetItem asset;

  static const _textHeight = AppTextMetrics.textHeight;
  static const double maxDialogWidth = 896;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewport = MediaQuery.sizeOf(context);
    final insetPadding =
        AppResponsiveDialogMetrics.insetPaddingForViewport(viewport.width);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dialogWidth = math.min(
            constraints.maxWidth,
            maxDialogWidth,
          );
          final metrics = AppResponsiveDialogMetrics.fromContext(
            context,
            dialogWidth: dialogWidth,
            dialogHeight: constraints.maxHeight,
          );
          final useScrollableBody = !metrics.isWide;

          final leftColumn = _DetailColumn(
            metrics: metrics,
            children: [
              _SectionBlock(
                title: l10n.basicInformation,
                metrics: metrics,
                children: [
                  _DetailField(
                    label: l10n.assetType,
                    value: _typeLabel(l10n, asset.type),
                    metrics: metrics,
                  ),
                  _DetailField(
                    label: l10n.businessValue,
                    value: asset.businessValue,
                    metrics: metrics,
                  ),
                  _DetailField(
                    label: l10n.assetOwner,
                    value: asset.owner,
                    metrics: metrics,
                  ),
                  _DetailField(
                    label: l10n.tableEnvironment,
                    value: asset.environment,
                    metrics: metrics,
                  ),
                ],
              ),
              _SectionBlock(
                title: l10n.securityInformation,
                metrics: metrics,
                children: [
                  _DetailField(
                    label: l10n.tableRiskLevel,
                    looseValueSpacing: true,
                    valueWidget: _RiskBadge(
                      label: _riskLabel(l10n, asset.riskLevel),
                      level: asset.riskLevel,
                    ),
                    metrics: metrics,
                  ),
                  _DetailField(
                    label: l10n.tableClassification,
                    value: _classificationLabel(l10n, asset.classification),
                    metrics: metrics,
                  ),
                ],
              ),
            ],
          );

          final rightColumn = _DetailColumn(
            metrics: metrics,
            children: [
              _SectionBlock(
                title: l10n.infrastructure,
                metrics: metrics,
                children: [
                  _DetailField(
                    label: l10n.tableCloudProvider,
                    value: asset.cloudProvider,
                    metrics: metrics,
                  ),
                ],
              ),
              _SectionBlock(
                title: l10n.relatedItems,
                metrics: metrics,
                children: [
                  _DetailField(
                    label: l10n.linkedRisks,
                    looseValueSpacing: true,
                    valueWidget: _ChipRow(
                      items: asset.linkedRisks,
                      backgroundColor: AppColors.statusCriticalBg,
                      foregroundColor: AppColors.statusCriticalFg,
                    ),
                    metrics: metrics,
                  ),
                  _DetailField(
                    label: l10n.appliedControls,
                    looseValueSpacing: true,
                    valueWidget: _ChipRow(
                      items: asset.appliedControls,
                      backgroundColor: AppColors.statusLowBg,
                      foregroundColor: AppColors.statusLowFg,
                    ),
                    metrics: metrics,
                  ),
                ],
              ),
            ],
          );

          final bodyContent = metrics.isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: leftColumn),
                    SizedBox(width: 24.w),
                    Expanded(child: rightColumn),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    leftColumn,
                    SizedBox(height: 16.h),
                    rightColumn,
                  ],
                );

          final shell = DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 25,
                  offset: Offset(0, 20),
                ),
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  useScrollableBody ? MainAxisSize.max : MainAxisSize.min,
              children: [
                _DetailHeader(
                  title: asset.name,
                  subtitle: asset.id,
                  onClose: () => Navigator.of(context).pop(),
                  metrics: metrics,
                ),
                if (useScrollableBody)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: metrics.contentPadding,
                      child: bodyContent,
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                    child: bodyContent,
                  ),
                _DetailFooter(
                  editLabel: l10n.editAsset,
                  viewRisksLabel: l10n.viewRisks,
                  viewControlsLabel: l10n.viewControls,
                  deleteLabel: l10n.deleteAsset,
                  onEdit: () => Navigator.of(context).pop(),
                  onViewRisks: () {},
                  onViewControls: () {},
                  onDelete: () => Navigator.of(context).pop(),
                  metrics: metrics,
                ),
              ],
            ),
          );

          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10.r),
              clipBehavior: Clip.antiAlias,
              child: useScrollableBody
                  ? SizedBox(
                      width: dialogWidth,
                      height: metrics.maxHeight,
                      child: shell,
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: dialogWidth,
                        maxHeight: metrics.maxHeight,
                      ),
                      child: shell,
                    ),
            ),
          );
        },
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, AssetType type) => switch (type) {
        AssetType.data => l10n.assetTypeData,
        AssetType.application => l10n.assetTypeApplication,
        AssetType.infrastructure => l10n.assetTypeInfrastructure,
        AssetType.cloud => l10n.assetTypeCloud,
      };

  String _riskLabel(AppLocalizations l10n, AssetRiskLevel level) => switch (level) {
        AssetRiskLevel.critical => l10n.statusCritical,
        AssetRiskLevel.high => l10n.statusHigh,
        AssetRiskLevel.medium => l10n.statusMedium,
        AssetRiskLevel.low => l10n.likelihoodLow,
      };

  String _classificationLabel(AppLocalizations l10n, AssetClassification value) =>
      switch (value) {
        AssetClassification.confidential => l10n.classificationConfidential,
        AssetClassification.internal => l10n.classificationInternal,
      };
}

class _DetailColumn extends StatelessWidget {
  const _DetailColumn({
    required this.metrics,
    required this.children,
  });

  final AppResponsiveDialogMetrics metrics;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          children[i],
          if (i != children.length - 1) SizedBox(height: 16.h),
        ],
      ],
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
    required this.metrics,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final AppResponsiveDialogMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: metrics.headerPadding,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.46,
                    fontSize: metrics.isPhone ? 18.sp : 20.sp,
                  ),
                  maxLines: metrics.isWide ? 1 : 3,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
                  textHeightBehavior: AssetDetailDialog._textHeight,
                ),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.154,
                    fontSize: metrics.isPhone ? 13.sp : 14.sp,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: AssetDetailDialog._textHeight,
                ),
              ],
            ),
          ),
          AppButton.close(
            onPressed: onClose,
            iconSize: 20.r,
            padding: EdgeInsets.all(6.r),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.children,
    required this.metrics,
  });

  final String title;
  final List<Widget> children;
  final AppResponsiveDialogMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLabel,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.154,
                fontSize: metrics.isPhone ? 13.sp : 14.sp,
              ),
          strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
          textHeightBehavior: AssetDetailDialog._textHeight,
        ),
        SizedBox(height: 12.h),
        ...children.expand((child) => [child, SizedBox(height: 12.h)]).toList()
          ..removeLast(),
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.metrics,
    this.value,
    this.valueWidget,
    this.looseValueSpacing = false,
  });

  final String label;
  final AppResponsiveDialogMetrics metrics;
  final String? value;
  final Widget? valueWidget;
  final bool looseValueSpacing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueGap = looseValueSpacing ? 6.5.h : 2.5.h;

    return Padding(
      padding: EdgeInsets.only(top: 5.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: metrics.isPhone ? 11.sp : 12.sp,
              height: 16 / 12,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
            textHeightBehavior: AssetDetailDialog._textHeight,
          ),
          SizedBox(height: valueGap),
          if (valueWidget != null)
            valueWidget!
          else
            Text(
              value ?? '',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.154,
                fontSize: metrics.isPhone ? 13.sp : 14.sp,
              ),
              strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
              textHeightBehavior: AssetDetailDialog._textHeight,
            ),
        ],
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.label, required this.level});

  final String label;
  final AssetRiskLevel level;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(top: 3.5.h, bottom: 0.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: _bg(level),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: _fg(level),
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }

  Color _bg(AssetRiskLevel level) => switch (level) {
        AssetRiskLevel.critical => AppColors.statusCriticalBg,
        AssetRiskLevel.high => AppColors.statusHighBg,
        AssetRiskLevel.medium => AppColors.statusMediumBg,
        AssetRiskLevel.low => AppColors.statusLowBg,
      };

  Color _fg(AssetRiskLevel level) => switch (level) {
        AssetRiskLevel.critical => AppColors.statusCriticalFg,
        AssetRiskLevel.high => AppColors.statusHighFg,
        AssetRiskLevel.medium => AppColors.statusMediumFg,
        AssetRiskLevel.low => AppColors.statusLowFg,
      };
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.items,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final List<String> items;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        '—',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
      );
    }

    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: items
          .map(
            (item) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      height: 16 / 12,
                    ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DetailFooter extends StatelessWidget {
  const _DetailFooter({
    required this.editLabel,
    required this.viewRisksLabel,
    required this.viewControlsLabel,
    required this.deleteLabel,
    required this.onEdit,
    required this.onViewRisks,
    required this.onViewControls,
    required this.onDelete,
    required this.metrics,
  });

  final String editLabel;
  final String viewRisksLabel;
  final String viewControlsLabel;
  final String deleteLabel;
  final VoidCallback onEdit;
  final VoidCallback onViewRisks;
  final VoidCallback onViewControls;
  final VoidCallback onDelete;
  final AppResponsiveDialogMetrics metrics;

  EdgeInsets get _footerPadding => metrics.isPhone
      ? metrics.footerPadding
      : metrics.isCompact
          ? metrics.footerPadding
          : EdgeInsets.fromLTRB(24.w, 25.h, 24.w, 22.h);

  @override
  Widget build(BuildContext context) {
    final buttonSize = metrics.isPhone ? AppButtonSize.md : AppButtonSize.lg;

    final editButton = AppButton(
      label: editLabel,
      variant: AppButtonVariant.outlined,
      size: buttonSize,
      fullWidth: !metrics.isWide,
      onPressed: onEdit,
    );

    final viewRisksButton = AppButton(
      label: viewRisksLabel,
      variant: AppButtonVariant.outlined,
      size: buttonSize,
      fullWidth: !metrics.isWide,
      onPressed: onViewRisks,
    );

    final viewControlsButton = AppButton(
      label: viewControlsLabel,
      variant: AppButtonVariant.outlined,
      size: buttonSize,
      fullWidth: !metrics.isWide,
      onPressed: onViewControls,
    );

    final deleteButton = AppButton(
      label: deleteLabel,
      variant: AppButtonVariant.primary,
      size: buttonSize,
      backgroundColor: AppColors.deletePrimary,
      fullWidth: !metrics.isWide,
      onPressed: onDelete,
    );

    return Container(
      width: double.infinity,
      padding: _footerPadding,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: metrics.useStackedFooter
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                editButton,
                SizedBox(height: 10.h),
                viewRisksButton,
                SizedBox(height: 10.h),
                viewControlsButton,
                SizedBox(height: 10.h),
                deleteButton,
              ],
            )
          : metrics.isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: editButton),
                        SizedBox(width: 12.w),
                        Expanded(child: viewRisksButton),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: viewControlsButton),
                        SizedBox(width: 12.w),
                        Expanded(child: deleteButton),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    editButton,
                    SizedBox(width: 12.w),
                    viewRisksButton,
                    SizedBox(width: 12.w),
                    viewControlsButton,
                    const Spacer(),
                    deleteButton,
                  ],
                ),
    );
  }
}
