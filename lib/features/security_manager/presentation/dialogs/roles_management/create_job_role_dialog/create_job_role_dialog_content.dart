import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/features/security_manager/data/config/roles_management/job_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/config/roles_management/job_role_stepper_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_basic_information_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_data_role_selection_item.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_selection_step.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/inherited_job_roles_section.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/create_job_role_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_role_data_roles_selection_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_role_duty_roles_selection_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_role_form_inherited_picker_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateJobRoleDialogContent extends ConsumerStatefulWidget {
  const CreateJobRoleDialogContent({super.key, this.title = JobRoleFormConfig.dialogTitle, this.editingRole});

  final String title;
  final JobRoleItem? editingRole;

  @override
  ConsumerState<CreateJobRoleDialogContent> createState() => _CreateJobRoleDialogContentState();
}

class _CreateJobRoleDialogContentState extends ConsumerState<CreateJobRoleDialogContent> {
  final _roleNameController = TextEditingController();
  final _roleCodeController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dutySearchController = TextEditingController();
  final _dataSearchController = TextEditingController();
  final _inheritedJobRolesSearchController = TextEditingController();
  bool get _isEditMode => widget.editingRole != null;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      final formNotifier = ref.read(createJobRoleFormProvider.notifier);
      if (_isEditMode) {
        final role = widget.editingRole!;
        formNotifier.initializeForEdit(role);
        _roleNameController.text = role.name;
        _roleCodeController.text = role.code;
        _jobTitleController.text = role.jobTitle;
        _descriptionController.text = role.description;
      } else {
        formNotifier.initializeForCreate();
        _roleNameController.clear();
        _roleCodeController.clear();
        _jobTitleController.clear();
        _descriptionController.clear();
      }

      ref.read(jobRoleDutyRolesSelectionProvider.notifier).refresh();
      ref.read(jobRoleDataRolesSelectionProvider.notifier).refresh();

