import 'package:grc/features/enterprise_structure/data/datasources/active_structure_stats_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/repositories/active_structure_stats_repository_impl.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_stats.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/active_structure_stats_repository.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_active_structure_stats_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_component_values_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeStructureStatsRemoteDataSourceProvider = Provider<ActiveStructureStatsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ActiveStructureStatsRemoteDataSourceImpl(apiClient: apiClient);
});

final activeStructureStatsRepositoryProvider = Provider<ActiveStructureStatsRepository>((ref) {
  return ActiveStructureStatsRepositoryImpl(remoteDataSource: ref.read(activeStructureStatsRemoteDataSourceProvider));
});

final getActiveStructureStatsUseCaseProvider = Provider<GetActiveStructureStatsUseCase>((ref) {
  return GetActiveStructureStatsUseCase(repository: ref.read(activeStructureStatsRepositoryProvider));
});

final activeStructureStatsNotifierProvider =
    AsyncNotifierProvider.autoDispose<ActiveStructureStatsNotifier, ActiveStructureStats?>(
      ActiveStructureStatsNotifier.new,
    );

class ActiveStructureStatsNotifier extends AutoDisposeAsyncNotifier<ActiveStructureStats?> {
  @override
  Future<ActiveStructureStats?> build() async {
    final enterpriseId = ref.watch(manageComponentValuesEnterpriseIdProvider);
    if (enterpriseId == null) return null;
    final useCase = ref.read(getActiveStructureStatsUseCaseProvider);
    return useCase(enterpriseId: enterpriseId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
