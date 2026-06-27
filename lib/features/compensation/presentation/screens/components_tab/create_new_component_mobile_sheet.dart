import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/providers/create_component_api_provider.dart';
import 'package:grc/features/compensation/presentation/providers/create_new_component_provider.dart';
import 'package:grc/features/compensation/presentation/screens/components_tab/widgets/component_creation_step_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateNewComponentMobileSheet extends ConsumerStatefulWidget {
  const CreateNewComponentMobileSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Create New Component',
      barrierDismissible: false,
      child: ProviderScope(child: const CreateNewComponentMobileSheet()),
    );
    return result == true;
  }

  @override
  ConsumerState<CreateNewComponentMobileSheet> createState() => _CreateNewComponentMobileSheetState();
}

class _CreateNewComponentMobileSheetState extends ConsumerState<CreateNewComponentMobileSheet> {
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

  void _onNext() {
    final notifier = ref.read(createNewComponentProvider.notifier);
    final error = notifier.tryGoNext();
    if (error != null) ToastService.error(context, error);
  }

  void _onSave() {
    final state = ref.read(createNewComponentProvider);
    final notifier = ref.read(createNewComponentProvider.notifier);
    final submitNotifier = ref.read(createComponentApiProvider.notifier);

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
      ToastService.success(context, 'Component created successfully.');
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createNewComponentProvider);
    final notifier = ref.read(createNewComponentProvider.notifier);
    final submitState = ref.watch(createComponentApiProvider);
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
      saveLabel: 'Save & Activate',
      onPrevious: notifier.goBack,
      onNext: _onNext,
      onSave: _onSave,
      body: ComponentCreationStepBody(
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
