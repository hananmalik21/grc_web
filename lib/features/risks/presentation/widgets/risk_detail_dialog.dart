import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_responsive_dialog_metrics.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';

Future<void> showRiskDetailDialog({
  required BuildContext context,
  required RiskItem risk,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => RiskDetailDialog(risk: risk),
  );
}

// ─── Local colors ─────────────────────────────────────────────────────────────
const _kInherentBg1 = Color(0xFFFEF2F2);
const _kInherentBg2 = Color(0xFFFFE2E2);
const _kInherentLabel = Color(0xFF9F0712);
const _kInherentValue = Color(0xFF82181A);
const _kInherentDetail = Color(0xFFC10007);

const _kControlBg1 = Color(0xFFEFF6FF);
const _kControlBg2 = Color(0xFFDBEAFE);
const _kControlTrack = Color(0xFFBEDBFF);

const _kResidualBg1 = Color(0xFFFFF7ED);
const _kResidualBg2 = Color(0xFFFFEDD4);
const _kResidualLabel = Color(0xFF9F2D00);
const _kResidualValue = Color(0xFF7E2A0C);
const _kResidualDetail = Color(0xFFCA3500);

const _kAssetChipBg = Color(0xFFE3EFFE);
const _kAssetChipBorder = Color(0xFFBAD0FF);

// ─── Dialog ───────────────────────────────────────────────────────────────────

class RiskDetailDialog extends StatelessWidget {
  const RiskDetailDialog({super.key, required this.risk});

  final RiskItem risk;

  static const _textHeight = AppTextMetrics.textHeight;
  static const double maxDialogWidth = 936;

  @override
  Widget build(BuildContext context) {
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

          final bodyContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoSection(risk: risk, metrics: metrics),
              _AssessmentSection(risk: risk, metrics: metrics),
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
                _Header(
                  risk: risk,
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
                    padding: metrics.contentPadding,
                    child: bodyContent,
                  ),
                _Footer(
                  onEdit: () => Navigator.of(context).pop(),
                  onClose: () => Navigator.of(context).pop(),
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
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.risk,
    required this.onClose,
    required this.metrics,
  });

  final RiskItem risk;
  final VoidCallback onClose;
  final AppResponsiveDialogMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.primary,
      padding: metrics.headerPadding.copyWith(right: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  risk.title,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.46,
                    fontSize: metrics.isPhone ? 18.sp : 20.sp,
                  ),
                  maxLines: metrics.isWide ? 1 : 3,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
                  textHeightBehavior: RiskDetailDialog._textHeight,
                ),
                SizedBox(height: 2.h),
                Text(
                  '${l10n.riskIdPrefix} ${risk.id}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.154,
                    fontSize: metrics.isPhone ? 13.sp : 14.sp,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: RiskDetailDialog._textHeight,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  'assets/figma/library/svg/close_white.svg',
                  width: 20.r,
                  height: 20.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info + Linked Assets ─────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.risk, required this.metrics});

  final RiskItem risk;
  final AppResponsiveDialogMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final riskInfo = _RiskInfoColumn(risk: risk);
    final linkedAssets = _LinkedAssetsColumn(
      heading: l10n.linkedAssetsLabel,
      assets: risk.linkedAssets,
    );

    if (metrics.isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: riskInfo),
          SizedBox(width: 24.w),
          Expanded(child: linkedAssets),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        riskInfo,
        SizedBox(height: metrics.sectionGap),
        linkedAssets,
      ],
    );
  }
}

class _RiskInfoColumn extends StatelessWidget {
  const _RiskInfoColumn({required this.risk});

