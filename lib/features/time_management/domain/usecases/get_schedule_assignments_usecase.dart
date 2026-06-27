import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/domain/repositories/schedule_assignment_repository.dart';

class GetScheduleAssignmentsUseCase {
  final ScheduleAssignmentRepository repository;

  const GetScheduleAssignmentsUseCase({required this.repository});

  Future<PaginatedScheduleAssignments> call({required int tenantId, int page = 1, int pageSize = 10}) async {
    return await repository.getScheduleAssignments(tenantId: tenantId, page: page, pageSize: pageSize);
  }
}
