import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application_roles_state.dart';

class ApplicationRolesNotifier extends StateNotifier<ApplicationRolesState> {
  ApplicationRolesNotifier() : super(ApplicationRolesState(roles: _seedRoles));

  static const typeFilterOptions = ['All', 'System', 'Custom'];
  static const statusFilterOptions = ['All', 'Active', 'Inactive'];
  static const categoryFilterOptions = ['All', 'Administration', 'HR', 'Finance', 'Operations', 'IT'];

  static const List<ApplicationRoleItem> _seedRoles = [
    ApplicationRoleItem(
      id: 'sys-admin',
      name: 'System Administrator',
      code: 'SYS_ADMIN',
      description: 'Full access to all system modules and configuration settings.',
      type: 'System',
      category: 'Administration',
      usersAssigned: 3,
      isActive: true,
      permissions: ['User Management', 'System Config', 'Audit Logs', 'Security Settings'],
      createdBy: 'Ahmed Al-Mutairi',
      updatedAt: '2 days ago',
    ),
    ApplicationRoleItem(
      id: 'hr-manager',
      name: 'HR Manager',
      code: 'HR_MGR',
      description: 'Manages employee records, onboarding, and HR operations.',
      type: 'System',
      category: 'HR',
      usersAssigned: 8,
      isActive: true,
      permissions: ['Employee Records', 'Onboarding', 'Leave Management', 'Payroll View'],
      createdBy: 'Sara Al-Farsi',
      updatedAt: '1 week ago',
    ),
    ApplicationRoleItem(
      id: 'payroll-manager',
      name: 'Payroll Manager',
      code: 'PAY_MGR',
      description: 'Handles payroll processing, compensation plans, and salary adjustments.',
      type: 'System',
      category: 'Finance',
      usersAssigned: 2,
      isActive: true,
      permissions: ['Payroll Processing', 'Compensation Plans', 'Tax Management'],
      createdBy: 'Khalid Mansoor',
      updatedAt: '3 days ago',
    ),
    ApplicationRoleItem(
      id: 'ess',
      name: 'Employee Self-Service',
      code: 'ESS',
      description: 'Standard employee access for self-service HR tasks.',
      type: 'System',
      category: 'HR',
      usersAssigned: 25,
      isActive: true,
      permissions: ['View Payslips', 'Leave Requests', 'Profile Update'],
      createdBy: 'Sara Al-Farsi',
      updatedAt: '2 weeks ago',
    ),
    ApplicationRoleItem(
      id: 'recruiter',
      name: 'Recruiter',
      code: 'RECRUITER',
      description: 'Access to recruitment pipeline, candidate management, and job postings.',
      type: 'Custom',
      category: 'HR',
      usersAssigned: 4,
      isActive: true,
      permissions: ['Job Postings', 'Candidate Management', 'Interview Scheduling'],
      createdBy: 'Ahmed Al-Mutairi',
      updatedAt: '5 days ago',
    ),
    ApplicationRoleItem(
      id: 'finance-auditor',
      name: 'Finance Auditor',
      code: 'FIN_AUDIT',
      description: 'Read-only access to financial reports and audit trails.',
      type: 'Custom',
      category: 'Finance',
      usersAssigned: 2,
      isActive: true,
      permissions: ['Financial Reports', 'Audit Trails', 'Expense View'],
      createdBy: 'Khalid Mansoor',
      updatedAt: '1 month ago',
    ),
    ApplicationRoleItem(
      id: 'dept-head',
      name: 'Department Head',
      code: 'DEPT_HEAD',
      description: 'Manages team members, approvals, and department-level reporting.',
      type: 'Custom',
      category: 'Operations',
      usersAssigned: 6,
      isActive: true,
      permissions: ['Team Management', 'Leave Approvals', 'Performance Reviews'],
      createdBy: 'Nora Al-Rashidi',
      updatedAt: '4 days ago',
    ),
    ApplicationRoleItem(
      id: 'it-support',
      name: 'IT Support',
      code: 'IT_SUPP',
      description: 'Access to user account management and system monitoring tools.',
      type: 'Custom',
      category: 'IT',
      usersAssigned: 3,
      isActive: false,
      permissions: ['User Account Mgmt', 'System Monitoring', 'Helpdesk'],
      createdBy: 'Omar Hasan',
      updatedAt: '3 weeks ago',
    ),
  ];

  void selectTypeFilter(String type) {
    state = state.copyWith(selectedTypeFilter: type);
  }

  void selectStatusFilter(String status) {
    state = state.copyWith(selectedStatusFilter: status);
  }

  void selectCategoryFilter(String category) {
    state = state.copyWith(selectedCategoryFilter: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void selectRole(ApplicationRoleItem role) {
    state = state.copyWith(selectedRole: () => role);
  }

  void clearSelectedRole() {
    state = state.copyWith(selectedRole: () => null);
  }
}

final applicationRolesProvider = StateNotifierProvider<ApplicationRolesNotifier, ApplicationRolesState>(
  (ref) => ApplicationRolesNotifier(),
);
