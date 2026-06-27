import 'package:grc/features/time_management/domain/models/pagination_info.dart';

/// Domain model for Timesheet entry
class Timesheet {
  final int id;
  final int employeeId;
  final DateTime date;
  final List<TimesheetEntry> entries;
  final double totalHours;
  final TimesheetStatus status;
  final String? notes;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final int? approvedBy;

  const Timesheet({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.entries,
    required this.totalHours,
    required this.status,
    this.notes,
    this.submittedAt,
    this.approvedAt,
    this.approvedBy,
  });
}

/// Domain model for Timesheet entry (task/project entry)
class TimesheetEntry {
  final int id;
  final int? projectId;
  final String? projectName;
  final int? taskId;
  final String? taskName;
  final double hours;
  final String? description;
  final DateTime date;

  const TimesheetEntry({
    required this.id,
    this.projectId,
    this.projectName,
    this.taskId,
    this.taskName,
    required this.hours,
    this.description,
    required this.date,
  });
}

/// Domain model for Timesheet overview
class TimesheetOverview {
  final int id;
  final int employeeId;
  final String employeeName;
  final DateTime date;
  final double totalHours;
  final TimesheetStatus status;
  final int entryCount;

  const TimesheetOverview({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.totalHours,
    required this.status,
    required this.entryCount,
  });
}

/// Timesheet status enum
enum TimesheetStatus { draft, submitted, approved, rejected }

/// Paginated timesheet response
class PaginatedTimesheets {
  final List<TimesheetOverview> timesheets;
  final PaginationInfo pagination;

  const PaginatedTimesheets({
    required this.timesheets,
    required this.pagination,
  });
}
