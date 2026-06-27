import 'package:grc/core/enums/active_inactive_status.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/security_function.dart';
import 'package:grc/features/security_manager/domain/repositories/function_roles_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/get_function_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_role_form_inherited_picker_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_dependencies.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_functions/security_functions_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_modules/security_modules_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'function_roles_state.dart';

class FunctionRolesNotifier extends StateNotifier<FunctionRolesState> {
  FunctionRolesNotifier(this._getFunctionRoles, this._repository, this._ref) : super(const FunctionRolesState());

  final GetFunctionRolesUseCase _getFunctionRoles;
  final FunctionRolesRepository _repository;
  final Ref _ref;
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  List<Map<String, dynamic>> _buildFunctionsJson() {
    final currentPageFunctions = _ref.read(securityFunctionsProvider).functions;
    final resolvedIdMap = {
      ...state.formFunctionGuidToId,
      for (final fn in currentPageFunctions) fn.functionGuid: fn.functionId,
    };
    return state.formSelectedFunctions.map((guid) {
      final id = resolvedIdMap[guid];
      if (id == null) {
        throw ClientException('Could not resolve ID for function $guid. Please reload and try again.');
      }
      return {'function_id': id};
    }).toList();
  }

  List<FunctionRoleItem> _inheritedPickerRolesForSubmit() {
    final picker = _ref.read(functionRoleFormInheritedPickerProvider);
    final byGuid = <String, FunctionRoleItem>{for (final r in picker.roles) r.functionRoleGuid: r};
    for (final r in state.roles) {
      if (picker.selectedGuids.contains(r.functionRoleGuid)) {
        byGuid.putIfAbsent(r.functionRoleGuid, () => r);
      }
    }
    return picker.selectedGuids.map((g) => byGuid[g]).whereType<FunctionRoleItem>().toList();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> refresh({bool showListLoading = true}) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(isLoading: false, roles: const [], error: 'Select an enterprise to load function roles');
      return;
    }

