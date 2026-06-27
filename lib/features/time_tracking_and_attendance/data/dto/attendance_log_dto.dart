import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';

class AttendanceLogPaginationDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const AttendanceLogPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory AttendanceLogPaginationDto.fromJson(Map<String, dynamic> json) {
    return AttendanceLogPaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 25,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }
}

class AttendanceLogItemDto {
  final int attendanceDayId;
  final String attendanceDayGuid;
  final int enterpriseId;
  final int employeeId;
  final String attendanceDate;
  final String? attendanceStatus;
  final String? inState;
  final String? outState;
  final String employeeName;
  final String employeeNumber;
  final List<Map<String, dynamic>> orgStructureList;
  final Map<String, dynamic>? scheduleObj;
  final Map<String, dynamic>? actualObj;

  const AttendanceLogItemDto({
    required this.attendanceDayId,
    required this.attendanceDayGuid,
    required this.enterpriseId,
    required this.employeeId,
    required this.attendanceDate,
    this.attendanceStatus,
    this.inState,
    this.outState,
    required this.employeeName,
    required this.employeeNumber,
    required this.orgStructureList,
    this.scheduleObj,
    this.actualObj,
  });

  factory AttendanceLogItemDto.fromJson(Map<String, dynamic> json) {
    final actualObj = json['actual_obj'];
    return AttendanceLogItemDto(
      attendanceDayId: (json['attendance_day_id'] as num?)?.toInt() ?? 0,
      attendanceDayGuid: json['attendance_day_guid'] as String? ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      attendanceDate: json['attendance_date'] as String? ?? '',
      attendanceStatus: json['attendance_status'] as String?,
      inState: json['in_state'] as String?,
      outState: json['out_state'] as String?,
      employeeName: json['employee_name'] as String? ?? '',
      employeeNumber: json['employee_number'] as String? ?? '',
      orgStructureList: (json['org_structure_list'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().toList(),
      scheduleObj: json['schedule_obj'] as Map<String, dynamic>?,
      actualObj: actualObj is Map<String, dynamic> && actualObj.isNotEmpty ? actualObj : null,
    );
  }

  String _getDepartmentName() {
    for (final unit in orgStructureList) {
      if (unit['level_code'] == 'DEPARTMENT') {
        return unit['org_unit_name_en'] as String? ?? '';
      }
    }
    return '';
  }

  String? _formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      final dt = DateTime.parse(isoString);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return null;
    }
  }

