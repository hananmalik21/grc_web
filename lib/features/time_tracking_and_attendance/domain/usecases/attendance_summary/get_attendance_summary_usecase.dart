import '../../models/attendance_summary/attendance_summary_page.dart';
import '../../repositories/attendance_summary_repository.dart';

class GetAttendanceSummaryUseCase {
  final AttendanceSummaryRepository repository;

  GetAttendanceSummaryUseCase({required this.repository});

  Future<AttendanceSummaryPage> call({
    required String companyId,
    String? orgUnitId,
    String? levelCode,
    String? date,
    String? fromDate,
    String? toDate,
    int? page,
    int? pageSize,
  }) async {
    return await repository.getAttendanceSummaryRecords(
      companyId: companyId,
      orgUnitId: orgUnitId,
      levelCode: levelCode,
      date: date,
      fromDate: fromDate,
      toDate: toDate,
      page: page,
      pageSize: pageSize,
    );
  }
}
