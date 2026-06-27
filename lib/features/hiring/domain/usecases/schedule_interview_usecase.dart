import 'package:grc/features/hiring/domain/models/candidates/schedule_interview_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class ScheduleInterviewUseCase {
  const ScheduleInterviewUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(ScheduleInterviewInput input) {
    return repository.scheduleInterview(input);
  }
}
