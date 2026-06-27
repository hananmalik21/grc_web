import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/presentation/config/roles_management/data_role_stepper_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_basic_information_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_enterprise_structure_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_workforce_structure_step.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/create_data_role_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_lookups/security_lookups_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateDataRoleDialogContent extends ConsumerStatefulWidget {
  const CreateDataRoleDialogContent({super.key, this.title = DataRoleFormConfig.dialogTitle, this.editingRole});

  final String title;
  final DataRoleItem? editingRole;

  @override
  ConsumerState<CreateDataRoleDialogContent> createState() => _CreateDataRoleDialogContentState();
}

class _CreateDataRoleDialogContentState extends ConsumerState<CreateDataRoleDialogContent> {
  final _roleNameController = TextEditingController();
  final _roleCodeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get _isEditMode => widget.editingRole != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final editingRole = widget.editingRole;
      if (editingRole != null) {
        await ref.read(createDataRoleFormProvider.notifier).initializeForEditingRole(editingRole);
        _roleNameController.text = editingRole.name;
        _roleCodeController.text = editingRole.code;
        _descriptionController.text = editingRole.description;
      }
    });
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _roleCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createDataRoleFormProvider);
    final formNotifier = ref.read(createDataRoleFormProvider.notifier);
    final dataRolesState = ref.watch(dataRolesProvider);
    final isCreating = dataRolesState.isCreating;
    final enterpriseId = ref.watch(securityManagerEnterpriseIdProvider);
    final dataTypeLookupAsync = (enterpriseId != null && enterpriseId > 0)
        ? ref.watch(dataRoleDataTypeLookupValuesProvider(enterpriseId))
        : const AsyncValue<List<SecurityLookupValue>>.data(<SecurityLookupValue>[]);

    final (dataTypeOptions, dataTypeLoading, dataTypeError) = dataTypeLookupAsync.when(
      data: (values) => (
        values.map((v) => v.valueCode).where((code) => code.trim().isNotEmpty).toSet().toList()..sort(),
        false,
        null as String?,
      ),
      loading: () => (<String>[], true, null as String?),
      error: (e, _) => (<String>[], false, e is AppException ? e.message : e.toString()),
    );

    final steps = DataRoleStepperConfig.steps();

    if (context.isMobile) {
      return DigifyStepperSheetContent(
        currentStep: formState.currentStep,
        totalSteps: steps.length,
        stepLabel: steps[formState.currentStep].label,
        isDark: context.isDark,
        canGoPrevious: formState.currentStep > 0,
        isLastStep: formState.isLastStep,
        isLoading: isCreating && formState.isLastStep,
        previousLabel: DataRoleFormConfig.backButtonLabel,
        nextLabel: DataRoleFormConfig.continueButtonLabel,
        saveLabel: _isEditMode ? 'Update Data Role' : DataRoleFormConfig.createButtonLabel,
        onPrevious: formNotifier.previousStep,
        onNext: () => _onPrimaryAction(context, formNotifier, dataTypeOptions),
        onSave: () => _onPrimaryAction(context, formNotifier, dataTypeOptions),
        body: _buildStepBody(
          formState: formState,
          formNotifier: formNotifier,
          dataTypeOptions: dataTypeOptions,
          dataTypeLoading: dataTypeLoading,
          dataTypeError: dataTypeError,
        ),
      );
    }

    return AppStepperDialog(
      title: widget.title,
      maxWidth: DataRoleFormConfig.dialogMaxWidth.w,
      maxHeight: DataRoleFormConfig.dialogMaxHeightFactor,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      stepperSteps: steps,
      currentStepIndex: formState.currentStep,
      onClose: () => context.pop(),
      content: _buildStepBody(
        formState: formState,
        formNotifier: formNotifier,
        dataTypeOptions: dataTypeOptions,
        dataTypeLoading: dataTypeLoading,
        dataTypeError: dataTypeError,
      ),
      footerLeftActions: [
        AppButton.outline(
          label: formState.currentStep > 0 ? DataRoleFormConfig.backButtonLabel : DataRoleFormConfig.cancelButtonLabel,
          onPressed: formState.currentStep > 0 ? formNotifier.previousStep : () => context.pop(),
        ),
      ],
      footerActions: [
        AppButton(
          label: formState.isLastStep
              ? (_isEditMode ? 'Update Data Role' : DataRoleFormConfig.createButtonLabel)
              : DataRoleFormConfig.continueButtonLabel,
          onPressed: isCreating ? null : () => _onPrimaryAction(context, formNotifier, dataTypeOptions),
          isLoading: isCreating && formState.isLastStep,
          type: AppButtonType.primary,
          svgPath: formState.isLastStep && !isCreating ? DataRoleFormConfig.submitIconPath : null,
        ),
      ],
    );
  }

  Widget _buildStepBody({
    required CreateDataRoleFormState formState,
    required CreateDataRoleFormNotifier formNotifier,
    required List<String> dataTypeOptions,
    required bool dataTypeLoading,
    required String? dataTypeError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        switch (formState.currentStep) {
          0 => CreateDataRoleBasicInformationStep(
            roleNameController: _roleNameController,
            roleCodeController: _roleCodeController,
            descriptionController: _descriptionController,
            dataTypeOptions: dataTypeOptions,
            dataTypeOptionsLoading: dataTypeLoading,
            dataTypeOptionsError: dataTypeError,
            selectedDataType: formState.selectedDataType,
            selectedStatus: formState.selectedStatus,
            onRoleNameChanged: formNotifier.updateRoleName,
            onRoleCodeChanged: formNotifier.updateRoleCode,
            onDescriptionChanged: formNotifier.updateDescription,
            onDataTypeChanged: formNotifier.updateDataType,
            onStatusChanged: formNotifier.updateStatus,
          ),
          1 => const CreateDataRoleWorkforceStructureStep(),
          2 => const CreateDataRoleEnterpriseStructureStep(),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }

  Future<void> _onPrimaryAction(
    BuildContext context,
    CreateDataRoleFormNotifier notifier,
    List<String> dataTypeOptions,
  ) async {
    final result = await notifier.submit(
      availableDataTypes: dataTypeOptions,
      editingRoleId: widget.editingRole?.dataRoleGuid,
    );

    if (!context.mounted) return;
    if (result.hasError) {
      ToastService.error(context, result.errorMessage!);
      return;
    }

    if (result.shouldShowSuccess) {
      context.pop();
      ToastService.success(context, result.successMessage!, title: result.successTitle);
    }
  }
}
