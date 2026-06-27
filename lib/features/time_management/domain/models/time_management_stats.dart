/// Time management statistics domain model
class TimeManagementStats {
  final int totalShifts;
  final int totalWorkPatterns;
  final int totalWorkSchedules;
  final int totalScheduleAssignments;

  const TimeManagementStats({
    required this.totalShifts,
    required this.totalWorkPatterns,
    required this.totalWorkSchedules,
    required this.totalScheduleAssignments,
  });

  String get formattedTotalShifts {
    return totalShifts == 0 ? '---' : totalShifts.toString();
  }

  String get formattedTotalWorkPatterns {
    return totalWorkPatterns == 0 ? '---' : totalWorkPatterns.toString();
  }

  String get formattedTotalWorkSchedules {
    return totalWorkSchedules == 0 ? '---' : totalWorkSchedules.toString();
  }

  String get formattedTotalScheduleAssignments {
    return totalScheduleAssignments == 0 ? '---' : totalScheduleAssignments.toString();
  }
}
