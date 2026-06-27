import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/presentation/providers/create_new_component_provider.dart';
import 'package:grc/features/compensation/presentation/providers/update_component_api_provider.dart';
import 'package:grc/features/compensation/presentation/providers/update_component_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_update/update_component_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateComponentMobileSheet extends ConsumerStatefulWidget {
  final CompComponent component;

  const UpdateComponentMobileSheet({super.key, required this.component});

  static Future<bool> show(BuildContext context, CompComponent component) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Update Component',
      barrierDismissible: false,
      child: ProviderScope(
        key: ValueKey(component.componentGuid),
        child: UpdateComponentMobileSheet(component: component),
      ),
    );
    return result == true;
  }

  @override
  ConsumerState<UpdateComponentMobileSheet> createState() => _UpdateComponentMobileSheetState();
}

class _UpdateComponentMobileSheetState extends ConsumerState<UpdateComponentMobileSheet> {
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

  void _onNext() {
    final notifier = ref.read(updateComponentProvider(widget.component).notifier);
    final error = notifier.tryGoNext();
    if (error != null) ToastService.error(context, error);
  }

  void _onSave() {
    final state = ref.read(updateComponentProvider(widget.component));
    final notifier = ref.read(updateComponentProvider(widget.component).notifier);
    final submitNotifier = ref.read(updateComponentApiProvider(widget.component).notifier);

    final error = notifier.validateForSubmit();
    if (error != null) {
      ToastService.error(context, error);
      return;
    }

    submitNotifier.submit(state).then((apiError) {
      if (!mounted) return;
      if (apiError != null) {
        ToastService.error(context, apiError);
        return;
      }
      ToastService.success(context, 'Component updated successfully.');
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateComponentProvider(widget.component));
    final notifier = ref.read(updateComponentProvider(widget.component).notifier);
    final submitState = ref.watch(updateComponentApiProvider(widget.component));
    final isLastStep = notifier.stepIndex == notifier.stepCount - 1;

    final label = switch (state.step) {
      CreateNewComponentStep.basicInformation => 'Basic Information',
      CreateNewComponentStep.calculation => 'Calculation',
      CreateNewComponentStep.payrollAccounting => 'Payroll & Accounting',
      CreateNewComponentStep.advancedSettings => 'Advanced Settings',
      CreateNewComponentStep.eligibility => 'Eligibility Rules',
    };

    return DigifyStepperSheetContent(
      currentStep: notifier.stepIndex,
      totalSteps: notifier.stepCount,
      stepLabel: label,
      isDark: context.isDark,
      canGoPrevious: notifier.stepIndex > 0,
      isLastStep: isLastStep,
      isLoading: submitState.isLoading,
      previousLabel: 'Back',
      nextLabel: 'Continue',
      saveLabel: 'Save Changes',
      onPrevious: notifier.goBack,
      onNext: _onNext,
      onSave: _onSave,
      body: UpdateComponentStepBody(
        component: widget.component,
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
    );
  }
}
