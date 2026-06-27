import 'package:grc/features/hiring/data/datasources/job_postings_remote_data_source.dart';
import 'package:grc/features/hiring/domain/models/job_postings/create_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/job_posting.dart';
import 'package:grc/features/hiring/domain/models/job_postings/activate_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/pause_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/update_job_posting_input.dart';
import 'package:grc/features/hiring/domain/repositories/job_postings_repository.dart';

class JobPostingsRepositoryImpl implements JobPostingsRepository {
  const JobPostingsRepositoryImpl({required this.remoteDataSource});

  final JobPostingsRemoteDataSource remoteDataSource;

  @override
  Future<Map<String, dynamic>> createJobPosting(CreateJobPostingInput input) {
    return remoteDataSource.createJobPosting(input);
  }

  @override
  Future<List<JobPosting>> getJobPostingsByRequisition({
    required int enterpriseId,
    required String requisitionGuid,
  }) async {
    final page = await remoteDataSource.getJobPostingsByRequisition(
      enterpriseId: enterpriseId,
      requisitionGuid: requisitionGuid,
    );
    return page.toDomain();
  }

  @override
  Future<Map<String, dynamic>> pauseJobPosting(PauseJobPostingInput input) {
    return remoteDataSource.pauseJobPosting(input);
  }

  @override
  Future<Map<String, dynamic>> activateJobPosting(ActivateJobPostingInput input) {
    return remoteDataSource.activateJobPosting(input);
  }

  @override
  Future<Map<String, dynamic>> updateJobPosting(UpdateJobPostingInput input) {
    return remoteDataSource.updateJobPosting(input);
  }
}