  final RiskItem risk;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final treatmentLabel = _treatmentLabel(context);
    final statusProps = _statusBadge(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(l10n.riskInformation),
        SizedBox(height: 12.h),
        _InfoField(label: l10n.category, value: risk.category),
        SizedBox(height: 12.h),
        _InfoField(label: l10n.tableOwner, value: risk.owner),
        SizedBox(height: 8.h),
        _StatusField(
          label: l10n.tableStatus,
          bg: statusProps.$1,
          fg: statusProps.$2,
          text: statusProps.$3,
        ),
        SizedBox(height: 12.h),
        _InfoField(label: l10n.treatmentStrategyLabel, value: treatmentLabel),
      ],
    );
  }

  String _treatmentLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (risk.treatment) {
      RiskTreatment.mitigate => l10n.treatmentMitigate,
      RiskTreatment.transfer => l10n.treatmentTransfer,
      RiskTreatment.accept => l10n.treatmentAccept,
      RiskTreatment.avoid => l10n.treatmentAvoid,
    };
  }

  (Color bg, Color fg, String label) _statusBadge(BuildContext context) {
    final l10n = context.l10n;
    return switch (risk.status) {
      RiskStatus.assessed => (
          AppColors.statusMediumBg,
          AppColors.statusMediumFg,
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
}

class _LinkedAssetsColumn extends StatelessWidget {
  const _LinkedAssetsColumn({
    required this.heading,
    required this.assets,
  });

  final String heading;
  final List<RiskLinkedAsset> assets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(heading),
        SizedBox(height: 12.h),
        for (int i = 0; i < assets.length; i++) ...[
          _AssetChip(asset: assets[i]),
          if (i != assets.length - 1) SizedBox(height: 8.h),
        ],
      ],
    );
  }
}

class _AssetChip extends StatelessWidget {
  const _AssetChip({required this.asset});

  final RiskLinkedAsset asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: _kAssetChipBg,
        border: Border.all(color: _kAssetChipBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/figma/risks/svg/link_icon.svg',
            width: 16.r,
            height: 16.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.id,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                Text(
                  asset.name,
                  style: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Risk Assessment section ──────────────────────────────────────────────────

class _AssessmentSection extends StatelessWidget {
  const _AssessmentSection({required this.risk, required this.metrics});

  final RiskItem risk;
  final AppResponsiveDialogMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final effectivePct = risk.controlEffectiveness / 100;
    final reductionPct = risk.controlEffectiveness;
    final likelihoodLabel = _likelihoodLabel(context);
    final likelihoodNumber = _likelihoodNumber();

    final inherentCard = _InherentCard(
      label: l10n.inherentRiskVar,
      value: risk.inherentValue,
      likelihoodText:
          '${l10n.likelihoodLabel}: $likelihoodLabel ($likelihoodNumber/5)',
      impactText: '${l10n.impactLabel}: ${risk.impactValue}',
    );

    final controlCard = _ControlCard(
      label: l10n.controlEffectivenessLabel,
      value: '${risk.controlEffectiveness.toStringAsFixed(0)}%',
      progress: effectivePct,
    );

    final residualCard = _ResidualCard(
      label: l10n.residualRiskVar,
      value: risk.residualValue,
      reductionText:
          '${l10n.riskReductionLabel}: ${reductionPct.toStringAsFixed(1)}%',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: metrics.sectionGap),
          child: Divider(color: AppColors.border, height: 1.h),
        ),
        SizedBox(height: 25.h),
        _SectionHeading(l10n.riskAssessmentTitle),
        SizedBox(height: 16.h),
        if (metrics.isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: inherentCard),
              SizedBox(width: 16.w),
              Expanded(child: controlCard),
              SizedBox(width: 16.w),
              Expanded(child: residualCard),
            ],
          )
        else if (metrics.isCompact)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: inherentCard),
                  SizedBox(width: 16.w),
                  Expanded(child: controlCard),
                ],
              ),
              SizedBox(height: 16.h),
              residualCard,
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              inherentCard,
              SizedBox(height: metrics.fieldGap),
              controlCard,
              SizedBox(height: metrics.fieldGap),
              residualCard,
            ],
          ),
      ],
    );
  }

  String _likelihoodLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (risk.likelihood) {
      RiskLikelihood.veryHigh => l10n.likelihoodVeryHigh,
      RiskLikelihood.high => l10n.likelihoodHigh,
      RiskLikelihood.medium => l10n.likelihoodMedium,
      RiskLikelihood.low => l10n.likelihoodLow,
      RiskLikelihood.veryLow => l10n.likelihoodVeryLow,
    };
  }

  int _likelihoodNumber() => switch (risk.likelihood) {
        RiskLikelihood.veryHigh => 5,
        RiskLikelihood.high => 4,
        RiskLikelihood.medium => 3,
        RiskLikelihood.low => 2,
        RiskLikelihood.veryLow => 1,
      };
}

