import '../models/attendance_summary/attendance_summary_page.dart';

abstract class AttendanceSummaryRepository {
  Future<AttendanceSummaryPage> getAttendanceSummaryRecords({
    required String companyId,
    String? orgUnitId,
    String? levelCode,
    String? date,
    String? fromDate,
    String? toDate,
    int? page,
    int? pageSize,
  });
}
