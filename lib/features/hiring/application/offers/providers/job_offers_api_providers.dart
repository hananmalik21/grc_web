import 'package:grc/features/hiring/application/requisition/providers/requisitions_api_providers.dart';
import 'package:grc/features/hiring/data/datasources/job_offers_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/job_offers_repository_impl.dart';
import 'package:grc/features/hiring/domain/repositories/job_offers_repository.dart';
import 'package:grc/features/hiring/domain/usecases/create_job_offer_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_job_offers_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/perform_job_offer_status_action_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobOffersRemoteDataSourceProvider = Provider<JobOffersRemoteDataSource>((ref) {
  return JobOffersRemoteDataSourceImpl(apiClient: ref.watch(requisitionsApiClientProvider));
});

final jobOffersRepositoryProvider = Provider<JobOffersRepository>((ref) {
  return JobOffersRepositoryImpl(remoteDataSource: ref.watch(jobOffersRemoteDataSourceProvider));
});

final createJobOfferUseCaseProvider = Provider<CreateJobOfferUseCase>((ref) {
  return CreateJobOfferUseCase(repository: ref.watch(jobOffersRepositoryProvider));
});

final getJobOffersUseCaseProvider = Provider<GetJobOffersUseCase>((ref) {
  return GetJobOffersUseCase(repository: ref.watch(jobOffersRepositoryProvider));
});

final performJobOfferStatusActionUseCaseProvider = Provider<PerformJobOfferStatusActionUseCase>((ref) {
  return PerformJobOfferStatusActionUseCase(repository: ref.watch(jobOffersRepositoryProvider));
});
