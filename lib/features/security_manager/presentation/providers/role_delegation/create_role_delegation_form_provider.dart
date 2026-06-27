import 'package:grc/features/security_manager/presentation/providers/role_delegation/create_role_delegation_form_state.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRoleDelegationFormNotifier extends StateNotifier<CreateRoleDelegationFormState> {
  CreateRoleDelegationFormNotifier() : super(_initialState);

  static const RoleDelegationUser _currentUser = RoleDelegationUser(name: 'Ahmed Al-Mutairi', title: 'HR Specialist');

  static const List<RoleDelegationUser> availableDelegatees = [
    RoleDelegationUser(name: 'Sarah Johnson', title: 'HR Director'),
    RoleDelegationUser(name: 'Fatima Noor', title: 'Security Analyst'),
    RoleDelegationUser(name: 'Bilal Hussain', title: 'Payroll Specialist'),
    RoleDelegationUser(name: 'Hira Ahmed', title: 'Finance Officer'),
    RoleDelegationUser(name: 'Leila Khan', title: 'IT Support Lead'),
    RoleDelegationUser(name: 'Hassan Raza', title: 'Compliance Specialist'),
    RoleDelegationUser(name: 'Arif Mehmood', title: 'Operations Coordinator'),
  ];

  static const List<String> availableRoles = ['ROLE_HR_DIRECTOR', 'ROLE_PAYROLL_ADMIN', 'ROLE_LEAVE_APPROVER'];

  static const List<String> availableReasons = [
    'Annual Leave',
    'Vacation Coverage',
    'Project Handover',
    'Emergency Access',
    'Temporary Authority',
  ];

  static final CreateRoleDelegationFormState _initialState = CreateRoleDelegationFormState(
    currentUser: _currentUser,
    startDate: DateTime(2026, 3, 10),
    endDate: DateTime(2026, 3, 20),
  );

  void reset() {
    state = _initialState;
  }

  void setDelegatee(RoleDelegationUser? user) {
    state = state.copyWith(delegatee: user);
  }

  void toggleRole(String role) {
    final updated = Set<String>.from(state.selectedRoles);
    if (updated.contains(role)) {
      updated.remove(role);
    } else {
      updated.add(role);
    }
    state = state.copyWith(selectedRoles: updated);
  }

  void setStartDate(DateTime date) {
    final normalizedEndDate = state.endDate != null && state.endDate!.isBefore(date) ? date : state.endDate;
    state = state.copyWith(startDate: date, endDate: normalizedEndDate);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void setReason(String? reason) {
    state = state.copyWith(reason: reason);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }
}

final createRoleDelegationFormProvider =
    StateNotifierProvider.autoDispose<CreateRoleDelegationFormNotifier, CreateRoleDelegationFormState>(
      (ref) => CreateRoleDelegationFormNotifier(),
    );
