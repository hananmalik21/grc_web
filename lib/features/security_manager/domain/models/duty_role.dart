import 'package:grc/core/enums/security_enums.dart';

const skeletonDutyRole = DutyRole(
  dutyRoleId: 0,
  dutyRoleGuid: 'skeleton-duty-role-guid',
  enterpriseId: 0,
  dutyRoleCode: 'HR_APPROVER',
  dutyRoleName: 'HR Approver',
  categoryCode: 'HR',
  status: 'ACTIVE',
  description: 'Can approve payroll runs for assigned orgs.',
  effectiveDate: null,
  expirationDate: null,
  requiresManagerApproval: false,
  directFunctionRoleCodes: ['HR_MANAGER', 'HR_MANAGER1'],
  inheritedFunctionRoleCodes: [],
  inheritedDutyRoleGuids: [],
);

class DutyRole {
  const DutyRole({
    required this.dutyRoleId,
    required this.dutyRoleGuid,
    required this.enterpriseId,
    required this.dutyRoleCode,
    required this.dutyRoleName,
    required this.categoryCode,
    required this.status,
    this.description,
    required this.effectiveDate,
    required this.expirationDate,
    required this.requiresManagerApproval,
    required this.directFunctionRoleCodes,
    required this.inheritedFunctionRoleCodes,
    required this.inheritedDutyRoleGuids,
  });

  final int dutyRoleId;
  final String dutyRoleGuid;
  final int enterpriseId;
  final String dutyRoleCode;
  final String dutyRoleName;
  final String categoryCode;
  final String status;
  final String? description;
  final DateTime? effectiveDate;
  final DateTime? expirationDate;
  final bool requiresManagerApproval;
  final List<String> directFunctionRoleCodes;
  final List<String> inheritedFunctionRoleCodes;
  final List<String> inheritedDutyRoleGuids;

  bool get isActive => status == 'ACTIVE';

  factory DutyRole.fromJson(Map<String, dynamic> json) {
    final dutyRoleGuid = json['duty_role_guid'] as String? ?? '';
    final directFunctionRoles = (json['direct_function_roles'] as List<dynamic>? ?? [])
        .map((e) => ((e as Map<String, dynamic>)['function_role_code'] as String?) ?? '')
        .where((code) => code.isNotEmpty)
        .toList();

    final inheritedFunctionRoles = (json['effective_function_roles'] as List<dynamic>? ?? [])
        .where((e) {
          final type = (e as Map<String, dynamic>)['assignment_type'] as String? ?? '';
          return FunctionAssignmentType.fromString(type) == FunctionAssignmentType.inherited;
        })
        .map((e) => ((e as Map<String, dynamic>)['function_role_code'] as String?) ?? '')
        .where((code) => code.isNotEmpty)
        .toList();

    final inheritedDutyRoleGuids = (json['effective_function_roles'] as List<dynamic>? ?? [])
        .where((e) {
          final type = (e as Map<String, dynamic>)['assignment_type'] as String? ?? '';
          return FunctionAssignmentType.fromString(type) == FunctionAssignmentType.inherited;
        })
        .map((e) => ((e as Map<String, dynamic>)['source_duty_role_guid'] as String?) ?? '')
        .where((guid) => guid.isNotEmpty && guid != dutyRoleGuid)
        .toSet()
        .toList();

    return DutyRole(
      dutyRoleId: _asInt(json['duty_role_id']),
      dutyRoleGuid: dutyRoleGuid,
      enterpriseId: _asInt(json['enterprise_id']),
      dutyRoleCode: json['duty_role_code'] as String? ?? '',
      dutyRoleName: json['duty_role_name'] as String? ?? '',
      categoryCode: json['category_code'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      description: json['description'] as String?,
      effectiveDate: _parseDate(json['effective_date']),
      expirationDate: _parseDate(json['expiration_date']),
      requiresManagerApproval: _flagToBool(json['requires_manager_approval']),
      directFunctionRoleCodes: directFunctionRoles,
      inheritedFunctionRoleCodes: inheritedFunctionRoles,
      inheritedDutyRoleGuids: inheritedDutyRoleGuids,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static bool _flagToBool(dynamic value) {
    return value?.toString().toUpperCase() == 'Y';
  }
}

class DutyRolePage {
  const DutyRolePage({
    required this.roles,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<DutyRole> roles;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
