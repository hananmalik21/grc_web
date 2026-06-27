import 'package:grc/features/security_manager/data/config/roles_management/duty_role_form_config.dart';

class CreateDutyRoleFormState {
  const CreateDutyRoleFormState({
    this.currentStep = 0,
    this.totalSteps = 3,
    this.roleName = '',
    this.roleCode = '',
    this.selectedStatus = DutyRoleFormConfig.activeStatus,
    this.selectedCategory = '',
    this.description = '',
    this.effectiveFrom,
    this.expirationDate,
    this.requiresApproval = false,
    this.selectedFunctionRoles = const <String>{},
    this.lockedFunctionRoleCodes = const <String>{},
  });

  final int currentStep;
  final int totalSteps;
  final String roleName;
  final String roleCode;
  final String selectedStatus;
  final String selectedCategory;
  final String description;
  final DateTime? effectiveFrom;
  final DateTime? expirationDate;
  final bool requiresApproval;
  final Set<String> selectedFunctionRoles;
  final Set<String> lockedFunctionRoleCodes;

  bool get isLastStep => currentStep == totalSteps - 1;

  CreateDutyRoleFormState copyWith({
    int? currentStep,
    int? totalSteps,
    String? roleName,
    String? roleCode,
    String? selectedStatus,
    String? selectedCategory,
    String? description,
    Object? effectiveFrom = _sentinel,
    Object? expirationDate = _sentinel,
    bool? requiresApproval,
    Set<String>? selectedFunctionRoles,
    Set<String>? lockedFunctionRoleCodes,
  }) {
    return CreateDutyRoleFormState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      roleName: roleName ?? this.roleName,
      roleCode: roleCode ?? this.roleCode,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      description: description ?? this.description,
      effectiveFrom: identical(effectiveFrom, _sentinel) ? this.effectiveFrom : effectiveFrom as DateTime?,
      expirationDate: identical(expirationDate, _sentinel) ? this.expirationDate : expirationDate as DateTime?,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      selectedFunctionRoles: selectedFunctionRoles ?? this.selectedFunctionRoles,
      lockedFunctionRoleCodes: lockedFunctionRoleCodes ?? this.lockedFunctionRoleCodes,
    );
  }
}

const Object _sentinel = Object();
