import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/hiring/data/datasources/talent_pools_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/talent_pools_repository_impl.dart';
import 'package:grc/features/hiring/domain/usecases/add_candidate_to_talent_pools_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/create_talent_pool_usecase.dart';
import 'package:grc/features/hiring/domain/repositories/talent_pools_repository.dart';
import 'package:grc/features/hiring/domain/usecases/get_talent_pools_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final talentPoolsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final talentPoolsRemoteDataSourceProvider = Provider<TalentPoolsRemoteDataSource>((ref) {
  return TalentPoolsRemoteDataSourceImpl(apiClient: ref.watch(talentPoolsApiClientProvider));
});

final talentPoolsRepositoryProvider = Provider<TalentPoolsRepository>((ref) {
  return TalentPoolsRepositoryImpl(remoteDataSource: ref.watch(talentPoolsRemoteDataSourceProvider));
});

final getTalentPoolsUseCaseProvider = Provider<GetTalentPoolsUseCase>((ref) {
  return GetTalentPoolsUseCase(repository: ref.watch(talentPoolsRepositoryProvider));
});

final createTalentPoolUseCaseProvider = Provider<CreateTalentPoolUseCase>((ref) {
  return CreateTalentPoolUseCase(repository: ref.watch(talentPoolsRepositoryProvider));
});

final addCandidateToTalentPoolsUseCaseProvider = Provider<AddCandidateToTalentPoolsUseCase>((ref) {
  return AddCandidateToTalentPoolsUseCase(repository: ref.watch(talentPoolsRepositoryProvider));
});
