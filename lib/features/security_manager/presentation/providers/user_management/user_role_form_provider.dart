import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_management/user_role.dart';

class UserRoleFormState {
  final bool isLoading;
  final bool clearError;
  final String? error;
  final List<int>? assignedRoles;
  final List<UserRole> availableRoles;
  final List<UserRole> filteredRoles;
  final String? selectedRoleType;

  UserRoleFormState({
    this.isLoading = false,
    this.clearError = false,
    this.error,
    this.assignedRoles = const [],
    this.availableRoles = const [],
    this.filteredRoles = const [],
    this.selectedRoleType,
  });

  UserRoleFormState copyWith({
    bool? isLoading,
    bool? clearError,
    String? error,
    List<int>? assignedRoles,
    List<UserRole>? availableRoles,
    List<UserRole>? filteredRoles,
    String? selectedRoleType,
  }) {
    return UserRoleFormState(
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
      assignedRoles: assignedRoles ?? this.assignedRoles,
      availableRoles: availableRoles ?? this.availableRoles,
      filteredRoles: filteredRoles ?? this.filteredRoles,
      selectedRoleType: selectedRoleType ?? this.selectedRoleType,
    );
  }
}

class UserRoleFormProvider extends StateNotifier<UserRoleFormState> {
  UserRoleFormProvider() : super(UserRoleFormState()) {
    loadAvailableRoles();
  }

  void loadAvailableRoles() {
    final roles = [
      UserRole(
        id: 1,
        title: "HR Administrator",
        description: "Full access to HR Module",
        type: "Application Role",
        userCount: 4,
      ),
      UserRole(
        id: 2,
        title: "Payroll Administrator",
        description: "Manage payroll operations",
        type: "Application Role",
        userCount: 2,
      ),
      UserRole(
        id: 3,
        title: "Department Manager",
        description: "Manage department employees",
        type: "Job Role",
        userCount: 8,
      ),
      UserRole(
        id: 4,
        title: "Employee",
        description: "Basic employee access",
        type: "Abstract Role",
        userCount: 150,
      ),
      UserRole(
        id: 5,
        title: "Recruiter",
        description: "Manage recruitment process",
        type: "Function Role",
        userCount: 2,
      ),
      UserRole(
        id: 6,
        title: "Time Administrator",
        description: "Manage time and attendance process",
        type: "Function Role",
        userCount: 4,
      ),
    ];
    state = state.copyWith(availableRoles: roles, filteredRoles: roles);
  }

  void assignRole(int id) {
    List<int> roles = List<int>.from(state.assignedRoles ?? []);
    if (roles.contains(id)) {
      roles.remove(id);
    } else {
      roles.add(id);
    }
    state = state.copyWith(assignedRoles: roles);
  }

  void searchRoles(String query) {
    final filteredRoles = state.availableRoles.where((role) {
      return role.title.toLowerCase().contains(query.toLowerCase()) ||
          role.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredRoles: filteredRoles);
  }

  void filterRoles(String type) {
    if (type == "All Categories") {
      state = state.copyWith(
        selectedRoleType: type,
        filteredRoles: state.availableRoles,
      );
      return;
    }
    final filteredRoles = state.availableRoles.where((role) {
      return role.type.toLowerCase().contains(type.toLowerCase());
    }).toList();

    state = state.copyWith(
      selectedRoleType: type,
      filteredRoles: filteredRoles,
    );
  }

  void resetFilters() {
    state = state.copyWith(
      selectedRoleType: null,
      filteredRoles: state.availableRoles,
    );
  }
}

final userRoleFormProvider =
    StateNotifierProvider<UserRoleFormProvider, UserRoleFormState>(
      (ref) => UserRoleFormProvider(),
    );
