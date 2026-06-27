import 'dart:async';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/data/repositories/duty_roles/duty_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/repositories/duty_roles_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/get_duty_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_lookups/security_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _dutyRolesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _dutyRolesRepositoryProvider = Provider<DutyRolesRepository>((ref) {
  return DutyRolesRepositoryImpl(ref.watch(_dutyRolesApiClientProvider));
});

final _getDutyRolesUseCaseProvider = Provider<GetDutyRolesUseCase>((ref) {
  return GetDutyRolesUseCase(ref.watch(_dutyRolesRepositoryProvider));
});

class DutyRolesNotifier extends StateNotifier<DutyRolesState> {
  DutyRolesNotifier(this._getDutyRoles, this._repository, this._ref) : super(const DutyRolesState());

  final GetDutyRolesUseCase _getDutyRoles;
  final DutyRolesRepository _repository;
  final Ref _ref;
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  /// Full refresh — re-fetches roles (with active filters) and category lookups.
  Future<void> refresh({bool showLoading = true}) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(isLoading: false, roles: const [], error: 'Select an enterprise to load duty roles');
      return;
    }

    state = state.copyWith(isLoading: true, categoriesLoading: showLoading, clearError: true);

    try {
      final (roles, categories) = await (
        _getDutyRoles(
          enterpriseId: enterpriseId,
          search: state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim(),
          categoryCode: state.selectedCategoryCode.isEmpty ? null : state.selectedCategoryCode,
          page: state.currentPage,
          pageSize: state.effectivePageSize,
        ),
        _ref.read(dutyRoleCategoryLookupValuesProvider(enterpriseId).future),
      ).wait;

      state = state.copyWith(
        roles: roles.roles.map(DutyRoleItem.fromDutyRole).toList(),
        currentPage: roles.page,
        pageSize: roles.pageSize,
        totalItems: roles.total,
        totalPages: roles.totalPages,
        hasNext: roles.hasNext,
        hasPrevious: roles.hasPrevious,
        categoryLookups: categories,
        isLoading: false,
        categoriesLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, categoriesLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        categoriesLoading: false,
        error: 'Failed to load duty roles: ${e.toString()}',
      );
    }
  }

  /// Re-fetches only roles using the current search and category filters.
  Future<void> _fetchRoles() async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final roles = await _getDutyRoles(
        enterpriseId: enterpriseId,
        search: state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim(),
        categoryCode: state.selectedCategoryCode.isEmpty ? null : state.selectedCategoryCode,
        page: state.currentPage,
        pageSize: state.effectivePageSize,
      );
      state = state.copyWith(
        roles: roles.roles.map(DutyRoleItem.fromDutyRole).toList(),
        currentPage: roles.page,
        pageSize: roles.pageSize,
        totalItems: roles.total,
        totalPages: roles.totalPages,
        hasNext: roles.hasNext,
        hasPrevious: roles.hasPrevious,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load duty roles: ${e.toString()}');
    }
  }

  Future<void> updateDutyRole({
    required String dutyRoleGuid,
    required String name,
    required String code,
    required String description,
    required String category,
    required List<Map<String, dynamic>> functionRoles,
    required List<Map<String, dynamic>> inheritedDutyRoles,
    required bool isActive,
    required bool requiresApproval,
    DateTime? effectiveFrom,
    DateTime? expirationDate,
  }) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) throw Exception('Select an enterprise first.');

    state = state.copyWith(isUpdating: true, clearError: true);
    try {
      await _repository.updateDutyRole(
        dutyRoleGuid: dutyRoleGuid,
        enterpriseId: enterpriseId,
        name: name,
        code: code,
        categoryCode: category,
        status: isActive ? 'ACTIVE' : 'INACTIVE',
        description: description,
        requiresManagerApproval: requiresApproval ? 'Y' : 'N',
        activeFlag: isActive ? 'Y' : 'N',
        actor: 'admin',
        functionRoles: functionRoles,
        inheritedDutyRoles: inheritedDutyRoles,
        effectiveDate: effectiveFrom?.toUtc().toIso8601String(),
        expirationDate: expirationDate?.toUtc().toIso8601String(),
      );
      await refresh(showLoading: false);
      state = state.copyWith(isUpdating: false);
    } on AppException catch (e) {
      state = state.copyWith(isUpdating: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isUpdating: false, error: e.toString());
      rethrow;
    }
  }

  Future<String?> deleteDutyRole(String dutyRoleGuid) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      return 'Select an enterprise to delete duty roles.';
    }
    if (dutyRoleGuid.isEmpty) {
      return 'This duty role cannot be deleted (missing id).';
    }

    state = state.copyWith(deletingDutyRoleGuid: dutyRoleGuid, clearError: true);
    try {
      await _repository.deleteDutyRole(dutyRoleGuid: dutyRoleGuid, enterpriseId: enterpriseId, actor: 'admin');
      state = state.copyWith(clearDeletingDutyRoleGuid: true);
      return null;
    } on AppException catch (e) {
      state = state.copyWith(clearDeletingDutyRoleGuid: true);
      return e.message;
    } catch (e) {
      state = state.copyWith(clearDeletingDutyRoleGuid: true);
      return 'Failed to delete duty role: ${e.toString()}';
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), _fetchRoles);
  }

  void updateCategory(String? categoryCode) {
    state = state.copyWith(selectedCategoryCode: categoryCode ?? '', currentPage: 1);
    _fetchRoles();
  }

  void goToPage(int page) {
    final targetPage = page.clamp(1, state.totalPages);
    if (targetPage == state.currentPage) return;
    state = state.copyWith(currentPage: targetPage);
    _fetchRoles();
  }

  void nextPage() => goToPage(state.safeCurrentPage + 1);

  void previousPage() => goToPage(state.safeCurrentPage - 1);

  void toggleRoleSelection(String dutyRoleGuid) {
    final updated = Set<String>.from(state.selectedRoleGuids);
    if (updated.contains(dutyRoleGuid)) {
      updated.remove(dutyRoleGuid);
    } else {
      updated.add(dutyRoleGuid);
    }
    state = state.copyWith(selectedRoleGuids: updated);
  }

  Future<void> createDutyRole({
    required String name,
    required String code,
    required String description,
    required String category,
    required List<Map<String, dynamic>> functionRoles,
    required List<Map<String, dynamic>> inheritedDutyRoles,
    required bool isActive,
    required bool requiresApproval,
    DateTime? effectiveFrom,
    DateTime? expirationDate,
  }) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) throw Exception('Select an enterprise first.');

    state = state.copyWith(isCreating: true, clearError: true);
    try {
      await _repository.createDutyRole(
        enterpriseId: enterpriseId,
        name: name,
        code: code,
        categoryCode: category,
        status: isActive ? 'ACTIVE' : 'INACTIVE',
        description: description,
        requiresManagerApproval: requiresApproval ? 'Y' : 'N',
        activeFlag: isActive ? 'Y' : 'N',
        actor: 'admin',
        functionRoles: functionRoles,
        inheritedDutyRoles: inheritedDutyRoles,
        effectiveDate: effectiveFrom?.toUtc().toIso8601String(),
        expirationDate: expirationDate?.toUtc().toIso8601String(),
      );
      await refresh(showLoading: false);
      state = state.copyWith(isCreating: false);
    } on AppException catch (e) {
      state = state.copyWith(isCreating: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: e.toString());
      rethrow;
    }
  }
}

final dutyRolesProvider = StateNotifierProvider<DutyRolesNotifier, DutyRolesState>((ref) {
  return DutyRolesNotifier(ref.watch(_getDutyRolesUseCaseProvider), ref.watch(_dutyRolesRepositoryProvider), ref);
});
