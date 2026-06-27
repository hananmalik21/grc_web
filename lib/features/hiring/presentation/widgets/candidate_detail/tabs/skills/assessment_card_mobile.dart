import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AssessmentCardMobile extends StatelessWidget {
  const AssessmentCardMobile({super.key, required this.assessment, required this.isDark});

  final CandidateAssessmentData assessment;
  final bool isDark;

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
                      style: context.textTheme.titleMedium?.copyWith(
                        color: textPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(2.h),
                    Text(assessment.category, style: context.textTheme.bodySmall?.copyWith(color: textSecondary)),
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
                          style: context.textTheme.titleLarge?.copyWith(
                            color: textPrimary,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${assessment.maxScore}',
                          style: context.textTheme.bodySmall?.copyWith(color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(12.h),
          Container(
            width: double.infinity,
            height: 6.h,
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
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${assessment.date}',
                style: context.textTheme.bodySmall?.copyWith(color: textSecondary, fontSize: 12.sp),
              ),
              Text(
                'Evaluator: ${assessment.evaluator}',
                style: context.textTheme.bodySmall?.copyWith(color: textSecondary, fontSize: 12.sp),
              ),
            ],
          ),
          Gap(12.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.3) : AppColors.grayBg.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '"${assessment.feedback}"',
              style: context.textTheme.bodySmall?.copyWith(
                color: textSecondary,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
