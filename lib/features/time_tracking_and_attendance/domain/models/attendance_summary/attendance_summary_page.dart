import 'attendance_summary_record.dart';

class AttendanceSummaryPage {
  final List<AttendanceSummaryRecord> records;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const AttendanceSummaryPage({
    required this.records,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
