import 'package:grc/features/security_manager/data/config/roles_management/duty_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/create_duty_role_form_state.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'create_duty_role_form_state.dart';

sealed class CreateDutyRolePrimaryActionOutcome {}

final class CreateDutyRolePrimaryActionValidationError extends CreateDutyRolePrimaryActionOutcome {
  CreateDutyRolePrimaryActionValidationError(this.message);
  final String message;
}

final class CreateDutyRolePrimaryActionAdvancedStep extends CreateDutyRolePrimaryActionOutcome {
  CreateDutyRolePrimaryActionAdvancedStep();
}

final class CreateDutyRolePrimaryActionSubmitted extends CreateDutyRolePrimaryActionOutcome {
  CreateDutyRolePrimaryActionSubmitted();
}

class CreateDutyRoleFormNotifier extends StateNotifier<CreateDutyRoleFormState> {
  CreateDutyRoleFormNotifier() : super(const CreateDutyRoleFormState());

  void initForCreate() {
    state = const CreateDutyRoleFormState(totalSteps: 3);
  }

  void initFromRole(DutyRoleItem role) {
    final lockedCodes = role.inheritedFunctionRoleCodes.toSet();
    final directCodes = role.includedFunctionRoles.where((c) => !lockedCodes.contains(c)).toSet();

    state = CreateDutyRoleFormState(
      totalSteps: 3,
      roleName: role.name,
      roleCode: role.code,
      description: role.description,
      selectedCategory: role.category,
      selectedStatus: role.isActive ? DutyRoleFormConfig.activeStatus : DutyRoleFormConfig.inactiveStatus,
      requiresApproval: role.requiresApproval,
      effectiveFrom: role.effectiveFrom,
      expirationDate: role.expirationDate,
      selectedFunctionRoles: directCodes,
      lockedFunctionRoleCodes: lockedCodes,
    );
  }

  void updateCurrentStep(int step) {
    state = state.copyWith(currentStep: step.clamp(0, state.totalSteps - 1).toInt());
  }

  void nextStep() => updateCurrentStep(state.currentStep + 1);

  void previousStep() => updateCurrentStep(state.currentStep - 1);

  void updateRoleName(String value) => state = state.copyWith(roleName: value);

  void updateRoleCode(String value) => state = state.copyWith(roleCode: value);

  void updateStatus(String? value) {
    if (value == null) return;
    state = state.copyWith(selectedStatus: value);
  }

  void updateCategory(String? value) {
    if (value == null) return;
    state = state.copyWith(selectedCategory: value);
  }

  void updateDescription(String value) => state = state.copyWith(description: value);

  void updateEffectiveFrom(DateTime? value) {
    final expiration = state.expirationDate;
    final shouldClearExpiration = value != null && expiration != null && !expiration.isAfter(value);

    state = state.copyWith(effectiveFrom: value, expirationDate: shouldClearExpiration ? null : state.expirationDate);
  }

  void updateExpirationDate(DateTime? value) => state = state.copyWith(expirationDate: value);

  void updateRequiresApproval(bool? value) {
    state = state.copyWith(requiresApproval: value ?? false);
  }

  void toggleFunctionRole(String code) {
    if (state.lockedFunctionRoleCodes.contains(code)) return;
    state = state.copyWith(selectedFunctionRoles: _toggleSelection(state.selectedFunctionRoles, code));
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
        if (state.roleName.trim().isEmpty) return 'Duty role name is required';
        if (state.roleCode.trim().isEmpty) return 'Role code is required';
        if (state.selectedStatus.trim().isEmpty) return 'Status is required';
        if (state.selectedCategory.trim().isEmpty) return 'Category is required';
        return _validateDateRange();
      case 1:
        return null;
      default:
        return null;
    }
  }

  String? _validateDateRange() {
    final effectiveFrom = state.effectiveFrom;
    final expirationDate = state.expirationDate;

    if (effectiveFrom == null && expirationDate == null) return null;
    if (effectiveFrom == null) return 'Select Effective Date before Expiration Date';
    if (expirationDate == null) return null;
    if (!expirationDate.isAfter(effectiveFrom)) {
      return 'Expiration Date must be after Effective Date';
    }
    return null;
  }

  CreateDutyRolePrimaryActionOutcome handlePrimaryButtonTap() {
    final error = validateStep(step: state.currentStep);
    if (error != null) {
      return CreateDutyRolePrimaryActionValidationError(error);
    }

    if (!state.isLastStep) {
      nextStep();
      return CreateDutyRolePrimaryActionAdvancedStep();
    }

    return CreateDutyRolePrimaryActionSubmitted();
  }
}

final createDutyRoleFormProvider =
    StateNotifierProvider.autoDispose<CreateDutyRoleFormNotifier, CreateDutyRoleFormState>(
      (_) => CreateDutyRoleFormNotifier(),
    );
