import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/root_navigator_key.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/security_manager/presentation/config/roles_management/function_role_stepper_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog/steps/functions_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog/steps/inherited_roles_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog/steps/role_details_step.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_role_form_inherited_picker_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_functions/security_functions_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_modules/security_modules_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionRoleFormMobileSheet extends ConsumerStatefulWidget {
  const FunctionRoleFormMobileSheet({super.key, this.editingRole});

  final FunctionRoleItem? editingRole;

  static Future<void> showCreate(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: l10n.functionRoleFormCreateSheetTitle,
      barrierDismissible: false,
      child: const FunctionRoleFormMobileSheet(editingRole: null),
    );
  }

  static Future<void> showEdit(BuildContext context, {required FunctionRoleItem role}) {
    final l10n = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: l10n.functionRoleFormEditSheetTitle,
      barrierDismissible: false,
      child: FunctionRoleFormMobileSheet(editingRole: role),
    );
  }

  @override
  ConsumerState<FunctionRoleFormMobileSheet> createState() => _FunctionRoleFormMobileSheetState();
}

class _FunctionRoleFormMobileSheetState extends ConsumerState<FunctionRoleFormMobileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _functionsSearchController;
  late final TextEditingController _inheritedRolesSearchController;

  static const int _stepCount = 3;

  bool get _isEdit => widget.editingRole != null;

  @override
  void initState() {
    super.initState();
    final role = widget.editingRole;
    _nameController = TextEditingController(text: role?.name ?? '');
    _codeController = TextEditingController(text: role?.code ?? '');
    _descriptionController = TextEditingController(text: role?.description ?? '');
    _functionsSearchController = TextEditingController();
    _inheritedRolesSearchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final enterpriseId = ref.read(securityManagerEnterpriseIdProvider);
      final rolesNotifier = ref.read(functionRolesProvider.notifier);
      final inheritedNotifier = ref.read(functionRoleFormInheritedPickerProvider.notifier);
      rolesNotifier.initFormState(role);
      inheritedNotifier.initForForm(role);
      _inheritedRolesSearchController.clear();
      await Future.wait([
        ref.read(securityModulesProvider.notifier).load(enterpriseId: enterpriseId),
        ref.read(securityFunctionsProvider.notifier).load(),
        inheritedNotifier.load(),
      ]);
      if (!context.mounted) return;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _functionsSearchController.dispose();
    _inheritedRolesSearchController.dispose();
    super.dispose();
  }

  void _goNext() {
    final notifier = ref.read(functionRolesProvider.notifier);
    final step = ref.read(functionRolesProvider).formStep;
    if (step == 0) {
      final error = notifier.validateDetailsStep(name: _nameController.text, code: _codeController.text);
      if (error != null) {
        ToastService.error(context, error);
        return;
      }
    } else if (step == 1) {
      final error = notifier.validateFunctionsStep();
      if (error != null) {
        ToastService.error(context, error);
        return;
      }
    }
    notifier.goToFormStep(step + 1);
  }

  void _onPrevious() {
    final notifier = ref.read(functionRolesProvider.notifier);
    final step = ref.read(functionRolesProvider).formStep;
    if (step <= 0) return;
    notifier.goToFormStep(step - 1);
  }

  Future<void> _handleSubmit() async {
    final notifier = ref.read(functionRolesProvider.notifier);
    try {
      if (_isEdit) {
        final role = widget.editingRole!;
        await notifier.submitEditForm(
          functionRoleGuid: role.functionRoleGuid,
          name: _nameController.text,
          code: _codeController.text,
          description: _descriptionController.text,
        );
      } else {
        await notifier.submitCreateForm(
          name: _nameController.text,
          code: _codeController.text,
          description: _descriptionController.text,
        );
      }
      if (!mounted) return;
      context.pop();
      final toastContext = rootNavigatorKey.currentContext;
      if (toastContext != null && toastContext.mounted) {
        if (_isEdit) {
          ToastService.success(toastContext, 'Function role updated successfully', title: 'Updated Role');
        } else {
          ToastService.success(toastContext, 'Function role created successfully', title: 'Created Role');
        }
      }
    } catch (_) {
      if (!mounted) return;
      final error = ref.read(functionRolesProvider).error;
      ToastService.error(
        context,
        error ?? (_isEdit ? 'Failed to update function role' : 'Failed to create function role'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(functionRolesProvider);
    final notifier = ref.read(functionRolesProvider.notifier);
    final step = state.formStep;
    final inheritedState = ref.watch(functionRoleFormInheritedPickerProvider);
    final inheritedNotifier = ref.read(functionRoleFormInheritedPickerProvider.notifier);
    final functionsState = ref.watch(securityFunctionsProvider);
    final fnNotifier = ref.read(securityFunctionsProvider.notifier);
    final filteredFunctions = ref.watch(filteredSecurityFunctionsProvider);
    final moduleNames = ref.watch(formModuleNamesProvider);
    final formModule = ref.watch(formModuleProvider);
    final modulesLoading = ref.watch(formModulesLoadingProvider);
    final modulesError = ref.watch(formModulesErrorProvider);

    final stepConfigs = FunctionRoleStepperConfig.steps(
      functionsCount: state.formSelectedFunctions.length,
      inheritedCount: inheritedState.selectedGuids.length,
    );

    final stepBody = switch (step) {
      0 => RoleDetailsStep(
        nameController: _nameController,
        codeController: _codeController,
        descriptionController: _descriptionController,
        state: state,
        notifier: notifier,
        moduleNames: moduleNames,
        formModule: formModule,
        modulesLoading: modulesLoading,
        modulesError: modulesError,
      ),
      1 => FunctionsStep(
        functionsSearchController: _functionsSearchController,
        state: state,
        notifier: notifier,
        functionsState: functionsState,
        fnNotifier: fnNotifier,
        filteredFunctions: filteredFunctions,
      ),
      _ => InheritedRolesStep(
        inheritedState: inheritedState,
        inheritedNotifier: inheritedNotifier,
        searchController: _inheritedRolesSearchController,
      ),
    };

    final l10n = AppLocalizations.of(context)!;

    return DigifyStepperSheetContent(
      currentStep: step,
      totalSteps: _stepCount,
      stepLabel: stepConfigs[step].label,
      isDark: context.isDark,
      canGoPrevious: step > 0,
      isLastStep: step == _stepCount - 1,
      isLoading: state.isSubmitting,
      previousLabel: l10n.stepperBack,
      nextLabel: l10n.stepperContinue,
      saveLabel: _isEdit ? l10n.saveChanges : l10n.createRole,
      onPrevious: _onPrevious,
      onNext: _goNext,
      onSave: _handleSubmit,
      body: stepBody,
    );
  }
}
