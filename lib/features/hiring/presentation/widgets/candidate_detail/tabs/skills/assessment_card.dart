import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/overview/edit_assessment_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AssessmentCard extends StatelessWidget {
  const AssessmentCard({
    super.key,
    required this.assessment,
    required this.isDark,
    required this.candidate,
    this.isDeleting = false,
    this.onDelete,
  });

  final CandidateAssessmentData assessment;
  final bool isDark;
  final CandidateData candidate;
  final bool isDeleting;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    final scorePercentage = assessment.score / assessment.maxScore;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assessment.title,
                      style: context.textTheme.titleMedium?.copyWith(color: textPrimary, fontSize: 15.sp),
                    ),
                    Gap(4.h),
                    Text(assessment.category, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${assessment.score}',
                          style: context.textTheme.titleLarge?.copyWith(color: textPrimary, fontSize: 24.sp),
                        ),
                        TextSpan(
                          text: ' / ${assessment.maxScore}',
                          style: context.textTheme.bodyLarge?.copyWith(color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.h),
                  Container(
                    width: 128.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.grayBgDark : AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: scorePercentage,
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(100.r)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(16.h),
          Row(
            children: [
              Text('Date: ${assessment.date}', style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
              if (assessment.durationMinutes != null) ...[
                Gap(8.w),
                DigifyStatusDot(color: textSecondary, size: 4),
                Gap(8.w),
                Text(
                  'Duration: ${assessment.durationMinutes} mins',
                  style: context.textTheme.bodyMedium?.copyWith(color: textSecondary),
                ),
              ],
            ],
          ),
          Gap(4.h),
          Text(
            'Evaluator: ${assessment.evaluator}',
            style: context.textTheme.bodyMedium?.copyWith(color: textSecondary),
          ),
          Gap(8.h),
          Text(
            '"${assessment.feedback}"',
            style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontStyle: FontStyle.italic),
          ),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ActionButtonWidget(
                type: ActionButtonType.edit,
                onTap: () => EditAssessmentDialog.show(context, candidate: candidate, assessment: assessment),
                width: 18.w,
                height: 18.w,
                padding: 6.w,
                borderRadius: BorderRadius.circular(6.r),
                customBorder: null,
              ),
              if (onDelete != null) ...[
                Gap(8.w),
                ActionButtonWidget(
                  type: ActionButtonType.delete,
                  isLoading: isDeleting,
                  onTap: () async {
                    if (isDeleting) return;
                    final confirmed = await AppConfirmationDialog.show(
                      context,
                      title: 'Delete Assessment',
                      message: 'Are you sure you want to delete this assessment?',
                      itemName: assessment.title,
                      confirmLabel: 'Delete',
                      cancelLabel: 'Cancel',
                      type: ConfirmationType.danger,
                      svgPath: Assets.icons.deleteIconRed.path,
                    );
                    if (confirmed == true) {
                      onDelete?.call();
                    }
                  },
                  width: 18.w,
                  height: 18.w,
                  padding: 6.w,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
