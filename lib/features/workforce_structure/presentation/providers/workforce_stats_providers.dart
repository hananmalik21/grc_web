import 'package:grc/features/workforce_structure/data/datasources/workforce_stats_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/workforce_stats_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:grc/features/workforce_structure/domain/repositories/workforce_stats_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_workforce_stats_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_families_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_levels_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_tree_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final workforceStatsRemoteDataSourceProvider = Provider<WorkforceStatsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkforceStatsRemoteDataSourceImpl(apiClient: apiClient);
});

final workforceStatsRepositoryProvider = Provider<WorkforceStatsRepository>((ref) {
  return WorkforceStatsRepositoryImpl(remoteDataSource: ref.read(workforceStatsRemoteDataSourceProvider));
});

final getWorkforceStatsUseCaseProvider = Provider<GetWorkforceStatsUseCase>((ref) {
  return GetWorkforceStatsUseCase(repository: ref.read(workforceStatsRepositoryProvider));
});

// State Provider using AsyncNotifier
final workforceStatsNotifierProvider = AsyncNotifierProvider<WorkforceStatsNotifier, WorkforceStats?>(() {
  return WorkforceStatsNotifier();
});

class WorkforceStatsNotifier extends AsyncNotifier<WorkforceStats?> {
  @override
  Future<WorkforceStats?> build() async {
    final useCase = ref.watch(getWorkforceStatsUseCaseProvider);
    final tabState = ref.watch(workforceTabStateProvider);
    final currentTab = _tabFromIndex(tabState.currentTabIndex);
    final tenantId = _enterpriseIdForTab(ref, currentTab);
    return await useCase(tenantId: tenantId);
  }

  WorkforceTab _tabFromIndex(int index) {
    final tabs = WorkforceTab.values;
    return (index >= 0 && index < tabs.length) ? tabs[index] : WorkforceTab.positions;
  }

  int? _enterpriseIdForTab(Ref ref, WorkforceTab tab) {
    switch (tab) {
      case WorkforceTab.positions:
        return ref.watch(positionsEnterpriseIdProvider);
      case WorkforceTab.jobFamilies:
        return ref.watch(jobFamiliesEnterpriseIdProvider);
      case WorkforceTab.jobLevels:
        return ref.watch(jobLevelsEnterpriseIdProvider);
      case WorkforceTab.gradeStructure:
        return ref.watch(gradeStructureEnterpriseIdProvider);
      case WorkforceTab.reportingStructure:
        return ref.watch(reportingStructureEnterpriseIdProvider);
      case WorkforceTab.positionTree:
        return ref.watch(positionTreeEnterpriseIdProvider);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final useCase = ref.read(getWorkforceStatsUseCaseProvider);
    final tabState = ref.read(workforceTabStateProvider);
    final currentTab = _tabFromIndex(tabState.currentTabIndex);
    final tenantId = _enterpriseIdForTab(ref, currentTab);
    state = await AsyncValue.guard(() => useCase(tenantId: tenantId));
  }
}

// Convenience provider to get the stats value
final workforceStatsProvider = Provider<WorkforceStats?>((ref) {
  final asyncValue = ref.watch(workforceStatsNotifierProvider);
  return asyncValue.value;
});
