import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../../../../workforce_structure/data/datasources/org_structure_remote_datasource.dart';
import '../../../../workforce_structure/data/repositories/org_structure_repository_impl.dart';
import '../../../../workforce_structure/domain/models/org_structure_level.dart';
import '../../../../workforce_structure/domain/repositories/org_structure_repository.dart';
import '../../../../workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'attendance_summary_enterprise_provider.dart';

final attendanceSummaryOrgStructureApiClientProvider = Provider<ApiClient>((
  ref,
) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final attendanceSummaryOrgStructureRemoteDataSourceProvider =
    Provider<OrgStructureRemoteDataSource>((ref) {
      final apiClient = ref.watch(
        attendanceSummaryOrgStructureApiClientProvider,
      );
      return OrgStructureRemoteDataSourceImpl(apiClient: apiClient);
    });

final attendanceSummaryOrgStructureRepositoryProvider =
    Provider<OrgStructureRepository>((ref) {
      return OrgStructureRepositoryImpl(
        remoteDataSource: ref.read(
          attendanceSummaryOrgStructureRemoteDataSourceProvider,
        ),
      );
    });

final attendanceSummaryGetActiveOrgStructureLevelsUseCaseProvider =
    Provider<GetActiveOrgStructureLevelsUseCase>((ref) {
      return GetActiveOrgStructureLevelsUseCase(
        repository: ref.read(attendanceSummaryOrgStructureRepositoryProvider),
      );
    });

class AttendanceSummaryOrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final String? error;

  const AttendanceSummaryOrgStructureState({
    this.orgStructure,
    this.isLoading = false,
    this.error,
  });

  AttendanceSummaryOrgStructureState copyWith({
    OrgStructure? orgStructure,
    bool? isLoading,
    String? error,
  }) {
    return AttendanceSummaryOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AttendanceSummaryOrgStructureNotifier
    extends StateNotifier<AttendanceSummaryOrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;
  final int? tenantId;

  AttendanceSummaryOrgStructureNotifier({
    required this.getActiveOrgStructureLevelsUseCase,
    this.tenantId,
  }) : super(const AttendanceSummaryOrgStructureState());

  Future<void> fetchOrgStructureLevels() async {
    if (tenantId == null) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orgStructure = await getActiveOrgStructureLevelsUseCase(
        tenantId: tenantId,
      );
      state = state.copyWith(orgStructure: orgStructure, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  List<OrgStructureLevel> get activeLevels =>
      state.orgStructure?.activeLevels ?? [];
}

final attendanceSummaryOrgStructureNotifierProvider =
    StateNotifierProvider<
      AttendanceSummaryOrgStructureNotifier,
      AttendanceSummaryOrgStructureState
    >((ref) {
      final useCase = ref.read(
        attendanceSummaryGetActiveOrgStructureLevelsUseCaseProvider,
      );
      final enterpriseId = ref.watch(attendanceSummaryEnterpriseIdProvider);
      final notifier = AttendanceSummaryOrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: useCase,
        tenantId: enterpriseId,
      );
      if (enterpriseId != null) {
        Future.microtask(() => notifier.fetchOrgStructureLevels());
      }
      return notifier;
    });
