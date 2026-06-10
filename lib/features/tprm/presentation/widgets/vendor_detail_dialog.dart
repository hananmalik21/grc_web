import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/features/tprm/presentation/widgets/add_vendor_dialog.dart';

const _kKpiCardBg = Color(0xFFE1EEFF);
const _kKpiLabel = Color(0xFF1447E6);
const _kKpiValue = Color(0xFF1C398E);
const _kLowRiskBadgeBg = Color(0xFFDCFCE7);
const _kLowRiskBadgeFg = Color(0xFF016630);
const _kCriticalTierBg = Color(0xFFFFE2E2);
const _kCriticalTierFg = Color(0xFF9F0712);
const _kProgressTrackGreen = Color(0xFFB9F8CF);
const _kProgressFillGreen = Color(0xFF00A63E);
const _kInherentBg = Color(0xFFFEF2F2);
const _kInherentLabel = Color(0xFFC10007);
const _kInherentValue = Color(0xFF82181A);
const _kInherentTrack = Color(0xFFFFC9C9);
const _kInherentFill = Color(0xFFE7000B);
const _kResidualBg = Color(0xFFFFF7ED);
const _kResidualLabel = Color(0xFFCA3500);
const _kResidualValue = Color(0xFF7E2A0C);
const _kResidualTrack = Color(0xFFFFD6A7);
const _kResidualFill = Color(0xFFF54900);
const _kReductionBg = Color(0xFFF0FDF4);
const _kReductionLabel = Color(0xFF008236);
const _kReductionValue = Color(0xFF0D542B);
const _kCertBorder = Color(0xFFBEDBFF);
const _kRiskChipBg = Color(0xFFFEF2F2);
const _kRiskChipBorder = Color(0xFFFFC9C9);
const _kIssueCardBg = Color(0xFFFEFCE8);
const _kIssueCardBorder = Color(0xFFFFF085);
const _kIssueMediumBg = Color(0xFFFEF9C2);
const _kIssueMediumFg = Color(0xFF894B00);
const _kSlaCardBg = Color(0xFFF9FAFB);
const _kRadarBlue = Color(0xFF2563EB);
const _kRadarGrid = Color(0xFFCCCCCC);
const _kRadarAxis = Color(0xFF808080);

Future<void> showVendorDetailDialog({
  required BuildContext context,
  required VendorDetailData data,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) => VendorDetailDialog(
      data: data,
      onEdit: () {
        Navigator.of(dialogContext).pop();
        showEditVendorDialog(
          context: context,
          data: VendorFormData.fromDetail(data),
        );
      },
    ),
  );
}

class VendorDetailData {
  const VendorDetailData({
    required this.id,
    required this.name,
    required this.category,
    required this.tierLabel,
    required this.riskRating,
    required this.riskLevelLabel,
    required this.contractValue,
    required this.controlEffectiveness,
    required this.openIssuesCount,
    required this.businessOwner,
    required this.vendorManager,
    required this.geography,
    required this.dataAccess,
    required this.servicesProvided,
    required this.lastAssessment,
    required this.nextAssessment,
    required this.inherentRisk,
    required this.residualRisk,
    required this.riskReduction,
    required this.assessmentScores,
    required this.certifications,
    required this.linkedAssets,
    required this.linkedRisks,
    required this.linkedControls,
    required this.linkedPrograms,
    required this.openIssues,
    required this.slaAvailability,
    required this.slaResponseTime,
    required this.slaIncidentResolution,
  });

  final String id;
  final String name;
  final String category;
  final String tierLabel;
  final int riskRating;
  final String riskLevelLabel;
  final String contractValue;
  final int controlEffectiveness;
  final int openIssuesCount;
  final String businessOwner;
  final String vendorManager;
  final String geography;
  final String dataAccess;
  final String servicesProvided;
  final String lastAssessment;
  final String nextAssessment;
  final int inherentRisk;
  final int residualRisk;
  final int riskReduction;
  final List<VendorAssessmentScore> assessmentScores;
  final List<String> certifications;
  final List<String> linkedAssets;
  final List<String> linkedRisks;
  final List<String> linkedControls;
  final List<String> linkedPrograms;
  final List<VendorOpenIssue> openIssues;
  final double slaAvailability;
  final int slaResponseTime;
  final int slaIncidentResolution;

