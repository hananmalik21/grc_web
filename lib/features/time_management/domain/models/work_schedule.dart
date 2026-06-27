import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

/// Work schedule shift information
class WorkScheduleShift {
  final int shiftId;
  final String shiftCode;
  final String shiftNameEn;
  final String shiftNameAr;
  final int startMinutes;
  final int endMinutes;
  final double durationHours;
  final int breakHours;
  final int paidHours;
  final String shiftType;
  final String colorHex;
  final PositionStatus status;

  const WorkScheduleShift({
    required this.shiftId,
    required this.shiftCode,
    required this.shiftNameEn,
    required this.shiftNameAr,
    required this.startMinutes,
    required this.endMinutes,
    required this.durationHours,
    required this.breakHours,
    required this.paidHours,
    required this.shiftType,
    required this.colorHex,
    required this.status,
  });

  factory WorkScheduleShift.fromJson(Map<String, dynamic> json) {
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

    double parseDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed ?? defaultValue;
      }
      if (value is num) return value.toDouble();
      return defaultValue;
    }

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null || value == 'null') return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    final statusStr = parseString(json['status'], defaultValue: 'ACTIVE').toUpperCase();
    final status = statusStr == 'ACTIVE' ? PositionStatus.active : PositionStatus.inactive;

    return WorkScheduleShift(
      shiftId: parseInt(json['shift_id'], defaultValue: 0),
      shiftCode: parseString(json['shift_code']),
      shiftNameEn: parseString(json['shift_name_en']),
      shiftNameAr: parseString(json['shift_name_ar']),
      startMinutes: parseInt(json['start_minutes'], defaultValue: 0),
      endMinutes: parseInt(json['end_minutes'], defaultValue: 0),
      durationHours: parseDouble(json['duration_hours'], defaultValue: 0.0),
      breakHours: parseInt(json['break_hours'], defaultValue: 0),
      paidHours: parseInt(json['paid_hours'], defaultValue: 0),
      shiftType: parseString(json['shift_type']),
      colorHex: parseString(json['color_hex'], defaultValue: '#000000'),
      status: status,
    );
  }
}

/// Weekly line representing a day in the work schedule
class WorkScheduleWeeklyLine {
  final int workScheduleId;
  final int dayOfWeek;
  final String dayType;
  final WorkScheduleShift? shift;

  const WorkScheduleWeeklyLine({
    required this.workScheduleId,
    required this.dayOfWeek,
    required this.dayType,
    this.shift,
  });

  factory WorkScheduleWeeklyLine.fromJson(Map<String, dynamic> json) {
    final shiftJson = json['shift'] as Map<String, dynamic>?;
    final shift = shiftJson != null ? WorkScheduleShift.fromJson(shiftJson) : null;

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

    return WorkScheduleWeeklyLine(
      workScheduleId: parseInt(json['work_schedule_id'], defaultValue: 0),
      dayOfWeek: parseInt(json['day_of_week'], defaultValue: 0),
      dayType: parseString(json['day_type'], defaultValue: 'REST'),
      shift: shift,
    );
  }
}

/// Work schedule domain model
class WorkSchedule {
  final int workScheduleId;
  final int tenantId;
  final String scheduleCode;
  final String scheduleNameEn;
  final String scheduleNameAr;
  final int workPatternId;
  final String? patternNameEn;
  final String? patternNameAr;
  final DateTime effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String assignmentMode;
  final PositionStatus status;
  final String timeZone;
  final DateTime creationDate;
  final String createdBy;
  final DateTime lastUpdateDate;
  final String lastUpdatedBy;
  final List<WorkScheduleWeeklyLine> weeklyLines;

  const WorkSchedule({
    required this.workScheduleId,
    required this.tenantId,
    required this.scheduleCode,
    required this.scheduleNameEn,
    required this.scheduleNameAr,
    required this.workPatternId,
    this.patternNameEn,
    this.patternNameAr,
    required this.effectiveStartDate,
    this.effectiveEndDate,
    required this.assignmentMode,
    required this.status,
    this.timeZone = 'UTC',
    required this.creationDate,
    required this.createdBy,
    required this.lastUpdateDate,
    required this.lastUpdatedBy,
    required this.weeklyLines,
  });

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
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

    final statusStr = parseString(json['status'], defaultValue: 'ACTIVE').toUpperCase();
    final status = statusStr == 'ACTIVE' ? PositionStatus.active : PositionStatus.inactive;

    final weeklyLinesJson = json['weekly_lines'] as List<dynamic>? ?? [];
    final weeklyLines = weeklyLinesJson
        .map((line) => WorkScheduleWeeklyLine.fromJson(line as Map<String, dynamic>))
        .toList();

    final effectiveStartDate = parseDateTime(json['effective_start_date']);
    if (effectiveStartDate == null) {
      throw FormatException('effective_start_date is required');
    }

    return WorkSchedule(
      workScheduleId: parseInt(json['work_schedule_id'], defaultValue: 0),
      tenantId: parseInt(json['tenant_id'], defaultValue: 0),
      scheduleCode: parseString(json['schedule_code']),
      scheduleNameEn: parseString(json['schedule_name_en']),
      scheduleNameAr: parseString(json['schedule_name_ar']),
      workPatternId: parseInt(json['work_pattern_id'], defaultValue: 0),
      patternNameEn: json['pattern_name_en'] != null ? parseString(json['pattern_name_en']) : null,
      patternNameAr: json['pattern_name_ar'] != null ? parseString(json['pattern_name_ar']) : null,
      effectiveStartDate: effectiveStartDate,
      effectiveEndDate: parseDateTime(json['effective_end_date']),
      assignmentMode: parseString(json['assignment_mode']),
      status: status,
      timeZone: parseString(json['time_zone'], defaultValue: 'UTC'),
      creationDate: parseDateTime(json['creation_date']) ?? DateTime.now(),
      createdBy: parseString(json['created_by']),
      lastUpdateDate: parseDateTime(json['last_update_date']) ?? DateTime.now(),
      lastUpdatedBy: parseString(json['last_updated_by']),
      weeklyLines: weeklyLines,
    );
  }

  bool get isActive => status == PositionStatus.active;

  String get formattedStartDate {
    return '${effectiveStartDate.year}-${effectiveStartDate.month.toString().padLeft(2, '0')}-${effectiveStartDate.day.toString().padLeft(2, '0')}';
  }

  String get formattedEndDate {
    if (effectiveEndDate == null) return '';
    return '${effectiveEndDate!.year}-${effectiveEndDate!.month.toString().padLeft(2, '0')}-${effectiveEndDate!.day.toString().padLeft(2, '0')}';
  }

  String get year {
    return effectiveStartDate.year.toString();
  }

  Map<String, String> get weeklySchedule {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final schedule = <String, String>{};

    for (var line in weeklyLines) {
      if (line.dayOfWeek >= 1 && line.dayOfWeek <= 7) {
        final dayName = dayNames[line.dayOfWeek - 1];
        if (line.dayType == 'WORK' && line.shift != null) {
          schedule[dayName] = line.shift!.shiftNameEn;
        } else if (line.dayType == 'OFF') {
          schedule[dayName] = 'OFF';
        } else if (line.dayType == 'REST') {
          schedule[dayName] = 'REST';
        } else {
          schedule[dayName] = line.dayType.isEmpty ? '--' : line.dayType;
        }
      }
    }

    return schedule;
  }
}

class PaginatedWorkSchedules {
  final List<WorkSchedule> workSchedules;
  final PaginationInfo pagination;

  const PaginatedWorkSchedules({required this.workSchedules, required this.pagination});
}
