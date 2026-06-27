import 'package:grc/features/time_management/domain/models/work_schedule.dart';

abstract class WorkScheduleRepository {
  Future<PaginatedWorkSchedules> getWorkSchedules({int page = 1, int pageSize = 10});
  Future<WorkSchedule> createWorkSchedule({required Map<String, dynamic> data});
  Future<WorkSchedule> updateWorkSchedule({required int scheduleId, required Map<String, dynamic> data});
  Future<void> deleteWorkSchedule({required int scheduleId, bool hard = true});
}
