import 'dart:async';

import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/data/repositories/job_roles/job_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/repositories/job_roles_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/get_job_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_role_duty_roles_selection_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/create_job_role_form_state.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_role_data_roles_selection_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_role_form_inherited_picker_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _jobRolesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _jobRolesRepositoryProvider = Provider<JobRolesRepository>((ref) {
  return JobRolesRepositoryImpl(ref.watch(_jobRolesApiClientProvider));
});

final _getJobRolesUseCaseProvider = Provider<GetJobRolesUseCase>((ref) {
  return GetJobRolesUseCase(ref.watch(_jobRolesRepositoryProvider));
});

class JobRolesNotifier extends StateNotifier<JobRolesState> {
  JobRolesNotifier(this._getJobRoles, this._repository, this._ref) : super(const JobRolesState());

  final GetJobRolesUseCase _getJobRoles;
  final JobRolesRepository _repository;
  final Ref _ref;
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> refresh({bool showLoading = true}) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(isLoading: false, roles: const [], error: 'Select an enterprise to load job roles');
      return;
    }

    if (showLoading) {
      state = state.copyWith(isLoading: true, clearError: true);
    } else {
      state = state.copyWith(clearError: true);
    }

    try {
      final search = state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim();
      final page = await _getJobRoles(
        enterpriseId: enterpriseId,
        page: state.currentPage,
        pageSize: state.effectivePageSize,
        search: search,
      );
      state = state.copyWith(
        roles: page.roles.map(JobRoleItem.fromJobRole).toList(),
        currentPage: page.page,
        pageSize: page.pageSize,
        totalItems: page.total,
        totalPages: page.totalPages,
        hasNext: page.hasNext,
        hasPrevious: page.hasPrevious,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load job roles: ${e.toString()}');
    }
  }

  Future<bool> deleteJobRole(String jobRoleGuid) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null || jobRoleGuid.isEmpty) {
      return false;
    }

    state = state.copyWith(deletingJobRoleGuid: jobRoleGuid, clearError: true);
    try {
      await _repository.deleteJobRole(jobRoleGuid: jobRoleGuid);
      state = state.copyWith(clearDeletingJobRoleGuid: true);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(clearDeletingJobRoleGuid: true, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(clearDeletingJobRoleGuid: true, error: 'Failed to delete job role: ${e.toString()}');
      return false;
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () => refresh(showLoading: true));
  }

  Future<void> goToPage(int page) async {
    final maxPage = state.totalPages < 1 ? 1 : state.totalPages;
    final clamped = page.clamp(1, maxPage);
    if (clamped == state.currentPage) return;
    state = state.copyWith(currentPage: clamped);
    await refresh(showLoading: true);
  }

  Future<void> nextPage() => goToPage(state.currentPage + 1);

  Future<void> previousPage() => goToPage(state.currentPage - 1);

  Future<void> createJobRole(CreateJobRoleFormState formState) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) throw Exception('No enterprise selected');

    final body = _buildUpsertBody(
      enterpriseId: enterpriseId,
      formState: formState,
      actorField: 'created_by',
      includeInheritedJobRoles: true,
    );

    state = state.copyWith(isCreating: true, clearError: true);
    try {
      await _repository.createJobRole(body: body);
      await refresh(showLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isCreating: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: 'Failed to create job role: ${e.toString()}');
      rethrow;
    } finally {
      state = state.copyWith(isCreating: false);
    }
  }

  Future<void> updateJobRole({required String jobRoleGuid, required CreateJobRoleFormState formState}) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) throw Exception('No enterprise selected');
    if (jobRoleGuid.isEmpty) throw Exception('Invalid job role id');

    final body = _buildUpsertBody(
      enterpriseId: enterpriseId,
      formState: formState,
      actorField: 'last_updated_by',
      includeInheritedJobRoles: true,
    );

    state = state.copyWith(isCreating: true, clearError: true);
    try {
      await _repository.updateJobRole(jobRoleGuid: jobRoleGuid, body: body);
      await refresh(showLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isCreating: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: 'Failed to update job role: ${e.toString()}');
      rethrow;
    } finally {
      state = state.copyWith(isCreating: false);
    }
  }

  Map<String, dynamic> _buildUpsertBody({
    required int enterpriseId,
    required CreateJobRoleFormState formState,
    required String actorField,
    required bool includeInheritedJobRoles,
  }) {
    final directDuty = formState.selectedDutyRoles.difference(formState.lockedDutyRoleCodes);
    final directData = formState.selectedDataRoles.difference(formState.lockedDataRoleCodes);

    final body = <String, dynamic>{
      'enterprise_id': enterpriseId,
      'role_name': formState.roleName.trim(),
      'role_code': formState.roleCode.trim(),
      'job_title': formState.jobTitle.trim(),
      'description': formState.description.trim(),
      'status': formState.selectedStatus.apiValue,
      actorField: 'ADMIN',
      'duty_roles': _resolveDutyRoleIds(directDuty),
      'function_roles': const <Map<String, dynamic>>[],
      'data_roles': _resolveDataRoleIds(directData),
    };
    if (includeInheritedJobRoles) {
      body['inherited_job_roles'] = _resolveInheritedJobRoles();
    }
    return body;
  }

  List<Map<String, dynamic>> _resolveInheritedJobRoles() {
    final picker = _ref.read(jobRoleFormInheritedPickerProvider);
    final selected = picker.selectedGuids;
    if (selected.isEmpty) return const [];
    return picker.roles
        .where((r) => selected.contains(r.jobRoleGuid))
        .map((r) => {'job_role_id': int.parse(r.id)})
        .toList();
  }

  List<Map<String, dynamic>> _resolveDutyRoleIds(Set<String> codes) {
    final cache = _ref.read(jobRoleDutyRolesSelectionProvider).codeToIdCache;
    return codes
        .map((code) => int.tryParse(cache[code] ?? ''))
        .whereType<int>()
        .map((id) => {'duty_role_id': id})
        .toList();
  }

  List<Map<String, dynamic>> _resolveDataRoleIds(Set<String> codes) {
    final cache = _ref.read(jobRoleDataRolesSelectionProvider).codeToIdCache;
    return codes
        .map((code) => int.tryParse(cache[code] ?? ''))
        .whereType<int>()
        .map((id) => {'data_role_id': id})
        .toList();
  }
}

final jobRolesProvider = StateNotifierProvider<JobRolesNotifier, JobRolesState>((ref) {
  return JobRolesNotifier(ref.watch(_getJobRolesUseCaseProvider), ref.watch(_jobRolesRepositoryProvider), ref);
});
