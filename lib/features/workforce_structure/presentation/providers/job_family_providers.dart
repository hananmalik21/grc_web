import 'package:grc/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/data/datasources/job_family_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/job_family_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/repositories/job_family_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_job_family_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_job_family_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_job_families_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_job_family_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_families_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_create_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_delete_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_update_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';

// Providers for dependency injection
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final jobFamilyRemoteDataSourceProvider = Provider<JobFamilyRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JobFamilyRemoteDataSourceImpl(apiClient: apiClient);
});

final jobFamilyRepositoryProvider = Provider<JobFamilyRepository>((ref) {
  return JobFamilyRepositoryImpl(remoteDataSource: ref.read(jobFamilyRemoteDataSourceProvider));
});

final getJobFamiliesUseCaseProvider = Provider<GetJobFamiliesUseCase>((ref) {
  return GetJobFamiliesUseCase(repository: ref.read(jobFamilyRepositoryProvider));
});

final createJobFamilyUseCaseProvider = Provider<CreateJobFamilyUseCase>((ref) {
  return CreateJobFamilyUseCase(repository: ref.read(jobFamilyRepositoryProvider));
});

final updateJobFamilyUseCaseProvider = Provider<UpdateJobFamilyUseCase>((ref) {
  return UpdateJobFamilyUseCase(repository: ref.read(jobFamilyRepositoryProvider));
});

final deleteJobFamilyUseCaseProvider = Provider<DeleteJobFamilyUseCase>((ref) {
  return DeleteJobFamilyUseCase(repository: ref.read(jobFamilyRepositoryProvider));
});

