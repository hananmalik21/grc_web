import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/router/nav_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/features/assessments/presentation/widgets/create_assessment_dialog.dart';

const _kAssetsDir = 'assets/figma/assessments/svg';

// ─── Colors not in AppColors ─────────────────────────────────────────────────
const _kCriteriaBg = Color(0xFFEFF6FF);
const _kCriteriaTitle = Color(0xFF1C398E);
const _kCriteriaDesc = Color(0xFF155DFC);
const _kFeatureBorder = Color(0xFFBEDBFF);
const _kMetaLabel = Color(0xFF4A5565);

class AssessmentHubPage extends StatelessWidget {
  const AssessmentHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1512.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(l10n: l10n),
            SizedBox(height: 24.h),
            _StatsRow(l10n: l10n),
            SizedBox(height: 24.h),
            _CriteriaCard(l10n: l10n),
            SizedBox(height: 24.h),
            _FrameworksSection(l10n: l10n),
            SizedBox(height: 24.h),
            _FeaturesCard(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Title bar
// ---------------------------------------------------------------------------

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.deferGo(AppRoutes.assessments),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderInput),
              ),
              child: Center(
                child: SvgPicture.asset(
                  '$_kAssetsDir/back_arrow.svg',
                  width: 20.r,
                  height: 20.r,
                  colorFilter:
                      const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.assessmentHubTitle,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  height: 32 / 24,
                  letterSpacing: 0.072,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.hubPageSubtitle,
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            onTap: () => showCreateAssessmentDialog(context: context),
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '$_kAssetsDir/plus.svg',
                    width: 16.r,
                    height: 16.r,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    l10n.addAssessment,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 24 / 16,
                      letterSpacing: -0.32,
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

// ---------------------------------------------------------------------------
// Stats row — 4 cards
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('3', l10n.hubQuestionLibraries, 'hub_book.svg'),
      ('42', l10n.hubTotalQuestions, 'hub_clipboard.svg'),
      ('5', l10n.hubStandardCriteria, 'hub_barchart.svg'),
      ('0', l10n.hubCustomAssessments, 'hub_clipboard.svg'),
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            Expanded(
              child: _StatCard(
                value: stats[i].$1,
                label: stats[i].$2,
                icon: stats[i].$3,
              ),
            ),
            if (i != stats.length - 1) SizedBox(width: 16.w),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.icon});

  final String value;
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                '$_kAssetsDir/$icon',
                width: 20.r,
                height: 20.r,
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textBody,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Standard Evaluation Criteria
// ---------------------------------------------------------------------------

