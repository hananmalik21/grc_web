import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/presentation/providers/update_component_api_provider.dart';
import 'package:grc/features/compensation/presentation/providers/update_component_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_update/update_component_stepper.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpdateComponentScreen extends ConsumerStatefulWidget {
  final CompComponent component;

  const UpdateComponentScreen({super.key, required this.component});

  @override
  ConsumerState<UpdateComponentScreen> createState() => _UpdateComponentScreenState();
}

class _UpdateComponentScreenState extends ConsumerState<UpdateComponentScreen> {
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
    final c = widget.component;
    _nameController = TextEditingController(text: c.componentName);
    _codeController = TextEditingController(text: c.componentCode);
    _descriptionController = TextEditingController(text: c.description == '---' ? '' : c.description);
    _minController = TextEditingController(text: c.minValue?.toString() ?? '');
    _maxController = TextEditingController(text: c.maxValue?.toString() ?? '');
    _formulaNameController = TextEditingController(text: c.formulaName ?? '');
    _payrollCodeController = TextEditingController();
    _glAccountController = TextEditingController();
    _costCenterController = TextEditingController();
    _displayOrderController = TextEditingController();
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
    final comp = widget.component;
    final state = ref.watch(updateComponentProvider(comp));
    final notifier = ref.read(updateComponentProvider(comp).notifier);
    final submitState = ref.watch(updateComponentApiProvider(comp));
    final submitNotifier = ref.read(updateComponentApiProvider(comp).notifier);
    final isLastStep = notifier.stepIndex == notifier.stepCount - 1;
    final canGoBack = notifier.stepIndex > 0;

    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
        child: Column(
          children: [
            DigifyTabHeader(
              title: 'Update Component',
              description:
                  'Edit the compensation component settings, calculation rules, payroll mapping, and eligibility criteria.',
              trailing: Row(
                children: [
                  AppButton.outline(label: 'Back', onPressed: canGoBack ? notifier.goBack : null),
                  Gap(12.w),
                  AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
                  Gap(12.w),
                  AppButton.primary(
                    label: isLastStep ? 'Save Changes' : 'Continue',
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
                          ToastService.success(context, 'Component updated successfully.');
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
            UpdateComponentStepper(currentStep: state.step, maxStepIndex: state.maxStepIndex),
            Gap(24.h),
            UpdateComponentStepBody(
              component: comp,
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
