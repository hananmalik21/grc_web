import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/hiring/data/datasources/candidates_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/candidates_repository_impl.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';
import 'package:grc/features/hiring/domain/usecases/create_candidate_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_candidate_by_guid_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_candidates_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/initiate_background_check_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/delete_candidate_assessment_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/delete_candidate_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/request_assessment_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/update_candidate_assessment_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/update_candidate_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/schedule_interview_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final candidatesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final candidatesRemoteDataSourceProvider = Provider<CandidatesRemoteDataSource>((ref) {
  return CandidatesRemoteDataSourceImpl(apiClient: ref.watch(candidatesApiClientProvider));
});

final candidatesRepositoryProvider = Provider<CandidatesRepository>((ref) {
  return CandidatesRepositoryImpl(remoteDataSource: ref.watch(candidatesRemoteDataSourceProvider));
});

final getCandidatesUseCaseProvider = Provider<GetCandidatesUseCase>((ref) {
  return GetCandidatesUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final getCandidateByGuidUseCaseProvider = Provider<GetCandidateByGuidUseCase>((ref) {
  return GetCandidateByGuidUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final createCandidateUseCaseProvider = Provider<CreateCandidateUseCase>((ref) {
  return CreateCandidateUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final updateCandidateUseCaseProvider = Provider<UpdateCandidateUseCase>((ref) {
  return UpdateCandidateUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final initiateBackgroundCheckUseCaseProvider = Provider<InitiateBackgroundCheckUseCase>((ref) {
  return InitiateBackgroundCheckUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final scheduleInterviewUseCaseProvider = Provider<ScheduleInterviewUseCase>((ref) {
  return ScheduleInterviewUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final requestAssessmentUseCaseProvider = Provider<RequestAssessmentUseCase>((ref) {
  return RequestAssessmentUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final deleteCandidateAssessmentUseCaseProvider = Provider<DeleteCandidateAssessmentUseCase>((ref) {
  return DeleteCandidateAssessmentUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final deleteCandidateUseCaseProvider = Provider<DeleteCandidateUseCase>((ref) {
  return DeleteCandidateUseCase(repository: ref.watch(candidatesRepositoryProvider));
});

final updateCandidateAssessmentUseCaseProvider = Provider<UpdateCandidateAssessmentUseCase>((ref) {
  return UpdateCandidateAssessmentUseCase(repository: ref.watch(candidatesRepositoryProvider));
});
