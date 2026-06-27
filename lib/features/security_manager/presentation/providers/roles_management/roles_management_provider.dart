import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'roles_management_state.dart';

class RolesManagementNotifier extends StateNotifier<RolesManagementState> {
  RolesManagementNotifier() : super(const RolesManagementState()) {
    _loadData();
  }

  static final List<RoleTabType> roleTabs = [RoleTabType.function, RoleTabType.duty, RoleTabType.job, RoleTabType.data];

  static const List<String> categoryFilterOptions = ['All Types', 'System Role', 'Custom Role'];

  void _loadData() {
    state = state.copyWith(isLoading: true);
    final roles = [
      RoleModel(
        id: '1',
        name: 'HR Administrator',
        code: 'APP_HR_ADMIN',
        description: 'Full access to all HR modules and employee data management',
        type: RoleType.application,
        usersAssigned: 3,
        isActive: true,
        createdOn: DateTime(2024, 1, 15),
        updatedLabel: 'Updated 2 days ago',
        roleBadge: 'System Role',
      ),
      RoleModel(
        id: '2',
        name: 'Payroll Manager',
        code: 'APP_PAY_MGR',
        description: 'Manage payroll processing and financial reports',
        type: RoleType.application,
        usersAssigned: 2,
        isActive: true,
        createdOn: DateTime(2024, 2, 10),
        updatedLabel: 'Updated 5 days ago',
        roleBadge: 'System Role',
      ),
      RoleModel(
        id: '3',
        name: 'Employee Self Service',
        code: 'APP_ESS',
        description: 'Standard employee self-service access',
        type: RoleType.application,
        usersAssigned: 45,
        isActive: true,
        createdOn: DateTime(2024, 1, 1),
        updatedLabel: 'Updated 1 week ago',
        roleBadge: 'Custom Role',
      ),
      RoleModel(
        id: '4',
        name: 'Leave Approver',
        code: 'FUNC_LEAVE_APPR',
        description: 'Approve and manage leave requests',
        type: RoleType.function,
        usersAssigned: 8,
        isActive: true,
        createdOn: DateTime(2024, 3, 5),
        updatedLabel: 'Updated 4 days ago',
        roleBadge: 'Custom Role',
      ),
      RoleModel(
        id: '5',
        name: 'Attendance Viewer',
        code: 'FUNC_ATT_VIEW',
        description: 'View attendance records and reports',
        type: RoleType.function,
        usersAssigned: 12,
        isActive: true,
        createdOn: DateTime(2024, 3, 10),
        updatedLabel: 'Updated 3 days ago',
        roleBadge: 'Custom Role',
      ),
      RoleModel(
        id: '6',
        name: 'Payroll Processor',
        code: 'FUNC_PAY_PROC',
        description: 'Process monthly payroll runs',
        type: RoleType.function,
        usersAssigned: 2,
        isActive: false,
        createdOn: DateTime(2024, 4, 1),
        updatedLabel: 'Updated yesterday',
        roleBadge: 'Custom Role',
      ),
      RoleModel(
        id: '7',
        name: 'HR Data Access',
        code: 'DATA_HR_FULL',
        description: 'Full access to HR employee data',
        type: RoleType.data,
        usersAssigned: 5,
        isActive: true,
        createdOn: DateTime(2024, 2, 20),
        updatedLabel: 'Updated 6 days ago',
        roleBadge: 'System Role',
      ),
      RoleModel(
        id: '8',
        name: 'Finance Data Viewer',
        code: 'DATA_FIN_VIEW',
        description: 'Read-only access to financial data',
        type: RoleType.data,
        usersAssigned: 7,
        isActive: true,
        createdOn: DateTime(2024, 2, 25),
        updatedLabel: 'Updated 2 weeks ago',
        roleBadge: 'Custom Role',
      ),
      RoleModel(
        id: '9',
        name: 'HR Director',
        code: 'JOB_HR_DIR',
        description: 'Director-level HR access and approvals',
        type: RoleType.job,
        usersAssigned: 1,
        isActive: true,
        createdOn: DateTime(2024, 1, 5),
        updatedLabel: 'Updated 1 month ago',
        roleBadge: 'System Role',
      ),
      RoleModel(
        id: '10',
        name: 'Department Manager',
        code: 'JOB_DEPT_MGR',
        description: 'Department management and team oversight',
        type: RoleType.job,
        usersAssigned: 6,
        isActive: true,
        createdOn: DateTime(2024, 1, 10),
        updatedLabel: 'Updated 9 days ago',
        roleBadge: 'Custom Role',
      ),
      RoleModel(
        id: '11',
        name: 'Timesheet Approver',
        code: 'DUTY_TS_APPR',
        description: 'Approve employee timesheets',
        type: RoleType.duty,
        usersAssigned: 4,
        isActive: true,
        createdOn: DateTime(2024, 3, 15),
        updatedLabel: 'Updated 5 days ago',
        roleBadge: 'Custom Role',
      ),
      RoleModel(
        id: '12',
        name: 'Recruitment Coordinator',
        code: 'DUTY_REC_COORD',
        description: 'Coordinate recruitment activities',
        type: RoleType.duty,
        usersAssigned: 3,
        isActive: false,
        createdOn: DateTime(2024, 4, 5),
        updatedLabel: 'Updated 8 days ago',
        roleBadge: 'Custom Role',
      ),
    ];

    final firstVisible = roles.firstWhere((r) => r.type == RoleType.function);
    state = state.copyWith(isLoading: false, roles: roles, selectedRoleId: firstVisible.id);
  }

