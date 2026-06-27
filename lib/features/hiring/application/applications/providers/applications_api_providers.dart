import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/hiring/data/datasources/applications_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/applications_repository_impl.dart';
import 'package:grc/features/hiring/domain/repositories/applications_repository.dart';
import 'package:grc/features/hiring/domain/usecases/add_application_note_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/change_application_stage_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_application_detail_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_applications_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/reject_application_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final applicationsRemoteDataSourceProvider = Provider<ApplicationsRemoteDataSource>((ref) {
  return ApplicationsRemoteDataSourceImpl(apiClient: ref.watch(applicationsApiClientProvider));
});

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) {
  return ApplicationsRepositoryImpl(remoteDataSource: ref.watch(applicationsRemoteDataSourceProvider));
});

final getApplicationsUseCaseProvider = Provider<GetApplicationsUseCase>((ref) {
  return GetApplicationsUseCase(repository: ref.watch(applicationsRepositoryProvider));
});

final getApplicationDetailUseCaseProvider = Provider<GetApplicationDetailUseCase>((ref) {
  return GetApplicationDetailUseCase(repository: ref.watch(applicationsRepositoryProvider));
});

final changeApplicationStageUseCaseProvider = Provider<ChangeApplicationStageUseCase>((ref) {
  return ChangeApplicationStageUseCase(repository: ref.watch(applicationsRepositoryProvider));
});

final addApplicationNoteUseCaseProvider = Provider<AddApplicationNoteUseCase>((ref) {
  return AddApplicationNoteUseCase(repository: ref.watch(applicationsRepositoryProvider));
});

final rejectApplicationUseCaseProvider = Provider<RejectApplicationUseCase>((ref) {
  return RejectApplicationUseCase(repository: ref.watch(applicationsRepositoryProvider));
});
