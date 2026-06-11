import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/router/nav_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/features/assessments/presentation/widgets/assessment_page_layout.dart';
import 'package:grc_web/features/library/presentation/widgets/edit_question_dialog.dart';

const _kAssetsDir = 'assets/figma/assessments/svg';

// ─── Colors not in AppColors ─────────────────────────────────────────────────
const _kWeightBadgeBg = Color(0xFFF3E8FF);
const _kWeightBadgeFg = Color(0xFF6E11B0);
const _kCodeColor = Color(0xFF6A7282);
const _kCircleStroke = Color(0xFF99A1AF);

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

enum _ResponseKind { yesNo, maturity, select }

class _QData {
  const _QData({
    required this.code,
    required this.question,
    required this.weight,
    this.evidenceRequired = true,
    this.description,
    this.evidenceHint,
    this.kind = _ResponseKind.yesNo,
    this.options = const [],
  });

  final String code;
  final String question;
  final int weight;
  final bool evidenceRequired;
  final String? description;
  final String? evidenceHint;
  final _ResponseKind kind;
  final List<String> options;

  bool get hasEvidence => kind != _ResponseKind.maturity && kind != _ResponseKind.select;

  /// Score percentage (0–100) for the selected option [index].
  int score(int index) {
    switch (kind) {
      case _ResponseKind.yesNo:
        return const [80, 40, 0, 0][index];
      case _ResponseKind.maturity:
        return (index + 1) * 20;
      case _ResponseKind.select:
        return options.isEmpty ? 0 : (((index + 1) * 100) / options.length).round();
    }
  }
}

class _CategoryData {
  const _CategoryData({
    required this.title,
    required this.description,
    required this.weightPercent,
    required this.questions,
  });

  final String title;
  final String description;
  final int weightPercent;
  final List<_QData> questions;
}

const _kCategories = <_CategoryData>[
  _CategoryData(
    title: 'Section 302 - Corporate Responsibility',
    description:
        'CEO/CFO certification of financial reports and internal controls',
    weightPercent: 25,
    questions: [
      _QData(
        code: 'sox-302-001',
        question:
            'Are financial reports reviewed and certified by CEO and CFO before filing?',
        description:
            'Quarterly and annual reports must be certified by principal officers',
        evidenceHint:
            'Review certification documents for last 4 quarters. Verify signatures and dates.',
        weight: 10,
      ),
      _QData(
        code: 'sox-302-002',
        question:
            'Are internal controls assessed for effectiveness on a quarterly basis?',
        weight: 9,
      ),
      _QData(
        code: 'sox-302-003',
        question:
            'Is there a documented process for disclosure of material changes in internal controls?',
        weight: 8,
      ),
      _QData(
        code: 'sox-302-004',
        question: 'What is the maturity level of your disclosure control process?',
        weight: 7,
        evidenceRequired: false,
        kind: _ResponseKind.maturity,
      ),
    ],
  ),
  _CategoryData(
    title: 'Section 404 - Management Assessment',
    description: 'Assessment of internal control over financial reporting (ICFR)',
    weightPercent: 25,
    questions: [
      _QData(
        code: 'sox-404-001',
        question:
            'Is there a documented and comprehensive internal control framework (e.g., COSO)?',
        evidenceHint:
            'Review internal control framework documentation. Common frameworks: COSO, COBIT.',
        weight: 10,
      ),
      _QData(
        code: 'sox-404-002',
        question: 'Are controls tested annually by external auditors?',
        weight: 10,
      ),
      _QData(
        code: 'sox-404-003',
        question:
            'Are IT General Controls (ITGC) documented, implemented, and tested?',
        weight: 9,
      ),
      _QData(
        code: 'sox-404-004',
        question: 'Is there a remediation plan for identified control deficiencies?',
        weight: 8,
      ),
      _QData(
        code: 'sox-404-005',
        question: 'How frequently are key financial controls tested?',
        weight: 7,
        evidenceRequired: false,
        kind: _ResponseKind.select,
        options: [
          'Continuous',
          'Daily',
          'Weekly',
          'Monthly',
          'Quarterly',
          'Annually',
        ],
      ),
    ],
  ),
  _CategoryData(
    title: 'Section 409 - Real-Time Disclosure',
    description: 'Timely disclosure of material changes in financial condition',
    weightPercent: 25,
    questions: [
      _QData(
        code: 'sox-409-001',
        question: 'Are material events disclosed within required timeframes?',
        weight: 10,
      ),
      _QData(
        code: 'sox-409-002',
        question: 'Is there a process to identify reportable material changes?',
        weight: 9,
      ),
    ],
  ),
];

