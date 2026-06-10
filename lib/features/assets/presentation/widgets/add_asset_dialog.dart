import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_responsive_dialog_metrics.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';

Future<void> showAddAssetDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => const AddAssetDialog(),
  );
}

class AddAssetDialog extends StatefulWidget {
  const AddAssetDialog({super.key});

  static const _textHeight = AppTextMetrics.textHeight;
  static const double maxDialogWidth = 672;

  @override
  State<AddAssetDialog> createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _businessValueController = TextEditingController(text: '0');
  final _ownerController = TextEditingController();
  final _locationController = TextEditingController();
  final _endpointController = TextEditingController();
  final _tagsController = TextEditingController();

  AssetType _assetType = AssetType.application;
  String _environment = 'production';
  String _cloudProvider = 'aws';
  AssetRiskLevel _riskLevel = AssetRiskLevel.medium;
  AssetRiskLevel _criticality = AssetRiskLevel.medium;
  AssetClassification _classification = AssetClassification.internal;
  final Set<String> _compliance = {};

  static const _complianceOptions = [
    'iso27001',
    'soc2',
    'gdpr',
    'hipaa',
    'pciDss',
    'nist',
    'cis',
    'fedRamp',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _businessValueController.dispose();
    _ownerController.dispose();
    _locationController.dispose();
    _endpointController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _toggleCompliance(String key) {
    setState(() {
      if (_compliance.contains(key)) {
        _compliance.remove(key);
      } else {
        _compliance.add(key);
      }
    });
  }

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
            AddAssetDialog.maxDialogWidth,
          );
          final metrics = AppResponsiveDialogMetrics.fromContext(
            context,
            dialogWidth: dialogWidth,
            dialogHeight: constraints.maxHeight,
            wideMinWidth: AppResponsiveDialogMetrics.compactDialogWideMinWidth,
          );

          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: dialogWidth,
              height: metrics.maxHeight,
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10.r),
                clipBehavior: Clip.antiAlias,
                child: DecoratedBox(
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
                    children: [
                      _DialogHeader(
                        title: l10n.addNewAsset,
                        onClose: () => Navigator.of(context).pop(),
                        metrics: metrics,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: metrics.contentPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _ResponsiveFieldRow(
                                metrics: metrics,
                                left: AppTextField(
                                  label: l10n.assetName,
                                  isRequired: true,
                                  controller: _nameController,
                                  hint: l10n.enterAssetName,
                                ),
                                right: AppSelectField<AssetType>(
                                  label: l10n.assetType,
                                  isRequired: true,
                                  value: _assetType,
                                  items: AssetType.values,
                                  itemLabel: (value) =>
                                      _assetTypeLabel(l10n, value),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _assetType = value);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: metrics.fieldGap),
                              AppTextField(
                                label: l10n.assetDescription,
                                controller: _descriptionController,
                                hint: l10n.assetDescriptionPlaceholder,
                                minLines: 3,
                                maxLines: 5,
                              ),
                              SizedBox(height: metrics.fieldGap),
                              _ResponsiveFieldRow(
                                metrics: metrics,
                                left: AppTextField(
                                  label: l10n.businessValue,
                                  isRequired: true,
                                  controller: _businessValueController,
                                  keyboardType: TextInputType.number,
                                  hint: '0',
                                ),
                                right: AppTextField(
                                  label: l10n.assetOwner,
                                  isRequired: true,
                                  controller: _ownerController,
                                  hint: l10n.assetOwnerPlaceholder,
                                ),
                              ),
                              SizedBox(height: metrics.fieldGap),
                              _ResponsiveFieldRow(
                                metrics: metrics,
                                left: AppSelectField<String>(
                                  label: l10n.tableEnvironment,
                                  value: _environment,
                                  items: const [
                                    'production',
                                    'staging',
                                    'development',
                                    'onPrem',
                                  ],
                                  itemLabel: (value) =>
                                      _environmentLabel(l10n, value),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _environment = value);
                                    }
                                  },
                                ),
                                right: AppSelectField<String>(
                                  label: l10n.tableCloudProvider,
                                  value: _cloudProvider,
                                  items: const ['aws', 'azure', 'gcp', 'onPrem'],
                                  itemLabel: (value) =>
                                      _cloudProviderLabel(l10n, value),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _cloudProvider = value);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: metrics.fieldGap),
                              _ResponsiveFieldRow(
                                metrics: metrics,
                                left: AppTextField(
                                  label: l10n.location,
                                  controller: _locationController,
                                  hint: l10n.locationPlaceholder,
                                ),
                                right: AppTextField(
                                  label: l10n.ipAddressEndpoint,
                                  controller: _endpointController,
                                  hint: l10n.ipAddressPlaceholder,
                                ),
                              ),
                              SizedBox(height: metrics.fieldGap),
                              _RiskFieldsRow(
                                metrics: metrics,
                                riskLevel: _riskLevel,
                                criticality: _criticality,
                                classification: _classification,
                                riskLabel: (value) => _riskLabel(l10n, value),
                                classificationLabel: (value) =>
                                    _classificationLabel(l10n, value),
                                onRiskChanged: (value) {
                                  if (value != null) {
                                    setState(() => _riskLevel = value);
                                  }
                                },
                                onCriticalityChanged: (value) {
                                  if (value != null) {
                                    setState(() => _criticality = value);
                                  }
                                },
                                onClassificationChanged: (value) {
                                  if (value != null) {
                                    setState(() => _classification = value);
                                  }
                                },
                              ),
                              SizedBox(height: metrics.fieldGap),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AppFieldLabel(label: l10n.complianceRequirements),
                                  SizedBox(height: 8.h),
                                  _ComplianceGrid(
                                    metrics: metrics,
                                    options: _complianceOptions,
                                    selected: _compliance,
                                    labelFor: (key) =>
                                        _complianceLabel(l10n, key),
                                    onToggle: _toggleCompliance,
                                  ),
                                ],
                              ),
                              SizedBox(height: metrics.fieldGap),
                              AppTextField(
                                label: l10n.assetTags,
                                controller: _tagsController,
                                hint: l10n.assetTagsPlaceholder,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _DialogFooter(
                        cancelLabel: l10n.cancel,
                        saveLabel: l10n.addAsset,
                        onCancel: () => Navigator.of(context).pop(),
                        onSave: () => Navigator.of(context).pop(),
                        metrics: metrics,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _assetTypeLabel(AppLocalizations l10n, AssetType type) => switch (type) {
        AssetType.data => l10n.assetTypeData,
        AssetType.application => l10n.assetTypeApplication,
        AssetType.infrastructure => l10n.assetTypeInfrastructure,
        AssetType.cloud => l10n.assetTypeCloud,
      };

  String _environmentLabel(AppLocalizations l10n, String value) => switch (value) {
        'production' => l10n.envProduction,
        'staging' => l10n.envStaging,
        'development' => l10n.envDevelopment,
        _ => l10n.envOnPrem,
      };

  String _cloudProviderLabel(AppLocalizations l10n, String value) => switch (value) {
        'aws' => l10n.providerAws,
        'azure' => l10n.providerAzure,
        'gcp' => l10n.providerGcp,
        _ => l10n.envOnPrem,
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

  String _complianceLabel(AppLocalizations l10n, String key) => switch (key) {
        'iso27001' => l10n.complianceIso27001,
        'soc2' => l10n.complianceSoc2,
        'gdpr' => l10n.complianceGdpr,
        'hipaa' => l10n.complianceHipaa,
        'pciDss' => l10n.compliancePciDss,
        'nist' => l10n.complianceNist,
        'cis' => l10n.complianceCis,
        _ => l10n.complianceFedRamp,
      };
}

class _ResponsiveFieldRow extends StatelessWidget {
  const _ResponsiveFieldRow({
    required this.metrics,
    required this.left,
    required this.right,
  });

  final AppResponsiveDialogMetrics metrics;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (metrics.isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          SizedBox(width: 16.w),
          Expanded(child: right),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        left,
        SizedBox(height: metrics.fieldGap),
        right,
      ],
    );
  }
}