  String? _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      final dt = DateTime.parse(isoString);
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final day = days[dt.weekday - 1];
      final month = _monthName(dt.month);
      return '$day, $month ${dt.day}, ${dt.year}';
    } catch (_) {
      return null;
    }
  }

  String _monthName(int month) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return names[month - 1];
  }

  String? _formatDateAtTime(String? dateIso, String? timeIso) {
    if (dateIso == null || dateIso.isEmpty) return null;
    try {
      final dt = DateTime.parse(dateIso);
      final month = _monthName(dt.month);
      String timePart = '';
      if (timeIso != null && timeIso.isNotEmpty) {
        try {
          final t = DateTime.parse(timeIso);
          timePart = ' @ ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
        } catch (_) {}
      }
      return '$month ${dt.day}$timePart';
    } catch (_) {
      return null;
    }
  }

  String? _formatDuration(num? hours) {
    if (hours == null) return null;
    if (hours >= 1) {
      final h = hours.floor();
      final m = ((hours - h) * 60).round();
      if (m > 0) return '${h}h ${m}m';
      return '$h hour${h == 1 ? '' : 's'}';
    }
    final m = (hours * 60).round();
    return '${m}m';
  }

  String _resolveStatus() {
    if (attendanceStatus != null && attendanceStatus!.isNotEmpty) {
      switch (attendanceStatus!.toUpperCase()) {
        case 'PRESENT':
          return 'Present';
        case 'MISSING_OUT':
          return 'Missing Out';
        case 'ABSENT':
          return 'Absent';
        case 'ON_LEAVE':
        case 'ON LEAVE':
          return 'On Leave';
        case 'LATE':
          return 'Late';
        case 'EARLY':
          return 'Early';
        case 'HALF_DAY':
        case 'HALF DAY':
          return 'Half Day';
        default:
          break;
      }
    }
    if (inState != null || outState != null) {
      final inUpper = inState?.toUpperCase() ?? '';
      final outUpper = outState?.toUpperCase() ?? '';
      if (inUpper.contains('LATE') || outUpper.contains('LATE')) return 'Late';
      if (inUpper.contains('EARLY')) return 'Early';
      if (inUpper.contains('ON-TIME') || inUpper.contains('ONTIME')) return 'Present';
      if (outUpper.contains('MISSING')) return 'Missing Out';
    }
    return '-';
  }

  String _avatarInitials() {
    final names = employeeName.trim().split(RegExp(r'\s+'));
    if (names.isEmpty) return '?';
    if (names.length == 1) return names[0].isNotEmpty ? names[0][0].toUpperCase() : '?';
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }

  AttendanceRecord toDomain() {
    String? checkIn;
    String? checkOut;
    String? hoursWorked;
    String? overtimeHours;
    if (actualObj != null) {
      checkIn = _formatTime(actualObj!['check_in_time'] as String?);
      checkOut = _formatTime(actualObj!['check_out_time'] as String?);
      final hw = actualObj!['hours_worked'];
      if (hw != null) {
        if (hw is num) {
          hoursWorked = _formatDuration(hw);
        } else if (hw is String && hw.isNotEmpty) {
          hoursWorked = hw;
        }
      }
      final ot = actualObj!['overtime_hours'];
      if (ot != null) {
        if (ot is num) {
          overtimeHours = _formatDuration(ot);
        } else if (ot is String && ot.isNotEmpty) {
          overtimeHours = ot;
        }
      }
    }

    String? scheduleDate;
    String? scheduleStartTime;
    String? scheduleEndTime;
    String? scheduledHours;
    DateTime? scheduleStartTimeAsDateTime;
    int? scheduledHoursAsInt;
    if (scheduleObj != null) {
      scheduleDate = _formatDate(scheduleObj!['schedule_date'] as String?);
      final start = scheduleObj!['schedule_start_time'] as String?;
      final end = scheduleObj!['schedule_end_time'] as String?;
      scheduleStartTime = _formatDateAtTime(scheduleObj!['schedule_date'] as String?, start);
      scheduleEndTime = _formatDateAtTime(scheduleObj!['schedule_date'] as String?, end);
      final sh = scheduleObj!['scheduled_hours'];
      if (sh != null) {
        if (sh is num) {
          scheduledHours = _formatDuration(sh);
          scheduledHoursAsInt = sh.toInt();
        } else if (sh is String && sh.isNotEmpty) {
          scheduledHours = sh;
          scheduledHoursAsInt = int.tryParse(sh);
        }
      }
      if (start != null && start.isNotEmpty) {
        try {
          scheduleStartTimeAsDateTime = DateTime.parse(start);
        } catch (_) {}
      }
    }

    DateTime date;
    try {
      date = DateTime.parse(attendanceDate);
    } catch (_) {
      date = DateTime.now();
    }

    DateTime? clockInDt;
    DateTime? clockOutDt;
    if (actualObj != null) {
      final cin = actualObj!['check_in_time'] as String?;
      final cout = actualObj!['check_out_time'] as String?;
      if (cin != null && cin.isNotEmpty) {
        try {
          clockInDt = DateTime.parse(cin);
        } catch (_) {}
      }
      if (cout != null && cout.isNotEmpty) {
        try {
          clockOutDt = DateTime.parse(cout);
        } catch (_) {}
      }
    }

    final statusStr = _resolveStatus();
    final attendance = Attendance(
      id: attendanceDayId,
      attendanceDayId: attendanceDayId,
      employeeId: employeeId,
      employeeName: employeeName,
      employeeNumber: employeeNumber,
      departmentName: _getDepartmentName(),
      date: date,
      clockIn: clockInDt,
      clockOut: clockOutDt,
      status: Attendance.parseStatus(statusStr),
      checkInLocation: null,
      checkOutLocation: null,
      workedHours: actualObj?['hours_worked'] is num ? (actualObj!['hours_worked'] as num).toDouble() : null,
      notes: null,
      createdAt: null,
      updatedAt: null,
    );

    return AttendanceRecord(
      employeeName: employeeName,
      employeeId: employeeNumber,
      departmentName: _getDepartmentName(),
      date: date,
      checkIn: checkIn,
      checkOut: checkOut,
      status: statusStr,
      avatarInitials: _avatarInitials(),
      attendance: attendance,
      attendanceDayId: attendanceDayId,
      scheduleDate: scheduleDate,
      scheduleStartTime: scheduleStartTime,
      scheduleEndTime: scheduleEndTime,
      scheduledHours: scheduledHours,
      scheduleStartTimeAsDateTime: scheduleStartTimeAsDateTime,
      scheduledHoursAsInt: scheduledHoursAsInt,
      hoursWorked: hoursWorked,
      overtimeHours: overtimeHours,
    );
  }
}

class AttendanceLogsResponseDto {
  final int enterpriseId;
  final AttendanceLogPaginationDto pagination;
  final List<AttendanceLogItemDto> items;

  const AttendanceLogsResponseDto({required this.enterpriseId, required this.pagination, required this.items});

  factory AttendanceLogsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null || data is! Map<String, dynamic>) {
      return const AttendanceLogsResponseDto(
        enterpriseId: 0,
        pagination: AttendanceLogPaginationDto(
          page: 1,
          pageSize: 25,
          total: 0,
          totalPages: 0,
          hasNext: false,
          hasPrevious: false,
        ),
        items: [],
      );
    }

    final paginationMap = data['pagination'] as Map<String, dynamic>?;
    final pagination = paginationMap != null
        ? AttendanceLogPaginationDto.fromJson(paginationMap)
        : const AttendanceLogPaginationDto(
            page: 1,
            pageSize: 25,
            total: 0,
            totalPages: 0,
            hasNext: false,
            hasPrevious: false,
          );

    final list = data['data'] as List<dynamic>? ?? [];
    final items = list.whereType<Map<String, dynamic>>().map((e) => AttendanceLogItemDto.fromJson(e)).toList();

    return AttendanceLogsResponseDto(
      enterpriseId: (data['enterprise_id'] as num?)?.toInt() ?? 0,
      pagination: pagination,
      items: items,
    );
  }
}
