import 'package:grc/features/hiring/domain/models/job_postings/create_job_posting_input.dart';
import 'package:grc/features/hiring/domain/repositories/job_postings_repository.dart';

class CreateJobPostingUseCase {
  const CreateJobPostingUseCase({required this.repository});

  final JobPostingsRepository repository;

  Future<Map<String, dynamic>> call(CreateJobPostingInput input) {
    return repository.createJobPosting(input);
  }
}
