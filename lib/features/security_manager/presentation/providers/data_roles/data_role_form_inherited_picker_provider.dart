import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/data/repositories/data_roles/data_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/features/security_manager/domain/usecases/get_data_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_role_form_inherited_picker_state.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'data_role_form_inherited_picker_state.dart';

class DataRoleFormInheritedPickerNotifier extends StateNotifier<DataRoleFormInheritedPickerState> {
  DataRoleFormInheritedPickerNotifier(this._useCase, this._ref) : super(const DataRoleFormInheritedPickerState());

  final GetDataRolesUseCase _useCase;
  final Ref _ref;

  static const int _apiPageSize = 10;

  void initForForm(DataRoleItem? editingRole, {Set<String> initialSelectedGuids = const {}}) {
    state = DataRoleFormInheritedPickerState(
      editingRoleGuid: editingRole?.dataRoleGuid,
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
      final accumulated = <DataRole>[];
      var apiPage = 1;
      var reportedTotal = 0;
      while (true) {
        final page = await _useCase(
          enterpriseId: enterpriseId,
          page: apiPage,
          pageSize: _apiPageSize,
          search: null,
          dataTypeCode: null,
        );
        if (apiPage == 1) {
          reportedTotal = page.total;
        }
        accumulated.addAll(page.roles);
        if (!page.hasNext || page.roles.isEmpty) break;
        if (reportedTotal > 0 && accumulated.length >= reportedTotal) break;
        apiPage++;
        if (apiPage > 500) break;
      }

      state = state.copyWith(
        roles: accumulated.map(DataRoleItem.fromDataRole).toList(),
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

  void toggleSelection(String dataRoleGuid) {
    final updated = Set<String>.from(state.selectedGuids);
    if (updated.contains(dataRoleGuid)) {
      updated.remove(dataRoleGuid);
    } else {
      updated.add(dataRoleGuid);
    }
    state = state.copyWith(selectedGuids: updated);
  }
}

final dataRoleFormInheritedPickerProvider =
    StateNotifierProvider.autoDispose<DataRoleFormInheritedPickerNotifier, DataRoleFormInheritedPickerState>((ref) {
      final client = ApiClient(baseUrl: ApiConfig.baseUrl);
      final repository = DataRolesRepositoryImpl(client);
      final useCase = GetDataRolesUseCase(repository);
      return DataRoleFormInheritedPickerNotifier(useCase, ref);
    });
