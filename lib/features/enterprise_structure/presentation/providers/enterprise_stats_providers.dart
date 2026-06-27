import 'package:grc/features/enterprise_structure/data/datasources/enterprise_stats_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/repositories/enterprise_stats_repository_impl.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise_stats.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/enterprise_stats_repository.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_enterprise_stats_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_enterprise_structure_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final enterpriseStatsRemoteDataSourceProvider = Provider<EnterpriseStatsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EnterpriseStatsRemoteDataSourceImpl(apiClient: apiClient);
});

final enterpriseStatsRepositoryProvider = Provider<EnterpriseStatsRepository>((ref) {
  return EnterpriseStatsRepositoryImpl(remoteDataSource: ref.read(enterpriseStatsRemoteDataSourceProvider));
});

final getEnterpriseStatsUseCaseProvider = Provider<GetEnterpriseStatsUseCase>((ref) {
  return GetEnterpriseStatsUseCase(repository: ref.read(enterpriseStatsRepositoryProvider));
});

final enterpriseStatsNotifierProvider = AsyncNotifierProvider.autoDispose<EnterpriseStatsNotifier, EnterpriseStats?>(
  EnterpriseStatsNotifier.new,
);

class EnterpriseStatsNotifier extends AutoDisposeAsyncNotifier<EnterpriseStats?> {
  @override
  Future<EnterpriseStats?> build() async {
    final enterpriseId = ref.watch(manageEnterpriseStructureEnterpriseIdProvider);
    if (enterpriseId == null) return null;
    final useCase = ref.read(getEnterpriseStatsUseCaseProvider);
    return useCase(enterpriseId: enterpriseId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final enterpriseId = ref.read(manageEnterpriseStructureEnterpriseIdProvider);
      if (enterpriseId == null) return null;
      final useCase = ref.read(getEnterpriseStatsUseCaseProvider);
      return useCase(enterpriseId: enterpriseId);
    });
  }
}
