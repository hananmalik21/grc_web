import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/navigation/root_navigator_key.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
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
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditFunctionRoleDialog extends ConsumerStatefulWidget {
  const EditFunctionRoleDialog({super.key, required this.role});

  final FunctionRoleItem role;

  static Future<void> show(BuildContext context, {required FunctionRoleItem role}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditFunctionRoleDialog(role: role),
    );
  }

  @override
  ConsumerState<EditFunctionRoleDialog> createState() => _EditFunctionRoleDialogState();
}

class _EditFunctionRoleDialogState extends ConsumerState<EditFunctionRoleDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _functionsSearchController;
  late final TextEditingController _inheritedRolesSearchController;

  @override
  void initState() {
    super.initState();
    final role = widget.role;
    _nameController = TextEditingController(text: role.name);
    _codeController = TextEditingController(text: role.code);
    _descriptionController = TextEditingController(text: role.description);
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

    return AppStepperDialog(
      title: 'Edit Functional Role',
      subtitle: 'Update role details, included functions, and inherited roles.',
      maxWidth: 800.w,
      maxHeight: 0.9,
      onClose: () => context.pop(),
      stepperSteps: FunctionRoleStepperConfig.steps(
        functionsCount: state.formSelectedFunctions.length,
        inheritedCount: inheritedState.selectedGuids.length,
      ),
      currentStepIndex: step,
      content: switch (step) {
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
      },
      footerLeftActions: [
        AppButton(
          label: step == 0 ? 'Cancel' : 'Back',
          onPressed: step == 0 ? () => context.pop() : () => notifier.goToFormStep(step - 1),
          type: AppButtonType.outline,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textDarkSlate,
          borderColor: AppColors.borderGrey,
        ),
      ],
      footerActions: [
        AppButton(
          label: step < 2 ? 'Next' : 'Save Changes',
          svgPath: step == 2 ? Assets.icons.saveDivisionIcon.path : null,
          onPressed: state.isSubmitting ? null : (step < 2 ? _goNext : _handleSubmit),
          isLoading: state.isSubmitting,
          type: AppButtonType.primary,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    final notifier = ref.read(functionRolesProvider.notifier);
    try {
      await notifier.submitEditForm(
        functionRoleGuid: widget.role.functionRoleGuid,
        name: _nameController.text,
        code: _codeController.text,
        description: _descriptionController.text,
      );
      if (!mounted) return;
      context.pop();
      final toastContext = rootNavigatorKey.currentContext;
      if (toastContext != null && toastContext.mounted) {
        ToastService.success(toastContext, 'Function role updated successfully', title: 'Updated Role');
      }
    } catch (_) {
      if (!mounted) return;
      final error = ref.read(functionRolesProvider).error;
      ToastService.error(context, error ?? 'Failed to update function role');
    }
  }
}
