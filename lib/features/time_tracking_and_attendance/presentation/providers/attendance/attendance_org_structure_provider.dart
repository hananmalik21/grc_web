import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_screen_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/data/datasources/org_structure_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/org_structure_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_structure_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceOrgStructureApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final attendanceOrgStructureRemoteDataSourceProvider = Provider<OrgStructureRemoteDataSource>((ref) {
  final apiClient = ref.watch(attendanceOrgStructureApiClientProvider);
  return OrgStructureRemoteDataSourceImpl(apiClient: apiClient);
});

final attendanceOrgStructureRepositoryProvider = Provider<OrgStructureRepository>((ref) {
  return OrgStructureRepositoryImpl(remoteDataSource: ref.read(attendanceOrgStructureRemoteDataSourceProvider));
});

final attendanceGetActiveOrgStructureLevelsUseCaseProvider = Provider<GetActiveOrgStructureLevelsUseCase>((ref) {
  return GetActiveOrgStructureLevelsUseCase(repository: ref.read(attendanceOrgStructureRepositoryProvider));
});

class AttendanceOrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final String? error;

  const AttendanceOrgStructureState({this.orgStructure, this.isLoading = false, this.error});

  AttendanceOrgStructureState copyWith({OrgStructure? orgStructure, bool? isLoading, String? error}) {
    return AttendanceOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AttendanceOrgStructureNotifier extends StateNotifier<AttendanceOrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;
  final int? tenantId;

  AttendanceOrgStructureNotifier({required this.getActiveOrgStructureLevelsUseCase, this.tenantId})
    : super(const AttendanceOrgStructureState());

  Future<void> fetchOrgStructureLevels() async {
    if (tenantId == null) return;
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

final attendanceOrgStructureNotifierProvider =
    StateNotifierProvider<AttendanceOrgStructureNotifier, AttendanceOrgStructureState>((ref) {
      final useCase = ref.read(attendanceGetActiveOrgStructureLevelsUseCaseProvider);
      final enterpriseId = ref.watch(attendanceScreenEnterpriseIdProvider);
      final notifier = AttendanceOrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: useCase,
        tenantId: enterpriseId,
      );
      if (enterpriseId != null) {
        Future.microtask(() => notifier.fetchOrgStructureLevels());
      }
      return notifier;
    });
