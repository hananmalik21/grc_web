import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_state.dart';

class CreateRoleDelegationFormState {
  final RoleDelegationUser currentUser;
  final RoleDelegationUser? delegatee;
  final Set<String> selectedRoles;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? reason;
  final String notes;

  const CreateRoleDelegationFormState({
    required this.currentUser,
    this.delegatee,
    this.selectedRoles = const <String>{},
    this.startDate,
    this.endDate,
    this.reason,
    this.notes = '',
  });

  bool get isValid =>
      delegatee != null &&
      selectedRoles.isNotEmpty &&
      startDate != null &&
      endDate != null &&
      reason != null &&
      reason!.trim().isNotEmpty;

  CreateRoleDelegationFormState copyWith({
    RoleDelegationUser? currentUser,
    RoleDelegationUser? delegatee,
    bool clearDelegatee = false,
    Set<String>? selectedRoles,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? reason,
    bool clearReason = false,
    String? notes,
  }) {
    return CreateRoleDelegationFormState(
      currentUser: currentUser ?? this.currentUser,
      delegatee: clearDelegatee ? null : (delegatee ?? this.delegatee),
      selectedRoles: selectedRoles ?? this.selectedRoles,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      reason: clearReason ? null : (reason ?? this.reason),
      notes: notes ?? this.notes,
    );
  }
}
