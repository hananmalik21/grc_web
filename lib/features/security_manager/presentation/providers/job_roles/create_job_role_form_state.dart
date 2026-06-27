import 'package:grc/features/security_manager/data/config/roles_management/job_role_form_config.dart';
import 'package:grc/features/security_manager/domain/models/job_role.dart';

class CreateJobRoleFormState {
  const CreateJobRoleFormState({
    this.currentStep = 0,
    this.totalSteps = 4,
    this.roleName = '',
    this.roleCode = '',
    this.selectedStatus = JobRoleFormConfig.defaultStatus,
    this.jobTitle = '',
    this.selectedDepartment = '',
    this.description = '',
    this.effectiveFrom,
    this.expirationDate,
    this.isAutoAssign = false,
    this.requiresApproval = false,
    this.selectedDutyRoles = const <String>{},
    this.selectedFunctionRoles = const <String>{},
    this.selectedDataRoles = const <String>{},
    this.lockedDutyRoleCodes = const <String>{},
    this.lockedFunctionRoleCodes = const <String>{},
    this.lockedDataRoleCodes = const <String>{},
    this.dutySearchQuery = '',
    this.functionSearchQuery = '',
    this.dataSearchQuery = '',
  });

  final int currentStep;
  final int totalSteps;
  final String roleName;
  final String roleCode;
  final JobRoleStatus selectedStatus;
  final String jobTitle;
  final String selectedDepartment;
  final String description;
  final DateTime? effectiveFrom;
  final DateTime? expirationDate;
  final bool isAutoAssign;
  final bool requiresApproval;
  final Set<String> selectedDutyRoles;
  final Set<String> selectedFunctionRoles;
  final Set<String> selectedDataRoles;
  final Set<String> lockedDutyRoleCodes;
  final Set<String> lockedFunctionRoleCodes;
  final Set<String> lockedDataRoleCodes;
  final String dutySearchQuery;
  final String functionSearchQuery;
  final String dataSearchQuery;

  bool get isLastStep => currentStep == totalSteps - 1;

  CreateJobRoleFormState copyWith({
    int? currentStep,
    int? totalSteps,
    String? roleName,
    String? roleCode,
    JobRoleStatus? selectedStatus,
    String? jobTitle,
    String? selectedDepartment,
    String? description,
    DateTime? effectiveFrom,
    DateTime? expirationDate,
    bool? isAutoAssign,
    bool? requiresApproval,
    Set<String>? selectedDutyRoles,
    Set<String>? selectedFunctionRoles,
    Set<String>? selectedDataRoles,
    Set<String>? lockedDutyRoleCodes,
    Set<String>? lockedFunctionRoleCodes,
    Set<String>? lockedDataRoleCodes,
    String? dutySearchQuery,
    String? functionSearchQuery,
    String? dataSearchQuery,
  }) {
    return CreateJobRoleFormState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      roleName: roleName ?? this.roleName,
      roleCode: roleCode ?? this.roleCode,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      jobTitle: jobTitle ?? this.jobTitle,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      description: description ?? this.description,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      expirationDate: expirationDate ?? this.expirationDate,
      isAutoAssign: isAutoAssign ?? this.isAutoAssign,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      selectedDutyRoles: selectedDutyRoles ?? this.selectedDutyRoles,
      selectedFunctionRoles: selectedFunctionRoles ?? this.selectedFunctionRoles,
      selectedDataRoles: selectedDataRoles ?? this.selectedDataRoles,
      lockedDutyRoleCodes: lockedDutyRoleCodes ?? this.lockedDutyRoleCodes,
      lockedFunctionRoleCodes: lockedFunctionRoleCodes ?? this.lockedFunctionRoleCodes,
      lockedDataRoleCodes: lockedDataRoleCodes ?? this.lockedDataRoleCodes,
      dutySearchQuery: dutySearchQuery ?? this.dutySearchQuery,
      functionSearchQuery: functionSearchQuery ?? this.functionSearchQuery,
      dataSearchQuery: dataSearchQuery ?? this.dataSearchQuery,
    );
  }
}
