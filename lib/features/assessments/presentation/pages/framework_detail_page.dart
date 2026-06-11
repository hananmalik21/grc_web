import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/router/nav_ext.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_loading_indicator.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/assessments/application/providers/assessments_providers.dart';
import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';
import 'package:grc_web/features/assessments/presentation/widgets/add_action_dialog.dart';
import 'package:grc_web/features/assessments/presentation/widgets/assessment_page_layout.dart';

// ─── Colors not in AppColors ─────────────────────────────────────────────────
const _kGreen = Color(0xFF00A63E);
const _kAmber = Color(0xFFD08700);
const _kRed = Color(0xFFE7000B);
const _kProgressTrack = Color(0xFFE5E7EB);
const _kCountText = Color(0xFF364153);
const _kSubLabel = Color(0xFF6A7282);
const _kBorderInput = Color(0xFFD1D5DC);
const _kExportText = Color(0xFF0A0A0A);

// remediation — high (red)
const _kRedBg = Color(0xFFFEF2F2);
const _kRedBorder = Color(0xFFFFC9C9);
const _kRedTitle = Color(0xFF82181A);
const _kRedBody = Color(0xFFC10007);
const _kPriorityHighBg = Color(0xFFFFE2E2);
const _kPriorityHighFg = Color(0xFF9F0712);

// remediation — medium (amber)
const _kAmberBg = Color(0xFFFEFCE8);
const _kAmberBorder = Color(0xFFFFF085);
const _kAmberTitle = Color(0xFF733E0A);
const _kAmberBody = Color(0xFFA65F00);
const _kAmberIcon = Color(0xFFCA8A04);
const _kPriorityMediumBg = Color(0xFFFEF9C2);
const _kPriorityMediumFg = Color(0xFF894B00);

// status badges
const _kStatusOpenBg = Color(0xFFF3F4F6);
const _kStatusOpenFg = Color(0xFF1E2939);
const _kStatusInProgressBg = Color(0xFFDBEAFE);
const _kStatusInProgressFg = Color(0xFF193CB8);

// expanded section questions
const _kSectionExpandBg = Color(0xFFF9FAFB);
const _kNumberBadgeBg = Color(0xFFDBEAFE);
const _kNumberBadgeFg = Color(0xFF155DFC);
const _kRadioSelected = Color(0xFF0075FF);
const _kRadioBorder = Color(0xFF767676);
const _kEvidenceBg = Color(0xFFEFF6FF);
const _kEvidenceBorder = Color(0xFFBEDBFF);
const _kEvidenceLabel = Color(0xFF1C398E);
const _kEvidenceText = Color(0xFF1447E6);

const _kAssetsDir = 'assets/figma/assessments/svg';

class FrameworkDetailPage extends ConsumerWidget {
  const FrameworkDetailPage({super.key, required this.frameworkName});

  final String frameworkName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detailAsync = ref.watch(frameworkDetailProvider(frameworkName));

