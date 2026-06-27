import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/data/repositories/job_roles/job_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:grc/features/security_manager/domain/repositories/job_roles_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/get_job_roles_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_role_form_inherited_picker_state.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'job_role_form_inherited_picker_state.dart';

final _jobRoleInheritedPickerRepositoryProvider = Provider<JobRolesRepository>((ref) {
  return JobRolesRepositoryImpl(ApiClient(baseUrl: ApiConfig.baseUrl));
});

final _getJobRolesForInheritedPickerProvider = Provider<GetJobRolesUseCase>((ref) {
  return GetJobRolesUseCase(ref.watch(_jobRoleInheritedPickerRepositoryProvider));
});

class JobRoleFormInheritedPickerNotifier extends StateNotifier<JobRoleFormInheritedPickerState> {
  JobRoleFormInheritedPickerNotifier(this._getJobRoles, this._ref) : super(const JobRoleFormInheritedPickerState());

  final GetJobRolesUseCase _getJobRoles;
  final Ref _ref;

  static const int _apiPageSize = 10;

  void initForForm(JobRoleItem? editingRole, {Set<String> initialSelectedGuids = const {}}) {
    state = JobRoleFormInheritedPickerState(
      editingRoleGuid: editingRole?.jobRoleGuid,
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
      final accumulated = <JobRole>[];
      var apiPage = 1;
      var reportedTotal = 0;
      while (true) {
        final page = await _getJobRoles(
          enterpriseId: enterpriseId,
          page: apiPage,
          pageSize: _apiPageSize,
          search: null,
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
        roles: accumulated.map(JobRoleItem.fromJobRole).toList(),
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

  void toggleSelection(String jobRoleGuid) {
    final updated = Set<String>.from(state.selectedGuids);
    if (updated.contains(jobRoleGuid)) {
      updated.remove(jobRoleGuid);
    } else {
      updated.add(jobRoleGuid);
    }
    state = state.copyWith(selectedGuids: updated);
  }
}

final jobRoleFormInheritedPickerProvider =
    StateNotifierProvider.autoDispose<JobRoleFormInheritedPickerNotifier, JobRoleFormInheritedPickerState>((ref) {
      return JobRoleFormInheritedPickerNotifier(ref.watch(_getJobRolesForInheritedPickerProvider), ref);
    });
