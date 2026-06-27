import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/access_management/access_role.dart';

class AccessManagementState {
  final List<dynamic> stats;
  final List<AccessRole> roles;
  final AccessRole? selectedRole;
  final AccessRoleDetail? roleDetail;

  final String? companyId;
  final bool isLoading;
  final bool clearError;
  final String? error;

  const AccessManagementState({
    this.stats = const [],
    this.roles = const [],
    this.selectedRole,
    this.roleDetail,
    this.companyId,
    this.isLoading = false,
    this.clearError = true,
    this.error,
  });

  AccessManagementState copyWith({
    List<dynamic>? stats,
    List<AccessRole>? roles,
    AccessRole? selectedRole,
    AccessRoleDetail? roleDetail,
    List<AccessAssignedUser>? assignedUsers,
    List<AccessActivity>? activities,
    String? companyId,
    bool? isLoading,
    bool? clearError,
    String? error,
  }) {
    return AccessManagementState(
      stats: stats ?? this.stats,
      roles: roles ?? this.roles,
      selectedRole: selectedRole ?? this.selectedRole,
      roleDetail: roleDetail ?? this.roleDetail,
      companyId: companyId ?? this.companyId,
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
    );
  }
}

class AccessManagementNotifier extends StateNotifier<AccessManagementState> {
  AccessManagementNotifier() : super(AccessManagementState()) {
    loadingData();
  }

  void loadingData() {
    state = state.copyWith(isLoading: true);
    state = state.copyWith(
      roles: [
        AccessRole(
          id: '1',
          name: 'HR Administrator',
          description: 'Full access to HR modules',
          type: 'Admin',
          assignedUsersCount: 3,
        ),
        AccessRole(
          id: '2',
          name: 'Payroll Manager',
          description: 'Manage payroll and financial reports',
          type: 'Manager',
          assignedUsersCount: 2,
        ),
        AccessRole(
          id: '3',
          name: 'Employee',
          description: 'Standard access for all employees',
          type: 'Standard',
          assignedUsersCount: 45,
        ),
      ],
    );

    state = state.copyWith(isLoading: false);
  }

  void selectRole(AccessRole role) {
    state = state.copyWith(
      selectedRole: role,
      roleDetail: AccessRoleDetail(
        id: role.id,
        name: role.name,
        description: role.description,
        type: role.type,
        assignedUsersCount: role.assignedUsersCount,
        permissions: [
          AccessRolePermission(id: '1', name: 'Employees'),
          AccessRolePermission(id: '2', name: 'Attendance'),
          AccessRolePermission(id: '3', name: 'Leave'),
          AccessRolePermission(id: '4', name: 'Payroll'),
          AccessRolePermission(id: '5', name: 'Documents'),
          AccessRolePermission(id: '6', name: 'Recruitment'),
          AccessRolePermission(id: '7', name: 'Settings'),
          AccessRolePermission(id: '8', name: 'Security'),
        ],
        assignedUsers: [
          AccessAssignedUser(
            name: 'Ahmed Al-Mutairi',
            email: 'ahmed@digifyhr.com',
            assignedDate: DateTime.now(),
          ),
          AccessAssignedUser(
            name: 'Sarah Johnson',
            email: 'sarah@digifyhr.com',
            assignedDate: DateTime.now(),
          ),
          AccessAssignedUser(
            name: 'Mohammed Al-Fahad',
            email: 'mohammed@digifyhr.com',
            assignedDate: DateTime.now(),
          ),
        ],
        activities: [
          AccessActivity(
            id: '1',
            title: 'Role Permission Updated',
            description: 'HR Administrator permissions were modified',
            user: 'Ahmed Al-Mutairi',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          AccessActivity(
            id: '2',
            title: 'New Role Created',
            description: 'Payroll Assistant role was added',
            user: 'Sarah Johnson',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
      ),
    );
  }

  void setCompanyId(String? companyId) {
    state = state.copyWith(companyId: companyId);
  }
}

final accessManagementProvider =
    StateNotifierProvider<AccessManagementNotifier, AccessManagementState>(
      (ref) => AccessManagementNotifier(),
    );
