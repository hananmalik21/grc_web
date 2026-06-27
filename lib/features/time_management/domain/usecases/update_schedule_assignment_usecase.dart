import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/domain/repositories/schedule_assignment_repository.dart';

class UpdateScheduleAssignmentUseCase {
  final ScheduleAssignmentRepository repository;

  const UpdateScheduleAssignmentUseCase({required this.repository});

  Future<ScheduleAssignment> call({
    required int scheduleAssignmentId,
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  }) async {
    return await repository.updateScheduleAssignment(
      scheduleAssignmentId: scheduleAssignmentId,
      tenantId: tenantId,
      assignmentData: assignmentData,
    );
  }
}
