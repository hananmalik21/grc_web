import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_page.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_stats.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';

/// Repository interface for timesheet operations
abstract class TimesheetRepository {
  Future<TimesheetPage> getTimesheets({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? searchQuery,
    TimesheetStatus? status,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  });

  Future<TimesheetStats> getTimesheetStatistics({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
  });

  /// Gets timesheet by ID
  Future<Timesheet> getTimesheetById(int timesheetId);

  /// Creates a new timesheet
  Future<Timesheet> createTimesheet(Map<String, dynamic> timesheetData);

  Future<Timesheet> updateTimesheet(String timesheetGuid, Map<String, dynamic> timesheetData);

  /// Submits a timesheet for approval
  Future<Timesheet> submitTimesheet(int timesheetId);

  Future<void> approveTimesheet(String timesheetGuid);

  Future<void> rejectTimesheet(String timesheetGuid, {required String rejectReason});

  /// Deletes a timesheet
  Future<void> deleteTimesheet(int timesheetId);
}