class _CriteriaCard extends StatelessWidget {
  const _CriteriaCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final criteria = [
      (l10n.criteriaDocumentation, l10n.criteriaDocumentationDesc, 20),
      (l10n.criteriaImplementation, l10n.criteriaImplementationDesc, 30),
      (l10n.criteriaEffectiveness, l10n.criteriaEffectivenessDesc, 25),
      (l10n.criteriaMonitoring, l10n.criteriaMonitoringDesc, 15),
      (l10n.criteriaContinuousImprovement, l10n.criteriaContinuousImprovementDesc, 10),
    ];

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
          Text(
            l10n.hubStandardEvaluationCriteria,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.hubCriteriaIntro,
            style: TextStyle(
              color: AppColors.textBody,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
          SizedBox(height: 16.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < criteria.length; i++) ...[
                  Expanded(
                    child: _CriteriaItem(
                      title: criteria[i].$1,
                      description: criteria[i].$2,
                      weight: criteria[i].$3,
                      l10n: l10n,
                    ),
                  ),
                  if (i != criteria.length - 1) SizedBox(width: 16.w),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CriteriaItem extends StatelessWidget {
  const _CriteriaItem({
    required this.title,
    required this.description,
    required this.weight,
    required this.l10n,
  });

  final String title;
  final String description;
  final int weight;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _kCriteriaBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _kCriteriaTitle,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: TextStyle(
              color: _kCriteriaDesc,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.weightValue(weight),
            style: TextStyle(
              color: _kCriteriaTitle,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Standard Framework Assessments
// ---------------------------------------------------------------------------

class _FrameworksSection extends StatelessWidget {
  const _FrameworksSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final frameworks = [
      _FrameworkData(
        name: l10n.soxComplianceAssessment,
        description: l10n.soxComplianceDesc,
        questions: '14',
        categories: '3',
        estTime: '45-60 min',
        icon: 'hub_clipboard.svg',
        detailName: 'SOX (Sarbanes-Oxley)',
      ),
      _FrameworkData(
        name: l10n.cosoErmAssessment,
        description: l10n.cosoErmDesc,
        questions: '8',
        categories: '3',
        estTime: '30-45 min',
        icon: 'hub_barchart.svg',
        detailName: 'COSO ERM',
      ),
      _FrameworkData(
        name: l10n.cybersecurityAssessment,
        description: l10n.cybersecurityDesc,
        questions: '10',
        categories: '5',
        estTime: '60-90 min',
        icon: 'hub_clipboard.svg',
        detailName: 'Cybersecurity',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.hubStandardFrameworkAssessments,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            height: 28 / 18,
            letterSpacing: -0.45,
          ),
        ),
        SizedBox(height: 16.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < frameworks.length; i++) ...[
                Expanded(child: _FrameworkCard(data: frameworks[i], l10n: l10n)),
                if (i != frameworks.length - 1) SizedBox(width: 24.w),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameworkData {
  const _FrameworkData({
    required this.name,
    required this.description,
    required this.questions,
    required this.categories,
    required this.estTime,
    required this.icon,
    required this.detailName,
  });

  final String name;
  final String description;
  final String questions;
  final String categories;
  final String estTime;
  final String icon;
  final String detailName;
}

class _FrameworkCard extends StatelessWidget {
  const _FrameworkCard({required this.data, required this.l10n});

  final _FrameworkData data;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                '$_kAssetsDir/${data.icon}',
                width: 24.r,
                height: 24.r,
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            data.name,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            data.description,
            style: TextStyle(
              color: AppColors.textBody,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
          SizedBox(height: 16.h),
          _metaRow(l10n.hubQuestionsLabel, data.questions),
          SizedBox(height: 8.h),
          _metaRow(l10n.hubCategoriesLabel, data.categories),
          SizedBox(height: 8.h),
          _metaRow(l10n.hubEstTimeLabel, data.estTime),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    onTap: () =>
                        context.deferGo(AppRoutes.assessmentQuestionnaire),
                    borderRadius: BorderRadius.circular(10.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            '$_kAssetsDir/play.svg',
                            width: 16.r,
                            height: 16.r,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.startAssessment,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                              letterSpacing: -0.32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10.r),
                child: InkWell(
                  onTap: () => switch (data.detailName) {
                    'Cybersecurity' =>
                      context.deferGo(AppRoutes.assessmentCyber),
                    'COSO ERM' =>
                      context.deferGo(AppRoutes.assessmentCosoErm),
                    _ => context.deferGo(
                        AppRoutes.assessmentDetail,
                        extra: data.detailName,
                      ),
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.borderInput),
                    ),
                    child: SvgPicture.asset(
                      '$_kAssetsDir/eye.svg',
                      width: 16.r,
                      height: 16.r,
                      colorFilter: const ColorFilter.mode(
                          AppColors.textPrimary, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _kMetaLabel,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Assessment Features
// ---------------------------------------------------------------------------

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final features = [
      (l10n.featureWeightedScoring, l10n.featureWeightedScoringDesc, 'hub_clipboard.svg'),
      (l10n.featureRealTimeScoring, l10n.featureRealTimeScoringDesc, 'hub_barchart.svg'),
      (l10n.featureEvidenceCollection, l10n.featureEvidenceCollectionDesc, 'hub_clipboard.svg'),
      (l10n.featureProgressTracking, l10n.featureProgressTrackingDesc, 'hub_clipboard.svg'),
    ];

    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: _kCriteriaBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _kFeatureBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hubAssessmentFeatures,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < features.length; i++) ...[
                  Expanded(
                    child: _FeatureItem(
                      title: features[i].$1,
                      description: features[i].$2,
                      icon: features[i].$3,
                    ),
                  ),
                  if (i != features.length - 1) SizedBox(width: 16.w),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              '$_kAssetsDir/$icon',
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
              Text(
                description,
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
    );
  }
}
