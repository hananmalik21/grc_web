import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/presentation/providers/create_new_component_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_update/update_advanced_settings_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_update/update_basic_information_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_update/update_calculation_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_update/update_eligibility_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_update/update_payroll_accounting_tab.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpdateComponentStepper extends StatelessWidget {
  final CreateNewComponentStep currentStep;
  final int maxStepIndex;

  const UpdateComponentStepper({super.key, required this.currentStep, required this.maxStepIndex});

  @override
  Widget build(BuildContext context) {
    final currentIndex = CreateNewComponentStep.values.indexOf(currentStep);
    final isDark = context.isDark;
    final stepCount = CreateNewComponentStep.values.length;
    final progressFraction = stepCount == 0 ? 0.0 : ((currentIndex + 1).clamp(0, stepCount) / stepCount).toDouble();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillWidth = (constraints.maxWidth * progressFraction).clamp(0.0, constraints.maxWidth);

          return Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  width: fillWidth,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100.r)),
                ),
              ),
              Row(
                children: CreateNewComponentStep.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  final isSelected = currentIndex == index;
                  final isCompleted = index < currentIndex;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: _StepChip(step: step, isSelected: isSelected, isCompleted: isCompleted),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  final CreateNewComponentStep step;
  final bool isSelected;
  final bool isCompleted;

  const _StepChip({required this.step, required this.isSelected, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final icons = Assets.icons;
    final label = switch (step) {
      CreateNewComponentStep.basicInformation => 'Basic Information',
      CreateNewComponentStep.calculation => 'Calculation',
      CreateNewComponentStep.payrollAccounting => 'Payroll & Accounting',
      CreateNewComponentStep.advancedSettings => 'Advanced Settings',
      CreateNewComponentStep.eligibility => 'Eligibility Rules',
    };
    final iconPath = switch (step) {
      CreateNewComponentStep.basicInformation => icons.registrationCardIcon.path,
      CreateNewComponentStep.calculation => icons.compensation.calculator.path,
      CreateNewComponentStep.payrollAccounting => icons.budgetIcon.path,
      CreateNewComponentStep.advancedSettings => icons.manageEnterpriseIcon.path,
      CreateNewComponentStep.eligibility => icons.employeesSmallIcon.path,
    };
    final effectiveIconPath = isCompleted ? icons.activeCheckIcon.path : iconPath;

    final isDark = context.isDark;
    final bg = isSelected ? AppColors.primary : Colors.transparent;
    final fg = (isSelected || isCompleted)
        ? Colors.white
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DigifyAsset(assetPath: effectiveIconPath, width: 16.w, height: 16.w, color: fg),
          Gap(8.w),
          Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              color: fg,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateComponentStepBody extends StatelessWidget {
  final CompComponent component;
  final CreateNewComponentStep step;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final TextEditingController minController;
  final TextEditingController maxController;
  final TextEditingController formulaNameController;
  final TextEditingController payrollCodeController;
  final TextEditingController glAccountController;
  final TextEditingController costCenterController;
  final TextEditingController displayOrderController;

  const UpdateComponentStepBody({
    super.key,
    required this.component,
    required this.step,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.minController,
    required this.maxController,
    required this.formulaNameController,
    required this.payrollCodeController,
    required this.glAccountController,
    required this.costCenterController,
    required this.displayOrderController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: Container(
        key: ValueKey(step),
        child: switch (step) {
          CreateNewComponentStep.basicInformation => UpdateBasicInformationStep(
            component: component,
            nameController: nameController,
            codeController: codeController,
            descriptionController: descriptionController,
          ),
          CreateNewComponentStep.calculation => UpdateCalculationStep(
            component: component,
            minController: minController,
            maxController: maxController,
            formulaNameController: formulaNameController,
          ),
          CreateNewComponentStep.payrollAccounting => UpdatePayrollAccountingStep(
            component: component,
            payrollCodeController: payrollCodeController,
            glAccountController: glAccountController,
            costCenterController: costCenterController,
            displayOrderController: displayOrderController,
          ),
          CreateNewComponentStep.advancedSettings => UpdateAdvancedSettingsStep(component: component),
          CreateNewComponentStep.eligibility => UpdateEligibilityStep(component: component),
        },
      ),
    );
  }
}