const _kMaturityLabels = ['initial', 'developing', 'defined', 'managed', 'optimizing'];

int _roundDiv(int numerator, int denominator) =>
    denominator == 0 ? 0 : (numerator / denominator).round();

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class AssessmentQuestionnairePage extends StatefulWidget {
  const AssessmentQuestionnairePage({super.key});

  @override
  State<AssessmentQuestionnairePage> createState() =>
      _AssessmentQuestionnairePageState();
}

class _AssessmentQuestionnairePageState
    extends State<AssessmentQuestionnairePage> {
  int _selected = 0;

  /// question code -> selected option index.
  final Map<String, int> _responses = {};

  void _goTo(int index) {
    final next = index.clamp(0, _kCategories.length - 1);
    if (next != _selected) setState(() => _selected = next);
  }

  void _answer(String code, int index) => setState(() => _responses[code] = index);

  int _categoryAnswered(_CategoryData c) =>
      c.questions.where((q) => _responses.containsKey(q.code)).length;

  int _categoryPercent(_CategoryData c) {
    var num = 0;
    var den = 0;
    for (final q in c.questions) {
      den += q.weight;
      final idx = _responses[q.code];
      if (idx != null) num += q.score(idx) * q.weight;
    }
    return _roundDiv(num, den);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final category = _kCategories[_selected];

    final totalQuestions =
        _kCategories.fold<int>(0, (sum, c) => sum + c.questions.length);
    final answeredCount = _responses.length;

    var scoreNum = 0;
    var scoreDen = 0;
    for (final c in _kCategories) {
      for (final q in c.questions) {
        scoreDen += q.weight;
        final idx = _responses[q.code];
        if (idx != null) scoreNum += q.score(idx) * q.weight;
      }
    }
    final overallScore = _roundDiv(scoreNum, scoreDen);
    final sectionGap = AssessmentPageLayout.sectionGap(context);

    return SingleChildScrollView(
      padding: AssessmentPageLayout.pagePadding(context),
      child: ConstrainedBox(
        constraints: AssessmentPageLayout.contentConstraints(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(l10n: l10n),
            SizedBox(height: sectionGap),
            _StatsRow(
              l10n: l10n,
              answered: answeredCount,
              total: totalQuestions,
              overallScore: overallScore,
              categories: _kCategories.length,
            ),
            SizedBox(height: sectionGap),
            _CategoryProgress(
              l10n: l10n,
              categories: _kCategories,
              selected: _selected,
              answeredOf: _categoryAnswered,
              percentOf: _categoryPercent,
              onSelect: _goTo,
            ),
            SizedBox(height: sectionGap),
            _SectionCard(
              l10n: l10n,
              category: category,
              responses: _responses,
              onAnswer: _answer,
            ),
            SizedBox(height: sectionGap),
            _Footer(
              l10n: l10n,
              current: _selected,
              total: _kCategories.length,
              onPrev: () => _goTo(_selected - 1),
              onNext: () => _goTo(_selected + 1),
            ),
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
    final layout = context.screenLayout;

    return AssessmentPageLayout.detailTitleBar(
      context: context,
      backButton: AppButton.back(
        iconAsset: '$_kAssetsDir/back_arrow.svg',
        onPressed: () => context.deferGo(AppRoutes.assessmentHub),
      ),
      titleSection: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SOX Compliance Question Library',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AssessmentPageLayout.titleFontSize(context),
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Comprehensive framework assessment',
            style: TextStyle(
              color: AppColors.textBody,
              fontSize: AssessmentPageLayout.subtitleFontSize(context),
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
        ],
      ),
      trailing: layout.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton.outline(
                  label: l10n.addQuestion,
                  iconAsset: '$_kAssetsDir/plus.svg',
                  iconColor: AppColors.textDark,
                  iconSize: 16.r,
                  fullWidth: true,
                  onPressed: () => showAddQuestionDialog(context: context),
                ),
                SizedBox(height: 8.h),
                AppButton.outline(
                  label: l10n.qlibSaveDraft,
                  iconAsset: '$_kAssetsDir/ql_save.svg',
                  iconColor: AppColors.textDark,
                  iconSize: 16.r,
                  fullWidth: true,
                  onPressed: () {},
                ),
                SizedBox(height: 8.h),
                AppButton.primary(
                  label: l10n.qlibSubmit,
                  iconAsset: '$_kAssetsDir/ql_send.svg',
                  iconSize: 16.r,
                  fullWidth: true,
                  onPressed: () {},
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton.outline(
                  label: l10n.addQuestion,
                  iconAsset: '$_kAssetsDir/plus.svg',
                  iconColor: AppColors.textDark,
                  iconSize: 16.r,
                  onPressed: () => showAddQuestionDialog(context: context),
                ),
                SizedBox(width: 8.w),
                AppButton.outline(
                  label: l10n.qlibSaveDraft,
                  iconAsset: '$_kAssetsDir/ql_save.svg',
                  iconColor: AppColors.textDark,
                  iconSize: 16.r,
                  onPressed: () {},
                ),
                SizedBox(width: 8.w),
                AppButton.primary(
                  label: l10n.qlibSubmit,
                  iconAsset: '$_kAssetsDir/ql_send.svg',
                  iconSize: 16.r,
                  onPressed: () {},
                ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stats row
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.l10n,
    required this.answered,
    required this.total,
    required this.overallScore,
    required this.categories,
  });

  final AppLocalizations l10n;
  final int answered;
  final int total;
  final int overallScore;
  final int categories;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : answered / total;
    final cards = <Widget>[
      _StatCard(
        icon: 'ql_answered.svg',
        value: '$answered/$total',
        label: l10n.qlibQuestionsAnswered,
        footer: _ProgressBar(fraction: fraction),
      ),
      _StatCard(
        icon: 'ql_score.svg',
        value: '$overallScore%',
        label: l10n.qlibOverallScore,
        footer: _Pill(
          text: l10n.qlibNeedsImprovement,
          bg: AppColors.statusCriticalBg,
          fg: AppColors.statusCriticalFg,
        ),
      ),
      _StatCard(
        icon: 'ql_evidence.svg',
        value: '0',
        label: l10n.qlibEvidenceAttached,
      ),
      _StatCard(
        icon: 'ql_findings.svg',
        value: '0',
        label: l10n.qlibFindings,
      ),
      _StatCard(
        icon: 'ql_trending.svg',
        value: '$categories',
        label: l10n.qlibCategories,
      ),
    ];

    return AssessmentPageLayout.statsRow(context, cards);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.footer,
  });

  final String icon;
  final String value;
  final String label;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            '$_kAssetsDir/$icon',
            width: 20.r,
            height: 20.r,
            colorFilter:
                const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
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
          SizedBox(height: 8.h),
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
          if (footer != null) ...[
            SizedBox(height: 8.h),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: Stack(
        children: [
          Container(width: double.infinity, height: 6.h, color: AppColors.border),
          FractionallySizedBox(
            widthFactor: fraction.clamp(0.0, 1.0),
            child: Container(height: 6.h, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.bg, required this.fg});

  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
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
    );
  }
}

// ---------------------------------------------------------------------------
// Category progress
// ---------------------------------------------------------------------------

class _CategoryProgress extends StatelessWidget {
  const _CategoryProgress({
    required this.l10n,
    required this.categories,
    required this.selected,
    required this.answeredOf,
    required this.percentOf,
    required this.onSelect,
  });

  final AppLocalizations l10n;
  final List<_CategoryData> categories;
  final int selected;
  final int Function(_CategoryData) answeredOf;
  final int Function(_CategoryData) percentOf;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final cardPadding = AssessmentPageLayout.cardPadding(context);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.qlibCategoryProgress,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          AssessmentPageLayout.twoColumnGrid(
            context,
            children: [
              for (var i = 0; i < categories.length; i++)
                _CategoryCard(
                  l10n: l10n,
                  data: categories[i],
                  selected: i == selected,
                  answered: answeredOf(categories[i]),
                  percent: percentOf(categories[i]),
                  onTap: () => onSelect(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.l10n,
    required this.data,
    required this.selected,
    required this.answered,
    required this.percent,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final _CategoryData data;
  final bool selected;
  final int answered;
  final int percent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inProgress = answered > 0;
    return Material(
      color: selected ? AppColors.primaryLightBg : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 20 / 14,
                        letterSpacing: -0.154,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  if (inProgress)
                    Container(
                      width: 20.r,
                      height: 20.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    SvgPicture.asset(
                      '$_kAssetsDir/ql_circle.svg',
                      width: 20.r,
                      height: 20.r,
                      colorFilter: const ColorFilter.mode(
                          _kCircleStroke, BlendMode.srcIn),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.qlibAnswered(answered, data.questions.length),
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(child: _ProgressBar(fraction: percent / 100)),
                  SizedBox(width: 8.w),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section card (questions)
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.l10n,
    required this.category,
    required this.responses,
    required this.onAnswer,
  });

  final AppLocalizations l10n;
  final _CategoryData category;
  final Map<String, int> responses;
  final void Function(String code, int index) onAnswer;

  @override
  Widget build(BuildContext context) {
    final cardPadding = AssessmentPageLayout.cardPadding(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          height: 28 / 20,
                          letterSpacing: -0.46,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        category.description,
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
                _Pill(
                  text: l10n.weightValue(category.weightPercent),
                  bg: _kWeightBadgeBg,
                  fg: _kWeightBadgeFg,
                ),
              ],
            ),
          ),
          for (var i = 0; i < category.questions.length; i++)
            Container(
              decoration: BoxDecoration(
                border: i == category.questions.length - 1
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AppColors.border)),
              ),
              padding: EdgeInsets.all(cardPadding),
              child: _QuestionCard(
                l10n: l10n,
                index: i + 1,
                data: category.questions[i],
                selectedIndex: responses[category.questions[i].code],
                onSelect: (idx) => onAnswer(category.questions[i].code, idx),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.l10n,
    required this.index,
    required this.data,
    required this.selectedIndex,
    required this.onSelect,
  });

  final AppLocalizations l10n;
  final int index;
  final _QData data;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  bool get _answered => selectedIndex != null;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: const BoxDecoration(
            color: AppColors.chipNeutralBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              color: AppColors.textLabel,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 4.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              data.code,
                              style: TextStyle(
                                color: _kCodeColor,
                                fontSize: 12.sp,
                                fontFamily: 'monospace',
                                height: 16 / 12,
                              ),
                            ),
                            if (data.evidenceRequired)
                              _SmallBadge(
                                text: l10n.evidenceRequired,
                                bg: AppColors.statusHighBg,
                                fg: AppColors.statusHighFg,
                              ),
                            if (_answered)
                              _SmallBadge(
                                text: l10n.qlibAnsweredBadge,
                                bg: AppColors.statusLowBg,
                                fg: AppColors.statusLowFg,
                                icon: 'check_circle.svg',
                              ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data.question,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 24 / 16,
                            letterSpacing: -0.32,
                          ),
                        ),
                        if (data.description != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            data.description!,
                            style: TextStyle(
                              color: AppColors.textBody,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              letterSpacing: -0.154,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.qlibQuestionWeight(data.weight),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 20 / 14,
                            letterSpacing: -0.154,
                          ),
                        ),
                        if (_answered) ...[
                          SizedBox(height: 4.h),
                          Text(
                            l10n.qlibScore(data.score(selectedIndex!)),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.textBody,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 16 / 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (data.evidenceHint != null) ...[
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    data.evidenceHint!,
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 16.h),
              _label(l10n.qlibResponse),
              SizedBox(height: 8.h),
              _responseField(context),
              if (data.hasEvidence) ...[
                SizedBox(height: 16.h),
                _evidenceLabel(l10n),
                SizedBox(height: 8.h),
                AppTextArea(hint: l10n.qlibEvidencePlaceholder, minLines: 1, maxLines: 4),
                SizedBox(height: 6.h),
              ],
              SizedBox(height: data.hasEvidence ? 10.h : 16.h),
              _label(l10n.qlibNotesOptional),
              SizedBox(height: 8.h),
              AppTextArea(hint: l10n.qlibNotesPlaceholder, minLines: 1, maxLines: 4),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _responseField(BuildContext context) {
    final layout = context.screenLayout;

    switch (data.kind) {
      case _ResponseKind.yesNo:
        final options = [
          l10n.answerYes,
          l10n.answerPartial,
          l10n.answerNo,
          l10n.answerNa,
        ];
        final buttons = [
          for (var i = 0; i < options.length; i++)
            _ResponseButton(
              label: options[i],
              selected: selectedIndex == i,
              onTap: () => onSelect(i),
              fullWidth: layout.isMobile,
            ),
        ];
        if (layout.isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < buttons.length; i++) ...[
                buttons[i],
                if (i != buttons.length - 1) SizedBox(height: 8.h),
              ],
            ],
          );
        }
        return Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: buttons,
        );
      case _ResponseKind.maturity:
        final maturityButtons = [
          for (var i = 0; i < _kMaturityLabels.length; i++)
            _MaturityButton(
              number: i + 1,
              label: _kMaturityLabels[i],
              selected: selectedIndex == i,
              onTap: () => onSelect(i),
            ),
        ];
        if (layout.isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < maturityButtons.length; i++) ...[
                maturityButtons[i],
                if (i != maturityButtons.length - 1) SizedBox(height: 8.h),
              ],
            ],
          );
        }
        if (layout.isCompact) {
          return Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: maturityButtons,
          );
        }
        return Row(
          children: [
            for (var i = 0; i < maturityButtons.length; i++) ...[
              Expanded(child: maturityButtons[i]),
              if (i != maturityButtons.length - 1) SizedBox(width: 8.w),
            ],
          ],
        );
      case _ResponseKind.select:
        return _SelectField(
          hint: l10n.qlibSelectOption,
          options: data.options,
          value: selectedIndex,
          onChanged: onSelect,
        );
    }
  }

  Widget _label(String text) {
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

  Widget _evidenceLabel(AppLocalizations l10n) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${l10n.evidenceLabel} '),
          TextSpan(
            text: '*',
            style: const TextStyle(color: AppColors.deletePrimary),
          ),
        ],
        style: TextStyle(
          color: AppColors.textLabel,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          height: 20 / 14,
          letterSpacing: -0.154,
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
    required this.text,
    required this.bg,
    required this.fg,
    this.icon,
  });

  final String text;
  final Color bg;
  final Color fg;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            SvgPicture.asset(
              '$_kAssetsDir/$icon',
              width: 12.r,
              height: 12.r,
              colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            text,
            style: TextStyle(
              color: fg,
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

class _ResponseButton extends StatelessWidget {
  const _ResponseButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.fullWidth = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLightBg : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: fullWidth ? double.infinity : null,
          alignment: fullWidth ? Alignment.center : null,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderInput,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primary : AppColors.textLabel,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              letterSpacing: -0.32,
            ),
          ),
        ),
      ),
    );
  }
}

