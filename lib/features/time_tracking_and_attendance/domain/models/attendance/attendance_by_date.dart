/// Domain model for attendance data fetched by date (for form pre-filling)
class AttendanceByDate {
  final int attendanceDayId;
  final String? attendanceStatus;
  final String? inState;
  final String? outState;
  final DateTime? scheduleStartTime;
  final DateTime? scheduleEndTime;
  final double? scheduledHours;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double? hoursWorked;
  final double? overtimeHours;

  const AttendanceByDate({
    required this.attendanceDayId,
    this.attendanceStatus,
    this.inState,
    this.outState,
    this.scheduleStartTime,
    this.scheduleEndTime,
    this.scheduledHours,
    this.checkInTime,
    this.checkOutTime,
    this.hoursWorked,
    this.overtimeHours,
  });
}
