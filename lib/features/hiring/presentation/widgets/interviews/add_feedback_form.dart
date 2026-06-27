import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/interviews/utils/interview_feedback_utils.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddFeedbackFormState {
  int overallRating = 0;
  String? technicalSkills;
  String? communication;
  String? cultureFit;
  String? recommendation;
  final commentsController = TextEditingController();

  bool get canSubmit => overallRating > 0 && recommendation != null;

  void dispose() => commentsController.dispose();
}

class AddFeedbackFormContent extends StatelessWidget {
  const AddFeedbackFormContent({super.key, required this.interview, required this.form, required this.onChanged});

  final Interview interview;
  final AddFeedbackFormState form;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : AppColors.sidebarSearchBg,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.interviewDetails,
                style: context.textTheme.bodyMedium?.copyWith(color: context.themeTextSecondary),
              ),
              Gap(4.h),
              Text(
                interview.candidateName,
                style: context.textTheme.titleSmall?.copyWith(fontSize: 16.sp, color: context.themeTextPrimary),
              ),
              Text(
                '${interview.position} • ${interview.roundInfo}',
                style: context.textTheme.bodyMedium?.copyWith(color: context.themeTextSecondary),
              ),
            ],
          ),
        ),
        Gap(24.h),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${loc.overallRating} ',
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                ),
              ),
              TextSpan(
                text: '*',
                style: context.textTheme.titleSmall?.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
        Gap(8.h),
        Row(
          children: List.generate(5, (index) {
            final rating = index + 1;
            return Padding(
              padding: EdgeInsetsDirectional.only(end: 8.w),
              child: InkWell(
                onTap: () {
                  form.overallRating = rating;
                  onChanged();
                },
                child: Icon(
                  rating <= form.overallRating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: rating <= form.overallRating ? AppColors.dashCompensation : AppColors.textMuted,
                  size: 32.sp,
                ),
              ),
            );
          }),
        ),
        Gap(24.h),
        DigifySelectFieldWithLabel<String>(
          label: loc.technicalSkills,
          items: interviewFeedbackSkillRatingCodes,
          value: form.technicalSkills,
          itemLabelBuilder: (item) => interviewFeedbackSkillRatingLabel(loc, item),
          hint: loc.select,
          onChanged: (value) {
            form.technicalSkills = value;
            onChanged();
          },
        ),
        Gap(16.h),
        DigifySelectFieldWithLabel<String>(
          label: loc.communication,
          items: interviewFeedbackSkillRatingCodes,
          value: form.communication,
          itemLabelBuilder: (item) => interviewFeedbackSkillRatingLabel(loc, item),
          hint: loc.select,
          onChanged: (value) {
            form.communication = value;
            onChanged();
          },
        ),
        Gap(16.h),
        DigifySelectFieldWithLabel<String>(
          label: loc.cultureFit,
          items: interviewFeedbackSkillRatingCodes,
          value: form.cultureFit,
          itemLabelBuilder: (item) => interviewFeedbackSkillRatingLabel(loc, item),
          hint: loc.select,
          onChanged: (value) {
            form.cultureFit = value;
            onChanged();
          },
        ),
        Gap(24.h),
        DigifySelectFieldWithLabel<String>(
          label: loc.recommendation,
          isRequired: true,
          items: interviewFeedbackRecommendationCodes,
          value: form.recommendation,
          itemLabelBuilder: (item) => interviewFeedbackRecommendationLabel(loc, item),
          hint: loc.selectRecommendation,
          onChanged: (value) {
            form.recommendation = value;
            onChanged();
          },
        ),
        Gap(24.h),
        DigifyTextArea(
          labelText: loc.detailedComments,
          hintText: loc.feedbackCommentsHint,
          controller: form.commentsController,
          maxLines: 4,
        ),
      ],
    );
  }
}