    return detailAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: AppErrorView(
          message: error is Failure ? error.message : l10n.errorGeneric,
          onRetry: () => ref.invalidate(frameworkDetailProvider(frameworkName)),
        ),
      ),
      data: (detail) => _DetailView(detail: detail),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.detail});

  final FrameworkDetail detail;

  @override
  Widget build(BuildContext context) {
    final sectionGap = AssessmentPageLayout.sectionGap(context);

    return SingleChildScrollView(
      padding: AssessmentPageLayout.pagePadding(context),
      child: ConstrainedBox(
        constraints: AssessmentPageLayout.contentConstraints(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(detail: detail),
            SizedBox(height: sectionGap),
            _StatsRow(detail: detail),
            SizedBox(height: sectionGap),
            _SectionsList(sections: detail.sections),
            SizedBox(height: sectionGap),
            _RemediationCard(detail: detail),
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
  const _TitleBar({required this.detail});

  final FrameworkDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return AssessmentPageLayout.detailTitleBar(
      context: context,
      backButton: AppButton.back(
        iconAsset: '$_kAssetsDir/back_arrow.svg',
        borderColor: _kBorderInput,
        onPressed: () => context.deferGo(AppRoutes.assessments),
      ),
      titleSection: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.title,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.072,
              fontSize: AssessmentPageLayout.titleFontSize(context),
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 4.h),
          Text(
            detail.subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody,
              fontSize: AssessmentPageLayout.subtitleFontSize(context),
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
      trailing: AppButton.export(
        label: l10n.exportReport,
        iconAsset: '$_kAssetsDir/export.svg',
        foregroundColor: _kExportText,
        fullWidth: context.screenLayout.isCompact,
        onPressed: () {},
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stats row
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.detail});

  final FrameworkDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AssessmentPageLayout.statsRow(
      context,
      [
        _ScoreCard(
          score: detail.complianceScore,
          label: l10n.complianceScore,
        ),
        _StatCard(
          value: '${detail.compliantControls}',
          valueColor: _kGreen,
          label: l10n.compliantControls,
          sublabel: l10n.outOfTotal(detail.totalControls),
        ),
        _StatCard(
          value: '${detail.partialCompliance}',
          valueColor: _kAmber,
          label: l10n.partialComplianceLabel,
          sublabel: l10n.needsImprovement,
        ),
        _StatCard(
          value: '${detail.nonCompliant}',
          valueColor: _kRed,
          label: l10n.nonCompliantLabel,
          sublabel: l10n.immediateActionRequired,
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.score, required this.label});

  final int score;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cardPadding = AssessmentPageLayout.cardPadding(context);

    return _cardBox(
      padding: EdgeInsets.fromLTRB(cardPadding, cardPadding, cardPadding, 29.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$score%',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textBody,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: Stack(
              children: [
                Container(height: 8.h, color: _kProgressTrack),
                FractionallySizedBox(
                  widthFactor: (score / 100).clamp(0.0, 1.0),
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.valueColor,
    required this.label,
    required this.sublabel,
  });

  final String value;
  final Color valueColor;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return _cardBox(
      padding: EdgeInsets.all(AssessmentPageLayout.cardPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
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
          SizedBox(height: 4.h),
          Text(
            sublabel,
            style: TextStyle(
              color: _kSubLabel,
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

// ---------------------------------------------------------------------------
// Sections
// ---------------------------------------------------------------------------

class _SectionsList extends StatelessWidget {
  const _SectionsList({required this.sections});

  final List<AssessmentSection> sections;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      children.add(_SectionCard(section: sections[i]));
      if (i != sections.length - 1) children.add(SizedBox(height: 16.h));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _SectionCard extends StatefulWidget {
  const _SectionCard({required this.section});

  final AssessmentSection section;

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final canExpand = section.questions.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: canExpand ? () => setState(() => _expanded = !_expanded) : null,
              child: Padding(
                padding: EdgeInsets.all(AssessmentPageLayout.cardPadding(context)),
                child: _header(context, section),
              ),
            ),
          ),
          if (_expanded && canExpand) _expansion(context, section),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, AssessmentSection section) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18,
                  letterSpacing: -0.45,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                section.description,
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 8.h,
                children: [
                  _countItem('check_circle.svg', l10n.compliantCount(section.compliant)),
                  _countItem('partial.svg', l10n.partialCount(section.partial)),
                  _countItem('x_circle.svg', l10n.nonCompliantCount(section.nonCompliant)),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${section.compliance}%',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  height: 32 / 24,
                  letterSpacing: 0.072,
                ),
              ),
              Text(
                l10n.complianceShort,
                style: TextStyle(
                  color: _kSubLabel,
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

  Widget _expansion(BuildContext context, AssessmentSection section) {
    final questions = section.questions;
    final items = <Widget>[];
    for (var i = 0; i < questions.length; i++) {
      items.add(_QuestionCard(index: i + 1, question: questions[i]));
      if (i != questions.length - 1) items.add(SizedBox(height: 16.h));
    }
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _kSectionExpandBg,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 25.h, 24.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      ),
    );
  }

  Widget _countItem(String icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('$_kAssetsDir/$icon', width: 16.r, height: 16.r),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: _kCountText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.index, required this.question});

  final int index;
  final AssessmentQuestion question;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      padding: EdgeInsets.all(17.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _kNumberBadgeBg,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: _kNumberBadgeFg,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: -0.32,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 8.h,
                  children: [
                    _option(l10n.answerYes, question.answer == QuestionAnswer.yes),
                    _option(l10n.answerPartial, question.answer == QuestionAnswer.partial),
                    _option(l10n.answerNo, question.answer == QuestionAnswer.no),
                    _option(l10n.answerNa, question.answer == QuestionAnswer.na),
                  ],
                ),
                SizedBox(height: 12.h),
                _evidence(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _option(String label, bool selected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.r,
          height: 16.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? _kRadioSelected : _kRadioBorder,
            ),
          ),
          child: selected
              ? Container(
                  width: 9.6.r,
                  height: 9.6.r,
                  decoration: const BoxDecoration(
                    color: _kRadioSelected,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: _kCountText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }

  Widget _evidence(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kEvidenceBg,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: _kEvidenceBorder),
      ),
      padding: EdgeInsets.all(13.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SvgPicture.asset(
              '$_kAssetsDir/evidence_icon.svg',
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(_kEvidenceLabel, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.evidenceLabel,
                  style: TextStyle(
                    color: _kEvidenceLabel,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  question.evidence,
                  style: TextStyle(
                    color: _kEvidenceText,
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
    );
  }
}

// ---------------------------------------------------------------------------
// Remediation
// ---------------------------------------------------------------------------

class _RemediationCard extends StatelessWidget {
  const _RemediationCard({required this.detail});

  final FrameworkDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _cardBox(
      padding: EdgeInsets.all(AssessmentPageLayout.cardPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.remediationActionItems,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 28 / 18,
                        letterSpacing: -0.45,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n.openCompletedSummary(
                        detail.remediationItems.length,
                        detail.completedItems,
                      ),
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
              AppButton.primary(
                label: l10n.addAction,
                iconAsset: '$_kAssetsDir/plus.svg',
                iconSize: 16.r,
                size: AppButtonSize.sm,
                onPressed: () => showAddActionDialog(
                  context: context,
                  sections: detail.sections.map((s) => s.title).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < detail.remediationItems.length; i++) ...[
            _RemediationItemCard(item: detail.remediationItems[i]),
            if (i != detail.remediationItems.length - 1) SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

class _RemediationItemCard extends StatelessWidget {
  const _RemediationItemCard({required this.item});

  final RemediationItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isHigh = item.priority == RemediationPriority.high;

    final bg = isHigh ? _kRedBg : _kAmberBg;
    final border = isHigh ? _kRedBorder : _kAmberBorder;
    final titleColor = isHigh ? _kRedTitle : _kAmberTitle;
    final bodyColor = isHigh ? _kRedBody : _kAmberBody;
    final accentIcon = isHigh ? _kRedBody : _kAmberIcon;
    final metaIcon = isHigh ? _kRedBody : _kAmberBody;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SvgPicture.asset(
              '$_kAssetsDir/alert_circle.svg',
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(accentIcon, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                              letterSpacing: -0.32,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.description,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              letterSpacing: -0.154,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _priorityBadge(l10n),
                    SizedBox(width: 8.w),
                    _statusBadge(l10n),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 16.w,
                        runSpacing: 4.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                '$_kAssetsDir/calendar.svg',
                                width: 12.r,
                                height: 12.r,
                                colorFilter: ColorFilter.mode(metaIcon, BlendMode.srcIn),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                l10n.dueDate(item.due),
                                style: _metaStyle(metaIcon),
                              ),
                            ],
                          ),
                          Text(l10n.ownerName(item.owner), style: _metaStyle(metaIcon)),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _iconButton('action_edit.svg', metaIcon),
                    SizedBox(width: 4.w),
                    _iconButton('action_delete.svg', metaIcon),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _metaStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    );
  }

  Widget _priorityBadge(AppLocalizations l10n) {
    final isHigh = item.priority == RemediationPriority.high;
    final bg = isHigh ? _kPriorityHighBg : _kPriorityMediumBg;
    final fg = isHigh ? _kPriorityHighFg : _kPriorityMediumFg;
    final label = isHigh ? l10n.priorityHigh : l10n.priorityMedium;
    return _badge(bg, fg, label);
  }

  Widget _statusBadge(AppLocalizations l10n) {
    final isOpen = item.status == RemediationStatus.open;
    final bg = isOpen ? _kStatusOpenBg : _kStatusInProgressBg;
    final fg = isOpen ? _kStatusOpenFg : _kStatusInProgressFg;
    final label = isOpen ? l10n.remediationStatusOpen : l10n.remediationStatusInProgress;
    return _badge(bg, fg, label);
  }

  Widget _badge(Color bg, Color fg, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _iconButton(String icon, Color color) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(4.r),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(4.r),
          child: SvgPicture.asset(
            '$_kAssetsDir/$icon',
            width: 16.r,
            height: 16.r,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared
// ---------------------------------------------------------------------------

Widget _cardBox({required EdgeInsetsGeometry padding, required Widget child}) {
  return Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );
}
