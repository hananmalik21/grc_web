import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_stats.dart';

class TimesheetStatsDto {
  final int total;
  final int draft;
  final int submitted;
  final int approved;
  final int rejected;
  final num regHours;
  final num otHours;

  const TimesheetStatsDto({
    required this.total,
    required this.draft,
    required this.submitted,
    required this.approved,
    required this.rejected,
    required this.regHours,
    required this.otHours,
  });

  factory TimesheetStatsDto.fromJson(Map<String, dynamic> json) {
    return TimesheetStatsDto(
      total: _asInt(json['total']),
      draft: _asInt(json['draft']),
      submitted: _asInt(json['submitted']),
      approved: _asInt(json['approved']),
      rejected: _asInt(json['rejected']),
      regHours: _asNum(json['reg_hours']),
      otHours: _asNum(json['ot_hours']),
    );
  }

  TimesheetStats toDomain() {
    return TimesheetStats(
      total: total,
      draft: draft,
      submitted: submitted,
      approved: approved,
      rejected: rejected,
      regHours: regHours.toDouble(),
      otHours: otHours.toDouble(),
    );
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static num _asNum(dynamic v, {num fallback = 0}) {
    if (v == null) return fallback;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? fallback;
    return fallback;
  }
}
