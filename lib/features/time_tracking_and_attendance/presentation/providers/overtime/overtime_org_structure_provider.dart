import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_screen_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/data/datasources/org_structure_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/org_structure_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_structure_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final overtimeOrgStructureApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final overtimeOrgStructureRemoteDataSourceProvider = Provider<OrgStructureRemoteDataSource>((ref) {
  final apiClient = ref.watch(overtimeOrgStructureApiClientProvider);
  return OrgStructureRemoteDataSourceImpl(apiClient: apiClient);
});

final overtimeOrgStructureRepositoryProvider = Provider<OrgStructureRepository>((ref) {
  return OrgStructureRepositoryImpl(remoteDataSource: ref.read(overtimeOrgStructureRemoteDataSourceProvider));
});

final overtimeGetActiveOrgStructureLevelsUseCaseProvider = Provider<GetActiveOrgStructureLevelsUseCase>((ref) {
  return GetActiveOrgStructureLevelsUseCase(repository: ref.read(overtimeOrgStructureRepositoryProvider));
});

class OvertimeOrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final String? error;

  const OvertimeOrgStructureState({this.orgStructure, this.isLoading = false, this.error});

  OvertimeOrgStructureState copyWith({OrgStructure? orgStructure, bool? isLoading, String? error}) {
    return OvertimeOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OvertimeOrgStructureNotifier extends StateNotifier<OvertimeOrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;
  final int? tenantId;

  OvertimeOrgStructureNotifier({required this.getActiveOrgStructureLevelsUseCase, this.tenantId})
    : super(const OvertimeOrgStructureState());

  Future<void> fetchOrgStructureLevels() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orgStructure = await getActiveOrgStructureLevelsUseCase(tenantId: tenantId);
      state = state.copyWith(orgStructure: orgStructure, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  List<OrgStructureLevel> get activeLevels => state.orgStructure?.activeLevels ?? [];
}

final overtimeOrgStructureNotifierProvider =
    StateNotifierProvider<OvertimeOrgStructureNotifier, OvertimeOrgStructureState>((ref) {
      final useCase = ref.read(overtimeGetActiveOrgStructureLevelsUseCaseProvider);
      final enterpriseId = ref.watch(overtimeScreenEnterpriseIdProvider);
      final notifier = OvertimeOrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: useCase,
        tenantId: enterpriseId,
      );
      if (enterpriseId != null) {
        Future.microtask(() => notifier.fetchOrgStructureLevels());
      }
      return notifier;
    });
