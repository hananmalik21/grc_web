import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ForfeitProcessingStep { upcomingForfeits, previewReview, confirmRun, resultsSummary }

class ForfeitProcessingStepper extends StatelessWidget {
  final ForfeitProcessingStep currentStep;
  final bool isDark;

  const ForfeitProcessingStepper({super.key, required this.currentStep, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepperStep(
            step: ForfeitProcessingStep.upcomingForfeits,
            label: 'Upcoming Forfeits',
            iconPath: Assets.icons.leaveManagement.emptyLeave.path,
            currentStep: currentStep,
            isDark: isDark,
          ),
          Expanded(
            child: _StepperConnector(
              isActive: currentStep.index > ForfeitProcessingStep.upcomingForfeits.index,
              isDark: isDark,
            ),
          ),
          _StepperStep(
            step: ForfeitProcessingStep.previewReview,
            label: 'Preview & Review',
            iconPath: Assets.icons.usersIcon.path,
            currentStep: currentStep,
            isDark: isDark,
          ),
          Expanded(
            child: _StepperConnector(
              isActive: currentStep.index > ForfeitProcessingStep.previewReview.index,
              isDark: isDark,
            ),
          ),
          _StepperStep(
            step: ForfeitProcessingStep.confirmRun,
            label: 'Confirm & Run',
            iconPath: Assets.icons.leaveManagement.play.path,
            currentStep: currentStep,
            isDark: isDark,
          ),
          Expanded(
            child: _StepperConnector(
              isActive: currentStep.index > ForfeitProcessingStep.confirmRun.index,
              isDark: isDark,
            ),
          ),
          _StepperStep(
            step: ForfeitProcessingStep.resultsSummary,
            label: 'Results Summary',
            iconPath: Assets.icons.checkIconGreen.path,
            currentStep: currentStep,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StepperStep extends StatelessWidget {
  final ForfeitProcessingStep step;
  final String label;
  final String? iconPath;
  final IconData? icon;
  final ForfeitProcessingStep currentStep;
  final bool isDark;

  const _StepperStep({
    required this.step,
    required this.label,
    this.iconPath,
    this.icon,
    required this.currentStep,
    required this.isDark,
  }) : assert(iconPath != null || icon != null, 'Either iconPath or icon must be provided');

  bool get isActive => currentStep == step;
  bool get isCompleted => currentStep.index > step.index;

  @override
  Widget build(BuildContext context) {
    final isPrimary = isActive || isCompleted;
    final iconColor = isPrimary ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final textColor = isPrimary ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 11.w,
      children: [
        Container(
          width: 35.w,
          height: 35.h,
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: isPrimary
                ? null
                : Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey, width: 2),
          ),
          alignment: Alignment.center,
          child: iconPath != null
              ? DigifyAsset(assetPath: iconPath!, width: 20, height: 20, color: iconColor)
              : Icon(icon, size: 20.sp, color: iconColor),
        ),
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(color: textColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StepperConnector extends StatelessWidget {
  final bool isActive;
  final bool isDark;

  const _StepperConnector({required this.isActive, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : (isDark ? AppColors.borderGreyDark : AppColors.borderGrey),
        borderRadius: BorderRadius.circular(1.r),
      ),
    );
  }
}
