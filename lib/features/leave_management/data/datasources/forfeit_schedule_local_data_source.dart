import 'package:grc/features/leave_management/domain/models/forfeit_schedule_entry.dart';

abstract class ForfeitScheduleLocalDataSource {
  List<ForfeitScheduleEntry> getForfeitScheduleEntries();
}

class ForfeitScheduleLocalDataSourceImpl implements ForfeitScheduleLocalDataSource {
  @override
  List<ForfeitScheduleEntry> getForfeitScheduleEntries() {
    return const [
      ForfeitScheduleEntry(
        id: '1',
        month: 'March',
        year: '2024',
        employeeCount: 12,
        totalDays: 48.5,
        status: ForfeitScheduleStatus.readyToProcess,
      ),
      ForfeitScheduleEntry(
        id: '2',
        month: 'April',
        year: '2024',
        employeeCount: 8,
        totalDays: 32.0,
        status: ForfeitScheduleStatus.scheduled,
      ),
      ForfeitScheduleEntry(
        id: '3',
        month: 'May',
        year: '2024',
        employeeCount: 15,
        totalDays: 67.5,
        status: ForfeitScheduleStatus.scheduled,
      ),
    ];
  }
}
