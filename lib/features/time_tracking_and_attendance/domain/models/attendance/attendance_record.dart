import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';

class AttendanceRecord {
  final String employeeName;
  final String employeeId;
  final String departmentName;
  final DateTime date;
  final String? checkIn;
  final String? checkOut;
  final String status;
  final String avatarInitials;
  final Attendance? attendance;
  final int? attendanceDayId;

  final String? scheduleDate;
  final String? scheduleStartTime;
  final String? scheduleEndTime;
  final String? scheduledHours;
  final DateTime? scheduleStartTimeAsDateTime;
  final int? scheduledHoursAsInt;
  final String? hoursWorked;
  final String? overtimeHours;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? notes;

  AttendanceRecord({
    required this.employeeName,
    required this.employeeId,
    required this.departmentName,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    required this.avatarInitials,
    this.attendance,
    this.attendanceDayId,
    this.scheduleDate,
    this.scheduleStartTime,
    this.scheduleEndTime,
    this.scheduledHours,
    this.scheduleStartTimeAsDateTime,
    this.scheduledHoursAsInt,
    this.hoursWorked,
    this.overtimeHours,
    this.checkInLocation,
    this.checkOutLocation,
    this.notes,
  });

  static const String _placeholder = '--';

  String displayValue(String? value) => value != null && value.isNotEmpty ? value : _placeholder;

  factory AttendanceRecord.fromAttendance(Attendance attendance) {
    return AttendanceRecord(
      employeeName: attendance.employeeName,
      employeeId: attendance.employeeNumber,
      departmentName: attendance.departmentName,
      date: attendance.date,
      checkIn: attendance.formattedCheckIn,
      checkOut: attendance.formattedCheckOut,
      status: attendance.statusString,
      avatarInitials: attendance.avatarInitials,
      attendance: attendance,
      attendanceDayId: attendance.attendanceDayId,
    );
  }
}
