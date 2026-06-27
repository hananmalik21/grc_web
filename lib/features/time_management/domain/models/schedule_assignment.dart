import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

/// Organization unit information for schedule assignment
class ScheduleAssignmentOrgUnit {
  final String orgUnitId;
  final String orgStructureId;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final ScheduleAssignmentParentUnit? parentUnit;

  const ScheduleAssignmentOrgUnit({
    required this.orgUnitId,
    required this.orgStructureId,
    required this.enterpriseId,
    required this.levelCode,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    this.parentUnit,
  });

  factory ScheduleAssignmentOrgUnit.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? defaultValue;
      }
      if (value is num) return value.toInt();
      return defaultValue;
    }

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null) return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    final parentUnitJson = json['parent_unit'] as Map<String, dynamic>?;
    final parentUnit = parentUnitJson != null ? ScheduleAssignmentParentUnit.fromJson(parentUnitJson) : null;

    return ScheduleAssignmentOrgUnit(
      orgUnitId: parseString(json['org_unit_id']),
      orgStructureId: parseString(json['org_structure_id']),
      enterpriseId: parseInt(json['enterprise_id'], defaultValue: 0),
      levelCode: parseString(json['level_code']),
      orgUnitCode: parseString(json['org_unit_code']),
      orgUnitNameEn: parseString(json['org_unit_name_en']),
      orgUnitNameAr: parseString(json['org_unit_name_ar']),
      parentUnit: parentUnit,
    );
  }
}

/// Parent unit information
class ScheduleAssignmentParentUnit {
  final String id;
  final String name;
  final String level;

  const ScheduleAssignmentParentUnit({required this.id, required this.name, required this.level});

  factory ScheduleAssignmentParentUnit.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) {
        final trimmed = value.trim();
        return trimmed.isEmpty ? defaultValue : trimmed;
      }
      if (value is int || value is num) {
        return value.toString();
      }
      return value.toString().trim();
    }

    return ScheduleAssignmentParentUnit(
      id: parseString(json['id']),
      name: parseString(json['name']),
      level: parseString(json['level']),
    );
  }
}

/// Work schedule information for schedule assignment
class ScheduleAssignmentWorkSchedule {
  final int workScheduleId;
  final int tenantId;
  final String scheduleCode;
  final String scheduleNameEn;
  final String scheduleNameAr;

  const ScheduleAssignmentWorkSchedule({
    required this.workScheduleId,
    required this.tenantId,
    required this.scheduleCode,
    required this.scheduleNameEn,
    required this.scheduleNameAr,
  });

  factory ScheduleAssignmentWorkSchedule.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? defaultValue;
      }
      if (value is num) return value.toInt();
      return defaultValue;
    }

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    return ScheduleAssignmentWorkSchedule(
      workScheduleId: parseInt(json['work_schedule_id'], defaultValue: 0),
      tenantId: parseInt(json['tenant_id'], defaultValue: 0),
      scheduleCode: parseString(json['schedule_code']),
      scheduleNameEn: parseString(json['schedule_name_en']),
      scheduleNameAr: parseString(json['schedule_name_ar']),
    );
  }
}

/// Enterprise information for schedule assignment
class ScheduleAssignmentEnterprise {
  final int id;
  final String name;
  final String code;

  const ScheduleAssignmentEnterprise({required this.id, required this.name, required this.code});

  factory ScheduleAssignmentEnterprise.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? defaultValue;
      }
      if (value is num) return value.toInt();
      return defaultValue;
    }

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    return ScheduleAssignmentEnterprise(
      id: parseInt(json['id'], defaultValue: 0),
      name: parseString(json['name']),
      code: parseString(json['code']),
    );
  }
}

class ScheduleAssignmentEmployee {
  final String name;
  final String code;

  const ScheduleAssignmentEmployee({required this.name, required this.code});

  factory ScheduleAssignmentEmployee.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    return ScheduleAssignmentEmployee(name: parseString(json['name']), code: parseString(json['code']));
  }
}

/// Organization path item
class ScheduleAssignmentOrgPathItem {
  final String levelCode;
  final String orgUnitId;
  final String nameEn;
  final String nameAr;
  final int? hierarchyLevel;

  const ScheduleAssignmentOrgPathItem({
    required this.levelCode,
    required this.orgUnitId,
    required this.nameEn,
    required this.nameAr,
    this.hierarchyLevel,
  });

  factory ScheduleAssignmentOrgPathItem.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) {
        final trimmed = value.trim();
        return trimmed.isEmpty ? defaultValue : trimmed;
      }
      if (value is int || value is num) {
        return value.toString();
      }
      return value.toString().trim();
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed;
      }
      if (value is num) return value.toInt();
      return null;
    }

    return ScheduleAssignmentOrgPathItem(
      levelCode: parseString(json['level_code']),
      orgUnitId: parseString(json['org_unit_id']),
      nameEn: parseString(json['name_en']),
      nameAr: parseString(json['name_ar']),
      hierarchyLevel: parseInt(json['hierarchy_level']),
    );
  }
}

/// Organization structure information for schedule assignment
class ScheduleAssignmentOrgStructure {
  final String id;
  final String name;
  final String code;

  const ScheduleAssignmentOrgStructure({required this.id, required this.name, required this.code});

  factory ScheduleAssignmentOrgStructure.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    return ScheduleAssignmentOrgStructure(
      id: parseString(json['id']),
      name: parseString(json['name']),
      code: parseString(json['code']),
    );
  }
}

