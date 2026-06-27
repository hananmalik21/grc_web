import 'package:grc/features/hiring/domain/models/job_postings/create_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/job_posting.dart';
import 'package:grc/features/hiring/domain/models/job_postings/activate_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/pause_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/update_job_posting_input.dart';

abstract class JobPostingsRepository {
  Future<Map<String, dynamic>> createJobPosting(CreateJobPostingInput input);

  Future<List<JobPosting>> getJobPostingsByRequisition({required int enterpriseId, required String requisitionGuid});

  Future<Map<String, dynamic>> pauseJobPosting(PauseJobPostingInput input);

  Future<Map<String, dynamic>> activateJobPosting(ActivateJobPostingInput input);

  Future<Map<String, dynamic>> updateJobPosting(UpdateJobPostingInput input);
}
