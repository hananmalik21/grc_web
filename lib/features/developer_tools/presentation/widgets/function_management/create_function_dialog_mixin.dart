import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/developer_tools/presentation/providers/create_function_form_provider.dart';
import 'package:grc/features/developer_tools/presentation/providers/function_management_provider.dart';
import 'package:grc/features/developer_tools/presentation/widgets/function_management/action_picker_dialog.dart';
import 'package:grc/features/developer_tools/presentation/widgets/function_management/module_picker_dialog.dart';
import 'package:grc/features/developer_tools/presentation/widgets/function_management/submodule_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin CreateFunctionDialogMixin {
  Future<void> openModuleDialog(BuildContext context, WidgetRef ref, CreateFunctionFormState state) async {
    final selected = await ModulePickerDialog.show(context, selectedId: state.selectedModule?.moduleGuid);

    if (selected == null) return;
    ref.read(createFunctionFormProvider.notifier).selectModule(selected);
  }

  Future<void> openSubmoduleDialog(BuildContext context, WidgetRef ref, CreateFunctionFormState state) async {
    if (state.selectedModule == null) {
      ToastService.warning(context, 'Please select module before selecting submodule.');
      return;
    }

    final selected = await SubmodulePickerDialog.show(
      context,
      moduleGuid: state.selectedModule!.moduleGuid,
      selectedId: state.selectedSubmodule?.subModuleGuid,
    );

    if (selected == null) return;
    ref.read(createFunctionFormProvider.notifier).selectSubmodule(selected);
  }

  Future<void> openActionDialog(BuildContext context, WidgetRef ref, CreateFunctionFormState state) async {
    if (state.selectedSubmodule == null) {
      ToastService.warning(context, 'Please select submodule before choosing action.');
      return;
    }

    final selected = await ActionPickerDialog.show(
      context,
      subModuleGuid: state.selectedSubmodule!.subModuleGuid,
      selectedId: state.selectedAction?.actionGuid,
    );

    if (selected == null) return;
    ref.read(createFunctionFormProvider.notifier).selectAction(selected);
  }

  Future<void> handleCreate(BuildContext context, WidgetRef ref, CreateFunctionFormState state) async {
    if (state.functionName.trim().isEmpty ||
        state.functionCode.trim().isEmpty ||
        state.selectedModule == null ||
        state.selectedSubmodule == null ||
        state.selectedAction == null) {
      ToastService.error(context, 'Please complete all required fields before creating the function.');
      return;
    }

    final success = await ref.read(createFunctionFormProvider.notifier).submitCreateFunction();
    if (!context.mounted) return;

    if (success) {
      await ref.read(functionManagementProvider.notifier).refresh();
      if (!context.mounted) return;
      Navigator.of(context).pop(true);
      ToastService.success(context, 'Function created successfully.');
    } else {
      final errorMessage =
          ref.read(createFunctionFormProvider).errorMessage ?? 'Failed to create function. Please try again.';
      ToastService.error(context, errorMessage);
    }
  }
}
