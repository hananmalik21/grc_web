import 'package:grc/features/hiring/domain/models/job_postings/activate_job_posting_input.dart';
import 'package:grc/features/hiring/domain/repositories/job_postings_repository.dart';

class ActivateJobPostingUseCase {
  const ActivateJobPostingUseCase({required this.repository});

  final JobPostingsRepository repository;

  Future<Map<String, dynamic>> call(ActivateJobPostingInput input) {
    return repository.activateJobPosting(input);
  }
}
