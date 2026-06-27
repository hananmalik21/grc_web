import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_shadows.dart';
import '../../../../../../core/theme/theme_extensions.dart';

enum CountryRuleStep {
  basicInformation,
  salaryStructure,
  statutoryCompliance,
  reviewPublish,
}

class CountryRuleStepper extends StatelessWidget {
  final CountryRuleStep currentStep;

  const CountryRuleStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          _StepItem(
            stepIndex: 0,
            step: CountryRuleStep.basicInformation,
            label: 'Basic Information',
            icon: Icons.public,
            currentStep: currentStep,
            isDark: isDark,
          ),
          _StepConnector(
            isActive:
                currentStep.index > CountryRuleStep.basicInformation.index,
            isDark: isDark,
          ),
          _StepItem(
            stepIndex: 1,
            step: CountryRuleStep.salaryStructure,
            label: 'Salary Structure',
            icon: Icons.attach_money,
            currentStep: currentStep,
            isDark: isDark,
          ),
          _StepConnector(
            isActive: currentStep.index > CountryRuleStep.salaryStructure.index,
            isDark: isDark,
          ),
          _StepItem(
            stepIndex: 2,
            step: CountryRuleStep.statutoryCompliance,
            label: 'Statutory & Compliance',
            icon: Icons.shield_outlined,
            currentStep: currentStep,
            isDark: isDark,
          ),
          _StepConnector(
            isActive:
                currentStep.index > CountryRuleStep.statutoryCompliance.index,
            isDark: isDark,
          ),
          _StepItem(
            stepIndex: 3,
            step: CountryRuleStep.reviewPublish,
            label: 'Review & Publish',
            icon: Icons.check_circle_outline,
            currentStep: currentStep,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int stepIndex;
  final CountryRuleStep step;
  final String label;
  final IconData icon;
  final CountryRuleStep currentStep;
  final bool isDark;

  const _StepItem({
    required this.stepIndex,
    required this.step,
    required this.label,
    required this.icon,
    required this.currentStep,
    required this.isDark,
  });

  bool get isActive => currentStep == step;
  bool get isCompleted => currentStep.index > step.index;

  @override
  Widget build(BuildContext context) {
    final isPrimary = isActive || isCompleted;
    final iconColor = isPrimary
        ? Colors.white
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final textColor = isPrimary
        ? AppColors.primary
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final stepLabelColor = isPrimary
        ? AppColors.primary
        : (isDark ? AppColors.textMutedDark : AppColors.textMuted);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.primary
                : (isDark
                      ? AppColors.cardBackgroundGreyDark
                      : Colors.transparent),
            shape: BoxShape.circle,
            border: isPrimary
                ? null
                : Border.all(
                    color: isDark
                        ? AppColors.borderGreyDark
                        : AppColors.borderGrey,
                    width: 1.5,
                  ),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20.sp, color: iconColor),
        ),
        Gap(10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'STEP ${stepIndex + 1}',
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: stepLabelColor,
                letterSpacing: 0.5,
              ),
            ),
            Gap(2.h),
            Text(
              label,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isActive;
  final bool isDark;

  const _StepConnector({required this.isActive, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark ? AppColors.borderGreyDark : AppColors.borderGrey),
          borderRadius: BorderRadius.circular(1.r),
        ),
      ),
    );
  }
}