class _MaturityButton extends StatelessWidget {
  const _MaturityButton({
    required this.number,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final int number;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLightBg : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderInput,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$number',
                style: TextStyle(
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 16 / 12,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.hint,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String hint;
  final List<String> options;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderInput),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: value,
          icon: Icon(Icons.expand_more, size: 18.r, color: AppColors.textDark),
          padding: EdgeInsets.symmetric(vertical: 9.h),
          borderRadius: BorderRadius.circular(10.r),
          hint: Text(
            hint,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16.sp,
              letterSpacing: -0.32,
            ),
          ),
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16.sp,
            letterSpacing: -0.32,
          ),
          items: [
            for (var i = 0; i < options.length; i++)
              DropdownMenuItem<int>(value: i, child: Text(options[i])),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

class _Footer extends StatelessWidget {
  const _Footer({
    required this.l10n,
    required this.current,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  final AppLocalizations l10n;
  final int current;
  final int total;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isFirst = current == 0;
    final isLast = current == total - 1;
    final isMobile = context.screenLayout.isMobile;

    final prevButton = Opacity(
      opacity: isFirst ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: isFirst ? null : onPrev,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: isMobile ? double.infinity : null,
            alignment: isMobile ? Alignment.center : null,
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 9.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderInput),
            ),
            child: Text(
              l10n.qlibPreviousCategory,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                letterSpacing: -0.32,
              ),
            ),
          ),
        ),
      ),
    );

    final categoryLabel = Text(
      l10n.qlibCategoryOf(current + 1, total),
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        color: AppColors.textBody,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: -0.154,
      ),
    );

    final nextButton = Opacity(
      opacity: isLast ? 0.5 : 1,
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: isLast ? null : onNext,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: isMobile ? double.infinity : null,
            alignment: isMobile ? Alignment.center : null,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              l10n.qlibNextCategory,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                letterSpacing: -0.32,
              ),
            ),
          ),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          prevButton,
          SizedBox(height: 12.h),
          categoryLabel,
          SizedBox(height: 12.h),
          nextButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [prevButton, categoryLabel, nextButton],
    );
  }
}