class _RiskFieldsRow extends StatelessWidget {
  const _RiskFieldsRow({
    required this.metrics,
    required this.riskLevel,
    required this.criticality,
    required this.classification,
    required this.riskLabel,
    required this.classificationLabel,
    required this.onRiskChanged,
    required this.onCriticalityChanged,
    required this.onClassificationChanged,
  });

  final AppResponsiveDialogMetrics metrics;
  final AssetRiskLevel riskLevel;
  final AssetRiskLevel criticality;
  final AssetClassification classification;
  final String Function(AssetRiskLevel value) riskLabel;
  final String Function(AssetClassification value) classificationLabel;
  final ValueChanged<AssetRiskLevel?> onRiskChanged;
  final ValueChanged<AssetRiskLevel?> onCriticalityChanged;
  final ValueChanged<AssetClassification?> onClassificationChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final riskField = AppSelectField<AssetRiskLevel>(
      label: l10n.tableRiskLevel,
      value: riskLevel,
      items: AssetRiskLevel.values,
      itemLabel: riskLabel,
      onChanged: onRiskChanged,
    );

    final criticalityField = AppSelectField<AssetRiskLevel>(
      label: l10n.criticality,
      value: criticality,
      items: AssetRiskLevel.values,
      itemLabel: riskLabel,
      onChanged: onCriticalityChanged,
    );

