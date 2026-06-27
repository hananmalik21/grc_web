import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/workforce_structure/data/datasources/org_unit_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/org_unit_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Security-manager-owned infrastructure providers — isolated from other modules.

final _smApiClientProvider = Provider<ApiClient>((ref) => ApiClient(baseUrl: ApiConfig.baseUrl));

final _smOrgUnitDataSourceProvider = Provider<OrgUnitRemoteDataSource>((ref) {
  return OrgUnitRemoteDataSourceImpl(apiClient: ref.read(_smApiClientProvider));
});

final _smGetOrgUnitsByLevelUseCaseProvider = Provider<GetOrgUnitsByLevelUseCase>((ref) {
  return GetOrgUnitsByLevelUseCase(
    repository: OrgUnitRepositoryImpl(remoteDataSource: ref.read(_smOrgUnitDataSourceProvider)),
  );
});

// ---------------------------------------------------------------------------

class OrgLevelPickerState {
  const OrgLevelPickerState({
    this.options = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 10,
    this.hasNext = false,
    this.hasPrevious = false,
    this.searchQuery = '',
  });

  final List<OrgUnit> options;
  final bool isLoading;
  final String? error;
  final int page;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;
  final String searchQuery;

  OrgLevelPickerState copyWith({
    List<OrgUnit>? options,
    bool? isLoading,
    String? error,
    bool clearError = false,
    int? page,
    int? totalPages,
    int? totalItems,
    int? pageSize,
    bool? hasNext,
    bool? hasPrevious,
    String? searchQuery,
  }) {
    return OrgLevelPickerState(
      options: options ?? this.options,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class OrgLevelPickerNotifier extends StateNotifier<OrgLevelPickerState> {
  OrgLevelPickerNotifier({
    required this.useCase,
    required this.structureId,
    required this.levelCode,
    required this.parentUnitId,
    this.tenantId,
  }) : super(const OrgLevelPickerState());

  final GetOrgUnitsByLevelUseCase useCase;
  final String structureId;
  final String levelCode;
  final String? parentUnitId;
  final int? tenantId;
  final _debouncer = Debouncer();

  Future<void> loadOptions() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await useCase(
        structureId: structureId,
        levelCode: levelCode,
        parentOrgUnitId: parentUnitId,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        tenantId: tenantId,
        page: 1,
        pageSize: 10,
      );
      final active = response.data.where((u) => u.isActive).toList();
      state = state.copyWith(
        options: active,
        isLoading: false,
        page: response.page,
        totalPages: response.totalPages,
        totalItems: response.total,
        pageSize: response.pageSize,
        hasNext: response.hasNext,
        hasPrevious: response.hasPrevious,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> goToPage(int page) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await useCase(
        structureId: structureId,
        levelCode: levelCode,
        parentOrgUnitId: parentUnitId,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        tenantId: tenantId,
        page: page,
        pageSize: 10,
      );
      final active = response.data.where((u) => u.isActive).toList();
      state = state.copyWith(
        options: active,
        isLoading: false,
        page: response.page,
        totalPages: response.totalPages,
        totalItems: response.total,
        pageSize: response.pageSize,
        hasNext: response.hasNext,
        hasPrevious: response.hasPrevious,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query);
    _debouncer.run(loadOptions);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

typedef OrgLevelPickerKey = ({String structureId, String levelCode, String? parentUnitId, int? tenantId});

final orgLevelPickerProvider =
    StateNotifierProvider.family<OrgLevelPickerNotifier, OrgLevelPickerState, OrgLevelPickerKey>((ref, key) {
      return OrgLevelPickerNotifier(
        useCase: ref.read(_smGetOrgUnitsByLevelUseCaseProvider),
        structureId: key.structureId,
        levelCode: key.levelCode,
        parentUnitId: key.parentUnitId,
        tenantId: key.tenantId,
      );
    });
