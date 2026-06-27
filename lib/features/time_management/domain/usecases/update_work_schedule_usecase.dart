import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/domain/repositories/work_schedule_repository.dart';

class UpdateWorkScheduleUseCase {
  final WorkScheduleRepository repository;

  const UpdateWorkScheduleUseCase({required this.repository});

  Future<WorkSchedule> call({required int scheduleId, required Map<String, dynamic> data}) async {
    return await repository.updateWorkSchedule(scheduleId: scheduleId, data: data);
  }
}
