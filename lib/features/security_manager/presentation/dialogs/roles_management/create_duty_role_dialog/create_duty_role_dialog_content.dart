import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/features/security_manager/data/config/roles_management/duty_role_form_config.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/presentation/config/roles_management/duty_role_stepper_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/widgets/create_duty_role_basic_information_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/widgets/create_duty_role_function_roles_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/widgets/inherited_duty_roles_section.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/create_duty_role_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_role_form_inherited_picker_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_role_function_roles_selection_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_lookups/security_lookups_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_inherited_roles_banner.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDutyRoleDialogContent extends ConsumerStatefulWidget {
  const CreateDutyRoleDialogContent({super.key});

  @override
  ConsumerState<CreateDutyRoleDialogContent> createState() => _CreateDutyRoleDialogContentState();
}

class _CreateDutyRoleDialogContentState extends ConsumerState<CreateDutyRoleDialogContent> {
  final _roleNameController = TextEditingController();
  final _roleCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _functionSearchController = TextEditingController();
  final _inheritedSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(createDutyRoleFormProvider.notifier).initForCreate();
      ref.read(dutyRoleFunctionRolesSelectionProvider.notifier).refresh();
      final inheritedNotifier = ref.read(dutyRoleFormInheritedPickerProvider.notifier);
      inheritedNotifier.initForForm(null);
      _inheritedSearchController.clear();
      await inheritedNotifier.load();
    });
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _roleCodeController.dispose();
    _descriptionController.dispose();
    _functionSearchController.dispose();
    _inheritedSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createDutyRoleFormProvider);
    final formNotifier = ref.read(createDutyRoleFormProvider.notifier);
    final functionRolesState = ref.watch(dutyRoleFunctionRolesSelectionProvider);
    final inheritedState = ref.watch(dutyRoleFormInheritedPickerProvider);
    final isCreating = ref.watch(dutyRolesProvider.select((s) => s.isCreating));
    final selectedDutyRoles = ref.watch(dutyRolesProvider.select((s) => s.selectedRoles));
    final enterpriseId = ref.watch(securityManagerEnterpriseIdProvider);
    final categoriesAsync = (enterpriseId != null && enterpriseId > 0)
        ? ref.watch(dutyRoleCategoryLookupValuesProvider(enterpriseId))
        : const AsyncValue<List<SecurityLookupValue>>.data(<SecurityLookupValue>[]);
    final (categoryItems, categoryLoading, categoryError) = categoriesAsync.when(
      data: (v) => (v, false, null as String?),
      loading: () => (categoriesAsync.valueOrNull ?? <SecurityLookupValue>[], true, null as String?),
      error: (e, _) => (<SecurityLookupValue>[], false, e is AppException ? e.message : e.toString()),
    );

    final steps = DutyRoleStepperConfig.createSteps(
      functionCount: formState.selectedFunctionRoles.length,
      inheritedCount: inheritedState.selectedGuids.length,
    );

    return AppStepperDialog(
      title: DutyRoleFormConfig.dialogTitle,
      maxWidth: DutyRoleFormConfig.dialogMaxWidth.w,
      maxHeight: DutyRoleFormConfig.dialogMaxHeightFactor,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      stepperSteps: steps,
      currentStepIndex: formState.currentStep,
      onClose: () => context.pop(),
      content: _buildStepContent(
        formState: formState,
        formNotifier: formNotifier,
        functionRolesState: functionRolesState,
        inheritedState: inheritedState,
        categoryItems: categoryItems,
        categoryLoading: categoryLoading,
        categoryError: categoryError,
        selectedDutyRoles: selectedDutyRoles,
      ),
      footerLeftActions: const [],
      footerActions: _buildFooterActions(formState, formNotifier, isCreating),
    );
  }

  Widget _buildStepContent({
    required CreateDutyRoleFormState formState,
    required CreateDutyRoleFormNotifier formNotifier,
    required DutyRoleFunctionRolesSelectionState functionRolesState,
    required DutyRoleFormInheritedPickerState inheritedState,
    required List<SecurityLookupValue> categoryItems,
    required bool categoryLoading,
    required String? categoryError,
    required List<DutyRoleItem> selectedDutyRoles,
  }) {
    return switch (formState.currentStep) {
      0 => _buildBasicInfoStep(
        formState: formState,
        formNotifier: formNotifier,
        categoryItems: categoryItems,
        categoryLoading: categoryLoading,
        categoryError: categoryError,
        selectedDutyRoles: selectedDutyRoles,
      ),
      1 => _buildFunctionRolesStep(formState, formNotifier, functionRolesState),
      _ => _buildInheritedRolesStep(inheritedState),
    };
  }

  Widget _buildBasicInfoStep({
    required CreateDutyRoleFormState formState,
    required CreateDutyRoleFormNotifier formNotifier,
    required List<SecurityLookupValue> categoryItems,
    required bool categoryLoading,
    required String? categoryError,
    required List<DutyRoleItem> selectedDutyRoles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedDutyRoles.isNotEmpty) ...[
          RolesManagementInheritedRolesBanner(
            roleLabels: selectedDutyRoles.map((r) => '${r.name} · ${r.code}').toList(),
            title: 'Inheriting from Selected Duty Roles',
          ),
          Gap(18.h),
        ],
        CreateDutyRoleBasicInformationStep(
          roleNameController: _roleNameController,
          roleCodeController: _roleCodeController,
          descriptionController: _descriptionController,
          categoryLookups: categoryItems,
          categoryLookupsLoading: categoryLoading,
          categoryLookupsError: categoryError,
          selectedStatus: formState.selectedStatus,
          selectedCategoryCode: formState.selectedCategory,
          onRoleNameChanged: formNotifier.updateRoleName,
          onRoleCodeChanged: formNotifier.updateRoleCode,
          onStatusChanged: formNotifier.updateStatus,
          onCategoryCodeChanged: formNotifier.updateCategory,
          onDescriptionChanged: formNotifier.updateDescription,
        ),
      ],
    );
  }

  Widget _buildFunctionRolesStep(
    CreateDutyRoleFormState formState,
    CreateDutyRoleFormNotifier formNotifier,
    DutyRoleFunctionRolesSelectionState state,
  ) {
    final notifier = ref.read(dutyRoleFunctionRolesSelectionProvider.notifier);

    return CreateDutyRoleFunctionRolesStep(
      searchController: _functionSearchController,
      searchHintText: DutyRoleFormConfig.functionRolesSearchHint,
      selectedTitle: DutyRoleFormConfig.functionRolesSelectedTitle,
      emptyMessage: DutyRoleFormConfig.functionRolesEmptyMessage,
      roleCodes: state.paginatedRoles.map((r) => r.code).toList(),
      roleNames: {for (final r in state.paginatedRoles) r.code: r.name},
      selectedCodes: formState.selectedFunctionRoles,
      lockedCodes: formState.lockedFunctionRoleCodes,
      onSearchChanged: notifier.updateSearch,
      onToggleItem: formNotifier.toggleFunctionRole,
      isLoading: state.isLoading,
      pagination: (
        info: PaginationInfo(
          currentPage: state.safeCurrentPage,
          totalPages: state.totalPages,
          totalItems: state.total,
          pageSize: state.pageSize,
          hasNext: state.hasNext,
          hasPrevious: state.hasPrevious,
        ),
        onPrevious: notifier.previousPage,
        onNext: notifier.nextPage,
        onPageTap: notifier.goToPage,
      ),
    );
  }

  Widget _buildInheritedRolesStep(DutyRoleFormInheritedPickerState state) {
    final notifier = ref.read(dutyRoleFormInheritedPickerProvider.notifier);

    return InheritedDutyRolesSection(
      isLoading: state.isLoading,
      selectedCount: state.selectedGuids.length,
      searchController: _inheritedSearchController,
      roles: state.paginatedRoles,
      selectedGuids: state.selectedGuids,
      onSearchChanged: notifier.updateSearch,
      onRoleToggle: notifier.toggleSelection,
      currentPage: state.safePage,
      totalPages: state.totalPages,
      totalItems: state.filteredRoles.length,
      pageSize: DutyRoleFormInheritedPickerState.pageSize,
      hasNext: state.safePage < state.totalPages,
      hasPrevious: state.safePage > 1,
      onPreviousPage: notifier.previousPage,
      onNextPage: notifier.nextPage,
    );
  }

  List<Widget> _buildFooterActions(
    CreateDutyRoleFormState formState,
    CreateDutyRoleFormNotifier formNotifier,
    bool isCreating,
  ) {
    return [
      if (formState.currentStep > 0) ...[
        AppButton.outline(label: DutyRoleFormConfig.backButtonLabel, onPressed: formNotifier.previousStep),
        Gap(10.w),
      ],
      AppButton.outline(label: DutyRoleFormConfig.cancelButtonLabel, onPressed: () => context.pop()),
      Gap(10.w),
      AppButton(
        label: formState.isLastStep ? DutyRoleFormConfig.createButtonLabel : DutyRoleFormConfig.continueButtonLabel,
        onPressed: isCreating ? null : () => _handlePrimaryAction(formState),
        isLoading: isCreating && formState.isLastStep,
        type: AppButtonType.primary,
        svgPath: formState.isLastStep && !isCreating ? DutyRoleFormConfig.submitIconPath : null,
      ),
    ];
  }

  void _handlePrimaryAction(CreateDutyRoleFormState formState) {
    final formNotifier = ref.read(createDutyRoleFormProvider.notifier);
    final outcome = formNotifier.handlePrimaryButtonTap();

    switch (outcome) {
      case CreateDutyRolePrimaryActionValidationError(:final message):
        ToastService.error(context, message);
      case CreateDutyRolePrimaryActionAdvancedStep():
        break;
      case CreateDutyRolePrimaryActionSubmitted():
        _submitForm(formState);
    }
  }

  Future<void> _submitForm(CreateDutyRoleFormState formState) async {
    final codeToIdCache = ref.read(dutyRoleFunctionRolesSelectionProvider).codeToIdCache;

    final functionRoles = formState.selectedFunctionRoles
        .toList()
        .map((code) => {'function_role_id': int.tryParse(codeToIdCache[code] ?? '') ?? 0})
        .where((e) => (e['function_role_id'] ?? 0) > 0)
        .toList();

    final inheritedPickerState = ref.read(dutyRoleFormInheritedPickerProvider);
    final inheritedDutyRoles = inheritedPickerState.roles
        .where((r) => inheritedPickerState.selectedGuids.contains(r.dutyRoleGuid))
        .map((r) => {'child_duty_role_id': int.tryParse(r.id) ?? 0})
        .toList();

    final isActive = formState.selectedStatus == DutyRoleFormConfig.activeStatus;

    try {
      await ref
          .read(dutyRolesProvider.notifier)
          .createDutyRole(
            name: formState.roleName.trim(),
            code: formState.roleCode.trim(),
            description: formState.description.trim(),
            category: formState.selectedCategory.trim(),
            functionRoles: functionRoles,
            inheritedDutyRoles: inheritedDutyRoles,
            isActive: isActive,
            requiresApproval: formState.requiresApproval,
            effectiveFrom: formState.effectiveFrom,
            expirationDate: formState.expirationDate,
          );
      if (!mounted) return;
      context.pop();
      ToastService.success(context, DutyRoleFormConfig.successMessage, title: DutyRoleFormConfig.successTitle);
    } catch (e) {
      if (!mounted) return;
      final message = e is AppException ? e.message : 'Failed to create duty role. Please try again.';
      ToastService.error(context, message);
    }
  }
}
