import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/grade_action_buttons.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/step_salary_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeStructureCard extends StatelessWidget {
  final Grade grade;

  const GradeStructureCard({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.gradeIcon.path,
                    color: AppColors.primaryLight,
                    width: 20.sp,
                    height: 20.sp,
                  ),
                  Gap(12.w),
                  Text(grade.gradeLabel, style: context.textTheme.titleMedium),
                  Gap(12.w),
                  Text('(${grade.gradeCategoryLabel})', style: context.textTheme.bodyMedium),
                ],
              ),
              GradeActionButtons(grade: grade),
            ],
          ),
          Gap(16.h),
          if (grade.description.isNotEmpty) ...[
            Text(grade.description, style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            Gap(16.h),
          ],
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: grade.steps.map((step) {
              return StepSalaryContainer(
                stepNumber: step.step,
                salary: step.salary.toStringAsFixed(0),
                currencyCode: grade.currencyCode,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