    if (showListLoading) {
      state = state.copyWith(isLoading: true, clearError: true);
    } else {
      state = state.copyWith(isRefreshing: true, clearError: true);
    }
    try {
      final roles = await _getFunctionRoles(
        enterpriseId: enterpriseId,
        search: state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim(),
        moduleId: state.selectedModuleId,
        page: state.currentPage,
        pageSize: state.effectivePageSize,
      );
      state = state.copyWith(
        roles: roles.roles.map(FunctionRoleItem.fromFunctionRole).toList(),
        currentPage: roles.page,
        pageSize: roles.pageSize,
        totalItems: roles.total,
        totalPages: roles.totalPages,
        hasNext: roles.hasNext,
        hasPrevious: roles.hasPrevious,
        isLoading: false,
        isRefreshing: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, isRefreshing: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: 'Failed to load function roles: ${e.toString()}',
      );
    }
  }

  Future<bool> deleteFunctionRole(String functionRoleGuid) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null || functionRoleGuid.isEmpty) {
      return false;
    }

    state = state.copyWith(deletingFunctionRoleGuid: functionRoleGuid, clearError: true);
    try {
      await _repository.deleteFunctionRole(functionRoleGuid: functionRoleGuid, enterpriseId: enterpriseId);
      await refresh();
      state = state.copyWith(clearDeletingFunctionRoleGuid: true);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(clearDeletingFunctionRoleGuid: true, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        clearDeletingFunctionRoleGuid: true,
        error: 'Failed to delete function role: ${e.toString()}',
      );
      return false;
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _debouncer.run(() => refresh(showListLoading: false));
  }

  void updateModule(int? moduleId) {
    if (moduleId == null) {
      state = state.copyWith(clearSelectedModuleId: true, currentPage: 1);
    } else {
      state = state.copyWith(selectedModuleId: moduleId, currentPage: 1);
    }
    refresh(showListLoading: false);
  }

  String? validateDetailsStep({required String name, required String code}) {
    if (name.trim().isEmpty) return 'Role name is required';
    if (code.trim().isEmpty) return 'Role code is required';

    final modulesState = _ref.read(securityModulesProvider);
    final moduleNames = modulesState.modules.map((m) => m.moduleName).toList();
    if (moduleNames.isEmpty || !moduleNames.contains(state.formModule)) {
      return 'A valid module is required';
    }

    return null;
  }

  String? validateFunctionsStep() {
    if (state.formSelectedFunctions.isEmpty) {
      return 'At least one included function is required';
    }
    return null;
  }

  Future<void> submitCreateForm({required String name, required String code, required String description}) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(error: 'Select an enterprise to save this role.');
      throw ClientException('Select an enterprise to save this role.');
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final modulesState = _ref.read(securityModulesProvider);
      final selectedModule = modulesState.modules.firstWhere(
        (m) => m.moduleName == state.formModule,
        orElse: () => throw ClientException('Selected module is no longer available.'),
      );

      final functionsJson = _buildFunctionsJson();

      final today = DateTime.now();
      final startDate =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final inheritedRolesJson = _inheritedPickerRolesForSubmit()
          .map((r) => {'parent_function_role_id': int.parse(r.id)})
          .toList();

      await _repository.createFunctionRole(
        enterpriseId: enterpriseId,
        moduleId: selectedModule.moduleId,
        roleCode: code.trim(),
        roleName: name.trim(),
        description: description.trim(),
        statusCode: state.formStatus.isActive ? 'ACTIVE' : 'INACTIVE',
        displayOrder: 1,
        activeFlag: state.formStatus.isActive ? 'Y' : 'N',
        isSystemFlag: 'N',
        startDate: startDate,
        functionsJson: functionsJson,
        inheritedRolesJson: inheritedRolesJson,
      );
      await refresh(showListLoading: true);
      state = state.copyWith(isSubmitting: false);
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: 'Failed to create function role: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> submitEditForm({
    required String functionRoleGuid,
    required String name,
    required String code,
    required String description,
  }) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(error: 'Select an enterprise to save this role.');
      throw ClientException('Select an enterprise to save this role.');
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final modulesState = _ref.read(securityModulesProvider);
      final selectedModule = modulesState.modules.firstWhere(
        (m) => m.moduleName == state.formModule,
        orElse: () => throw ClientException('Selected module is no longer available.'),
      );

      final functionsJson = _buildFunctionsJson();

      final today = DateTime.now();
      final startDate =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final inheritedRolesJson = _inheritedPickerRolesForSubmit()
          .map((r) => {'parent_function_role_id': int.parse(r.id)})
          .toList();

      await _repository.updateFunctionRole(
        functionRoleGuid: functionRoleGuid,
        enterpriseId: enterpriseId,
        moduleId: selectedModule.moduleId,
        roleCode: code.trim(),
        roleName: name.trim(),
        description: description.trim(),
        statusCode: state.formStatus.isActive ? 'ACTIVE' : 'INACTIVE',
        displayOrder: 1,
        activeFlag: state.formStatus.isActive ? 'Y' : 'N',
        isSystemFlag: 'N',
        startDate: startDate,
        functionsJson: functionsJson,
        inheritedRolesJson: inheritedRolesJson,
      );
      await refresh(showListLoading: true);
      state = state.copyWith(isSubmitting: false);
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: 'Failed to update function role: ${e.toString()}');
      rethrow;
    }
  }

  void initFormState(FunctionRoleItem? role) {
    state = state.copyWith(
      formModule: role?.moduleName ?? '',
      formStatus: (role?.isActive ?? true) ? ActiveInactiveStatus.active : ActiveInactiveStatus.inactive,
      formSelectedFunctions: {...?role?.includedFunctionGuids.where((g) => !(role.inheritedFunctionGuids.contains(g)))},
      formInheritedFunctions: {...?role?.inheritedFunctionGuids},
      formFunctionSearch: '',
      formStep: 0,
      formFunctionGuidToId: Map<String, int>.from(role?.functionGuidToIdMap ?? {}),
    );
  }

  void goToFormStep(int step) => state = state.copyWith(formStep: step);

  void updateFormModule(String module) => state = state.copyWith(formModule: module);

  void updateFormStatus(ActiveInactiveStatus? status) {
    if (status == null) return;
    state = state.copyWith(formStatus: status);
  }

  void toggleFormFunction(String functionGuid) {
    if (state.formInheritedFunctions.contains(functionGuid)) return;
    final updated = Set<String>.from(state.formSelectedFunctions);
    final updatedIdMap = Map<String, int>.from(state.formFunctionGuidToId);
    if (updated.contains(functionGuid)) {
      updated.remove(functionGuid);
    } else {
      updated.add(functionGuid);
      final fn = _ref
          .read(securityFunctionsProvider)
          .functions
          .firstWhere(
            (f) => f.functionGuid == functionGuid,
            orElse: () => throw StateError('Function not found: $functionGuid'),
          );
      updatedIdMap[functionGuid] = fn.functionId;
    }
    state = state.copyWith(formSelectedFunctions: updated, formFunctionGuidToId: updatedIdMap);
  }

  void updateFormFunctionSearch(String query) => state = state.copyWith(formFunctionSearch: query);

  void goToPage(int page) {
    final targetPage = page.clamp(1, state.totalPages);
    if (targetPage == state.currentPage) return;
    state = state.copyWith(currentPage: targetPage);
    refresh(showListLoading: false);
  }

  void nextPage() => goToPage(state.safeCurrentPage + 1);

  void previousPage() => goToPage(state.safeCurrentPage - 1);
}

final functionRolesProvider = StateNotifierProvider<FunctionRolesNotifier, FunctionRolesState>((ref) {
  return FunctionRolesNotifier(
    ref.watch(getFunctionRolesUseCaseProvider),
    ref.watch(functionRolesRepositoryProvider),
    ref,
  );
});

final filteredSecurityFunctionsProvider = Provider<List<SecurityFunction>>((ref) {
  return ref.watch(securityFunctionsProvider).functions;
});

/// Available module names derived from [securityModulesProvider].
final formModuleNamesProvider = Provider<List<String>>((ref) {
  return ref.watch(securityModulesProvider).modules.map((m) => m.moduleName).toList();
});

/// The currently selected module name, validated against available modules.
final formModuleProvider = Provider<String?>((ref) {
  final names = ref.watch(formModuleNamesProvider);
  final selected = ref.watch(functionRolesProvider).formModule;
  if (names.isEmpty || !names.contains(selected)) return null;
  return selected;
});

/// Whether modules are still loading for the first time.
final formModulesLoadingProvider = Provider<bool>((ref) {
  final modulesState = ref.watch(securityModulesProvider);
  return modulesState.isLoading && modulesState.modules.isEmpty;
});

/// Error string from [securityModulesProvider], if any.
final formModulesErrorProvider = Provider<String?>((ref) {
  return ref.watch(securityModulesProvider).error;
});
