import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_by_date.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_log_page.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/manual_attendance_request.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendance({
    required DateTime fromDate,
    required DateTime toDate,
    String? companyId,
    String? orgUnitId,
    String? levelCode,
    String? employeeNumber,
  });

  Future<AttendanceLogPage> getAttendanceLogs({
    required int enterpriseId,
    int page = 1,
    int pageSize = 25,
    DateTime? fromDate,
    DateTime? toDate,
    String? orgUnitId,
    String? levelCode,
    String? employeeNumber,
  });

  Future<AttendanceByDate?> getAttendanceByDate({
    required int enterpriseId,
    required int employeeId,
    required DateTime attendanceDate,
  });

  Future<int?> getAttendanceDayIdForEmployeeDate({
    required int enterpriseId,
    required String employeeNumber,
    required DateTime date,
  });

  Future<void> submitManualAttendance(ManualAttendanceRequest request);
}
