import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/hiring/data/datasources/interviews_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/interviews_repository_impl.dart';
import 'package:grc/features/hiring/domain/repositories/interviews_repository.dart';
import 'package:grc/features/hiring/domain/usecases/get_interviews_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/submit_interview_feedback_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/update_interview_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final interviewsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final interviewsRemoteDataSourceProvider = Provider<InterviewsRemoteDataSource>((ref) {
  return InterviewsRemoteDataSourceImpl(apiClient: ref.watch(interviewsApiClientProvider));
});

final interviewsRepositoryProvider = Provider<InterviewsRepository>((ref) {
  return InterviewsRepositoryImpl(remoteDataSource: ref.watch(interviewsRemoteDataSourceProvider));
});

final getInterviewsUseCaseProvider = Provider<GetInterviewsUseCase>((ref) {
  return GetInterviewsUseCase(repository: ref.watch(interviewsRepositoryProvider));
});

final submitInterviewFeedbackUseCaseProvider = Provider<SubmitInterviewFeedbackUseCase>((ref) {
  return SubmitInterviewFeedbackUseCase(repository: ref.watch(interviewsRepositoryProvider));
});

final updateInterviewUseCaseProvider = Provider<UpdateInterviewUseCase>((ref) {
  return UpdateInterviewUseCase(repository: ref.watch(interviewsRepositoryProvider));
});