class _InherentCard extends StatelessWidget {
  const _InherentCard({
    required this.label,
    required this.value,
    required this.likelihoodText,
    required this.impactText,
  });

  final String label;
  final String value;
  final String likelihoodText;
  final String impactText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.6, -1.0),
          end: Alignment(0.6, 1.0),
          colors: [_kInherentBg1, _kInherentBg2],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _kInherentLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: _kInherentValue,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            likelihoodText,
            style: TextStyle(
              color: _kInherentDetail,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
          Text(
            impactText,
            style: TextStyle(
              color: _kInherentDetail,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlCard extends StatelessWidget {
  const _ControlCard({
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.6, -1.0),
          end: Alignment(0.6, 1.0),
          colors: [_kControlBg1, _kControlBg2],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: Stack(
              children: [
                Container(
                  height: 8.h,
                  color: _kControlTrack,
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResidualCard extends StatelessWidget {
  const _ResidualCard({
    required this.label,
    required this.value,
    required this.reductionText,
  });

  final String label;
  final String value;
  final String reductionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.6, -1.0),
          end: Alignment(0.6, 1.0),
          colors: [_kResidualBg1, _kResidualBg2],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _kResidualLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: _kResidualValue,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            reductionText,
            style: TextStyle(
              color: _kResidualDetail,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({
    required this.onEdit,
    required this.onClose,
    required this.metrics,
  });

  final VoidCallback onEdit;
  final VoidCallback onClose;
  final AppResponsiveDialogMetrics metrics;

  EdgeInsets get _footerPadding => metrics.isPhone
      ? metrics.footerPadding
      : metrics.isCompact
          ? metrics.footerPadding
          : EdgeInsets.fromLTRB(24.w, 25.h, 24.w, 22.h);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final buttonSize = metrics.isPhone ? AppButtonSize.md : AppButtonSize.lg;

    final editButton = AppButton(
      label: l10n.editRisk,
      iconAsset: 'assets/figma/risks/svg/edit_icon.svg',
      variant: AppButtonVariant.primary,
      iconSize: 16.r,
      size: buttonSize,
      fullWidth: !metrics.isWide,
      onPressed: onEdit,
    );

    final closeButton = AppButton(
      label: l10n.cancel,
      variant: AppButtonVariant.outlined,
      size: buttonSize,
      fullWidth: !metrics.isWide,
      onPressed: onClose,
    );

    return Column(
      children: [
        Divider(color: AppColors.border, height: 1.h),
        Padding(
          padding: _footerPadding,
          child: metrics.isPhone
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    editButton,
                    SizedBox(height: 10.h),
                    closeButton,
                  ],
                )
              : metrics.isCompact
                  ? Row(
                      children: [
                        Expanded(child: editButton),
                        SizedBox(width: 12.w),
                        Expanded(child: closeButton),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        editButton,
                        SizedBox(width: 12.w),
                        closeButton,
                      ],
                    ),
        ),
      ],
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textLabel,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: -0.154,
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }
}

class _StatusField extends StatelessWidget {
  const _StatusField({
    required this.label,
    required this.bg,
    required this.fg,
    required this.text,
  });

  final String label;
  final Color bg;
  final Color fg;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
        SizedBox(height: 3.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
        ),
      ],
    );
  }
}