// Job Family Notifier with pagination
class JobFamilyNotifier extends StateNotifier<PaginationState<JobFamily>>
    with PaginationMixin<JobFamily>
    implements PaginationController<JobFamily> {
  final GetJobFamiliesUseCase _getJobFamiliesUseCase;
  final CreateJobFamilyUseCase _createJobFamilyUseCase;
  final _debouncer = Debouncer();
  final int? tenantId;

  JobFamilyNotifier(this._getJobFamiliesUseCase, this._createJobFamilyUseCase, this.tenantId)
    : super(const PaginationState());

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getJobFamiliesUseCase(
        page: 1,
        pageSize: state.pageSize,
        search: state.searchQuery,
        tenantId: tenantId,
      );

      final jobFamilies = response.data.map((data) => data.toJobFamily()).toList();

      state = handleSuccessState(
        currentState: state,
        newItems: jobFamilies,
        currentPage: response.meta.pagination.page,
        pageSize: response.meta.pagination.pageSize,
        totalItems: response.meta.pagination.total,
        totalPages: response.meta.pagination.totalPages,
        hasNextPage: response.meta.pagination.hasNext,
        hasPreviousPage: response.meta.pagination.hasPrevious,
        isFirstPage: true,
      );
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    final previousPage = state.currentPage;
    final nextPage = state.currentPage + 1;
    state = handleLoadingState(state, false).copyWith(isLoading: true, currentPage: nextPage);

    try {
      final response = await _getJobFamiliesUseCase(
        page: nextPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
        tenantId: tenantId,
      );

      final jobFamilies = response.data.map((data) => data.toJobFamily()).toList();

      state = handleSuccessState(
        currentState: state,
        newItems: jobFamilies,
        currentPage: response.meta.pagination.page,
        pageSize: response.meta.pagination.pageSize,
        totalItems: response.meta.pagination.total,
        totalPages: response.meta.pagination.totalPages,
        hasNextPage: response.meta.pagination.hasNext,
        hasPreviousPage: response.meta.pagination.hasPrevious,
        isFirstPage: false,
      );
    } catch (e) {
      state = handleErrorState(state.copyWith(currentPage: previousPage), e.toString());
    }
  }

  Future<void> goToPage(int page) async {
    if (state.isLoading || page == state.currentPage || page < 1 || page > state.totalPages) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getJobFamiliesUseCase(
        page: page,
        pageSize: state.pageSize,
        search: state.searchQuery,
        tenantId: tenantId,
      );

      final jobFamilies = response.data.map((data) => data.toJobFamily()).toList();

      state = handleSuccessState(
        currentState: state,
        newItems: jobFamilies,
        currentPage: response.meta.pagination.page,
        pageSize: response.meta.pagination.pageSize,
        totalItems: response.meta.pagination.total,
        totalPages: response.meta.pagination.totalPages,
        hasNextPage: response.meta.pagination.hasNext,
        hasPreviousPage: response.meta.pagination.hasPrevious,
        isFirstPage: true, // we replace items like in page 1
      );
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  Future<JobFamily> createJobFamily(
    WidgetRef ref, {
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
  }) async {
    ref.read(jobFamilyCreateStateProvider.notifier).state = const JobFamilyCreateState(isCreating: true);

    try {
      final newJobFamily = await _createJobFamilyUseCase(
        code: code,
        nameEnglish: nameEnglish,
        nameArabic: nameArabic,
        description: description,
        status: 'ACTIVE',
        tenantId: tenantId,
      );

      ref.read(jobFamilyCreateStateProvider.notifier).state = const JobFamilyCreateState(isCreating: false);

      final currentItems = state.items;
      final updatedItems = [newJobFamily, ...currentItems];

      state = state.copyWith(items: updatedItems, totalItems: state.totalItems + 1);

      return newJobFamily;
    } catch (e) {
      ref.read(jobFamilyCreateStateProvider.notifier).state = JobFamilyCreateState(
        isCreating: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteJobFamily(
    WidgetRef ref,
    DeleteJobFamilyUseCase deleteUseCase, {
    required int id,
    bool hard = true,
  }) async {
    ref.read(jobFamilyDeleteStateProvider.notifier).state = JobFamilyDeleteState(isDeleting: true, deletingId: id);

    try {
      await deleteUseCase(id: id, hard: hard, tenantId: tenantId);

      final currentItems = state.items;
      final updatedItems = currentItems.where((item) => item.id != id).toList();

      state = state.copyWith(items: updatedItems, totalItems: state.totalItems - 1);

      ref.read(jobFamilyDeleteStateProvider.notifier).state = const JobFamilyDeleteState(isDeleting: false);
    } catch (e) {
      ref.read(jobFamilyDeleteStateProvider.notifier).state = JobFamilyDeleteState(
        isDeleting: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<JobFamily> updateJobFamily(
    WidgetRef ref,
    UpdateJobFamilyUseCase updateUseCase, {
    required int id,
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  }) async {
    ref.read(jobFamilyUpdateStateProvider.notifier).state = JobFamilyUpdateState(isUpdating: true, updatingId: id);

    try {
      final updatedJobFamily = await updateUseCase(
        id: id,
        code: code,
        nameEnglish: nameEnglish,
        nameArabic: nameArabic,
        description: description,
        status: status,
        tenantId: tenantId,
      );

      final currentItems = state.items;
      final updatedItems = currentItems.map((item) {
        return item.id == id ? updatedJobFamily : item;
      }).toList();

      state = state.copyWith(items: updatedItems);

      ref.read(jobFamilyUpdateStateProvider.notifier).state = const JobFamilyUpdateState(isUpdating: false);

      return updatedJobFamily;
    } catch (e) {
      ref.read(jobFamilyUpdateStateProvider.notifier).state = JobFamilyUpdateState(
        isUpdating: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  @override
  Future<void> refresh() async {
    reset();
    await loadFirstPage();
  }

  @override
  void reset() {
    state = const PaginationState();
  }

  void updatePageSize(int newPageSize) {
    if (newPageSize != state.pageSize) {
      state = state.copyWith(pageSize: newPageSize);
      refresh();
    }
  }

  void search(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query, items: []);
    _debouncer.run(() => loadFirstPage());
  }

  void clearSearch() {
    search('');
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

// Provider for the notifier
final jobFamilyNotifierProvider = StateNotifierProvider<JobFamilyNotifier, PaginationState<JobFamily>>((ref) {
  final tenantId = ref.watch(jobFamiliesEnterpriseIdProvider);
  final notifier = JobFamilyNotifier(
    ref.watch(getJobFamiliesUseCaseProvider),
    ref.watch(createJobFamilyUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final jobFamilyNotifierForPositionProvider = StateNotifierProvider<JobFamilyNotifier, PaginationState<JobFamily>>((
  ref,
) {
  final tenantId = ref.watch(positionsEnterpriseIdProvider);
  final notifier = JobFamilyNotifier(
    ref.watch(getJobFamiliesUseCaseProvider),
    ref.watch(createJobFamilyUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

// Convenience providers
final jobFamilyListProvider = Provider<List<JobFamily>>((ref) {
  return ref.watch(jobFamilyNotifierProvider).items;
});

final jobFamilyLoadingProvider = Provider<bool>((ref) {
  return ref.watch(jobFamilyNotifierProvider).isLoading;
});

final jobFamilyErrorProvider = Provider<String?>((ref) {
  return ref.watch(jobFamilyNotifierProvider).errorMessage;
});

// Create operation state providers
final jobFamilyCreatingProvider = Provider<bool>((ref) {
  return ref.watch(jobFamilyCreateStateProvider).isCreating;
});

final jobFamilyCreateErrorProvider = Provider<String?>((ref) {
  return ref.watch(jobFamilyCreateStateProvider).error;
});

/// Extension to easily access job family providers
extension JobFamilyProviderExtensions on WidgetRef {
  void refreshJobFamilies() {
    read(jobFamilyNotifierProvider.notifier).refresh();
  }

  void loadMoreJobFamilies() {
    read(jobFamilyNotifierProvider.notifier).loadNextPage();
  }

  Future<JobFamily> createJobFamily({
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
  }) {
    return read(
      jobFamilyNotifierProvider.notifier,
    ).createJobFamily(this, code: code, nameEnglish: nameEnglish, nameArabic: nameArabic, description: description);
  }

  Future<void> deleteJobFamily({required int id, bool hard = true}) {
    return read(
      jobFamilyNotifierProvider.notifier,
    ).deleteJobFamily(this, read(deleteJobFamilyUseCaseProvider), id: id, hard: hard);
  }

  Future<JobFamily> updateJobFamily({
    required int id,
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  }) {
    return read(jobFamilyNotifierProvider.notifier).updateJobFamily(
      this,
      read(updateJobFamilyUseCaseProvider),
      id: id,
      code: code,
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      description: description,
      status: status,
    );
  }
}
