import 'dart:async';

import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/data/repositories/data_roles/data_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/repositories/data_roles_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/create_data_role_use_case.dart';
import 'package:grc/features/security_manager/domain/usecases/get_data_roles_use_case.dart';
import 'package:grc/features/security_manager/domain/models/org_selection_node.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/create_data_role_form_state.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/security_manager_org_structure_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_lookups/security_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _dataRolesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _dataRolesRepositoryProvider = Provider<DataRolesRepository>((ref) {
  return DataRolesRepositoryImpl(ref.watch(_dataRolesApiClientProvider));
});

final _getDataRolesUseCaseProvider = Provider<GetDataRolesUseCase>((ref) {
  return GetDataRolesUseCase(ref.watch(_dataRolesRepositoryProvider));
});

final _createDataRolesUseCaseProvider = Provider<CreateDataRoleUseCase>((ref) {
  return CreateDataRoleUseCase(ref.watch(_dataRolesRepositoryProvider));
});

class DataRolesNotifier extends StateNotifier<DataRolesState> {
  DataRolesNotifier(this._getDataRoles, this._createDataRole, this._repository, this._ref)
    : super(const DataRolesState());

  final GetDataRolesUseCase _getDataRoles;
  final CreateDataRoleUseCase _createDataRole;
  final DataRolesRepository _repository;
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
      state = state.copyWith(isLoading: false, roles: const [], error: 'Select an enterprise to load data roles');
      return;
    }

    if (showLoading) {
      state = state.copyWith(isLoading: true, clearError: true);
    } else {
      state = state.copyWith(clearError: true);
    }

    try {
      final page = await _getDataRoles(
        enterpriseId: enterpriseId,
        page: state.currentPage,
        pageSize: state.effectivePageSize,
        search: state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim(),
        dataTypeCode: state.selectedDataTypeCode.isEmpty ? null : state.selectedDataTypeCode,
      );
      state = state.copyWith(
        roles: page.roles.map(DataRoleItem.fromDataRole).toList(),
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
      state = state.copyWith(isLoading: false, error: 'Failed to load data roles: ${e.toString()}');
    }
  }

  Future<bool> deleteDataRole(String dataRoleGuid) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null || dataRoleGuid.isEmpty) return false;

    state = state.copyWith(deletingDataRoleGuid: dataRoleGuid, clearError: true);
    try {
      await _repository.deleteDataRole(dataRoleGuid: dataRoleGuid, enterpriseId: enterpriseId, actor: 'ADMIN');
      state = state.copyWith(clearDeletingDataRoleGuid: true);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(clearDeletingDataRoleGuid: true, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(clearDeletingDataRoleGuid: true, error: 'Failed to delete data role: ${e.toString()}');
      return false;
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      refresh(showLoading: true);
    });
  }

  void updateDataType(String? dataTypeCode) {
    state = state.copyWith(selectedDataTypeCode: dataTypeCode ?? '', currentPage: 1);
    refresh(showLoading: true);
  }

  Future<void> refreshDataTypeLookups() async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) return;
    _ref.invalidate(dataRoleDataTypeLookupValuesProvider(enterpriseId));
  }

  Future<void> goToPage(int page) async {
    final clamped = page.clamp(1, state.totalPages);
    if (clamped == state.currentPage) return;
    state = state.copyWith(currentPage: clamped);
    await refresh(showLoading: true);
  }

  Future<void> nextPage() => goToPage(state.currentPage + 1);

  Future<void> previousPage() => goToPage(state.currentPage - 1);

  Future<void> createDataRole(CreateDataRoleFormState formState) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) throw Exception('No enterprise selected');

    final activeLevels = _ref.read(securityManagerOrgStructureNotifierProvider).orgStructure?.activeLevels ?? const [];
    final levelByCode = {for (final level in activeLevels) level.levelCode: level};

    final leafNodes = _collectLeafNodes(formState.orgSelections);

    final body = <String, dynamic>{
      'enterprise_id': enterpriseId,
      'role_name': formState.roleName.trim(),
      'role_code': formState.roleCode.trim(),
      'data_type_code': formState.selectedDataType ?? '',
      'status': formState.selectedStatus.apiValue,
      'description': formState.description.trim(),
      'actor': 'ADMIN',
      'positions': [
        for (final p in formState.selectedPositions) {'position_id': p.id, 'active_flag': 'Y'},
      ],
      'grades': [
        for (final g in formState.selectedGrades) {'grade_id': g.id, 'active_flag': 'Y'},
      ],
      'job_families': [
        for (final jf in formState.selectedJobFamilies) {'job_family_id': jf.id, 'active_flag': 'Y'},
      ],
      'job_levels': [
        for (final jl in formState.selectedJobLevels) {'job_level_id': jl.id, 'active_flag': 'Y'},
      ],
      'org_units': [
        for (final node in leafNodes)
          {
            'org_unit_id': node.unitId,
            'active_flag': 'Y',
            'hierarchy_level': levelByCode[node.levelCode]?.levelNumber ?? 1,
            'include_subordinates': 'Y',
          },
      ],
    };

    state = state.copyWith(isCreating: true, clearError: true);
    try {
      await _createDataRole(body: body);
      await refresh(showLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isCreating: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: 'Failed to create data role: ${e.toString()}');
      rethrow;
    } finally {
      state = state.copyWith(isCreating: false);
    }
  }

  Future<void> updateDataRole({required String dataRoleGuid, required CreateDataRoleFormState formState}) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) throw Exception('No enterprise selected');
    if (dataRoleGuid.isEmpty) throw Exception('Invalid data role id');

    final activeLevels = _ref.read(securityManagerOrgStructureNotifierProvider).orgStructure?.activeLevels ?? const [];
    final levelByCode = {for (final level in activeLevels) level.levelCode: level};

    final leafNodes = _collectLeafNodes(formState.orgSelections);

    final body = <String, dynamic>{
      'enterprise_id': enterpriseId,
      'role_name': formState.roleName.trim(),
      'role_code': formState.roleCode.trim(),
      'data_type_code': formState.selectedDataType ?? '',
      'status': formState.selectedStatus.apiValue,
      'description': formState.description.trim(),
      'actor': 'ADMIN',
      'positions': [
        for (final p in formState.selectedPositions) {'position_id': p.id, 'active_flag': 'Y'},
      ],
      'grades': [
        for (final g in formState.selectedGrades) {'grade_id': g.id, 'active_flag': 'Y'},
      ],
      'job_families': [
        for (final jf in formState.selectedJobFamilies) {'job_family_id': jf.id, 'active_flag': 'Y'},
      ],
      'job_levels': [
        for (final jl in formState.selectedJobLevels) {'job_level_id': jl.id, 'active_flag': 'Y'},
      ],
      'org_units': [
        for (final node in leafNodes)
          {
            'org_unit_id': node.unitId,
            'active_flag': 'Y',
            'hierarchy_level': levelByCode[node.levelCode]?.levelNumber ?? 1,
            'include_subordinates': 'Y',
          },
      ],
    };

    state = state.copyWith(isCreating: true, clearError: true);
    try {
      await _repository.updateDataRole(dataRoleGuid: dataRoleGuid, body: body);
      await refresh(showLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isCreating: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: 'Failed to update data role: ${e.toString()}');
      rethrow;
    } finally {
      state = state.copyWith(isCreating: false);
    }
  }

  List<OrgSelectionNode> _collectLeafNodes(List<OrgSelectionNode> nodes) {
    final leaves = <OrgSelectionNode>[];
    for (final node in nodes) {
      if (node.children.isEmpty) {
        leaves.add(node);
      } else {
        leaves.addAll(_collectLeafNodes(node.children));
      }
    }
    return leaves;
  }
}

final dataRolesProvider = StateNotifierProvider<DataRolesNotifier, DataRolesState>((ref) {
  return DataRolesNotifier(
    ref.watch(_getDataRolesUseCaseProvider),
    ref.watch(_createDataRolesUseCaseProvider),
    ref.watch(_dataRolesRepositoryProvider),
    ref,
  );
});
