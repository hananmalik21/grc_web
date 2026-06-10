import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/router/nav_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_loading_indicator.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/assessments/application/providers/assessments_providers.dart';
import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';

// ─── Colors not in AppColors ─────────────────────────────────────────────────
const _kComplianceGreen = Color(0xFF00A63E);
const _kProgressTrack = Color(0xFFE5E7EB);
const _kHubSubtitle = Color(0xFFDBEAFE);
const _kStatusInProgressBg = Color(0xFFDBEAFE);
const _kStatusInProgressFg = Color(0xFF193CB8);
const _kStatusActiveBg = Color(0xFFDCFCE7);
const _kStatusActiveFg = Color(0xFF016630);
const _kChevron = Color(0xFF99A1AF);

const _kAssetsDir = 'assets/figma/assessments/svg';

class AssessmentsPage extends ConsumerWidget {
  const AssessmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dataAsync = ref.watch(assessmentsProvider);

    return dataAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: AppErrorView(
          message: error is Failure ? error.message : l10n.errorGeneric,
          onRetry: () => ref.invalidate(assessmentsProvider),
        ),
      ),
      data: (data) => _AssessmentsView(data: data),
    );
  }
}

// ---------------------------------------------------------------------------
// Root view
// ---------------------------------------------------------------------------

class _AssessmentsView extends StatelessWidget {
  const _AssessmentsView({required this.data});

  final AssessmentsData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1512.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TitleSection(),
            SizedBox(height: 24.h),
            _AssessmentHubBanner(hub: data.hub),
            SizedBox(height: 24.h),
            _StatsRow(summary: data.summary),
            SizedBox(height: 24.h),
            _FrameworksGrid(frameworks: data.frameworks),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Title
// ---------------------------------------------------------------------------

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.frameworkAssessmentsTitle,
          style: textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.072,
          ),
          strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
          textHeightBehavior: AppTextMetrics.textHeight,
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.frameworkAssessmentsSubtitle,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textBody),
          strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
          textHeightBehavior: AppTextMetrics.textHeight,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Assessment Hub banner
// ---------------------------------------------------------------------------

class _AssessmentHubBanner extends StatelessWidget {
  const _AssessmentHubBanner({required this.hub});

  final AssessmentHubInfo hub;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    '$_kAssetsDir/hub_icon.svg',
                    width: 24.r,
                    height: 24.r,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.assessmentHubTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      height: 28 / 20,
                      letterSpacing: -0.46,
                    ),
                  ),
                  Text(
                    l10n.assessmentHubSubtitle,
                    style: TextStyle(
                      color: _kHubSubtitle,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      letterSpacing: -0.154,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.assessmentHubDescription,
            style: TextStyle(
              color: _kHubSubtitle,
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
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    onTap: () => context.deferGo(AppRoutes.assessmentHub),
                    borderRadius: BorderRadius.circular(10.r),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w,),
                        child: Text(
                          l10n.launchAssessmentHub,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            height: 24 / 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _HubStat(value: '${hub.libraries}', label: l10n.hubLibraries),
                      _hubDivider(),
                      _HubStat(value: '${hub.questions}', label: l10n.hubQuestions),
                      _hubDivider(),
                      _HubStat(value: '${hub.criteria}', label: l10n.hubCriteria),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hubDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: 1,
        height: 32.h,
        color: Colors.white.withValues(alpha: 0.2),
      ),
    );
  }
}

class _HubStat extends StatelessWidget {
  const _HubStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            height: 28 / 18,
            letterSpacing: -0.45,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: _kHubSubtitle,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
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
  const _StatsRow({required this.summary});

  final AssessmentsSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatCard(
              value: '${summary.totalFrameworks}',
              label: l10n.statTotalFrameworks,
              iconAsset: '$_kAssetsDir/stat_total_frameworks.svg',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _StatCard(
              value: '${summary.avgCompliance}%',
              label: l10n.statAvgCompliance,
              iconAsset: '$_kAssetsDir/stat_avg_compliance.svg',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _StatCard(
              value: '${summary.totalControls}',
              label: l10n.statTotalControls,
              iconAsset: '$_kAssetsDir/stat_total_controls.svg',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _StatCard(
              value: '${summary.activeFrameworks}',
              label: l10n.statActiveFrameworks,
              iconAsset: '$_kAssetsDir/stat_active_frameworks.svg',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.iconAsset,
  });

  final String value;
  final String label;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              child: SvgPicture.asset(iconAsset, width: 20.r, height: 20.r),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.072,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textBody),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Frameworks grid — 2 columns
// ---------------------------------------------------------------------------

class _FrameworksGrid extends StatelessWidget {
  const _FrameworksGrid({required this.frameworks});

  final List<FrameworkAssessment> frameworks;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < frameworks.length; i += 2) {
      final left = frameworks[i];
      final right = i + 1 < frameworks.length ? frameworks[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _FrameworkCard(framework: left)),
              SizedBox(width: 24.w),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _FrameworkCard(framework: right),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < frameworks.length) rows.add(SizedBox(height: 24.h));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _FrameworkCard extends StatelessWidget {
  const _FrameworkCard({required this.framework});

  final FrameworkAssessment framework;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () => switch (framework.category) {
          'Cybersecurity' => context.deferGo(AppRoutes.assessmentCyber),
          'Enterprise Risk Management' =>
            context.deferGo(AppRoutes.assessmentCosoErm),
          'Operational Risk' => context.deferGo(AppRoutes.assessmentOrm),
          'Third-Party Risk' =>
            context.deferGo(AppRoutes.assessmentCloudVendor),
          'Business Continuity' => context.deferGo(AppRoutes.assessmentBcm),
          _ => context.deferGo(AppRoutes.assessmentDetail,
              extra: framework.name),
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(25.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              SizedBox(height: 16.h),
              _compliance(context),
              SizedBox(height: 16.h),
              _footer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          '$_kAssetsDir/framework_icon.svg',
                          width: 24.r,
                          height: 24.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            framework.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              height: 28 / 18,
                              letterSpacing: -0.45,
                            ),
                          ),
                          Text(
                            framework.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              letterSpacing: -0.154,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  framework.description,
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
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: SvgPicture.asset(
              '$_kAssetsDir/chevron_right.svg',
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(_kChevron, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _compliance(BuildContext context) {
    final l10n = context.l10n;
    final fillColor =
        framework.compliance >= 85 ? _kComplianceGreen : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.complianceLevel,
              style: TextStyle(
                color: AppColors.textLabel,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
            Text(
              '${framework.compliance}%',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: Stack(
            children: [
              Container(height: 8.h, color: _kProgressTrack),
              FractionallySizedBox(
                widthFactor: (framework.compliance / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footer(BuildContext context) {
    final l10n = context.l10n;
    final (statusBg, statusFg, statusLabel) = switch (framework.status) {
      FrameworkStatus.active => (
          _kStatusActiveBg,
          _kStatusActiveFg,
          l10n.frameworkStatusActive
        ),
      FrameworkStatus.inProgress => (
          _kStatusInProgressBg,
          _kStatusInProgressFg,
          l10n.frameworkStatusInProgress
        ),
    };

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(top: 17.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _footerLabel(l10n.frameworkStatusLabel),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusFg,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _footerLabel(l10n.frameworkControlsLabel),
                SizedBox(height: 4.h),
                Text(
                  '${framework.controls}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _footerLabel(l10n.lastAssessmentLabel),
                SizedBox(height: 4.h),
                Text(
                  framework.lastAssessment,
                  style: TextStyle(
                    color: AppColors.textLabel,
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

  Widget _footerLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      ),
    );
  }
}
