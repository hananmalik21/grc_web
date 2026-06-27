import 'package:grc/features/time_management/domain/repositories/schedule_assignment_repository.dart';

class DeleteScheduleAssignmentUseCase {
  final ScheduleAssignmentRepository repository;

  const DeleteScheduleAssignmentUseCase({required this.repository});

  Future<void> call({required int scheduleAssignmentId, required int tenantId, bool hard = true}) async {
    return await repository.deleteScheduleAssignment(
      scheduleAssignmentId: scheduleAssignmentId,
      tenantId: tenantId,
      hard: hard,
    );
  }
}
