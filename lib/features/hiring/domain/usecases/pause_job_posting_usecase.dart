import 'package:grc/features/hiring/domain/models/job_postings/pause_job_posting_input.dart';
import 'package:grc/features/hiring/domain/repositories/job_postings_repository.dart';

class PauseJobPostingUseCase {
  const PauseJobPostingUseCase({required this.repository});

  final JobPostingsRepository repository;

  Future<Map<String, dynamic>> call(PauseJobPostingInput input) {
    return repository.pauseJobPosting(input);
  }
}
