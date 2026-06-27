import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_stats.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/repositories/timesheet_repository.dart';

class GetTimesheetStatisticsUseCase {
  final TimesheetRepository repository;

  const GetTimesheetStatisticsUseCase({required this.repository});

  Future<TimesheetStats> call({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
  }) async {
    try {
      return await repository.getTimesheetStatistics(
        weekStartDate: weekStartDate,
        weekEndDate: weekEndDate,
        employeeNumber: employeeNumber,
        companyId: companyId,
        divisionId: divisionId,
        departmentId: departmentId,
        sectionId: sectionId,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get timesheet statistics: ${e.toString()}', originalError: e);
    }
  }
}
