import 'package:grc/features/time_management/domain/repositories/work_schedule_repository.dart';

class DeleteWorkScheduleUseCase {
  final WorkScheduleRepository repository;

  const DeleteWorkScheduleUseCase({required this.repository});

  Future<void> call({required int scheduleId, bool hard = true}) async {
    return await repository.deleteWorkSchedule(scheduleId: scheduleId, hard: hard);
  }
}
