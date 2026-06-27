import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';

class AttendanceLogPage {
  final List<AttendanceRecord> records;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const AttendanceLogPage({
    required this.records,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
