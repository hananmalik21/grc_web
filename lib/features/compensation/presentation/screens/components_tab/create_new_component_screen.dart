import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/compensation/presentation/providers/create_component_api_provider.dart';
import 'package:grc/features/compensation/presentation/providers/create_new_component_provider.dart';
import 'package:grc/features/compensation/presentation/screens/components_tab/widgets/component_creation_step_body.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateNewComponentScreen extends ConsumerStatefulWidget {
  const CreateNewComponentScreen({super.key});

  @override
  ConsumerState<CreateNewComponentScreen> createState() => _CreateNewComponentScreenState();
}

class _CreateNewComponentScreenState extends ConsumerState<CreateNewComponentScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;

  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  late final TextEditingController _formulaNameController;

  late final TextEditingController _payrollCodeController;
  late final TextEditingController _glAccountController;
  late final TextEditingController _costCenterController;
  late final TextEditingController _displayOrderController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createNewComponentProvider);
    _nameController = TextEditingController(text: state.name);
    _codeController = TextEditingController(text: state.code);
    _descriptionController = TextEditingController(text: state.description);

    _minController = TextEditingController(text: state.minValue);
    _maxController = TextEditingController(text: state.maxValue);
    _formulaNameController = TextEditingController(text: state.formulaName ?? '');

    _payrollCodeController = TextEditingController(text: state.payrollCode);
    _glAccountController = TextEditingController(text: state.glAccount);
    _costCenterController = TextEditingController(text: state.costCenter);
    _displayOrderController = TextEditingController(text: state.displayOrder);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _formulaNameController.dispose();
    _payrollCodeController.dispose();
    _glAccountController.dispose();
    _costCenterController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(createNewComponentProvider);
    final notifier = ref.read(createNewComponentProvider.notifier);
    final submitState = ref.watch(createComponentApiProvider);
    final submitNotifier = ref.read(createComponentApiProvider.notifier);
    final isLastStep = notifier.stepIndex == notifier.stepCount - 1;
    final canGoBack = notifier.stepIndex > 0;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
        child: Column(
          children: [
            DigifyTabHeader(
              title: 'Create New Component',
              description:
                  'Configure a new compensation component with calculation rules, payroll mapping, and eligibility criteria.',
              trailing: Row(
                children: [
                  AppButton.outline(label: 'Back', onPressed: canGoBack ? notifier.goBack : null),
                  Gap(12.w),
                  AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
                  Gap(12.w),
                  AppButton.primary(
                    label: isLastStep ? 'Save & Activate' : 'Continue',
                    svgPath: isLastStep ? Assets.icons.checkIconGreen.path : null,
                    isLoading: isLastStep && submitState.isLoading,
                    onPressed: () {
                      if (isLastStep) {
                        final error = notifier.validateForSubmit();
                        if (error != null) {
                          ToastService.error(context, error);
                          return;
                        }
                        submitNotifier.submit(state).then((apiError) {
                          if (!context.mounted) return;
                          if (apiError != null) {
                            ToastService.error(context, apiError);
                            return;
                          }
                          ToastService.success(context, 'Component created successfully.');
                          context.pop(true);
                        });
                        return;
                      }

                      final error = notifier.tryGoNext();
                      if (error != null) ToastService.error(context, error);
                    },
                  ),
                ],
              ),
            ),
            Gap(24.h),
            _CreateNewComponentStepper(currentStep: state.step, maxStepIndex: state.maxStepIndex),
            Gap(24.h),
            ComponentCreationStepBody(
              step: state.step,
              nameController: _nameController,
              codeController: _codeController,
              descriptionController: _descriptionController,
              minController: _minController,
              maxController: _maxController,
              formulaNameController: _formulaNameController,
              payrollCodeController: _payrollCodeController,
              glAccountController: _glAccountController,
              costCenterController: _costCenterController,
              displayOrderController: _displayOrderController,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateNewComponentStepper extends StatelessWidget {
  final CreateNewComponentStep currentStep;
  final int maxStepIndex;

  const _CreateNewComponentStepper({required this.currentStep, required this.maxStepIndex});

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
    final bg = isSelected
        ? AppColors.primary
        : isCompleted
        ? Colors.transparent
        : Colors.transparent;
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
