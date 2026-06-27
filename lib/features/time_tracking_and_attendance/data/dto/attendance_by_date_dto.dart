class AttendanceByDateDto {
  final AttendanceDayDto? attendanceDay;
  final ScheduleDto? schedule;
  final ActualDto? actual;

  const AttendanceByDateDto({this.attendanceDay, this.schedule, this.actual});

  factory AttendanceByDateDto.fromApiResponse(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null || data is! Map<String, dynamic>) return const AttendanceByDateDto();
    return AttendanceByDateDto.fromJson(data);
  }

  factory AttendanceByDateDto.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return const AttendanceByDateDto();
    return AttendanceByDateDto(
      attendanceDay: _parseAttendanceDay(json['attendance_day']),
      schedule: _parseSchedule(json['schedule']),
      actual: _parseActual(json['actual']),
    );
  }

  static AttendanceDayDto? _parseAttendanceDay(dynamic v) {
    if (v == null || v is! Map<String, dynamic>) return null;
    return AttendanceDayDto.fromJson(v);
  }

  static ScheduleDto? _parseSchedule(dynamic v) {
    if (v == null || v is! Map<String, dynamic>) return null;
    return ScheduleDto.fromJson(v);
  }

  static ActualDto? _parseActual(dynamic v) {
    if (v == null || v is! Map<String, dynamic>) return null;
    return ActualDto.fromJson(v);
  }
}

class AttendanceDayDto {
  final int attendanceDayId;
  final String attendanceDayGuid;
  final int enterpriseId;
  final int employeeId;
  final String attendanceDate;
  final String? attendanceStatus;
  final String? inState;
  final String? outState;

  const AttendanceDayDto({
    required this.attendanceDayId,
    required this.attendanceDayGuid,
    required this.enterpriseId,
    required this.employeeId,
    required this.attendanceDate,
    this.attendanceStatus,
    this.inState,
    this.outState,
  });

  factory AttendanceDayDto.fromJson(Map<String, dynamic> json) {
    return AttendanceDayDto(
      attendanceDayId: (json['attendance_day_id'] as num?)?.toInt() ?? 0,
      attendanceDayGuid: json['attendance_day_guid'] as String? ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      attendanceDate: json['attendance_date'] as String? ?? '',
      attendanceStatus: json['attendance_status'] as String?,
      inState: json['in_state'] as String?,
      outState: json['out_state'] as String?,
    );
  }
}

class ScheduleDto {
  final int scheduleId;
  final int attendanceDayId;
  final int workScheduleId;
  final String scheduleDate;
  final String? scheduleStartTime;
  final String? scheduleEndTime;
  final num? scheduledHours;
  final String? dayCategory;

  const ScheduleDto({
    required this.scheduleId,
    required this.attendanceDayId,
    required this.workScheduleId,
    required this.scheduleDate,
    this.scheduleStartTime,
    this.scheduleEndTime,
    this.scheduledHours,
    this.dayCategory,
  });

  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    return ScheduleDto(
      scheduleId: (json['schedule_id'] as num?)?.toInt() ?? 0,
      attendanceDayId: (json['attendance_day_id'] as num?)?.toInt() ?? 0,
      workScheduleId: (json['work_schedule_id'] as num?)?.toInt() ?? 0,
      scheduleDate: json['schedule_date'] as String? ?? '',
      scheduleStartTime: json['schedule_start_time'] as String?,
      scheduleEndTime: json['schedule_end_time'] as String?,
      scheduledHours: json['scheduled_hours'] as num?,
      dayCategory: json['day_category'] as String?,
    );
  }
}

class ActualDto {
  final int actualId;
  final int attendanceDayId;
  final String? checkInTime;
  final String? checkOutTime;
  final num? hoursWorked;
  final num? overtimeHours;

  const ActualDto({
    required this.actualId,
    required this.attendanceDayId,
    this.checkInTime,
    this.checkOutTime,
    this.hoursWorked,
    this.overtimeHours,
  });

  factory ActualDto.fromJson(Map<String, dynamic> json) {
    return ActualDto(
      actualId: (json['actual_id'] as num?)?.toInt() ?? 0,
      attendanceDayId: (json['attendance_day_id'] as num?)?.toInt() ?? 0,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      hoursWorked: json['hours_worked'] as num?,
      overtimeHours: json['overtime_hours'] as num?,
    );
  }
}
