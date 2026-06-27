import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/user_management_remote_data_source.dart';
import '../../../data/models/user_management/user_managment_status.dart';
import '../../../data/repositories/user_management_repository_impl.dart';
import '../../../domain/models/system_user.dart';
import '../../../domain/repositories/user_management_repository.dart';
import '../../../domain/usecases/get_employee_details_use_case.dart';
import '../../../domain/usecases/get_users_use_case.dart';
import 'user_management_enterprise_provider.dart';

class UserManagementState {
  final String searchQuery;
  final UserManagementStatus? statusFilter;
  final List<SystemUser> users;
  final bool isLoading;
  final bool clearError;
  final String? error;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final Set<String> deletingUserGuids;

  UserManagementState({
    this.searchQuery = '',
    this.statusFilter,
    this.users = const [],
    this.isLoading = false,
    this.clearError = false,
    this.error,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.deletingUserGuids = const <String>{},
  });

  UserManagementState copyWith({
    String? searchQuery,
    UserManagementStatus? statusFilter,
    List<SystemUser>? users,
    bool? isLoading,
    bool? clearError,
    String? error,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    Set<String>? deletingUserGuids,
  }) {
    return UserManagementState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      deletingUserGuids: deletingUserGuids ?? this.deletingUserGuids,
    );
  }
}

class UserManagementNotifier extends StateNotifier<UserManagementState> {
  final GetUsersUseCase _getUsersUseCase;
  final UserManagementRepository _userManagementRepository;
  final int? _enterpriseId;
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 400));

  UserManagementNotifier(this._getUsersUseCase, this._userManagementRepository, this._enterpriseId)
    : super(UserManagementState()) {
    getUsers();
  }

  Future<void> getUsers() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _getUsersUseCase(
        enterpriseId: _enterpriseId,
        page: state.currentPage,
        limit: state.pageSize,
        searchQuery: state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim(),
      );
      state = state.copyWith(
        users: result.users,
        totalItems: result.total,
        totalPages: result.totalPages,
        hasNext: result.hasNext,
        hasPrevious: result.hasPrevious,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
    getUsers();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _searchDebouncer.run(getUsers);
  }

  void setStatusFilter(UserManagementStatus? status) {
    state = state.copyWith(statusFilter: status, currentPage: 1);
    getUsers();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(clearError: true, error: null);
  }

  Future<void> deleteUser({required String userGuid}) async {
    if (state.deletingUserGuids.contains(userGuid)) return;
    final deleting = Set<String>.from(state.deletingUserGuids)..add(userGuid);
    state = state.copyWith(deletingUserGuids: deleting);
    try {
      await _userManagementRepository.deleteUser(userGuid: userGuid);
      await getUsers();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      final updated = Set<String>.from(state.deletingUserGuids)..remove(userGuid);
      state = state.copyWith(deletingUserGuids: updated);
    }
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }
}

final _userManagementApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final userManagementRemoteDataSourceProvider = Provider<UserManagementRemoteDataSource>((ref) {
  return UserManagementRemoteDataSourceImpl(ref.watch(_userManagementApiClientProvider));
});

final userManagementRepositoryProvider = Provider<UserManagementRepository>((ref) {
  return UserManagementRepositoryImpl(ref.watch(userManagementRemoteDataSourceProvider));
});

final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  return GetUsersUseCase(ref.watch(userManagementRepositoryProvider));
});

final getEmployeeDetailsUseCaseProvider = Provider<GetEmployeeDetailsUseCase>((ref) {
  return GetEmployeeDetailsUseCase(ref.watch(userManagementRepositoryProvider));
});

final employeeSelectionProvider = FutureProvider.autoDispose.family<List<SystemUser>, int?>((ref, enterpriseId) async {
  if (enterpriseId == null) return const [];
  final getUsersUseCase = ref.watch(getUsersUseCaseProvider);
  final result = await getUsersUseCase(enterpriseId: enterpriseId, limit: 100);
  return result.users;
});

final userManagementProvider = StateNotifierProvider<UserManagementNotifier, UserManagementState>((ref) {
  final enterpriseId = ref.watch(userManagementEnterpriseIdProvider);
  return UserManagementNotifier(
    ref.watch(getUsersUseCaseProvider),
    ref.watch(userManagementRepositoryProvider),
    enterpriseId,
  );
});
