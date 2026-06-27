import 'package:grc/features/workforce_structure/data/datasources/org_unit_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/org_unit_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_unit_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orgUnitRemoteDataSourceProvider = Provider<OrgUnitRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrgUnitRemoteDataSourceImpl(apiClient: apiClient);
});

final orgUnitRepositoryProvider = Provider<OrgUnitRepository>((ref) {
  return OrgUnitRepositoryImpl(remoteDataSource: ref.read(orgUnitRemoteDataSourceProvider));
});

final getOrgUnitsByLevelUseCaseProvider = Provider<GetOrgUnitsByLevelUseCase>((ref) {
  return GetOrgUnitsByLevelUseCase(repository: ref.read(orgUnitRepositoryProvider));
});

final enterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<
      EnterpriseSelectionNotifier,
      EnterpriseSelectionState,
      ({List<OrgStructureLevel> levels, String structureId})
    >((ref, params) {
      final tenantId = ref.watch(positionsEnterpriseIdProvider);
      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: params.levels,
        structureId: params.structureId,
        tenantId: tenantId,
      );
    });
