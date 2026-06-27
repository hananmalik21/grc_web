import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/data/repositories/duty_roles/duty_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/usecases/get_duty_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_role_form_inherited_picker_state.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
export 'duty_role_form_inherited_picker_state.dart';

class DutyRoleFormInheritedPickerNotifier extends StateNotifier<DutyRoleFormInheritedPickerState> {
  DutyRoleFormInheritedPickerNotifier(this._useCase, this._ref) : super(const DutyRoleFormInheritedPickerState());

  final GetDutyRolesUseCase _useCase;
  final Ref _ref;

  void initForForm(DutyRoleItem? editingRole, {Set<String> initialSelectedGuids = const {}}) {
    state = DutyRoleFormInheritedPickerState(
      editingRoleGuid: editingRole?.dutyRoleGuid,
      selectedGuids: initialSelectedGuids,
    );
  }

  Future<void> load() async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = state.copyWith(isLoading: false, roles: const []);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final roles = await _useCase(enterpriseId: enterpriseId, page: 1, pageSize: 10);
      state = state.copyWith(
        roles: roles.roles.map(DutyRoleItem.fromDutyRole).toList(),
        isLoading: false,
        currentPage: 1,
      );
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

  void toggleSelection(String dutyRoleGuid) {
    final updated = Set<String>.from(state.selectedGuids);
    if (updated.contains(dutyRoleGuid)) {
      updated.remove(dutyRoleGuid);
    } else {
      updated.add(dutyRoleGuid);
    }
    state = state.copyWith(selectedGuids: updated);
  }
}

final dutyRoleFormInheritedPickerProvider =
    StateNotifierProvider.autoDispose<DutyRoleFormInheritedPickerNotifier, DutyRoleFormInheritedPickerState>((ref) {
      final client = ApiClient(baseUrl: ApiConfig.baseUrl);
      final repository = DutyRolesRepositoryImpl(client);
      final useCase = GetDutyRolesUseCase(repository);
      return DutyRoleFormInheritedPickerNotifier(useCase, ref);
    });
