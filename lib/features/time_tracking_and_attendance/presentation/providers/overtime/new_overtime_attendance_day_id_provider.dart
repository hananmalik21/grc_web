import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../attendance/attendance_provider.dart';
import 'new_overtime_provider.dart';
import 'overtime_enterprise_provider.dart';

class NewOvertimeAttendanceResult {
  final int? attendanceDayId;
  final double? overtimeHours;

  const NewOvertimeAttendanceResult({this.attendanceDayId, this.overtimeHours});
}

final newOvertimeAttendanceDayIdProvider = FutureProvider.autoDispose<NewOvertimeAttendanceResult>((ref) async {
  final enterpriseId = ref.watch(overtimeEnterpriseIdProvider);
  final employeeIdAndDate = ref.watch(
    newOvertimeRequestProvider.select((s) => (s.selectedEmployee?.id, s.date?.toIso8601String().split('T').first)),
  );
  final (employeeId, dateStr) = employeeIdAndDate;

  if (enterpriseId == null || employeeId == null || dateStr == null) {
    return const NewOvertimeAttendanceResult();
  }

  final date = DateTime.tryParse(dateStr);
  if (date == null) return const NewOvertimeAttendanceResult();

  final repository = ref.watch(attendanceRepositoryProvider);
  final attendance = await repository.getAttendanceByDate(
    enterpriseId: enterpriseId,
    employeeId: employeeId,
    attendanceDate: date,
  );

  if (attendance == null || attendance.attendanceDayId <= 0) {
    return const NewOvertimeAttendanceResult();
  }
  return NewOvertimeAttendanceResult(
    attendanceDayId: attendance.attendanceDayId,
    overtimeHours: attendance.overtimeHours,
  );
});
