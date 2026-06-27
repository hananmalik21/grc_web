import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/usecases/get_function_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_role_form_inherited_picker_state.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_dependencies.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionRoleFormInheritedPickerNotifier extends StateNotifier<FunctionRoleFormInheritedPickerState> {
  FunctionRoleFormInheritedPickerNotifier(this._getFunctionRoles, this._ref)
    : super(const FunctionRoleFormInheritedPickerState());

  final GetFunctionRolesUseCase _getFunctionRoles;
  final Ref _ref;

  void initForForm(FunctionRoleItem? editingRole) {
    state = FunctionRoleFormInheritedPickerState(
      editingRoleGuid: editingRole?.functionRoleGuid,
      initialParentRoleIds: editingRole?.inheritedParentRoleIds ?? const [],
    );
  }

  Future<void> load() async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(roles: const [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final roles = await _getFunctionRoles(
        enterpriseId: enterpriseId,
        search: null,
        moduleId: null,
        page: 1,
        pageSize: 10,
      );
      final items = roles.roles.map(FunctionRoleItem.fromFunctionRole).toList();
      final parentIds = state.initialParentRoleIds;
      final preSelected = parentIds.isEmpty
          ? state.selectedGuids
          : items.where((r) => parentIds.contains(int.tryParse(r.id))).map((r) => r.functionRoleGuid).toSet();
      state = state.copyWith(roles: items, isLoading: false, currentPage: 1, selectedGuids: preSelected);
    } on AppException catch (_) {
      state = state.copyWith(isLoading: false, roles: const []);
    } catch (_) {
      state = state.copyWith(isLoading: false, roles: const []);
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
  }

  void goToPage(int page) {
    state = state.copyWith(currentPage: page.clamp(1, state.totalPages));
  }

  void nextPage() => goToPage(state.safePage + 1);

  void previousPage() => goToPage(state.safePage - 1);

  void toggleSelection(String functionRoleGuid) {
    final updated = Set<String>.from(state.selectedGuids);
    if (updated.contains(functionRoleGuid)) {
      updated.remove(functionRoleGuid);
    } else {
      updated.add(functionRoleGuid);
    }
    state = state.copyWith(selectedGuids: updated);
  }
}

final functionRoleFormInheritedPickerProvider =
    StateNotifierProvider.autoDispose<FunctionRoleFormInheritedPickerNotifier, FunctionRoleFormInheritedPickerState>((
      ref,
    ) {
      return FunctionRoleFormInheritedPickerNotifier(ref.watch(getFunctionRolesUseCaseProvider), ref);
    });
