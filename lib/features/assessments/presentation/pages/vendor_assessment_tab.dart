import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/features/assessments/presentation/widgets/assessment_page_layout.dart';

const _kPrimary = Color(0xFF155DFC);
const _kGreen = Color(0xFF00A63E);
const _kAmber = Color(0xFFD08700);
const _kRed = Color(0xFFE7000B);
const _kSubLabel = Color(0xFF6A7282);
const _kPanelBg = Color(0xFFF9FAFB);
const _kTrack = Color(0xFFE5E7EB);
const _kRadioBlue = Color(0xFF0075FF);
const _kRadioBorder = Color(0xFF767676);

enum _VendorAnswer { yes, partial, no, na }

enum _QuestionSeverity { critical, high, medium }

class VendorAssessmentTab extends StatelessWidget {
  const VendorAssessmentTab({super.key});

  static const _categories = <_VendorCategory>[
    _VendorCategory(
      title: 'Security Controls',
      score: 75,
      questions: [
        _VendorQuestion(
          number: 1,
          text: 'Does vendor have ISO 27001 certification?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 2,
          text: 'Are penetration tests conducted annually?',
          severity: _QuestionSeverity.high,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 3,
          text: 'Is multi-factor authentication enforced?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 4,
          text: 'Are security incidents disclosed within 24 hours?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.partial,
        ),
      ],
    ),
    _VendorCategory(
      title: 'Data Protection',
      score: 100,
      questions: [
        _VendorQuestion(
          number: 1,
          text: 'Is data encrypted at rest and in transit?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 2,
          text: 'Are data backups tested quarterly?',
          severity: _QuestionSeverity.high,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 3,
          text: 'Is there a data retention policy?',
          severity: _QuestionSeverity.medium,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 4,
          text: 'Can data be deleted on request?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.yes,
        ),
      ],
    ),
    _VendorCategory(
      title: 'Compliance & Governance',
      score: 75,
      questions: [
        _VendorQuestion(
          number: 1,
          text: 'Does vendor comply with GDPR requirements?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 2,
          text: 'Are SOC 2 Type II reports available?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 3,
          text: 'Is there a business continuity plan?',
          severity: _QuestionSeverity.high,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 4,
          text: 'Are third-party audits conducted?',
          severity: _QuestionSeverity.high,
          answer: _VendorAnswer.partial,
        ),
      ],
    ),
    _VendorCategory(
      title: 'Operational Risk',
      score: 75,
      questions: [
        _VendorQuestion(
          number: 1,
          text: 'Is there 24/7 support coverage?',
          severity: _QuestionSeverity.high,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 2,
          text: 'Are SLAs contractually defined?',
          severity: _QuestionSeverity.critical,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 3,
          text: 'Is there financial stability (audited)?',
          severity: _QuestionSeverity.high,
          answer: _VendorAnswer.yes,
        ),
        _VendorQuestion(
          number: 4,
          text: 'Are change management procedures documented?',
          severity: _QuestionSeverity.medium,
          answer: _VendorAnswer.partial,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final gap = AssessmentPageLayout.sectionGap(context);
    final cardGap = AssessmentPageLayout.cardGap(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _VendorStatsRow(),
        SizedBox(height: gap),
        for (int i = 0; i < _categories.length; i++) ...[
          _VendorCategoryCard(category: _categories[i]),
          if (i != _categories.length - 1) SizedBox(height: cardGap),
        ],
      ],
    );
  }
}

class _VendorStatsRow extends StatelessWidget {
  const _VendorStatsRow();

  @override
  Widget build(BuildContext context) {
    return AssessmentPageLayout.statsRow(
      context,
      const [
        _VendorStatCard(
          value: '81%',
          label: 'Vendor Risk Score',
          progressPercent: 81,
        ),
        _VendorStatCard(
          value: '13',
          valueColor: _kGreen,
          label: 'Compliant Controls',
          sublabel: 'Out of 16',
        ),
        _VendorStatCard(
          value: '3',
          valueColor: _kAmber,
          label: 'Partial Compliance',
          sublabel: 'Needs review',
        ),
        _VendorStatCard(
          value: '0',
          valueColor: _kRed,
          label: 'Non-Compliant',
          sublabel: 'Critical gaps',
        ),
      ],
    );
  }
}

class _VendorStatCard extends StatelessWidget {
  const _VendorStatCard({
    required this.value,
    required this.label,
    this.sublabel,
    this.progressPercent,
    this.valueColor = AppColors.textPrimary,
  });

  final String value;
  final String label;
  final String? sublabel;
  final int? progressPercent;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final padding = AssessmentPageLayout.cardPadding(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        padding,
        padding,
        padding,
        progressPercent != null ? padding + 4.h : padding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
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
          Padding(
            padding: EdgeInsets.only(bottom: progressPercent != null ? 8.h : 0),
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
          if (progressPercent != null)
            _VendorProgressBar(percent: progressPercent!, color: _kPrimary),
          if (sublabel != null) ...[
            SizedBox(height: 4.h),
            Text(
              sublabel!,
              style: TextStyle(
                color: _kSubLabel,
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

class _VendorCategoryCard extends StatelessWidget {
  const _VendorCategoryCard({required this.category});

  final _VendorCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AssessmentPageLayout.cardPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    category.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      height: 28 / 18,
                      letterSpacing: -0.45,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${category.score}%',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      height: 28 / 20,
                      letterSpacing: -0.46,
                    ),
                  ),
                  Text(
                    'Score',
                    style: TextStyle(
                      color: _kSubLabel,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          for (int i = 0; i < category.questions.length; i++) ...[
            _VendorQuestionRow(question: category.questions[i]),
            if (i != category.questions.length - 1) SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

class _VendorQuestionRow extends StatelessWidget {
  const _VendorQuestionRow({required this.question});

  final _VendorQuestion question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _kPanelBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${question.number}',
              style: TextStyle(
                color: _kPrimary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
              ),
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
                      child: Text(
                        question.text,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _SeverityBadge(severity: question.severity),
                  ],
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 8.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _AnswerOption(label: 'Yes', selected: question.answer == _VendorAnswer.yes),
                    _AnswerOption(label: 'Partial', selected: question.answer == _VendorAnswer.partial),
                    _AnswerOption(label: 'No', selected: question.answer == _VendorAnswer.no),
                    _AnswerOption(label: 'N/A', selected: question.answer == _VendorAnswer.na),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity});

  final _QuestionSeverity severity;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (severity) {
      _QuestionSeverity.critical => (AppColors.statusCriticalBg, AppColors.statusCriticalFg, 'Critical'),
      _QuestionSeverity.high => (AppColors.statusHighBg, AppColors.statusHighFg, 'High'),
      _QuestionSeverity.medium => (AppColors.statusMediumBg, AppColors.statusMediumFg, 'Medium'),
    };

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
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20.r,
          height: 20.r,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: selected ? _kRadioBlue : _kRadioBorder),
          ),
          child: selected
              ? Container(
                  decoration: const BoxDecoration(
                    color: _kRadioBlue,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textLabel,
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

class _VendorProgressBar extends StatelessWidget {
  const _VendorProgressBar({required this.percent, required this.color});

  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        width: double.infinity,
        height: 8.h,
        color: _kTrack,
        child: FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: (percent / 100).clamp(0.0, 1.0),
          child: Container(color: color),
        ),
      ),
    );
  }
}

class _VendorCategory {
  const _VendorCategory({
    required this.title,
    required this.score,
    required this.questions,
  });

  final String title;
  final int score;
  final List<_VendorQuestion> questions;
}

class _VendorQuestion {
  const _VendorQuestion({
    required this.number,
    required this.text,
    required this.severity,
    required this.answer,
  });

  final int number;
  final String text;
  final _QuestionSeverity severity;
  final _VendorAnswer answer;
}
