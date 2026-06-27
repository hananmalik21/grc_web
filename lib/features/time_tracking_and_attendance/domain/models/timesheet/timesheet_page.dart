import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';

class TimesheetPage {
  final List<Timesheet> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const TimesheetPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
}