  static VendorDetailData sample() {
    return const VendorDetailData(
      id: 'VND-001',
      name: 'Cloud Infrastructure Services Inc.',
      category: 'Cloud Provider',
      tierLabel: 'Critical',
      riskRating: 85,
      riskLevelLabel: 'Low Risk',
      contractValue: '\$2.40M',
      controlEffectiveness: 88,
      openIssuesCount: 1,
      businessOwner: 'CTO',
      vendorManager: 'Cloud Team',
      geography: 'Global',
      dataAccess: 'Confidential',
      servicesProvided: 'Infrastructure as a Service (IaaS), Cloud Storage',
      lastAssessment: '2026-04-15',
      nextAssessment: '2026-07-15',
      inherentRisk: 75,
      residualRisk: 22,
      riskReduction: 71,
      assessmentScores: [
        VendorAssessmentScore(label: 'Info Security', value: 88),
        VendorAssessmentScore(label: 'Data Privacy', value: 82),
        VendorAssessmentScore(label: 'Cloud Security', value: 92),
        VendorAssessmentScore(label: 'Ops Resilience', value: 76),
        VendorAssessmentScore(label: 'Financial', value: 84),
      ],
      certifications: [
        'ISO 27001 Certified',
        'SOC 2 Type II',
        'GDPR Compliant',
      ],
      linkedAssets: ['AST-004', 'AST-006'],
      linkedRisks: ['R-003'],
      linkedControls: ['CTL-003'],
      linkedPrograms: ['PGM-002'],
      openIssues: [
        VendorOpenIssue(
          id: 'ISS-001',
          severity: 'Medium',
          title: 'MFA not enforced for all admin accounts',
          dueDate: '2026-05-30',
          status: 'Open',
        ),
      ],
      slaAvailability: 99.95,
      slaResponseTime: 98,
      slaIncidentResolution: 96,
    );
  }
}

class VendorAssessmentScore {
  const VendorAssessmentScore({required this.label, required this.value});

  final String label;
  final double value;
}

