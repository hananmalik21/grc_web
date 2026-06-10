import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/features/controls/presentation/widgets/add_control_dialog.dart';

const _kEffectivenessGreen = Color(0xFF22C55E);
const _kTestDotGreen = Color(0xFF22C55E);
const _kRiskCardBg = Color(0xFFFEF2F2);
const _kRiskCardBorder = Color(0xFFFEE2E2);
const _kRiskSectionTitle = Color(0xFFDC2626);
const _kLinkedCardBorder = Color(0xFFE5E7EB);

Future<void> showControlDetailDialog({
  required BuildContext context,
  required ControlDetailData data,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) => ControlDetailDialog(
      data: data,
      onEdit: () {
        Navigator.of(dialogContext).pop();
        showEditControlDialog(
          context: context,
          data: _controlFormDataFromDetail(data),
        );
      },
    ),
  );
}

class ControlDetailData {
  const ControlDetailData({
    required this.id,
    required this.name,
    required this.description,
    required this.typeLabel,
    required this.statusLabel,
    required this.statusBg,
    required this.statusFg,
    required this.owner,
    required this.testFrequency,
    required this.lastAssessed,
    required this.frameworks,
    required this.effectiveness,
    required this.testResults,
    required this.linkedRisks,
    required this.linkedAssets,
    required this.linkedAssessments,
    required this.evidence,
  });

  final String id;
  final String name;
  final String description;
  final String typeLabel;
  final String statusLabel;
  final Color statusBg;
  final Color statusFg;
  final String owner;
  final String testFrequency;
  final String lastAssessed;
  final List<String> frameworks;
  final int effectiveness;
  final List<ControlTestResult> testResults;
  final List<ControlLinkedRisk> linkedRisks;
  final List<String> linkedAssets;
  final List<ControlLinkedAssessment> linkedAssessments;
  final List<ControlEvidence> evidence;

  static ControlDetailData sample({
    required String id,
    required String name,
    required String description,
    required String typeLabel,
    required String statusLabel,
    required Color statusBg,
    required Color statusFg,
    required String owner,
    required String lastAssessed,
    required List<String> frameworks,
    required int effectiveness,
    required int riskLinks,
    required int assetLinks,
    required int assessmentLinks,
  }) {
    if (id == 'CTL-001') {
      return ControlDetailData(
        id: id,
        name: name,
        description: description,
        typeLabel: typeLabel,
        statusLabel: statusLabel,
        statusBg: statusBg,
        statusFg: statusFg,
        owner: owner,
        testFrequency: 'Continuous',
        lastAssessed: lastAssessed,
        frameworks: frameworks,
        effectiveness: effectiveness,
        testResults: const [
          ControlTestResult(
            date: '2026-04-15',
            testedBy: 'John Doe',
            result: 'Pass',
            score: 95,
          ),
          ControlTestResult(
            date: '2026-03-10',
            testedBy: 'Jane Smith',
            result: 'Pass',
            score: 94,
          ),
        ],
        linkedRisks: const [
          ControlLinkedRisk(id: 'R-004', subtitle: 'Risk being mitigated'),
          ControlLinkedRisk(id: 'R-001', subtitle: 'Risk being mitigated'),
        ],
        linkedAssets: const ['AST-006', 'AST-001'],
        linkedAssessments: const [
          ControlLinkedAssessment(id: 'ASSESS-001', subtitle: 'Assessment reference'),
          ControlLinkedAssessment(id: 'ASSESS-003', subtitle: 'Assessment reference'),
        ],
        evidence: const [
          ControlEvidence(
            title: 'MFA Configuration Report',
            meta: 'Document • 2026-04-15',
          ),
          ControlEvidence(
            title: 'User Enrollment Metrics',
            meta: 'Screenshot • 2026-04-10',
          ),
        ],
      );
    }

    return ControlDetailData(
      id: id,
      name: name,
      description: description,
      typeLabel: typeLabel,
      statusLabel: statusLabel,
      statusBg: statusBg,
      statusFg: statusFg,
      owner: owner,
      testFrequency: 'Annual',
      lastAssessed: lastAssessed,
      frameworks: frameworks,
      effectiveness: effectiveness,
      testResults: [
        ControlTestResult(
          date: lastAssessed,
          testedBy: owner,
          result: 'Pass',
          score: effectiveness,
        ),
      ],
      linkedRisks: [
        for (var i = 0; i < riskLinks; i++)
          ControlLinkedRisk(
            id: 'R-${(i + 1).toString().padLeft(3, '0')}',
            subtitle: 'Risk being mitigated',
          ),
      ],
      linkedAssets: [
        for (var i = 0; i < assetLinks; i++)
          'AST-${(i + 1).toString().padLeft(3, '0')}',
      ],
      linkedAssessments: [
        for (var i = 0; i < assessmentLinks; i++)
          ControlLinkedAssessment(
            id: 'ASSESS-${(i + 1).toString().padLeft(3, '0')}',
            subtitle: 'Assessment reference',
          ),
      ],
      evidence: const [],
    );
  }
}

