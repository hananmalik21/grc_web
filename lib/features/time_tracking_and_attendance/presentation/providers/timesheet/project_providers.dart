import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_tracking_and_attendance/data/datasources/project_remote_data_source.dart';
import 'package:grc/features/time_tracking_and_attendance/data/repositories/project_repository_impl.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/project.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/repositories/project_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tmApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final projectRemoteDataSourceProvider = Provider<ProjectRemoteDataSource>((ref) {
  final apiClient = ref.watch(tmApiClientProvider);
  return ProjectRemoteDataSourceImpl(apiClient: apiClient);
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final remote = ref.watch(projectRemoteDataSourceProvider);
  return ProjectRepositoryImpl(remoteDataSource: remote);
});

class ProjectState {
  final List<Project> projects;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final PaginationInfo pagination;
  final String? searchQuery;
  final int? enterpriseId;

  const ProjectState({
    this.projects = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.pagination = const PaginationInfo(
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      pageSize: 10,
      hasNext: false,
      hasPrevious: false,
    ),
    this.searchQuery,
    this.enterpriseId,
  });

  ProjectState copyWith({
    List<Project>? projects,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    PaginationInfo? pagination,
    String? searchQuery,
    int? enterpriseId,
    bool clearProjects = false,
  }) {
    return ProjectState(
      projects: clearProjects ? [] : (projects ?? this.projects),
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      pagination: pagination ?? this.pagination,
      searchQuery: searchQuery ?? this.searchQuery,
      enterpriseId: enterpriseId ?? this.enterpriseId,
    );
  }
}

class ProjectNotifier extends StateNotifier<ProjectState> {
  final ProjectRepository repository;

  ProjectNotifier({required this.repository}) : super(const ProjectState());

  Future<void> loadProjects({required int enterpriseId, String? search, int page = 1, bool append = false}) async {
    if (!append) {
      state = state.copyWith(isLoading: true, hasError: false, errorMessage: null, clearProjects: true);
    }

    try {
      final result = await repository.getProjects(
        enterpriseId: enterpriseId,
        search: search,
        page: page,
        pageSize: state.pagination.pageSize,
      );

      state = state.copyWith(
        projects: append ? [...state.projects, ...result.projects] : result.projects,
        isLoading: false,
        hasError: false,
        pagination: result.pagination,
        searchQuery: search,
        enterpriseId: enterpriseId,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load projects: ${e.toString()}',
      );
    }
  }

  Future<void> searchProjects({required int enterpriseId, String? search}) async {
    await loadProjects(enterpriseId: enterpriseId, search: search, page: 1);
  }

  Future<void> loadNextPage() async {
    if (!state.pagination.hasNext || state.isLoading || state.enterpriseId == null) {
      return;
    }

    await loadProjects(
      enterpriseId: state.enterpriseId!,
      search: state.searchQuery,
      page: state.pagination.currentPage + 1,
      append: true,
    );
  }

  Future<void> refresh() async {
    if (state.enterpriseId != null) {
      await loadProjects(
        enterpriseId: state.enterpriseId!,
        search: state.searchQuery,
        page: state.pagination.currentPage,
      );
    }
  }
}

final projectNotifierProvider = StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectNotifier(repository: repository);
});
