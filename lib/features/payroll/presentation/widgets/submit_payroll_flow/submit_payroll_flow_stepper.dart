import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/states/submit_payroll_flow_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SubmitPayrollFlowStepper extends StatelessWidget {
  const SubmitPayrollFlowStepper({required this.currentStep, super.key});

  final SubmitPayrollFlowStep currentStep;

  static const _steps = SubmitPayrollFlowStep.values;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final labels = <String>[
      loc.payrollSubmitPayrollFlowStepFlowDetails,
      loc.payrollSubmitPayrollFlowStepParameters,
      loc.payrollSubmitPayrollFlowStepReview,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            _SubmitPayrollFlowStepItem(
              stepNumber: i + 1,
              label: labels[i],
              isActive: currentStep == _steps[i],
              isCompleted: currentStep.index > _steps[i].index,
              isDark: isDark,
            ),
            if (i < _steps.length - 1)
              _SubmitPayrollFlowStepConnector(isActive: currentStep.index > _steps[i].index, isDark: isDark),
          ],
        ],
      ),
    );
  }
}

class _SubmitPayrollFlowStepItem extends StatelessWidget {
  const _SubmitPayrollFlowStepItem({
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.isDark,
  });

  final int stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;
  final bool isDark;

  bool get _isHighlighted => isActive || isCompleted;

  @override
  Widget build(BuildContext context) {
    final badgeColor = _isHighlighted
        ? AppColors.primary
        : (isDark ? AppColors.borderGreyDark : const Color(0xFFE5E7EB));
    final numberColor = _isHighlighted ? Colors.white : AppColors.textPlaceholder;
    final labelColor = isActive
        ? AppColors.primary
        : (_isHighlighted ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary) : AppColors.textPlaceholder);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: isCompleted
              ? DigifyAsset(
                  assetPath: Assets.icons.checkIconGreen.path,
                  color: AppColors.onPrimary,
                  width: 14,
                  height: 14,
                )
              : Text('$stepNumber', style: context.textTheme.labelLarge?.copyWith(color: numberColor)),
        ),
        Gap(8.w),
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _SubmitPayrollFlowStepConnector extends StatelessWidget {
  const _SubmitPayrollFlowStepConnector({required this.isActive, required this.isDark});

  final bool isActive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SizedBox(
        width: 40.w,
        child: DigifyDivider.horizontal(
          color: isActive ? AppColors.primary : (isDark ? AppColors.borderGreyDark : AppColors.grayTextDark),
        ),
      ),
    );
  }
}
