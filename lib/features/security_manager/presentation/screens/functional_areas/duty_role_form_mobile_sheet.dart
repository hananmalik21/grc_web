import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/root_navigator_key.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
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
import 'package:grc/features/security_manager/presentation/providers/security_functions/security_functions_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_modules/security_modules_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_lookups/security_lookups_provider.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DutyRoleFormMobileSheet extends ConsumerStatefulWidget {
  const DutyRoleFormMobileSheet({super.key, this.editingRole});

  final DutyRoleItem? editingRole;

  static Future<void> showCreate(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: l10n.createDutyRole,
      barrierDismissible: false,
      child: const DutyRoleFormMobileSheet(),
    );
  }

  static Future<void> showEdit(BuildContext context, {required DutyRoleItem role}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Edit Duty Role',
      barrierDismissible: false,
      child: DutyRoleFormMobileSheet(editingRole: role),
    );
  }

  bool get _isEdit => editingRole != null;

  @override
  ConsumerState<DutyRoleFormMobileSheet> createState() => _DutyRoleFormMobileSheetState();
}

class _DutyRoleFormMobileSheetState extends ConsumerState<DutyRoleFormMobileSheet> {
  final _roleNameController = TextEditingController();
  final _roleCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _functionSearchController = TextEditingController();
  final _inheritedSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget._isEdit) {
        final role = widget.editingRole!;
        _roleNameController.text = role.name;
        _roleCodeController.text = role.code;
        _descriptionController.text = role.description;
        ref.read(createDutyRoleFormProvider.notifier).initFromRole(role);
        final inheritedNotifier = ref.read(dutyRoleFormInheritedPickerProvider.notifier);
        inheritedNotifier.initForForm(role, initialSelectedGuids: role.inheritedDutyRoleGuids.toSet());
        _inheritedSearchController.clear();
      } else {
        ref.read(createDutyRoleFormProvider.notifier).initForCreate();
        ref.read(dutyRoleFunctionRolesSelectionProvider.notifier).refresh();
        final inheritedNotifier = ref.read(dutyRoleFormInheritedPickerProvider.notifier);
        inheritedNotifier.initForForm(null);
        _inheritedSearchController.clear();
      }

      final enterpriseId = ref.read(securityManagerEnterpriseIdProvider);
      await Future.wait([
        ref.read(dutyRoleFunctionRolesSelectionProvider.notifier).refresh(),
        ref.read(securityModulesProvider.notifier).load(enterpriseId: enterpriseId),
        ref.read(securityFunctionsProvider.notifier).load(),
        ref.read(dutyRoleFormInheritedPickerProvider.notifier).load(),
      ]);
      if (!mounted) return;
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

  void _goNext() {
    final outcome = ref.read(createDutyRoleFormProvider.notifier).handlePrimaryButtonTap();

    switch (outcome) {
      case CreateDutyRolePrimaryActionValidationError(:final message):
        ToastService.error(context, message);
      case CreateDutyRolePrimaryActionAdvancedStep():
      case CreateDutyRolePrimaryActionSubmitted():
        break;
    }
  }

  Future<void> _handleSubmit() async {
    final formState = ref.read(createDutyRoleFormProvider);

    try {
      if (widget._isEdit) {
        await _submitEdit(formState);
      } else {
        await _submitCreate(formState);
      }
      if (!mounted) return;
      context.pop();

      final toastContext = rootNavigatorKey.currentContext;
      if (toastContext != null && toastContext.mounted) {
        if (widget._isEdit) {
          ToastService.success(toastContext, 'Duty role updated successfully', title: 'Updated');
        } else {
          ToastService.success(toastContext, DutyRoleFormConfig.successMessage, title: DutyRoleFormConfig.successTitle);
        }
      }
    } catch (e) {
      if (!mounted) return;
      final message = e is AppException
          ? e.message
          : widget._isEdit
          ? 'Failed to update duty role. Please try again.'
          : 'Failed to create duty role. Please try again.';
      ToastService.error(context, message);
    }
  }

  Future<void> _submitCreate(CreateDutyRoleFormState formState) async {
    final codeToIdCache = ref.read(dutyRoleFunctionRolesSelectionProvider).codeToIdCache;
    final functionRoles = formState.selectedFunctionRoles
        .toList()
        .map((code) => {'function_role_id': int.tryParse(codeToIdCache[code] ?? '') ?? 0})
        .where((item) => (item['function_role_id'] ?? 0) > 0)
        .toList();

    final inheritedPickerState = ref.read(dutyRoleFormInheritedPickerProvider);
    final inheritedDutyRoles = inheritedPickerState.roles
        .where((role) => inheritedPickerState.selectedGuids.contains(role.dutyRoleGuid))
        .map((role) => {'child_duty_role_id': int.tryParse(role.id) ?? 0})
        .toList();

    await ref
        .read(dutyRolesProvider.notifier)
        .createDutyRole(
          name: formState.roleName.trim(),
          code: formState.roleCode.trim(),
          description: formState.description.trim(),
          category: formState.selectedCategory.trim(),
          functionRoles: functionRoles,
          inheritedDutyRoles: inheritedDutyRoles,
          isActive: formState.selectedStatus == DutyRoleFormConfig.activeStatus,
          requiresApproval: formState.requiresApproval,
          effectiveFrom: formState.effectiveFrom,
          expirationDate: formState.expirationDate,
        );
  }

  Future<void> _submitEdit(CreateDutyRoleFormState formState) async {
    final role = widget.editingRole!;
    final codeToIdCache = ref.read(dutyRoleFunctionRolesSelectionProvider).codeToIdCache;
    final functionRoles = formState.selectedFunctionRoles
        .difference(formState.lockedFunctionRoleCodes)
        .toList()
        .map((code) => {'function_role_id': int.tryParse(codeToIdCache[code] ?? '') ?? 0})
        .where((item) => (item['function_role_id'] ?? 0) > 0)
        .toList();

    final inheritedPickerState = ref.read(dutyRoleFormInheritedPickerProvider);
    final inheritedDutyRoles = inheritedPickerState.roles
        .where((item) => inheritedPickerState.selectedGuids.contains(item.dutyRoleGuid))
        .map((item) => {'child_duty_role_id': int.tryParse(item.id) ?? 0})
        .toList();

    await ref
        .read(dutyRolesProvider.notifier)
        .updateDutyRole(
          dutyRoleGuid: role.dutyRoleGuid,
          name: formState.roleName.trim(),
          code: formState.roleCode.trim(),
          description: formState.description.trim(),
          category: formState.selectedCategory.trim(),
          functionRoles: functionRoles,
          inheritedDutyRoles: inheritedDutyRoles,
          isActive: formState.selectedStatus == DutyRoleFormConfig.activeStatus,
          requiresApproval: formState.requiresApproval,
          effectiveFrom: formState.effectiveFrom,
          expirationDate: formState.expirationDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createDutyRoleFormProvider);
    final formNotifier = ref.read(createDutyRoleFormProvider.notifier);
    final functionRolesState = ref.watch(dutyRoleFunctionRolesSelectionProvider);
    final inheritedState = ref.watch(dutyRoleFormInheritedPickerProvider);
    final isSubmitting = widget._isEdit
        ? ref.watch(dutyRolesProvider.select((state) => state.isUpdating))
        : ref.watch(dutyRolesProvider.select((state) => state.isCreating));
    final enterpriseId = ref.watch(securityManagerEnterpriseIdProvider);
    final categoriesAsync = (enterpriseId != null && enterpriseId > 0)
        ? ref.watch(dutyRoleCategoryLookupValuesProvider(enterpriseId))
        : const AsyncValue<List<SecurityLookupValue>>.data(<SecurityLookupValue>[]);
    final (categoryItems, categoryLoading, categoryError) = categoriesAsync.when(
      data: (value) => (value, false, null as String?),
      loading: () => (categoriesAsync.valueOrNull ?? <SecurityLookupValue>[], true, null as String?),
      error: (e, _) => (<SecurityLookupValue>[], false, e is AppException ? e.message : e.toString()),
    );

    final steps = widget._isEdit
        ? DutyRoleStepperConfig.editSteps(
            functionCount: formState.selectedFunctionRoles.length,
            inheritedCount: inheritedState.selectedGuids.length,
          )
        : DutyRoleStepperConfig.createSteps(
            functionCount: formState.selectedFunctionRoles.length,
            inheritedCount: inheritedState.selectedGuids.length,
          );

    final body = switch (formState.currentStep) {
      0 => CreateDutyRoleBasicInformationStep(
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
      1 => CreateDutyRoleFunctionRolesStep(
        searchController: _functionSearchController,
        searchHintText: DutyRoleFormConfig.functionRolesSearchHint,
        selectedTitle: DutyRoleFormConfig.functionRolesSelectedTitle,
        emptyMessage: DutyRoleFormConfig.functionRolesEmptyMessage,
        roleCodes: functionRolesState.paginatedRoles.map((role) => role.code).toList(),
        roleNames: {for (final role in functionRolesState.paginatedRoles) role.code: role.name},
        selectedCodes: formState.selectedFunctionRoles,
        lockedCodes: formState.lockedFunctionRoleCodes,
        onSearchChanged: ref.read(dutyRoleFunctionRolesSelectionProvider.notifier).updateSearch,
        onToggleItem: formNotifier.toggleFunctionRole,
        isLoading: functionRolesState.isLoading,
        pagination: (
          info: PaginationInfo(
            currentPage: functionRolesState.safeCurrentPage,
            totalPages: functionRolesState.totalPages,
            totalItems: functionRolesState.total,
            pageSize: functionRolesState.pageSize,
            hasNext: functionRolesState.hasNext,
            hasPrevious: functionRolesState.hasPrevious,
          ),
          onPrevious: ref.read(dutyRoleFunctionRolesSelectionProvider.notifier).previousPage,
          onNext: ref.read(dutyRoleFunctionRolesSelectionProvider.notifier).nextPage,
          onPageTap: ref.read(dutyRoleFunctionRolesSelectionProvider.notifier).goToPage,
        ),
      ),
      _ => InheritedDutyRolesSection(
        isLoading: inheritedState.isLoading,
        selectedCount: inheritedState.selectedGuids.length,
        searchController: _inheritedSearchController,
        roles: inheritedState.paginatedRoles,
        selectedGuids: inheritedState.selectedGuids,
        onSearchChanged: ref.read(dutyRoleFormInheritedPickerProvider.notifier).updateSearch,
        onRoleToggle: ref.read(dutyRoleFormInheritedPickerProvider.notifier).toggleSelection,
        currentPage: inheritedState.safePage,
        totalPages: inheritedState.totalPages,
        totalItems: inheritedState.filteredRoles.length,
        pageSize: DutyRoleFormInheritedPickerState.pageSize,
        hasNext: inheritedState.safePage < inheritedState.totalPages,
        hasPrevious: inheritedState.safePage > 1,
        onPreviousPage: ref.read(dutyRoleFormInheritedPickerProvider.notifier).previousPage,
        onNextPage: ref.read(dutyRoleFormInheritedPickerProvider.notifier).nextPage,
      ),
    };

    return DigifyStepperSheetContent(
      currentStep: formState.currentStep,
      totalSteps: steps.length,
      stepLabel: steps[formState.currentStep].label,
      isDark: context.isDark,
      canGoPrevious: formState.currentStep > 0,
      isLastStep: formState.currentStep == steps.length - 1,
      isLoading: isSubmitting,
      previousLabel: DutyRoleFormConfig.backButtonLabel,
      nextLabel: DutyRoleFormConfig.continueButtonLabel,
      saveLabel: widget._isEdit ? 'Update Duty Role' : DutyRoleFormConfig.createButtonLabel,
      onPrevious: formNotifier.previousStep,
      onNext: _goNext,
      onSave: _handleSubmit,
      body: body,
    );
  }
}
