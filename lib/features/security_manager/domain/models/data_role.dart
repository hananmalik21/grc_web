enum DataRoleStatus {
  active,
  inactive;

  String get label => switch (this) {
    DataRoleStatus.active => 'Active',
    DataRoleStatus.inactive => 'Inactive',
  };

  String get apiValue => switch (this) {
    DataRoleStatus.active => 'ACTIVE',
    DataRoleStatus.inactive => 'INACTIVE',
  };
}

/// Domain model for a data role returned by the security API.
class DataRole {
  const DataRole({
    required this.dataRoleId,
    required this.dataRoleGuid,
    required this.roleName,
    required this.roleCode,
    required this.dataTypeCode,
    required this.status,
    required this.inheritedDataRoleGuids,
    this.description,
    this.createdBy,
    this.creationDate,
    required this.positions,
    required this.positionIds,
    required this.grades,
    required this.gradeIds,
    required this.jobFamilies,
    required this.jobFamilyIds,
    required this.jobLevels,
    required this.jobLevelIds,
    required this.orgUnits,
    required this.orgUnitIds,
  });

  final int dataRoleId;
  final String dataRoleGuid;
  final String roleName;
  final String roleCode;
  final String dataTypeCode;
  final String status;
  final List<String> inheritedDataRoleGuids;
  final String? description;
  final String? createdBy;
  final DateTime? creationDate;
  final List<String> positions;
  final List<String> positionIds;
  final List<String> grades;
  final List<int> gradeIds;
  final List<String> jobFamilies;
  final List<int> jobFamilyIds;
  final List<String> jobLevels;
  final List<int> jobLevelIds;
  final List<String> orgUnits;
  final List<String> orgUnitIds;

  bool get isActive => status == 'ACTIVE';

  factory DataRole.fromJson(Map<String, dynamic> json) {
    List<String> names(dynamic list, String key) =>
        (list as List<dynamic>? ?? []).map((e) => (e as Map<String, dynamic>)[key] as String).toList();
    List<String> stringIds(dynamic list, String key) => (list as List<dynamic>? ?? [])
        .map((e) => (e as Map<String, dynamic>)[key])
        .where((v) => v != null)
        .map((v) => '$v')
        .where((v) => v.trim().isNotEmpty)
        .toList();
    List<int> intIds(dynamic list, String key) => (list as List<dynamic>? ?? [])
        .map((e) => (e as Map<String, dynamic>)[key])
        .where((v) => v != null)
        .map((v) => v is int ? v : int.tryParse('$v'))
        .whereType<int>()
        .toList();

    final creationDateRaw = json['creation_date'] as String?;

    return DataRole(
      dataRoleId: json['data_role_id'] as int,
      dataRoleGuid: json['data_role_guid'] as String? ?? '',
      roleName: json['role_name'] as String,
      roleCode: json['role_code'] as String,
      dataTypeCode: json['data_type_code'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      inheritedDataRoleGuids: _parseInheritedDataRoleGuids(json),
      description: json['description'] as String?,
      createdBy: json['created_by'] as String?,
      creationDate: creationDateRaw != null ? DateTime.tryParse(creationDateRaw) : null,
      positions: names(json['positions'], 'position_name'),
      positionIds: stringIds(json['positions'], 'position_id'),
      grades: names(json['grades'], 'grade_name'),
      gradeIds: intIds(json['grades'], 'grade_id'),
      jobFamilies: names(json['job_families'], 'job_family_name'),
      jobFamilyIds: intIds(json['job_families'], 'job_family_id'),
      jobLevels: names(json['job_levels'], 'job_level_name'),
      jobLevelIds: intIds(json['job_levels'], 'job_level_id'),
      orgUnits: names(json['org_units'], 'org_unit_name'),
      orgUnitIds: stringIds(json['org_units'], 'org_unit_id'),
    );
  }

  static List<String> _parseInheritedDataRoleGuids(Map<String, dynamic> json) {
    final inherited = <String>{};
    for (final item in (json['inherited_data_roles_json'] as List<dynamic>? ?? const [])) {
      final guid = (item as Map<String, dynamic>)['data_role_guid'] as String?;
      if (guid != null && guid.isNotEmpty) inherited.add(guid);
    }
    for (final item in (json['inherited_from_json'] as List<dynamic>? ?? const [])) {
      final guid = (item as Map<String, dynamic>)['source_data_role_guid'] as String?;
      if (guid != null && guid.isNotEmpty) inherited.add(guid);
    }
    return inherited.toList();
  }
}

/// Paginated result from the data roles API.
class DataRolePage {
  const DataRolePage({
    required this.roles,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<DataRole> roles;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
