import 'package:grc/features/hiring/domain/models/job_postings/update_job_posting_input.dart';
import 'package:grc/features/hiring/domain/repositories/job_postings_repository.dart';

class UpdateJobPostingUseCase {
  const UpdateJobPostingUseCase({required this.repository});

  final JobPostingsRepository repository;

  Future<Map<String, dynamic>> call(UpdateJobPostingInput input) {
    return repository.updateJobPosting(input);
  }
}
