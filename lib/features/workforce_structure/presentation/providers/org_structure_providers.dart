import 'package:grc/features/workforce_structure/data/datasources/org_structure_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/org_structure_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_structure_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_org_structures_by_enterprise_id_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final orgStructureRemoteDataSourceProvider = Provider<OrgStructureRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrgStructureRemoteDataSourceImpl(apiClient: apiClient);
});

final orgStructureRepositoryProvider = Provider<OrgStructureRepository>((ref) {
  return OrgStructureRepositoryImpl(remoteDataSource: ref.read(orgStructureRemoteDataSourceProvider));
});

final getActiveOrgStructureLevelsUseCaseProvider = Provider<GetActiveOrgStructureLevelsUseCase>((ref) {
  return GetActiveOrgStructureLevelsUseCase(repository: ref.read(orgStructureRepositoryProvider));
});

final getOrgStructuresByEnterpriseIdUseCaseProvider = Provider<GetOrgStructuresByEnterpriseIdUseCase>((ref) {
  return GetOrgStructuresByEnterpriseIdUseCase(repository: ref.read(orgStructureRepositoryProvider));
});

// State Notifier Provider
final orgStructureNotifierProvider = StateNotifierProvider<OrgStructureNotifier, OrgStructureState>((ref) {
  final tenantId = ref.watch(positionsEnterpriseIdProvider);
  return OrgStructureNotifier(
    getActiveOrgStructureLevelsUseCase: ref.read(getActiveOrgStructureLevelsUseCaseProvider),
    tenantId: tenantId,
  );
});

// Convenience Providers
final orgStructureLoadingProvider = Provider<bool>((ref) {
  return ref.watch(orgStructureNotifierProvider).isLoading;
});

final orgStructureErrorProvider = Provider<String?>((ref) {
  return ref.watch(orgStructureNotifierProvider).error;
});

final orgStructureActiveLevelsProvider = Provider((ref) {
  final orgStructure = ref.watch(orgStructureNotifierProvider).orgStructure;
  return orgStructure?.activeLevels ?? [];
});