/// Schedule assignment domain model
class ScheduleAssignment {
  final int scheduleAssignmentId;
  final int tenantId;
  final AssignmentLevel assignmentLevel;
  final int? departmentId;
  final int? employeeId;
  final int workScheduleId;
  final DateTime effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String status;
  final String? notes;
  final DateTime creationDate;
  final String createdBy;
  final DateTime lastUpdateDate;
  final String lastUpdatedBy;
  final ScheduleAssignmentWorkSchedule? workSchedule;
  final ScheduleAssignmentOrgUnit? orgUnit;
  final String? orgUnitId;
  final List<ScheduleAssignmentOrgPathItem>? orgPath;
  final ScheduleAssignmentEnterprise? enterprise;
  final ScheduleAssignmentOrgStructure? orgStructure;
  final ScheduleAssignmentEmployee? employee;

  const ScheduleAssignment({
    required this.scheduleAssignmentId,
    required this.tenantId,
    required this.assignmentLevel,
    this.departmentId,
    this.employeeId,
    required this.workScheduleId,
    required this.effectiveStartDate,
    this.effectiveEndDate,
    required this.status,
    this.notes,
    required this.creationDate,
    required this.createdBy,
    required this.lastUpdateDate,
    required this.lastUpdatedBy,
    this.workSchedule,
    this.orgUnit,
    this.orgUnitId,
    this.orgPath,
    this.enterprise,
    this.orgStructure,
    this.employee,
  });

  factory ScheduleAssignment.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? defaultValue;
      }
      if (value is num) return value.toInt();
      return defaultValue;
    }

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    final workScheduleJson = json['work_schedule'] as Map<String, dynamic>?;
    final workSchedule = workScheduleJson != null ? ScheduleAssignmentWorkSchedule.fromJson(workScheduleJson) : null;

    final orgUnitJson = json['org_unit'] as Map<String, dynamic>?;
    final orgUnit = orgUnitJson != null ? ScheduleAssignmentOrgUnit.fromJson(orgUnitJson) : null;

    final orgPathJson = json['org_path'] as List<dynamic>?;
    final orgPath = orgPathJson
        ?.map((item) => ScheduleAssignmentOrgPathItem.fromJson(item as Map<String, dynamic>))
        .toList();

    final enterpriseJson = json['enterprise'] as Map<String, dynamic>?;
    final enterprise = enterpriseJson != null ? ScheduleAssignmentEnterprise.fromJson(enterpriseJson) : null;

    final orgStructureJson = json['org_structure'] as Map<String, dynamic>?;
    final orgStructure = orgStructureJson != null ? ScheduleAssignmentOrgStructure.fromJson(orgStructureJson) : null;

    final employeeJson = json['employee'] as Map<String, dynamic>?;
    final employee = employeeJson != null ? ScheduleAssignmentEmployee.fromJson(employeeJson) : null;

    final effectiveStartDate = parseDateTime(json['effective_start_date']);
    if (effectiveStartDate == null) {
      throw FormatException('effective_start_date is required');
    }

    return ScheduleAssignment(
      scheduleAssignmentId: parseInt(json['schedule_assignment_id'], defaultValue: 0),
      tenantId: parseInt(json['tenant_id'], defaultValue: 0),
      assignmentLevel: AssignmentLevel.fromString(parseString(json['assignment_level'])),
      departmentId: json['department_id'] != null ? parseInt(json['department_id']) : null,
      employeeId: json['employee_id'] != null ? parseInt(json['employee_id']) : null,
      workScheduleId: parseInt(json['work_schedule_id'], defaultValue: 0),
      effectiveStartDate: effectiveStartDate,
      effectiveEndDate: parseDateTime(json['effective_end_date']),
      status: parseString(json['status'], defaultValue: 'ACTIVE'),
      notes: json['notes'] != null ? parseString(json['notes']) : null,
      creationDate: parseDateTime(json['creation_date']) ?? DateTime.now(),
      createdBy: parseString(json['created_by']),
      lastUpdateDate: parseDateTime(json['last_update_date']) ?? DateTime.now(),
      lastUpdatedBy: parseString(json['last_updated_by']),
      workSchedule: workSchedule,
      orgUnit: orgUnit,
      orgUnitId: json['org_unit_id'] != null ? parseString(json['org_unit_id']) : null,
      orgPath: orgPath,
      enterprise: enterprise,
      orgStructure: orgStructure,
      employee: employee,
    );
  }

  bool get isActive => status.toUpperCase() == 'ACTIVE';

  String get formattedStartDate {
    return '${effectiveStartDate.year}-${effectiveStartDate.month.toString().padLeft(2, '0')}-${effectiveStartDate.day.toString().padLeft(2, '0')}';
  }

  String get formattedEndDate {
    if (effectiveEndDate == null) return '';
    return '${effectiveEndDate!.year}-${effectiveEndDate!.month.toString().padLeft(2, '0')}-${effectiveEndDate!.day.toString().padLeft(2, '0')}';
  }

  String get assignedToName {
    if (employee != null) {
      return employee!.name;
    }
    if (orgUnit != null) {
      return orgUnit!.orgUnitNameEn;
    }
    return '';
  }

  String get assignedToCode {
    if (employee != null) {
      return employee!.code;
    }
    if (orgUnit != null) {
      return orgUnit!.orgUnitCode;
    }
    return '';
  }

  String get assignedByName {
    return lastUpdatedBy;
  }
}

/// Paginated schedule assignments response
class PaginatedScheduleAssignments {
  final List<ScheduleAssignment> scheduleAssignments;
  final PaginationInfo pagination;

  const PaginatedScheduleAssignments({required this.scheduleAssignments, required this.pagination});
}
