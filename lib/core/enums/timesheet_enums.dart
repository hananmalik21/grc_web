import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';

const List<TimesheetStatus?> timesheetStatusFilterItems = <TimesheetStatus?>[
  null,
  TimesheetStatus.submitted,
  TimesheetStatus.approved,
  TimesheetStatus.rejected,
];
