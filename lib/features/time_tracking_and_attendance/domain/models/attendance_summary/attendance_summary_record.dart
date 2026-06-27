class AttendanceSummaryRecord {
  final int? actualId;
  final int? attendanceDayId;
  final String? checkInTime;
  final String? checkOutTime;
  final String? hoursWorked;
  final double? overtimeHours;
  final String? createdBy;
  final String? creationDate;
  final String? lastUpdatedBy;
  final String? lastUpdateDate;
  final int? otRateTypeId;
  final double? otMultiplier;
  final int? otConfigId;
  final String? attendanceActualGuid;
  final int? enterpriseId;
  final int? employeeId;
  final String? attendanceDate;
  final String? attendanceStatus;
  final String? employeeName;
  final String? orgUnitId;
  final List<OrgStructureSummaryRecord>? orgStructureList;

  AttendanceSummaryRecord({
    this.actualId,
    this.attendanceDayId,
    this.checkInTime,
    this.checkOutTime,
    this.hoursWorked,
    this.overtimeHours,
    this.createdBy,
    this.creationDate,
    this.lastUpdatedBy,
    this.lastUpdateDate,
    this.otRateTypeId,
    this.otMultiplier,
    this.otConfigId,
    this.attendanceActualGuid,
    this.enterpriseId,
    this.employeeId,
    this.attendanceDate,
    this.attendanceStatus,
    this.employeeName,
    this.orgUnitId,
    this.orgStructureList,
  });

  factory AttendanceSummaryRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryRecord(
      actualId: json['actual_id'],
      attendanceDayId: json['attendance_day_id'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      hoursWorked: json['hours_worked'],
      overtimeHours: (json['overtime_hours'] as num?)?.toDouble(),
      createdBy: json['created_by'],
      creationDate: json['creation_date'],
      lastUpdatedBy: json['last_updated_by'],
      lastUpdateDate: json['last_update_date'],
      otRateTypeId: json['ot_rate_type_id'],
      otMultiplier: (json['ot_multiplier'] as num?)?.toDouble(),
      otConfigId: json['ot_config_id'],
      attendanceActualGuid: json['attendance_actual_guid'],
      enterpriseId: json['enterprise_id'],
      employeeId: json['employee_id'],
      attendanceDate: json['attendance_date'],
      attendanceStatus: json['attendance_status'],
      employeeName: json['employee_name_en'],
      orgUnitId: json['org_unit_id'],
      orgStructureList: (json['org_structure_list'] as List?)
          ?.map((e) => OrgStructureSummaryRecord.fromJson(e))
          .toList(),
    );
  }
}

class OrgStructureSummaryRecord {
  final int? level;
  final String? orgUnitId;
  final String? orgUnitCode;
  final String? orgUnitNameEn;
  final String? orgUnitNameAr;
  final String? levelCode;
  final String? status;
  final String? isActive;

  OrgStructureSummaryRecord({
    this.level,
    this.orgUnitId,
    this.orgUnitCode,
    this.orgUnitNameEn,
    this.orgUnitNameAr,
    this.levelCode,
    this.status,
    this.isActive,
  });

  factory OrgStructureSummaryRecord.fromJson(Map<String, dynamic> json) {
    return OrgStructureSummaryRecord(
      level: json['level'],
      orgUnitId: json['org_unit_id'],
      orgUnitCode: json['org_unit_code'],
      orgUnitNameEn: json['org_unit_name_en'],
      orgUnitNameAr: json['org_unit_name_ar'],
      levelCode: json['level_code'],
      status: json['status'],
      isActive: json['is_active'],
    );
  }
}
