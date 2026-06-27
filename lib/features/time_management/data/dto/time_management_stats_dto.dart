import 'package:grc/features/time_management/domain/models/time_management_stats.dart';

/// DTO for Time Management Statistics from API
class TimeManagementStatsDto {
  final int totalShifts;
  final int totalWorkPatterns;
  final int totalWorkSchedules;
  final int totalScheduleAssignments;

  const TimeManagementStatsDto({
    required this.totalShifts,
    required this.totalWorkPatterns,
    required this.totalWorkSchedules,
    required this.totalScheduleAssignments,
  });

  factory TimeManagementStatsDto.fromJson(Map<String, dynamic> json) {
    return TimeManagementStatsDto(
      totalShifts: _asInt(json['total_shifts']),
      totalWorkPatterns: _asInt(json['total_work_patterns']),
      totalWorkSchedules: _asInt(json['total_work_schedules']),
      totalScheduleAssignments: _asInt(json['total_schedule_assignments']),
    );
  }

  TimeManagementStats toDomain() {
    return TimeManagementStats(
      totalShifts: totalShifts,
      totalWorkPatterns: totalWorkPatterns,
      totalWorkSchedules: totalWorkSchedules,
      totalScheduleAssignments: totalScheduleAssignments,
    );
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }
}