class VendorOpenIssue {
  const VendorOpenIssue({
    required this.id,
    required this.severity,
    required this.title,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final String severity;
  final String title;
  final String dueDate;
  final String status;
}

class VendorDetailDialog extends StatelessWidget {
  const VendorDetailDialog({
    super.key,
    required this.data,
    this.onEdit,
  });

  final VendorDetailData data;
  final VoidCallback? onEdit;

  static const _dialogWidth = 1152.0;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(_dialogWidth.w, screen.width - 48.w);
    final dialogHeight = math.min(1784.h, screen.height * 0.92);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Material(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: const [
                BoxShadow(color: Color(0x1A000000), blurRadius: 25, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                _Header(
                  name: data.name,
                  subtitle: '${data.id} • ${data.category}',
                  onClose: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _KpiRow(data: data),
                          _SectionDivider(title: 'Vendor Information'),
                          _VendorInfoSection(data: data),
                          _SectionDivider(title: 'Risk Assessment'),
                          _RiskAssessmentSection(data: data),
                          _SectionDivider(title: 'Assessment Scores'),
                          SizedBox(height: 16.h),
                          _AssessmentRadarChart(scores: data.assessmentScores),
                          _SectionDivider(title: 'Security Certifications & Compliance'),
                          _CertificationsSection(certifications: data.certifications),
                          _SectionDivider(title: 'GRC Integration'),
                          _GrcIntegrationSection(data: data),
                          if (data.openIssues.isNotEmpty) ...[
                            _SectionDivider(title: 'Open Issues'),
                            for (final issue in data.openIssues) ...[
                              _OpenIssueCard(issue: issue),
                              if (issue != data.openIssues.last) SizedBox(height: 12.h),
                            ],
                          ],
                          _SectionDivider(title: 'SLA Performance'),
                          _SlaPerformanceSection(data: data),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                  child: _Footer(
                    onEdit: onEdit,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.subtitle,
    required this.onClose,
  });

  final String name;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 17.h),
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
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    height: 28 / 20,
                    letterSpacing: -0.46,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
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
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  'assets/figma/library/svg/close_white.svg',
                  width: 28.r,
                  height: 28.r,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.only(top: 25.h),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.data});

  final VendorDetailData data;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _KpiCard(
              label: 'Risk Rating',
              value: '${data.riskRating}',
              badge: data.riskLevelLabel,
              badgeBg: _kLowRiskBadgeBg,
              badgeFg: _kLowRiskBadgeFg,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _KpiCard(
              label: 'Contract Value',
              value: data.contractValue,
              sublabel: 'Annual Spend',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _KpiCard(
              label: 'Control Effectiveness',
              value: '${data.controlEffectiveness}%',
              progress: data.controlEffectiveness / 100,
              progressTrack: _kProgressTrackGreen,
              progressFill: _kProgressFillGreen,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _KpiCard(
              label: 'Open Issues',
              value: '${data.openIssuesCount}',
              badge: '${data.tierLabel} Tier',
              badgeBg: _kCriticalTierBg,
              badgeFg: _kCriticalTierFg,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    this.sublabel,
    this.badge,
    this.badgeBg,
    this.badgeFg,
    this.progress,
    this.progressTrack,
    this.progressFill,
  });

  final String label;
  final String value;
  final String? sublabel;
  final String? badge;
  final Color? badgeBg;
  final Color? badgeFg;
  final double? progress;
  final Color? progressTrack;
  final Color? progressFill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _kKpiCardBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _kKpiLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: _kKpiValue,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          if (progress != null) ...[
            SizedBox(height: 4.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: progressTrack,
                color: progressFill,
              ),
            ),
          ],
          if (badge != null) ...[
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                badge!,
                style: TextStyle(
                  color: badgeFg,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                ),
              ),
            ),
          ],
          if (sublabel != null) ...[
            SizedBox(height: 4.h),
            Text(
              sublabel!,
              style: TextStyle(
                color: _kKpiLabel,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VendorInfoSection extends StatelessWidget {
  const _VendorInfoSection({required this.data});

  final VendorDetailData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _InfoField(label: 'Business Owner', value: data.businessOwner)),
            SizedBox(width: 16.w),
            Expanded(child: _InfoField(label: 'Vendor Manager', value: data.vendorManager)),
            SizedBox(width: 16.w),
            Expanded(child: _InfoField(label: 'Geography', value: data.geography)),
            SizedBox(width: 16.w),
            Expanded(child: _InfoField(label: 'Data Access', value: data.dataAccess)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _InfoField(label: 'Services Provided', value: data.servicesProvided),
            ),
            SizedBox(width: 16.w),
            Expanded(child: _InfoField(label: 'Last Assessment', value: data.lastAssessment)),
            SizedBox(width: 16.w),
            Expanded(child: _InfoField(label: 'Next Assessment', value: data.nextAssessment)),
          ],
        ),
      ],
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
            color: AppColors.textBody,
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

class _RiskAssessmentSection extends StatelessWidget {
  const _RiskAssessmentSection({required this.data});

  final VendorDetailData data;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _RiskCard(
              label: 'Inherent Risk',
              value: '${data.inherentRisk}%',
              labelColor: _kInherentLabel,
              valueColor: _kInherentValue,
              bg: _kInherentBg,
              progress: data.inherentRisk / 100,
              track: _kInherentTrack,
              fill: _kInherentFill,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _RiskCard(
              label: 'Residual Risk',
              value: '${data.residualRisk}%',
              labelColor: _kResidualLabel,
              valueColor: _kResidualValue,
              bg: _kResidualBg,
              progress: data.residualRisk / 100,
              track: _kResidualTrack,
              fill: _kResidualFill,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: _kReductionBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Reduction',
                    style: TextStyle(
                      color: _kReductionLabel,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${data.riskReduction}%',
                    style: TextStyle(
                      color: _kReductionValue,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      height: 32 / 24,
                      letterSpacing: 0.072,
                    ),
                  ),
                  Text(
                    'Through Controls',
                    style: TextStyle(
                      color: _kReductionLabel,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    required this.bg,
    required this.progress,
    required this.track,
    required this.fill,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final Color bg;
  final double progress;
  final Color track;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          SizedBox(height: 4.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: track,
              color: fill,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssessmentRadarChart extends StatelessWidget {
  const _AssessmentRadarChart({required this.scores});

  final List<VendorAssessmentScore> scores;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          dataSets: [
            RadarDataSet(
              dataEntries: [
                for (final s in scores) RadarEntry(value: s.value),
              ],
              fillColor: _kRadarBlue.withValues(alpha: 0.3),
              borderColor: _kRadarBlue,
              borderWidth: 2,
              entryRadius: 3,
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          radarBorderData: const BorderSide(color: _kRadarGrid, width: 1),
          gridBorderData: const BorderSide(color: _kRadarGrid, width: 1),
          tickBorderData: const BorderSide(color: _kRadarGrid, width: 1),
          tickCount: 4,
          ticksTextStyle: TextStyle(color: _kRadarGrid, fontSize: 12.sp),
          titlePositionPercentageOffset: 0.15,
          titleTextStyle: TextStyle(color: _kRadarAxis, fontSize: 12.sp),
          getTitle: (index, angle) => RadarChartTitle(text: scores[index].label),
        ),
      ),
    );
  }
}

class _CertificationsSection extends StatelessWidget {
  const _CertificationsSection({required this.certifications});

  final List<String> certifications;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: [
        for (final cert in certifications)
          Container(
            padding: EdgeInsets.fromLTRB(17.w, 9.h, 17.w, 9.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLightBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: _kCertBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/figma/tprm/svg/cert_check.svg',
                  width: 24.r,
                  height: 24.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  cert,
                  style: TextStyle(
                    color: _kKpiValue,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _GrcIntegrationSection extends StatelessWidget {
  const _GrcIntegrationSection({required this.data});

  final VendorDetailData data;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _GrcColumn(
              iconAsset: 'assets/figma/tprm/svg/link_asset.svg',
              title: 'Linked Assets (${data.linkedAssets.length})',
              items: data.linkedAssets,
              isRisk: false,
              viewLabel: 'View Assets',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _GrcColumn(
              iconAsset: 'assets/figma/tprm/svg/link_risk.svg',
              title: 'Linked Risks (${data.linkedRisks.length})',
              items: data.linkedRisks,
              isRisk: true,
              viewLabel: 'View Risks',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _GrcColumn(
              iconAsset: 'assets/figma/tprm/svg/integration_controls.svg',
              title: 'Linked Controls (${data.linkedControls.length})',
              items: data.linkedControls,
              isRisk: false,
              viewLabel: 'View Controls',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _GrcColumn(
              iconAsset: 'assets/figma/tprm/svg/integration_programs.svg',
              title: 'Linked Programs (${data.linkedPrograms.length})',
              items: data.linkedPrograms,
              isRisk: false,
              viewLabel: 'View Programs',
            ),
          ),
        ],
      ),
    );
  }
}

class _GrcColumn extends StatelessWidget {
  const _GrcColumn({
    required this.iconAsset,
    required this.title,
    required this.items,
    required this.isRisk,
    required this.viewLabel,
  });

  final String iconAsset;
  final String title;
  final List<String> items;
  final bool isRisk;
  final String viewLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SvgPicture.asset(iconAsset, width: 16.r, height: 16.r),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textBody,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        for (final item in items) ...[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: isRisk ? _kRiskChipBg : AppColors.primaryLightBg,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: isRisk ? _kRiskChipBorder : _kCertBorder),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: isRisk ? _kInherentValue : _kKpiValue,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
              ),
            ),
          ),
        ],
        SizedBox(height: 8.h),
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4.r),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/figma/tprm/svg/action_view.svg',
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    viewLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OpenIssueCard extends StatelessWidget {
  const _OpenIssueCard({required this.issue});

  final VendorOpenIssue issue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: _kIssueCardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _kIssueCardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _kIssueMediumBg,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        issue.severity,
                        style: TextStyle(
                          color: _kIssueMediumFg,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      issue.id,
                      style: TextStyle(
                        color: AppColors.textBody,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  issue.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Due: ${issue.dueDate}',
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _kCriticalTierBg,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              issue.status,
              style: TextStyle(
                color: _kCriticalTierFg,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlaPerformanceSection extends StatelessWidget {
  const _SlaPerformanceSection({required this.data});

  final VendorDetailData data;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _SlaCard(
              label: 'Availability',
              value: '${data.slaAvailability}%',
              progress: data.slaAvailability / 100,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _SlaCard(
              label: 'Response Time SLA',
              value: '${data.slaResponseTime}%',
              progress: data.slaResponseTime / 100,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _SlaCard(
              label: 'Incident Resolution',
              value: '${data.slaIncidentResolution}%',
              progress: data.slaIncidentResolution / 100,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlaCard extends StatelessWidget {
  const _SlaCard({
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _kSlaCardBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textBody,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: AppColors.border,
              color: _kProgressFillGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onEdit, required this.onClose});

  final VoidCallback? onEdit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: EdgeInsets.only(top: 25.h),
          child: Row(
            children: [
              AppButton(
                label: 'Edit Vendor',
                iconAsset: 'assets/figma/tprm/svg/action_edit.svg',
                iconSize: 24.r,
                variant: AppButtonVariant.primary,
                onPressed: onEdit,
              ),
              const Spacer(),
              AppButton(
                label: 'Close',
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
