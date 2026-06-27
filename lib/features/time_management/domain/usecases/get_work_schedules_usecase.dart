import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/domain/repositories/work_schedule_repository.dart';

class GetWorkSchedulesUseCase {
  final WorkScheduleRepository repository;

  const GetWorkSchedulesUseCase({required this.repository});

  Future<PaginatedWorkSchedules> call({int page = 1, int pageSize = 10}) async {
    return await repository.getWorkSchedules(page: page, pageSize: pageSize);
  }
}
