import 'package:grc/features/hiring/domain/models/job_postings/job_posting.dart';
import 'package:grc/features/hiring/domain/repositories/job_postings_repository.dart';

class GetJobPostingsByRequisitionUseCase {
  const GetJobPostingsByRequisitionUseCase({required this.repository});

  final JobPostingsRepository repository;

  Future<List<JobPosting>> call({required int enterpriseId, required String requisitionGuid}) {
    return repository.getJobPostingsByRequisition(enterpriseId: enterpriseId, requisitionGuid: requisitionGuid);
  }
}