      final inheritedJobRolesNotifier = ref.read(jobRoleFormInheritedPickerProvider.notifier);
      inheritedJobRolesNotifier.initForForm(
        widget.editingRole,
        initialSelectedGuids: widget.editingRole?.inheritedJobRoleGuids.toSet() ?? const {},
      );
      _inheritedJobRolesSearchController.clear();
      await inheritedJobRolesNotifier.load();
      if (!context.mounted) return;
    });
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _roleCodeController.dispose();
    _jobTitleController.dispose();
    _descriptionController.dispose();
    _dutySearchController.dispose();
    _dataSearchController.dispose();
    _inheritedJobRolesSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createJobRoleFormProvider);
    final inheritedState = ref.watch(jobRoleFormInheritedPickerProvider);
    final formNotifier = ref.read(createJobRoleFormProvider.notifier);
    final jobRolesState = ref.watch(jobRolesProvider);
    final dutyRolesState = ref.watch(jobRoleDutyRolesSelectionProvider);
    final dataRolesState = ref.watch(jobRoleDataRolesSelectionProvider);

    final steps = JobRoleStepperConfig.steps(
      dutyCount: formState.selectedDutyRoles.length,
      dataCount: formState.selectedDataRoles.length,
      inheritedCount: inheritedState.selectedGuids.length,
    );

    if (context.isMobile) {
      return DigifyStepperSheetContent(
        currentStep: formState.currentStep,
        totalSteps: steps.length,
        stepLabel: steps[formState.currentStep].label,
        isDark: context.isDark,
        canGoPrevious: formState.currentStep > 0,
        isLastStep: formState.isLastStep,
        isLoading: jobRolesState.isCreating,
        previousLabel: JobRoleFormConfig.backButtonLabel,
        nextLabel: JobRoleFormConfig.continueButtonLabel,
        saveLabel: _isEditMode ? 'Update Job Role' : JobRoleFormConfig.createButtonLabel,
        onPrevious: formNotifier.previousStep,
        onNext: () => _handlePrimaryAction(ref.read(createJobRoleFormProvider)),
        onSave: () => _handlePrimaryAction(ref.read(createJobRoleFormProvider)),
        body: _buildStepContent(
          formState: formState,
          formNotifier: formNotifier,
          jobRolesState: jobRolesState,
          dutyRolesState: dutyRolesState,
          dataRolesState: dataRolesState,
          inheritedState: inheritedState,
        ),
      );
    }

    return AppStepperDialog(
      title: widget.title,
      maxWidth: JobRoleFormConfig.dialogMaxWidth.w,
      maxHeight: JobRoleFormConfig.dialogMaxHeightFactor,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      stepperSteps: steps,
      currentStepIndex: formState.currentStep,
      onClose: () => context.pop(),
      content: _buildStepContent(
        formState: formState,
        formNotifier: formNotifier,
        jobRolesState: jobRolesState,
        dutyRolesState: dutyRolesState,
        dataRolesState: dataRolesState,
        inheritedState: inheritedState,
      ),
      footerLeftActions: const [],
      footerActions: _buildFooterActions(formState, formNotifier, jobRolesState.isCreating),
    );
  }

  Widget _buildStepContent({
    required CreateJobRoleFormState formState,
    required CreateJobRoleFormNotifier formNotifier,
    required JobRolesState jobRolesState,
    required JobRoleDutyRolesSelectionState dutyRolesState,
    required JobRoleDataRolesSelectionState dataRolesState,
    required JobRoleFormInheritedPickerState inheritedState,
  }) {
    return switch (formState.currentStep) {
      0 => _buildBasicInfoStep(formState, formNotifier, jobRolesState),
      1 => _buildDutyRolesStep(formState, formNotifier, dutyRolesState),
      2 => _buildDataRolesStep(formState, formNotifier, dataRolesState),
      _ => _buildInheritedJobRolesStep(inheritedState),
    };
  }

  Widget _buildBasicInfoStep(
    CreateJobRoleFormState formState,
    CreateJobRoleFormNotifier formNotifier,
    JobRolesState jobRolesState,
  ) {
    return CreateJobRoleBasicInformationStep(
      roleNameController: _roleNameController,
      roleCodeController: _roleCodeController,
      jobTitleController: _jobTitleController,
      descriptionController: _descriptionController,
      availableDepartments: const [],
      selectedStatus: formState.selectedStatus,
      selectedDepartment: formState.selectedDepartment,
      onRoleNameChanged: formNotifier.updateRoleName,
      onRoleCodeChanged: formNotifier.updateRoleCode,
      onStatusChanged: formNotifier.updateStatus,
      onJobTitleChanged: formNotifier.updateJobTitle,
      onDepartmentChanged: formNotifier.updateDepartment,
      onDescriptionChanged: formNotifier.updateDescription,
    );
  }

  Widget _buildDutyRolesStep(
    CreateJobRoleFormState formState,
    CreateJobRoleFormNotifier formNotifier,
    JobRoleDutyRolesSelectionState state,
  ) {
    final notifier = ref.read(jobRoleDutyRolesSelectionProvider.notifier);

    return CreateJobRoleSelectionStep(
      searchController: _dutySearchController,
      searchHintText: JobRoleFormConfig.dutyRolesSearchHint,
      selectedTitle: JobRoleFormConfig.dutyRolesSelectedTitle,
      emptyMessage: JobRoleFormConfig.dutyRolesEmptyMessage,
      roleCodes: state.paginatedRoles.map((r) => r.code).toList(),
      roleNames: {for (final r in state.paginatedRoles) r.code: r.name},
      selectedCodes: formState.selectedDutyRoles,
      lockedCodes: formState.lockedDutyRoleCodes,
      onSearchChanged: notifier.updateSearch,
      onToggleItem: formNotifier.toggleDutyRole,
      itemIconPath: JobRoleFormConfig.dutyRolesIconPath,
      isLoading: state.isLoading,
      pagination: _buildPagination(
        currentPage: state.safeCurrentPage,
        totalPages: state.totalPages,
        totalItems: state.total,
        pageSize: state.pageSize,
        hasNext: state.hasNext,
        hasPrevious: state.hasPrevious,
        onPrevious: notifier.previousPage,
        onNext: notifier.nextPage,
        onPageTap: notifier.goToPage,
      ),
    );
  }

  Widget _buildDataRolesStep(
    CreateJobRoleFormState formState,
    CreateJobRoleFormNotifier formNotifier,
    JobRoleDataRolesSelectionState state,
  ) {
    final notifier = ref.read(jobRoleDataRolesSelectionProvider.notifier);

    return CreateJobRoleSelectionStep(
      searchController: _dataSearchController,
      searchHintText: JobRoleFormConfig.dataRolesSearchHint,
      selectedTitle: JobRoleFormConfig.dataRolesSelectedTitle,
      emptyMessage: JobRoleFormConfig.dataRolesEmptyMessage,
      roleCodes: state.paginatedRoles.map((r) => r.code).toList(),
      selectedCodes: formState.selectedDataRoles,
      lockedCodes: formState.lockedDataRoleCodes,
      onSearchChanged: notifier.updateSearch,
      onToggleItem: formNotifier.toggleDataRole,
      itemIconPath: JobRoleFormConfig.dataRolesIconPath,
      isLoading: state.isLoading,
      pagination: _buildPagination(
        currentPage: state.safeCurrentPage,
        totalPages: state.totalPages,
        totalItems: state.total,
        pageSize: state.pageSize,
        hasNext: state.hasNext,
        hasPrevious: state.hasPrevious,
        onPrevious: notifier.previousPage,
        onNext: notifier.nextPage,
        onPageTap: notifier.goToPage,
      ),
      itemBuilder: (code, isSelected, isLocked, onTap) {
        final role = state.paginatedRoles.firstWhere(
          (r) => r.code == code,
          orElse: () => DataRoleItem(
            id: '0',
            dataRoleGuid: '',
            name: code,
            code: code,
            description: '',
            dataType: '',
            iconPath: '',
          ),
        );
        return CreateJobRoleDataRoleSelectionItem(
          role: role,
          isSelected: isSelected,
          isLocked: isLocked,
          iconPath: JobRoleFormConfig.dataRolesIconPath,
          onTap: onTap,
        );
      },
    );
  }

  Widget _buildInheritedJobRolesStep(JobRoleFormInheritedPickerState state) {
    final notifier = ref.read(jobRoleFormInheritedPickerProvider.notifier);

    return InheritedJobRolesSection(
      isLoading: state.isLoading,
      selectedCount: state.selectedGuids.length,
      searchController: _inheritedJobRolesSearchController,
      roles: state.paginatedRoles,
      selectedGuids: state.selectedGuids,
      onSearchChanged: notifier.updateSearch,
      onRoleToggle: notifier.toggleSelection,
      currentPage: state.safePage,
      totalPages: state.totalPages,
      totalItems: state.filteredRoles.length,
      pageSize: JobRoleFormInheritedPickerState.pageSize,
      hasNext: state.safePage < state.totalPages,
      hasPrevious: state.safePage > 1,
      onPreviousPage: notifier.previousPage,
      onNextPage: notifier.nextPage,
    );
  }

  ({PaginationInfo info, VoidCallback onPrevious, VoidCallback onNext, void Function(int) onPageTap}) _buildPagination({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int pageSize,
    bool? hasNext,
    bool? hasPrevious,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required void Function(int) onPageTap,
  }) {
    return (
      info: PaginationInfo(
        currentPage: currentPage,
        totalPages: totalPages,
        totalItems: totalItems,
        pageSize: pageSize,
        hasNext: hasNext ?? currentPage < totalPages,
        hasPrevious: hasPrevious ?? currentPage > 1,
      ),
      onPrevious: onPrevious,
      onNext: onNext,
      onPageTap: onPageTap,
    );
  }

  List<Widget> _buildFooterActions(
    CreateJobRoleFormState formState,
    CreateJobRoleFormNotifier formNotifier,
    bool isCreating,
  ) {
    return [
      if (formState.currentStep > 0) ...[
        AppButton.outline(label: JobRoleFormConfig.backButtonLabel, onPressed: formNotifier.previousStep),
        Gap(10.w),
      ],
      AppButton.outline(label: JobRoleFormConfig.cancelButtonLabel, onPressed: () => context.pop()),
      Gap(10.w),
      AppButton(
        label: formState.isLastStep
            ? (_isEditMode ? 'Update Job Role' : JobRoleFormConfig.createButtonLabel)
            : JobRoleFormConfig.continueButtonLabel,
        onPressed: isCreating ? null : () => _handlePrimaryAction(formState),
        isLoading: isCreating && formState.isLastStep,
        type: AppButtonType.primary,
        svgPath: formState.isLastStep && !isCreating ? JobRoleFormConfig.submitIconPath : null,
      ),
    ];
  }

  void _handlePrimaryAction(CreateJobRoleFormState formState) {
    final formNotifier = ref.read(createJobRoleFormProvider.notifier);

    final error = formNotifier.validateStep(step: formState.currentStep);
    if (error != null) {
      ToastService.error(context, error);
      return;
    }

    if (!formState.isLastStep) {
      formNotifier.nextStep();
      return;
    }

    _submitJobRole(formState);
  }

  Future<void> _submitJobRole(CreateJobRoleFormState formState) async {
    try {
      if (_isEditMode) {
        await ref
            .read(jobRolesProvider.notifier)
            .updateJobRole(jobRoleGuid: widget.editingRole!.jobRoleGuid, formState: formState);
      } else {
        await ref.read(jobRolesProvider.notifier).createJobRole(formState);
      }
      if (!mounted) return;
      context.pop();
      ToastService.success(
        context,
        _isEditMode ? 'Job role updated successfully' : JobRoleFormConfig.successMessage,
        title: _isEditMode ? 'Updated Role' : JobRoleFormConfig.successTitle,
      );
    } catch (_) {
      if (!mounted) return;
      ToastService.error(
        context,
        _isEditMode ? 'Failed to update job role. Please try again.' : 'Failed to create job role. Please try again.',
      );
    }
  }
}
