enum SystemUserStatus { active, locked }

class AssignedRole {
  final int roleId;
  final String roleCode;
  final String roleName;
  final String jobTitle;

  const AssignedRole({required this.roleId, required this.roleCode, required this.roleName, required this.jobTitle});
}

class SystemUser {
  final int id;
  final String userGuid;
  final String username;
  final String name;
  final String email;
  final String employeeNumber;
  final String department;
  final String designation;
  final List<String> roles;
  final SystemUserStatus status;
  final bool is2FAEnabled;
  final int? employeeId;
  final String? employeeGuid;

  const SystemUser({
    required this.id,
    required this.userGuid,
    required this.username,
    required this.name,
    required this.email,
    required this.employeeNumber,
    required this.department,
    required this.designation,
    required this.roles,
    required this.status,
    required this.is2FAEnabled,
    this.employeeId,
    this.employeeGuid,
  });

  String get initials {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  String get displayDepartment => department.isEmpty ? '--' : department;
  String get displayDesignation => designation.isEmpty ? '--' : designation;
  String get displayEmployeeNumber => employeeNumber.isEmpty ? '--' : employeeNumber;

  String get displayStatus => switch (status) {
    SystemUserStatus.active => 'Active',
    SystemUserStatus.locked => 'Locked',
  };

  String get twoFaLabel => is2FAEnabled ? '2FA On' : 'No 2FA';
}
