import 'package:grc/core/enums/security_enums.dart';

enum JobRoleStatus {
  active,
  inactive;

  String get label => switch (this) {
    JobRoleStatus.active => 'Active',
    JobRoleStatus.inactive => 'Inactive',
  };

  String get apiValue => switch (this) {
    JobRoleStatus.active => 'ACTIVE',
    JobRoleStatus.inactive => 'INACTIVE',
  };
}

/// Domain models for job roles returned by the security API.
class JobRoleDutyRole {
  const JobRoleDutyRole({
    required this.dutyRoleId,
    required this.dutyRoleCode,
    required this.dutyRoleName,
    required this.assignmentType,
  });

  final int dutyRoleId;
  final String dutyRoleCode;
  final String dutyRoleName;
  final FunctionAssignmentType assignmentType;

  factory JobRoleDutyRole.fromJson(Map<String, dynamic> json) {
    return JobRoleDutyRole(
      dutyRoleId: json['duty_role_id'] as int,
      dutyRoleCode: json['duty_role_code'] as String,
      dutyRoleName: json['duty_role_name'] as String,
      assignmentType: FunctionAssignmentType.fromString((json['assignment_type'] as String?)?.trim() ?? ''),
    );
  }
}

class JobRoleFunctionRole {
  const JobRoleFunctionRole({
    required this.functionRoleId,
    required this.functionRoleCode,
    required this.functionRoleName,
    required this.assignmentType,
  });

  final int functionRoleId;
  final String functionRoleCode;
  final String functionRoleName;
  final FunctionAssignmentType assignmentType;

  factory JobRoleFunctionRole.fromJson(Map<String, dynamic> json) {
    return JobRoleFunctionRole(
      functionRoleId: json['function_role_id'] as int,
      functionRoleCode: json['function_role_code'] as String,
      functionRoleName: json['function_role_name'] as String,
      assignmentType: FunctionAssignmentType.fromString((json['assignment_type'] as String?)?.trim() ?? ''),
    );
  }
}

class JobRoleDataRole {
  const JobRoleDataRole({
    required this.dataRoleId,
    required this.dataRoleCode,
    required this.dataRoleName,
    required this.assignmentType,
  });

  final int dataRoleId;
  final String dataRoleCode;
  final String dataRoleName;
  final FunctionAssignmentType assignmentType;

  factory JobRoleDataRole.fromJson(Map<String, dynamic> json) {
    return JobRoleDataRole(
      dataRoleId: json['data_role_id'] as int,
      dataRoleCode: json['data_role_code'] as String,
      dataRoleName: json['data_role_name'] as String,
      assignmentType: FunctionAssignmentType.fromString((json['assignment_type'] as String?)?.trim() ?? ''),
    );
  }
}

/// A job role as returned by the API.
class JobRole {
  const JobRole({
    required this.jobRoleId,
    required this.jobRoleGuid,
    required this.enterpriseId,
    required this.roleCode,
    required this.roleName,
    required this.jobTitle,
    this.description,
    required this.status,
    required this.inheritedJobRoleGuids,
    required this.dutyRoles,
    required this.functionRoles,
    required this.dataRoles,
  });

  final int jobRoleId;
  final String jobRoleGuid;
  final int enterpriseId;
  final String roleCode;
  final String roleName;
  final String jobTitle;
  final String? description;
  final String status;
  final List<String> inheritedJobRoleGuids;
  final List<JobRoleDutyRole> dutyRoles;
  final List<JobRoleFunctionRole> functionRoles;
  final List<JobRoleDataRole> dataRoles;

  bool get isActive => status == 'ACTIVE';

  factory JobRole.fromJson(Map<String, dynamic> json) {
    final jobRoleGuid = json['job_role_guid'] as String? ?? '';

    return JobRole(
      jobRoleId: json['job_role_id'] as int,
      jobRoleGuid: jobRoleGuid,
      enterpriseId: json['enterprise_id'] as int,
      roleCode: json['role_code'] as String,
      roleName: json['role_name'] as String,
      jobTitle: json['job_title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      inheritedJobRoleGuids: _parseInheritedJobRoleGuids(json, selfGuid: jobRoleGuid),
      dutyRoles: (json['duty_roles_json'] as List<dynamic>? ?? [])
          .map((e) => JobRoleDutyRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      functionRoles: (json['function_roles_json'] as List<dynamic>? ?? [])
          .map((e) => JobRoleFunctionRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataRoles: (json['data_roles_json'] as List<dynamic>? ?? [])
          .map((e) => JobRoleDataRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static List<String> _parseInheritedJobRoleGuids(Map<String, dynamic> json, {required String selfGuid}) {
    final inherited = <String>{};

    for (final item in (json['inherited_job_roles_json'] as List<dynamic>? ?? const [])) {
      final guid = (item as Map<String, dynamic>)['job_role_guid'] as String?;
      if (guid != null && guid.isNotEmpty) inherited.add(guid);
    }

    for (final item in (json['inherited_from_json'] as List<dynamic>? ?? const [])) {
      final guid = (item as Map<String, dynamic>)['source_job_role_guid'] as String?;
      if (guid != null && guid.isNotEmpty) inherited.add(guid);
    }

    void addFromAssignments(String key) {
      for (final entry in (json[key] as List<dynamic>? ?? const [])) {
        final map = entry as Map<String, dynamic>;
        final type = (map['assignment_type'] as String?)?.trim() ?? '';
        if (FunctionAssignmentType.fromString(type) != FunctionAssignmentType.inherited) continue;
        final guid = map['source_parent_role_guid'] as String?;
        if (guid != null && guid.isNotEmpty) inherited.add(guid);
      }
    }

    addFromAssignments('duty_roles_json');
    addFromAssignments('function_roles_json');
    addFromAssignments('data_roles_json');

    inherited.removeWhere((g) => g.isEmpty || (selfGuid.isNotEmpty && g == selfGuid));
    return inherited.toList();
  }
}

/// Paginated result from the job roles API.
class JobRolePage {
  const JobRolePage({
    required this.roles,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<JobRole> roles;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
