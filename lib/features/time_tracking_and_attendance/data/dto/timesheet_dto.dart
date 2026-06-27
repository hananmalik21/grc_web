import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_line.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';

class TimesheetDto {
  final int timesheetId;
  final String timesheetGuid;
  final int enterpriseId;
  final int employeeId;
  final String? firstNameEn;
  final String? middleNameEn;
  final String? lastNameEn;
  final String employeeNumber;
  final List<Map<String, dynamic>> orgStructureList;
  final String weekStartDate;
  final String weekEndDate;
  final String statusCode;
  final String? description;
  final List<Map<String, dynamic>> timesheetLines;
  final String? creationDate;
  final String? lastUpdateDate;
  final String? submittedDate;
  final String? approvedDate;
  final String? rejectedDate;
  final String? rejectReason;

  const TimesheetDto({
    required this.timesheetId,
    required this.timesheetGuid,
    required this.enterpriseId,
    required this.employeeId,
    required this.firstNameEn,
    required this.middleNameEn,
    required this.lastNameEn,
    required this.employeeNumber,
    required this.orgStructureList,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.statusCode,
    this.description,
    required this.timesheetLines,
    required this.creationDate,
    required this.lastUpdateDate,
    required this.submittedDate,
    required this.approvedDate,
    required this.rejectedDate,
    required this.rejectReason,
  });

  factory TimesheetDto.fromJson(Map<String, dynamic> json) {
    return TimesheetDto(
      timesheetId: (json['timesheet_id'] as num?)?.toInt() ?? 0,
      timesheetGuid: json['timesheet_guid'] as String? ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      firstNameEn: json['first_name_en'] as String?,
      middleNameEn: json['middle_name_en'] as String?,
      lastNameEn: json['last_name_en'] as String?,
      employeeNumber: json['employee_number'] as String? ?? '',
      orgStructureList: (json['org_structure_list'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().toList(),
      weekStartDate: json['week_start_date'] as String? ?? '',
      weekEndDate: json['week_end_date'] as String? ?? '',
      statusCode: json['status_code'] as String? ?? 'DRAFT',
      description: json['description'] as String?,
      timesheetLines: (json['timesheet_lines'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().toList(),
      creationDate: json['creation_date'] as String?,
      lastUpdateDate: json['last_update_date'] as String?,
      submittedDate: json['submitted_date'] as String?,
      approvedDate: json['approved_date'] as String?,
      rejectedDate: json['rejected_date'] as String?,
      rejectReason: json['reject_reason'] as String?,
    );
  }

  Timesheet toDomain() {
    final regularHours = timesheetLines
        .map((l) => (l['regular_hours'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (a, b) => a + b);

    final overtimeHours = timesheetLines
        .map((l) => (l['ot_hours'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (a, b) => a + b);

    final totalHours = regularHours + overtimeHours;

    final employeeName = [
      firstNameEn?.trim() ?? '',
      middleNameEn?.trim() ?? '',
      lastNameEn?.trim() ?? '',
    ].where((p) => p.isNotEmpty).join(' ');

    final companyName = _orgNameByLevel(orgStructureList, 'COMPANY');
    final divisionName = _orgNameByLevel(orgStructureList, 'DIVISION');
    final departmentName = _orgNameByLevel(orgStructureList, 'DEPARTMENT');

    final lines = timesheetLines.map(_lineFromMap).toList();

    return Timesheet(
      id: timesheetId,
      guid: timesheetGuid,
      employeeId: employeeId,
      employeeName: employeeName,
      employeeNumber: employeeNumber,
      departmentName: departmentName,
      companyName: companyName.isEmpty ? null : companyName,
      divisionName: divisionName.isEmpty ? null : divisionName,
      weekStartDate: DateTime.parse(weekStartDate),
      weekEndDate: DateTime.parse(weekEndDate),
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      totalHours: totalHours,
      status: _mapStatus(statusCode),
      description: description,
      createdAt: _parseDate(creationDate),
      updatedAt: _parseDate(lastUpdateDate),
      submittedAt: _parseDate(submittedDate),
      approvedAt: _parseDate(approvedDate),
      rejectedAt: _parseDate(rejectedDate),
      rejectionReason: rejectReason,
      lines: lines,
    );
  }

  static String _orgNameByLevel(List<Map<String, dynamic>> orgStructureList, String levelCode) {
    for (final s in orgStructureList) {
      final code = (s['level_code'] as String?)?.toUpperCase();
      if (code == levelCode) {
        return (s['org_unit_name_en'] as String?) ?? (s['org_unit_name'] as String?) ?? '';
      }
    }
    return '';
  }

  static TimesheetLine _lineFromMap(Map<String, dynamic> l) {
    final workDate = l['work_date'] as String? ?? '';
    final taskText = (l['project_task_text'] ?? l['line_notes']) as String? ?? '';
    return TimesheetLine(
      workDate: workDate,
      projectId: (l['project_id'] as num?)?.toInt(),
      taskId: (l['task_id'] as num?)?.toInt(),
      taskText: taskText,
      regularHours: (l['regular_hours'] as num?)?.toDouble() ?? 0.0,
      overtimeHours: (l['ot_hours'] as num?)?.toDouble() ?? 0.0,
      lineId: (l['line_id'] as num?)?.toInt(),
      projectName: l['project_name'] as String?,
    );
  }

  TimesheetStatus _mapStatus(String code) {
    switch (code.toUpperCase()) {
      case 'DRAFT':
        return TimesheetStatus.draft;
      case 'SUBMITTED':
      case 'PENDING':
        return TimesheetStatus.submitted;
      case 'APPROVED':
        return TimesheetStatus.approved;
      case 'REJECTED':
        return TimesheetStatus.rejected;
      case 'WITHDRAWN':
        return TimesheetStatus.withdrawn;
      default:
        return TimesheetStatus.draft;
    }
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}
