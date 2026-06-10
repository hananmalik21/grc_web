import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
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
  static const _dialogWidth = 896.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(_dialogWidth.w, screen.width - 48.w);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: SizedBox(
        width: dialogWidth,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: const [
                BoxShadow(color: Color(0x1A000000), blurRadius: 25, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DetailHeader(
                  title: asset.name,
                  subtitle: asset.id,
                  onClose: () => Navigator.of(context).pop(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SectionBlock(
                                title: l10n.basicInformation,
                                children: [
                                  _DetailField(
                                    label: l10n.assetType,
                                    value: _typeLabel(l10n, asset.type),
                                  ),
                                  _DetailField(
                                    label: l10n.businessValue,
                                    value: asset.businessValue,
                                  ),
                                  _DetailField(
                                    label: l10n.assetOwner,
                                    value: asset.owner,
                                  ),
                                  _DetailField(
                                    label: l10n.tableEnvironment,
                                    value: asset.environment,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              _SectionBlock(
                                title: l10n.securityInformation,
                                children: [
                                  _DetailField(
                                    label: l10n.tableRiskLevel,
                                    valueWidget: _RiskBadge(
                                      label: _riskLabel(l10n, asset.riskLevel),
                                      level: asset.riskLevel,
                                    ),
                                  ),
                                  _DetailField(
                                    label: l10n.tableClassification,
                                    value: _classificationLabel(l10n, asset.classification),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SectionBlock(
                                title: l10n.infrastructure,
                                children: [
                                  _DetailField(
                                    label: l10n.tableCloudProvider,
                                    value: asset.cloudProvider,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              _SectionBlock(
                                title: l10n.relatedItems,
                                children: [
                                  _DetailField(
                                    label: l10n.linkedRisks,
                                    valueWidget: _ChipRow(
                                      items: asset.linkedRisks,
                                      backgroundColor: AppColors.statusCriticalBg,
                                      foregroundColor: AppColors.statusCriticalFg,
                                    ),
                                  ),
                                  _DetailField(
                                    label: l10n.appliedControls,
                                    valueWidget: _ChipRow(
                                      items: asset.appliedControls,
                                      backgroundColor: AppColors.statusLowBg,
                                      foregroundColor: AppColors.statusLowFg,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                  ),
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
                ),
              ],
            ),
          ),
        ),
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

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 17.h),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
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
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
                  textHeightBehavior: AssetDetailDialog._textHeight,
                ),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.154,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: AssetDetailDialog._textHeight,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 32.r,
                height: 32.r,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/figma/library/svg/close_white.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.title, required this.children});

  final String title;
  final List<Widget> children;

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
              ),
          strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
          textHeightBehavior: AssetDetailDialog._textHeight,
        ),
        SizedBox(height: 12.h),
        ...children.expand((child) => [child, SizedBox(height: 12.h)]).toList()..removeLast(),
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    this.value,
    this.valueWidget,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              fontSize: 12.sp,
              height: 16 / 12,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
            textHeightBehavior: AssetDetailDialog._textHeight,
          ),
          SizedBox(height: 2.5.h),
          if (valueWidget != null)
            valueWidget!
          else
            Text(
              value ?? '',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.154,
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
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Wrap(
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
      ),
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
  });

  final String editLabel;
  final String viewRisksLabel;
  final String viewControlsLabel;
  final String deleteLabel;
  final VoidCallback onEdit;
  final VoidCallback onViewRisks;
  final VoidCallback onViewControls;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 25.h, 24.w, 22.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          AppButton(
            label: editLabel,
            variant: AppButtonVariant.outlined,
            onPressed: onEdit,
          ),
          SizedBox(width: 12.w),
          AppButton(
            label: viewRisksLabel,
            variant: AppButtonVariant.outlined,
            onPressed: onViewRisks,
          ),
          SizedBox(width: 12.w),
          AppButton(
            label: viewControlsLabel,
            variant: AppButtonVariant.outlined,
            onPressed: onViewControls,
          ),
          const Spacer(),
          AppButton(
            label: deleteLabel,
            variant: AppButtonVariant.primary,
            backgroundColor: AppColors.deletePrimary,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
