import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/create_job_role_form_state.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

export 'create_job_role_form_state.dart';

class CreateJobRoleFormNotifier extends StateNotifier<CreateJobRoleFormState> {
  CreateJobRoleFormNotifier() : super(const CreateJobRoleFormState());

  void initializeForCreate() {
    state = const CreateJobRoleFormState(totalSteps: 4);
  }

  void initializeForEdit(JobRoleItem role) {
    final directDutyCodes = role.dutyRoleCodes.where((c) => !role.lockedDutyRoleCodes.contains(c)).toSet();
    final directDataCodes = role.dataRoleCodes.where((c) => !role.lockedDataRoleCodes.contains(c)).toSet();

    state = CreateJobRoleFormState(
      totalSteps: 4,
      roleName: role.name,
      roleCode: role.code,
      selectedStatus: role.isActive ? JobRoleStatus.active : JobRoleStatus.inactive,
      jobTitle: role.jobTitle,
      description: role.description,
      selectedDutyRoles: directDutyCodes,
      selectedDataRoles: directDataCodes,
      lockedDutyRoleCodes: Set<String>.from(role.lockedDutyRoleCodes),
      lockedDataRoleCodes: Set<String>.from(role.lockedDataRoleCodes),
    );
  }

  void updateCurrentStep(int step) {
    state = state.copyWith(currentStep: step.clamp(0, state.totalSteps - 1).toInt());
  }

  void nextStep() => updateCurrentStep(state.currentStep + 1);

  void previousStep() => updateCurrentStep(state.currentStep - 1);

  void updateRoleName(String value) => state = state.copyWith(roleName: value);

  void updateRoleCode(String value) => state = state.copyWith(roleCode: value);

  void updateStatus(JobRoleStatus? value) {
    if (value == null) return;
    state = state.copyWith(selectedStatus: value);
  }

  void updateJobTitle(String value) => state = state.copyWith(jobTitle: value);

  void updateDepartment(String? value) {
    if (value == null) return;
    state = state.copyWith(selectedDepartment: value);
  }

  void updateDescription(String value) => state = state.copyWith(description: value);

  void updateEffectiveFrom(DateTime? value) {
    final expiration = state.expirationDate;
    final shouldClearExpiration = value != null && expiration != null && !expiration.isAfter(value);

    state = state.copyWith(effectiveFrom: value, expirationDate: shouldClearExpiration ? null : state.expirationDate);
  }

  void updateExpirationDate(DateTime? value) => state = state.copyWith(expirationDate: value);

  void updateIsAutoAssign(bool? value) {
    state = state.copyWith(isAutoAssign: value ?? false);
  }

  void updateRequiresApproval(bool? value) {
    state = state.copyWith(requiresApproval: value ?? false);
  }

  void updateDutySearchQuery(String value) => state = state.copyWith(dutySearchQuery: value);

  void updateDataSearchQuery(String value) => state = state.copyWith(dataSearchQuery: value);

  void toggleDutyRole(String code) {
    if (state.lockedDutyRoleCodes.contains(code)) return;
    state = state.copyWith(selectedDutyRoles: _toggleSelection(state.selectedDutyRoles, code));
  }

  void toggleDataRole(String code) {
    if (state.lockedDataRoleCodes.contains(code)) return;
    state = state.copyWith(selectedDataRoles: _toggleSelection(state.selectedDataRoles, code));
  }

  Set<String> _toggleSelection(Set<String> current, String value) {
    final updated = Set<String>.from(current);
    if (updated.contains(value)) {
      updated.remove(value);
    } else {
      updated.add(value);
    }
    return updated;
  }

  String? validateStep({required int step}) {
    switch (step) {
      case 0:
        if (state.roleName.trim().isEmpty) return 'Role name is required';
        if (state.roleCode.trim().isEmpty) return 'Role code is required';
        if (state.jobTitle.trim().isEmpty) return 'Job title is required';
        return _validateDateRange();
      case 1:
        return null;
      case 2:
        return null;
      case 3:
        return null;
      default:
        return null;
    }
  }

  String? _validateDateRange() {
    final effectiveFrom = state.effectiveFrom;
    final expirationDate = state.expirationDate;
    if (effectiveFrom == null || expirationDate == null) return null;
    if (!expirationDate.isAfter(effectiveFrom)) {
      return 'Expiration Date must be after Effective Date';
    }
    return null;
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

final createJobRoleFormProvider = StateNotifierProvider.autoDispose<CreateJobRoleFormNotifier, CreateJobRoleFormState>(
  (ref) => CreateJobRoleFormNotifier(),
);
