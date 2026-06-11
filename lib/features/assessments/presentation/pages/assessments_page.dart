import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/router/nav_ext.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_horizontal_scroll_row.dart';
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
    final layout = context.screenLayout;
    final compact = layout.isCompact;
    final sectionGap = compact
        ? ResponsiveHelper.getTabSectionSpacing(context)
        : 24.h;

    return SingleChildScrollView(
      padding: layout.isMobile
          ? EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 24.h)
          : compact
              ? ResponsiveHelper.getDetailScreenPadding(context)
              : EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: compact ? context.responsiveMaxContentWidth : 1512.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TitleSection(),
            SizedBox(height: sectionGap),
            _AssessmentHubBanner(hub: data.hub),
            SizedBox(height: sectionGap),
            _StatsRow(summary: data.summary),
            SizedBox(height: sectionGap),
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
    final isMobile = context.screenLayout.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.frameworkAssessmentsTitle,
          style: textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.072,
            fontSize: isMobile ? 20.sp : null,
          ),
          strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
          textHeightBehavior: AppTextMetrics.textHeight,
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.frameworkAssessmentsSubtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textBody,
            fontSize: isMobile ? 13.sp : null,
          ),
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
    final layout = context.screenLayout;
    final compact = layout.isCompact;
    final padding = compact
        ? ResponsiveHelper.libraryCardPadding(context)
        : EdgeInsets.all(24.w);

    final launchButton = AppButton(
      label: l10n.launchAssessmentHub,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      fullWidth: compact,
      fontSize: layout.isMobile ? 13.sp : (compact ? 14.sp : 16.sp),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12.w : 24.w,
        vertical: compact ? 12.h : 10.h,
      ),
      onPressed: () => context.deferGo(AppRoutes.assessmentHub),
    );

    final statsPanel = Container(
      width: compact ? double.infinity : null,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8.w : 16.w,
        vertical: compact ? 12.h : 8.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: compact
          ? Row(
              children: [
                Expanded(
                  child: _HubStat(
                    value: '${hub.libraries}',
                    label: l10n.hubLibraries,
                    compact: true,
                  ),
                ),
                _hubDivider(compact: true),
                Expanded(
                  child: _HubStat(
                    value: '${hub.questions}',
                    label: l10n.hubQuestions,
                    compact: true,
                  ),
                ),
                _hubDivider(compact: true),
                Expanded(
                  child: _HubStat(
                    value: '${hub.criteria}',
                    label: l10n.hubCriteria,
                    compact: true,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HubStat(value: '${hub.libraries}', label: l10n.hubLibraries),
                _hubDivider(),
                _HubStat(value: '${hub.questions}', label: l10n.hubQuestions),
                _hubDivider(),
                _HubStat(value: '${hub.criteria}', label: l10n.hubCriteria),
              ],
            ),
    );

    return Container(
      width: double.infinity,
      padding: padding,
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
                width: compact ? 40.r : 48.r,
                height: compact ? 40.r : 48.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    '$_kAssetsDir/hub_icon.svg',
                    width: compact ? 20.r : 24.r,
                    height: compact ? 20.r : 24.r,
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
                      l10n.assessmentHubTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 18.sp : 20.sp,
                        fontWeight: FontWeight.w600,
                        height: 28 / 20,
                        letterSpacing: -0.46,
                      ),
                    ),
                    Text(
                      l10n.assessmentHubSubtitle,
                      style: TextStyle(
                        color: _kHubSubtitle,
                        fontSize: compact ? 13.sp : 14.sp,
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
            l10n.assessmentHubDescription,
            maxLines: layout.isMobile ? 2 : null,
            overflow: layout.isMobile ? TextOverflow.ellipsis : null,
            style: TextStyle(
              color: _kHubSubtitle,
              fontSize: compact ? 13.sp : 14.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
          SizedBox(height: 16.h),
          if (compact)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                launchButton,
                SizedBox(height: 12.h),
                statsPanel,
              ],
            )
          else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  launchButton,
                  SizedBox(width: 12.w),
                  Expanded(child: statsPanel),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _hubDivider({bool compact = false}) {
    return Container(
      width: 1,
      height: compact ? 36.h : 32.h,
      margin: EdgeInsets.symmetric(horizontal: compact ? 4.w : 16.w),
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}

class _HubStat extends StatelessWidget {
  const _HubStat({
    required this.value,
    required this.label,
    this.compact = false,
  });

  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 16.sp : 18.sp,
            fontWeight: FontWeight.w600,
            height: 28 / 18,
            letterSpacing: -0.45,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color: _kHubSubtitle,
              fontSize: compact ? 11.sp : 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
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
  const _StatsRow({required this.summary});

  final AssessmentsSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.screenLayout;

    final cards = [
      _StatCard(
        value: '${summary.totalFrameworks}',
        label: l10n.statTotalFrameworks,
        iconAsset: '$_kAssetsDir/stat_total_frameworks.svg',
      ),
      _StatCard(
        value: '${summary.avgCompliance}%',
        label: l10n.statAvgCompliance,
        iconAsset: '$_kAssetsDir/stat_avg_compliance.svg',
      ),
      _StatCard(
        value: '${summary.totalControls}',
        label: l10n.statTotalControls,
        iconAsset: '$_kAssetsDir/stat_total_controls.svg',
      ),
      _StatCard(
        value: '${summary.activeFrameworks}',
        label: l10n.statActiveFrameworks,
        iconAsset: '$_kAssetsDir/stat_active_frameworks.svg',
      ),
    ];

    if (layout.isCompact) {
      final cardWidth = layout.isMobile
          ? MediaQuery.sizeOf(context).width * 0.86
          : ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 220,
              tablet: 240,
              web: 260,
            );
      final spacing = context.responsive(
        mobile: 12.0,
        tablet: 14.0,
        desktop: 16.0,
      );

      return AppHorizontalScrollRow(
        spacing: spacing,
        children: [
          for (final card in cards) SizedBox(width: cardWidth, child: card),
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i != cards.length - 1) SizedBox(width: 16.w),
        ],
      ],
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
    final padding = ResponsiveHelper.getCardPadding(context);

    return Container(
      padding: EdgeInsets.all(padding),
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
    final layout = context.screenLayout;
    final gap = layout.isCompact ? 16.h : 24.h;

    if (layout.isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < frameworks.length; i++) ...[
            _FrameworkCard(framework: frameworks[i]),
            if (i != frameworks.length - 1) SizedBox(height: gap),
          ],
        ],
      );
    }

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
              SizedBox(width: gap),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _FrameworkCard(framework: right),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < frameworks.length) rows.add(SizedBox(height: gap));
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
          padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
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

    final statusColumn = Column(
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
    );

    final controlsColumn = Column(
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
    );

    final lastAssessmentColumn = Column(
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
    );

    final layout = context.screenLayout;

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(top: 17.h),
      child: layout.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                statusColumn,
                SizedBox(height: 12.h),
                controlsColumn,
                SizedBox(height: 12.h),
                lastAssessmentColumn,
              ],
            )
          : layout.isTabletSmall
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: statusColumn),
                        SizedBox(width: 16.w),
                        Expanded(child: controlsColumn),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    lastAssessmentColumn,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: statusColumn),
                    SizedBox(width: 16.w),
                    Expanded(child: controlsColumn),
                    SizedBox(width: 16.w),
                    Expanded(child: lastAssessmentColumn),
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