  void selectRole(String roleId) => state = state.copyWith(selectedRoleId: roleId);

  void selectRoleType(RoleTabType tab) {
    state = state.copyWith(filterType: tab.label, roleCategoryFilter: 'All Types');
    _ensureSelection();
  }

  void updateRoleCategoryFilter(String filter) {
    state = state.copyWith(roleCategoryFilter: filter);
    _ensureSelection();
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
    _ensureSelection();
  }

  void updateRole(RoleModel updatedRole) {
    state = state.copyWith(
      roles: [
        for (final role in state.roles)
          if (role.id == updatedRole.id) updatedRole else role,
      ],
      selectedRoleId: updatedRole.id,
    );
    _ensureSelection();
  }

  List<RolePermission> get selectedRolePermissions {
    final role = state.selectedRole;
    if (role == null) return const [];

    return [
      const RolePermission(
        id: '1',
        group: 'Employee Management',
        name: 'Employee Records',
        view: true,
        export: true,
        download: true,
      ),
      const RolePermission(
        id: '2',
        group: 'Employee Management',
        name: 'Personal Information',
        view: true,
        edit: true,
        export: true,
        download: true,
        isRisky: true,
      ),
      const RolePermission(
        id: '3',
        group: 'Employee Management',
        name: 'Employment History',
        view: true,
        create: true,
        edit: true,
        upload: true,
      ),
      const RolePermission(id: '4', group: 'Employee Management', name: 'Organization Chart', view: true, export: true),
      const RolePermission(
        id: '5',
        group: 'Identity and Documents',
        name: 'Identity Documents',
        view: true,
        create: true,
        edit: true,
        upload: true,
        download: true,
        isRisky: true,
      ),
      const RolePermission(
        id: '6',
        group: 'Identity and Documents',
        name: 'Contracts',
        view: true,
        create: true,
        approve: true,
        export: true,
        download: true,
        isRisky: true,
      ),
      const RolePermission(
        id: '7',
        group: 'Identity and Documents',
        name: 'Certificates',
        view: true,
        create: true,
        upload: true,
        download: true,
      ),
      const RolePermission(
        id: '8',
        group: 'Identity and Documents',
        name: 'Document Templates',
        view: true,
        create: true,
        edit: true,
        override: true,
      ),
      const RolePermission(
        id: '9',
        group: 'Attendance',
        name: 'Time Entries',
        view: true,
        edit: true,
        approve: true,
        export: true,
      ),
      const RolePermission(
        id: '10',
        group: 'Attendance',
        name: 'Attendance Records',
        view: true,
        export: true,
        download: true,
      ),
    ];
  }

  List<RoleAssignedUser> get selectedRoleUsers => const [
    RoleAssignedUser(name: 'Ahmed Al-Mutairi', code: 'u1'),
    RoleAssignedUser(name: 'Sarah Johnson', code: 'u2'),
    RoleAssignedUser(name: 'Mohammed Al-Fahad', code: 'u3'),
    RoleAssignedUser(name: 'Fatima Al-Sabah', code: 'u4'),
    RoleAssignedUser(name: 'John Smith', code: 'u5'),
  ];

  List<RoleActivity> get selectedRoleActivities => const [
    RoleActivity(
      title: 'Role permissions updated',
      description: 'Modified by Ahmed Al-Mutairi',
      relativeTime: '2 days ago',
      iconKey: 'edit',
    ),
    RoleActivity(
      title: '3 users assigned to role',
      description: 'Sarah Johnson, Mohammed Al-Fahad, Fatima Al-Sabah',
      relativeTime: '5 days ago',
      iconKey: 'users',
    ),
    RoleActivity(
      title: 'Risky permission enabled',
      description: 'Payroll Processing access granted',
      relativeTime: '1 week ago',
      iconKey: 'warning',
    ),
    RoleActivity(
      title: 'Role cloned from template',
      description: 'Based on "Standard Manager" template',
      relativeTime: '2 weeks ago',
      iconKey: 'copy',
    ),
    RoleActivity(
      title: 'Role created',
      description: 'Created by John Smith',
      relativeTime: '1 month ago',
      iconKey: 'create',
    ),
  ];

  void _ensureSelection() {
    final items = state.filteredRoles;
    if (items.isEmpty) {
      state = state.copyWith(clearSelectedRole: true);
      return;
    }
    final selected = state.selectedRole;
    if (selected == null) {
      state = state.copyWith(selectedRoleId: items.first.id);
    }
  }
}

final rolesManagementProvider = StateNotifierProvider<RolesManagementNotifier, RolesManagementState>(
  (ref) => RolesManagementNotifier(),
);
