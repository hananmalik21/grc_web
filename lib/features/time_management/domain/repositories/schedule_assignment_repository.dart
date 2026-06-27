import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';

abstract class ScheduleAssignmentRepository {
  Future<PaginatedScheduleAssignments> getScheduleAssignments({required int tenantId, int page = 1, int pageSize = 10});
  Future<ScheduleAssignment> createScheduleAssignment({
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  });
  Future<ScheduleAssignment> updateScheduleAssignment({
    required int scheduleAssignmentId,
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  });
  Future<void> deleteScheduleAssignment({required int scheduleAssignmentId, required int tenantId, bool hard = true});
}
