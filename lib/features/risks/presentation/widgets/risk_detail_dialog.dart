import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
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

// ─── Dialog ───────────────────────────────────────────────────────────────────

class RiskDetailDialog extends StatelessWidget {
  const RiskDetailDialog({super.key, required this.risk});

  final RiskItem risk;

  static const _dialogWidth = 936.0;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final hPad = ((screenW - _dialogWidth.w) / 2).clamp(16.0, double.infinity);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40.h),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        width: _dialogWidth.w,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          elevation: 25,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(risk: risk, onClose: () => Navigator.of(context).pop()),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoSection(risk: risk),
                        _AssessmentSection(risk: risk),
                      ],
                    ),
                  ),
                ),
                _Footer(
                  onEdit: () => Navigator.of(context).pop(),
                  onClose: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.risk, required this.onClose});

  final RiskItem risk;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 8.w, 17.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  risk.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    height: 28 / 20,
                    letterSpacing: -0.46,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${l10n.riskIdPrefix} ${risk.id}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
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

// ─── Info + Linked Assets row ─────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.risk});

  final RiskItem risk;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _RiskInfoColumn(risk: risk)),
        SizedBox(width: 24.w),
        Expanded(
          child: _LinkedAssetsColumn(
            heading: l10n.linkedAssetsLabel,
            assets: risk.linkedAssets,
          ),
        ),
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
      RiskStatus.assessed => (AppColors.statusHighBg, AppColors.statusHighFg, l10n.statusAssessed),
      RiskStatus.treated => (AppColors.primaryTint, AppColors.primary, l10n.statusTreated),
      RiskStatus.monitored => (AppColors.statusLowBg, AppColors.statusLowFg, l10n.statusMonitored),
      RiskStatus.open => (AppColors.statusCriticalBg, AppColors.statusCriticalFg, l10n.statusCritical),
    };
  }
}

class _LinkedAssetsColumn extends StatelessWidget {
  const _LinkedAssetsColumn({required this.heading, required this.assets});

  final String heading;
  final List<RiskLinkedAsset> assets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(heading),
        SizedBox(height: 12.h),
        ...assets.map((a) => _AssetChip(asset: a)),
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
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EFFE),
        border: Border.all(color: const Color(0xFFBAD0FF)),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.id,
                style: TextStyle(
                  color: const Color(0xFF101828),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
              Text(
                asset.name,
                style: TextStyle(
                  color: const Color(0xFF4A5565),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Risk Assessment section ──────────────────────────────────────────────────

class _AssessmentSection extends StatelessWidget {
  const _AssessmentSection({required this.risk});

  final RiskItem risk;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final effectivePct = risk.controlEffectiveness / 100;
    final reductionPct = risk.controlEffectiveness;
    final likelihoodLabel = _likelihoodLabel(context);
    final likelihoodNumber = _likelihoodNumber();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: Divider(color: const Color(0xFFE5E7EB), height: 1.h),
        ),
        SizedBox(height: 25.h),
        _SectionHeading(l10n.riskAssessmentTitle),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InherentCard(
                label: l10n.inherentRiskVar,
                value: risk.inherentValue,
                likelihoodText:
                    '${l10n.likelihoodLabel}: $likelihoodLabel ($likelihoodNumber/5)',
                impactText: '${l10n.impactLabel}: ${risk.impactValue}',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _ControlCard(
                label: l10n.controlEffectivenessLabel,
                value: '${risk.controlEffectiveness.toStringAsFixed(0)}%',
                progress: effectivePct,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _ResidualCard(
                label: l10n.residualRiskVar,
                value: risk.residualValue,
                reductionText:
                    '${l10n.riskReductionLabel}: ${reductionPct.toStringAsFixed(1)}%',
              ),
            ),
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
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
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
  const _Footer({required this.onEdit, required this.onClose});

  final VoidCallback onEdit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Divider(color: const Color(0xFFE5E7EB), height: 1.h),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: l10n.editRisk,
                iconAsset: 'assets/figma/risks/svg/edit_icon.svg',
                variant: AppButtonVariant.primary,
                iconSize: 16.r,
                onPressed: onEdit,
              ),
              SizedBox(width: 12.w),
              AppButton(
                label: l10n.cancel,
                variant: AppButtonVariant.outlined,
                onPressed: onClose,
              ),
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
        color: const Color(0xFF364153),
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
            color: const Color(0xFF6A7282),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF101828),
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
            color: const Color(0xFF6A7282),
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
