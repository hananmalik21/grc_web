import 'package:grc/features/hiring/application/requisition/providers/requisitions_api_providers.dart';
import 'package:grc/features/hiring/data/datasources/job_postings_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/job_postings_repository_impl.dart';
import 'package:grc/features/hiring/domain/repositories/job_postings_repository.dart';
import 'package:grc/features/hiring/domain/usecases/create_job_posting_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_job_postings_by_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/activate_job_posting_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/pause_job_posting_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/update_job_posting_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobPostingsRemoteDataSourceProvider = Provider<JobPostingsRemoteDataSource>((ref) {
  return JobPostingsRemoteDataSourceImpl(apiClient: ref.watch(requisitionsApiClientProvider));
});

final jobPostingsRepositoryProvider = Provider<JobPostingsRepository>((ref) {
  return JobPostingsRepositoryImpl(remoteDataSource: ref.watch(jobPostingsRemoteDataSourceProvider));
});

final createJobPostingUseCaseProvider = Provider<CreateJobPostingUseCase>((ref) {
  return CreateJobPostingUseCase(repository: ref.watch(jobPostingsRepositoryProvider));
});

final getJobPostingsByRequisitionUseCaseProvider = Provider<GetJobPostingsByRequisitionUseCase>((ref) {
  return GetJobPostingsByRequisitionUseCase(repository: ref.watch(jobPostingsRepositoryProvider));
});

final pauseJobPostingUseCaseProvider = Provider<PauseJobPostingUseCase>((ref) {
  return PauseJobPostingUseCase(repository: ref.watch(jobPostingsRepositoryProvider));
});

final activateJobPostingUseCaseProvider = Provider<ActivateJobPostingUseCase>((ref) {
  return ActivateJobPostingUseCase(repository: ref.watch(jobPostingsRepositoryProvider));
});

final updateJobPostingUseCaseProvider = Provider<UpdateJobPostingUseCase>((ref) {
  return UpdateJobPostingUseCase(repository: ref.watch(jobPostingsRepositoryProvider));
});
