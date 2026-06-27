import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_screen_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/data/datasources/org_structure_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/org_structure_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_structure_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API client for timesheet org structure calls.
final timesheetOrgStructureApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

/// Remote data source for timesheet org structure.
final timesheetOrgStructureRemoteDataSourceProvider = Provider<OrgStructureRemoteDataSource>((ref) {
  final apiClient = ref.watch(timesheetOrgStructureApiClientProvider);
  return OrgStructureRemoteDataSourceImpl(apiClient: apiClient);
});

/// Repository for timesheet org structure.
final timesheetOrgStructureRepositoryProvider = Provider<OrgStructureRepository>((ref) {
  return OrgStructureRepositoryImpl(remoteDataSource: ref.read(timesheetOrgStructureRemoteDataSourceProvider));
});

/// Use case for fetching active org structure levels for timesheets.
final timesheetGetActiveOrgStructureLevelsUseCaseProvider = Provider<GetActiveOrgStructureLevelsUseCase>((ref) {
  return GetActiveOrgStructureLevelsUseCase(repository: ref.read(timesheetOrgStructureRepositoryProvider));
});

class TimesheetOrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final String? error;

  const TimesheetOrgStructureState({this.orgStructure, this.isLoading = false, this.error});

  TimesheetOrgStructureState copyWith({OrgStructure? orgStructure, bool? isLoading, String? error}) {
    return TimesheetOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TimesheetOrgStructureNotifier extends StateNotifier<TimesheetOrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;
  final int? tenantId;

  TimesheetOrgStructureNotifier({required this.getActiveOrgStructureLevelsUseCase, this.tenantId})
    : super(const TimesheetOrgStructureState());

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

  /// Get active levels sorted by display order.
  List<OrgStructureLevel> get activeLevels => state.orgStructure?.activeLevels ?? [];

  /// Check if a specific level code is active.
  bool hasLevel(String levelCode) {
    return activeLevels.any((level) => level.levelCode.toUpperCase() == levelCode.toUpperCase());
  }

  /// Get level by code.
  OrgStructureLevel? getLevelByCode(String levelCode) {
    try {
      return activeLevels.firstWhere((level) => level.levelCode.toUpperCase() == levelCode.toUpperCase());
    } catch (_) {
      return null;
    }
  }
}

/// State notifier provider used by the timesheet feature.
final timesheetOrgStructureNotifierProvider =
    StateNotifierProvider<TimesheetOrgStructureNotifier, TimesheetOrgStructureState>((ref) {
      final useCase = ref.read(timesheetGetActiveOrgStructureLevelsUseCaseProvider);
      final enterpriseId = ref.watch(timesheetScreenEnterpriseIdProvider);
      final notifier = TimesheetOrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: useCase,
        tenantId: enterpriseId,
      );
      if (enterpriseId != null) {
        Future.microtask(() => notifier.fetchOrgStructureLevels());
      }
      return notifier;
    });