class ControlTestResult {
  const ControlTestResult({
    required this.date,
    required this.testedBy,
    required this.result,
    required this.score,
  });

  final String date;
  final String testedBy;
  final String result;
  final int score;
}

class ControlLinkedRisk {
  const ControlLinkedRisk({required this.id, required this.subtitle});

  final String id;
  final String subtitle;
}

class ControlLinkedAssessment {
  const ControlLinkedAssessment({required this.id, required this.subtitle});

  final String id;
  final String subtitle;
}

class ControlEvidence {
  const ControlEvidence({required this.title, required this.meta});

  final String title;
  final String meta;
}

class ControlDetailDialog extends StatelessWidget {
  const ControlDetailDialog({
    super.key,
    required this.data,
    required this.onEdit,
  });

  final ControlDetailData data;
  final VoidCallback onEdit;

  static const _dialogWidth = 1152.0;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(_dialogWidth.w, screen.width - 48.w);
    final dialogHeight = math.min(1462.h, screen.height * 0.92);

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
                  subtitle: 'Control ID: ${data.id} | ${data.typeLabel}',
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
                          _OverviewSection(data: data),
                          SizedBox(height: 24.h),
                          _EffectivenessSection(percent: data.effectiveness),
                          SizedBox(height: 24.h),
                          _TestHistorySection(results: data.testResults),
                          if (data.linkedRisks.isNotEmpty) ...[
                            SizedBox(height: 24.h),
                            _LinkedRisksSection(risks: data.linkedRisks),
                          ],
                          if (data.linkedAssets.isNotEmpty) ...[
                            SizedBox(height: 24.h),
                            _LinkedAssetsSection(assets: data.linkedAssets),
                          ],
                          if (data.linkedAssessments.isNotEmpty) ...[
                            SizedBox(height: 24.h),
                            _LinkedAssessmentsSection(assessments: data.linkedAssessments),
                          ],
                          if (data.evidence.isNotEmpty) ...[
                            SizedBox(height: 24.h),
                            _EvidenceSection(items: data.evidence),
                          ],
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

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.data});

  final ControlDetailData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Description'),
              SizedBox(height: 12.h),
              Text(
                data.description,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
              SizedBox(height: 12.h),
              _fieldLabel('Framework Mappings'),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  for (final fw in data.frameworks)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLightBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: _kLinkedCardBorder),
                      ),
                      child: Text(
                        fw,
                        style: TextStyle(
                          color: AppColors.weightBadgeFg,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          letterSpacing: -0.154,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _metaField(
                label: 'Status',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: data.statusBg,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    data.statusLabel,
                    style: TextStyle(
                      color: data.statusFg,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _metaField(
                label: 'Owner',
                value: data.owner,
              ),
              SizedBox(height: 16.h),
              _metaField(
                label: 'Test Frequency',
                value: data.testFrequency,
              ),
              SizedBox(height: 16.h),
              _metaField(
                label: 'Last Assessed',
                value: data.lastAssessed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EffectivenessSection extends StatelessWidget {
  const _EffectivenessSection({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        _fieldLabel('Control Effectiveness'),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Current Effectiveness Rating',
                    style: TextStyle(
                      color: AppColors.textLabel,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      letterSpacing: -0.154,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      height: 32 / 24,
                      letterSpacing: 0.072,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 12.h,
                  backgroundColor: AppColors.primaryTint,
                  color: _kEffectivenessGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestHistorySection extends StatelessWidget {
  const _TestHistorySection({required this.results});

  final List<ControlTestResult> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        _SectionTitle(
          iconAsset: 'assets/figma/controls/svg/detail_test_history.svg',
          title: 'Test Results History',
        ),
        SizedBox(height: 16.h),
        for (var i = 0; i < results.length; i++) ...[
          _TestResultRow(result: results[i]),
          if (i != results.length - 1) SizedBox(height: 8.h),
        ],
      ],
    );
  }
}

class _TestResultRow extends StatelessWidget {
  const _TestResultRow({required this.result});

  final ControlTestResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: const BoxDecoration(
              color: _kTestDotGreen,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.date,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                Text(
                  'Tested by: ${result.testedBy}',
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
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.statusLowBg,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              result.result,
              style: TextStyle(
                color: AppColors.statusLowFg,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '${result.score}%',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkedRisksSection extends StatelessWidget {
  const _LinkedRisksSection({required this.risks});

  final List<ControlLinkedRisk> risks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        _SectionTitle(
          iconAsset: 'assets/figma/controls/svg/link_risk.svg',
          title: 'Linked Risks (${risks.length})',
          titleColor: _kRiskSectionTitle,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            for (var i = 0; i < risks.length; i++) ...[
              if (i > 0) SizedBox(width: 12.w),
              Expanded(child: _RiskCard(risk: risks[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.risk});

  final ControlLinkedRisk risk;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: _kRiskCardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _kRiskCardBorder),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/figma/controls/svg/link_risk.svg',
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  risk.id,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                Text(
                  risk.subtitle,
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(4.r),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: SvgPicture.asset(
                  'assets/figma/controls/svg/action_view.svg',
                  width: 24.r,
                  height: 24.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkedAssetsSection extends StatelessWidget {
  const _LinkedAssetsSection({required this.assets});

  final List<String> assets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        _SectionTitle(
          iconAsset: 'assets/figma/controls/svg/detail_linked_assets_header.svg',
          title: 'Linked Assets (${assets.length})',
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            for (var i = 0; i < assets.length; i++) ...[
              if (i > 0) SizedBox(width: 12.w),
              Expanded(child: _AssetCard(id: assets[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _kLinkedCardBorder),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/figma/controls/svg/detail_card_asset.svg',
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              id,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/figma/controls/svg/detail_card_link.svg',
            width: 20.r,
            height: 20.r,
          ),
        ],
      ),
    );
  }
}

class _LinkedAssessmentsSection extends StatelessWidget {
  const _LinkedAssessmentsSection({required this.assessments});

  final List<ControlLinkedAssessment> assessments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        _SectionTitle(
          iconAsset: 'assets/figma/controls/svg/detail_linked_assessments_header.svg',
          title: 'Linked Assessments (${assessments.length})',
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            for (var i = 0; i < assessments.length; i++) ...[
              if (i > 0) SizedBox(width: 12.w),
              Expanded(child: _AssessmentCard(assessment: assessments[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  const _AssessmentCard({required this.assessment});

  final ControlLinkedAssessment assessment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _kLinkedCardBorder),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/figma/controls/svg/integration_assessment.svg',
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assessment.id,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                Text(
                  assessment.subtitle,
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

class _EvidenceSection extends StatelessWidget {
  const _EvidenceSection({required this.items});

  final List<ControlEvidence> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        _SectionTitle(
          iconAsset: 'assets/figma/controls/svg/detail_evidence_header.svg',
          title: 'Evidence & Documentation (${items.length})',
        ),
        SizedBox(height: 16.h),
        for (var i = 0; i < items.length; i++) ...[
          _EvidenceRow(item: items[i]),
          if (i != items.length - 1) SizedBox(height: 8.h),
        ],
      ],
    );
  }
}

class _EvidenceRow extends StatelessWidget {
  const _EvidenceRow({required this.item});

  final ControlEvidence item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _kLinkedCardBorder),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/figma/controls/svg/integration_evidence.svg',
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                Text(
                  item.meta,
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
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.onEdit,
    required this.onClose,
  });

  final VoidCallback onEdit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        SizedBox(height: 25.h),
        Row(
          children: [
            AppButton(
              label: 'Edit Control',
              iconAsset: 'assets/figma/controls/svg/detail_edit.svg',
              iconSize: 24.r,
              variant: AppButtonVariant.primary,
              onPressed: onEdit,
            ),
            SizedBox(width: 12.w),
            AppButton(
              label: 'Delete',
              iconAsset: 'assets/figma/controls/svg/detail_delete.svg',
              iconSize: 24.r,
              iconColor: AppColors.deletePrimary,
              borderColor: AppColors.deleteBorderRed,
              variant: AppButtonVariant.outlined,
              onPressed: () {},
            ),
            const Spacer(),
            AppButton(
              label: 'Schedule Test',
              variant: AppButtonVariant.outlined,
              onPressed: () {},
            ),
            SizedBox(width: 12.w),
            AppButton(
              label: 'Close',
              variant: AppButtonVariant.outlined,
              onPressed: onClose,
            ),
          ],
        ),
      ],
    );
  }
}

ControlFormData _controlFormDataFromDetail(ControlDetailData detail) {
  final statusKey = switch (detail.statusLabel) {
    'Implemented' => 'implemented',
    'Partially Implemented' => 'partiallyImplemented',
    _ => 'notImplemented',
  };
  final typeKey = switch (detail.typeLabel) {
    'Preventive' => 'preventive',
    'Detective' => 'detective',
    'Corrective' => 'corrective',
    _ => 'preventive',
  };
  final frequencyKey = switch (detail.testFrequency) {
    'Continuous' => 'continuous',
    'Quarterly' => 'quarterly',
    'Monthly' => 'monthly',
    _ => 'annual',
  };

  return ControlFormData(
    id: detail.id,
    name: detail.name,
    description: detail.description,
    controlType: typeKey,
    status: statusKey,
    owner: detail.owner,
    testFrequency: frequencyKey,
    effectiveness: detail.effectiveness.toDouble(),
    frameworks: List<String>.from(detail.frameworks),
    linkedRisks: detail.linkedRisks.map((r) => r.id).join(', '),
    linkedAssets: detail.linkedAssets.join(', '),
    linkedAssessments: detail.linkedAssessments.map((a) => a.id).join(', '),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.iconAsset,
    required this.title,
    this.titleColor,
  });

  final String iconAsset;
  final String title;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconAsset, width: 28.r, height: 28.r),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? AppColors.textLabel,
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

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.border, height: 1, thickness: 1);
  }
}

Widget _fieldLabel(String text) {
  return Text(
    text,
    style: TextStyle(
      color: AppColors.axisLabel,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
      letterSpacing: -0.154,
    ),
  );
}

Widget _metaField({
  required String label,
  String? value,
  Widget? child,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AppColors.axisLabel,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          height: 16 / 12,
        ),
      ),
      SizedBox(height: 1.5.h),
      if (child != null)
        child
      else
        Text(
          value ?? '',
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