    final classificationField = AppSelectField<AssetClassification>(
      label: l10n.tableClassification,
      value: classification,
      items: AssetClassification.values,
      itemLabel: classificationLabel,
      onChanged: onClassificationChanged,
    );

    if (metrics.isPhone) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          riskField,
          SizedBox(height: metrics.fieldGap),
          criticalityField,
          SizedBox(height: metrics.fieldGap),
          classificationField,
        ],
      );
    }

    if (metrics.isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: riskField),
              SizedBox(width: 16.w),
              Expanded(child: criticalityField),
            ],
          ),
          SizedBox(height: metrics.fieldGap),
          classificationField,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: riskField),
        SizedBox(width: 16.w),
        Expanded(child: criticalityField),
        SizedBox(width: 16.w),
        Expanded(child: classificationField),
      ],
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.title,
    required this.onClose,
    required this.metrics,
  });

  final String title;
  final VoidCallback onClose;
  final AppResponsiveDialogMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: metrics.headerPadding,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.46,
                fontSize: metrics.isPhone ? 18.sp : null,
              ),
              strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
              textHeightBehavior: AddAssetDialog._textHeight,
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
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
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

class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.cancelLabel,
    required this.saveLabel,
    required this.onCancel,
    required this.onSave,
    required this.metrics,
  });

  final String cancelLabel;
  final String saveLabel;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final AppResponsiveDialogMetrics metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.useStackedFooter) {
      return Container(
        width: double.infinity,
        padding: metrics.footerPadding,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: saveLabel,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.md,
              fullWidth: true,
              onPressed: onSave,
            ),
            SizedBox(height: 10.h),
            AppButton(
              label: cancelLabel,
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.md,
              fullWidth: true,
              onPressed: onCancel,
            ),
          ],
        ),
      );
    }

    if (metrics.isCompact) {
      return Container(
        width: double.infinity,
        padding: metrics.footerPadding,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: cancelLabel,
                variant: AppButtonVariant.outlined,
                fullWidth: true,
                onPressed: onCancel,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                label: saveLabel,
                variant: AppButtonVariant.primary,
                fullWidth: true,
                onPressed: onSave,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: metrics.footerPadding,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AppButton(
              label: cancelLabel,
              variant: AppButtonVariant.outlined,
              fullWidth: true,
              onPressed: onCancel,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppButton(
              label: saveLabel,
              variant: AppButtonVariant.primary,
              fullWidth: true,
              onPressed: onSave,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplianceGrid extends StatelessWidget {
  const _ComplianceGrid({
    required this.metrics,
    required this.options,
    required this.selected,
    required this.labelFor,
    required this.onToggle,
  });

  final AppResponsiveDialogMetrics metrics;
  final List<String> options;
  final Set<String> selected;
  final String Function(String key) labelFor;
  final ValueChanged<String> onToggle;

  int get _crossAxisCount {
    if (metrics.isPhone) return 1;
    if (metrics.isCompact) return 2;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        mainAxisExtent: metrics.isPhone ? 36.h : 30.h,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final key = options[index];
        final isSelected = selected.contains(key);

        return InkWell(
          onTap: () => onToggle(key),
          borderRadius: BorderRadius.circular(4.r),
          child: Row(
            children: [
              _CheckboxIndicator(selected: isSelected, size: 16.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  labelFor(key),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLabel,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.154,
                        fontSize: metrics.isPhone ? 13.sp : null,
                      ),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: AddAssetDialog._textHeight,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CheckboxIndicator extends StatelessWidget {
  const _CheckboxIndicator({required this.selected, required this.size});

  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? AppColors.checkboxBlue : AppColors.surface,
        borderRadius: BorderRadius.circular(2.5.r),
        border: selected ? null : Border.all(color: AppColors.checkboxBorder),
      ),
    );
  }
}
