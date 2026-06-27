import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/datasources/components/comp_components_remote_data_source.dart';
import 'package:grc/features/compensation/data/datasources/salary_structure_management/salary_structure_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/components/comp_components_repository_impl.dart';
import 'package:grc/features/compensation/data/repositories/salary_structure_management/salary_structure_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_full_details.dart';
import 'package:grc/features/compensation/domain/repositories/components/comp_components_repository.dart';
import 'package:grc/features/compensation/domain/repositories/salary_structure_management/salary_structure_repository.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/manage_salary_structure_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_creation_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_submission_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'update_salary_structure_api_state.dart';

// ── Private infrastructure providers ─────────────────────────────────────────

final _updateSalaryStructureApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _updateSalaryStructureRemoteDataSourceProvider =
    Provider<SalaryStructureRemoteDataSource>((ref) {
  return SalaryStructureRemoteDataSourceImpl(
    apiClient: ref.watch(_updateSalaryStructureApiClientProvider),
  );
});

final _updateSalaryStructureRepositoryProvider = Provider<SalaryStructureRepository>((ref) {
  return SalaryStructureRepositoryImpl(
    remoteDataSource: ref.watch(_updateSalaryStructureRemoteDataSourceProvider),
  );
});

final _editCompComponentsRemoteDataSourceProvider =
    Provider<CompComponentsRemoteDataSource>((ref) {
  return CompComponentsRemoteDataSourceImpl(
    apiClient: ref.watch(_updateSalaryStructureApiClientProvider),
  );
});

final _editCompComponentsRepositoryProvider = Provider<CompComponentsRepository>((ref) {
  return CompComponentsRepositoryImpl(
    remoteDataSource: ref.watch(_editCompComponentsRemoteDataSourceProvider),
  );
});

// ── Public providers ──────────────────────────────────────────────────────────

/// Fetches the full salary structure details for pre-filling the edit form.
final salaryStructureFullDetailsProvider = FutureProvider.autoDispose
    .family<SalaryStructureFullDetails, (String, int)>((ref, args) async {
  final (structureGuid, enterpriseId) = args;
  final repository = ref.watch(_updateSalaryStructureRepositoryProvider);
  return repository.getSalaryStructureFullDetails(
    enterpriseId: enterpriseId,
    structureGuid: structureGuid,
  );
});

/// Fetches all components for a given enterprise (used to match IDs during
/// edit pre-fill).
final salaryStructureEditComponentsProvider =
    FutureProvider.autoDispose.family<List<CompComponent>, int>((ref, enterpriseId) async {
  final repository = ref.watch(_editCompComponentsRepositoryProvider);
  final page = await repository.getComponents(
    tenantId: enterpriseId,
    page: 1,
    pageSize: 500,
  );
  return page.items;
});

// ── Update API notifier ───────────────────────────────────────────────────────

/// Handles the PUT request to update an existing salary structure.
/// Use as a family provider keyed by [structureGuid].
final updateSalaryStructureApiProvider = StateNotifierProvider.autoDispose
    .family<UpdateSalaryStructureApiNotifier, UpdateSalaryStructureApiState, String>(
  (ref, structureGuid) => UpdateSalaryStructureApiNotifier(ref, structureGuid),
);

class UpdateSalaryStructureApiNotifier
    extends StateNotifier<UpdateSalaryStructureApiState> {
  UpdateSalaryStructureApiNotifier(this._ref, this._structureGuid)
      : super(const UpdateSalaryStructureApiState.idle());

  final Ref _ref;
  final String _structureGuid;

  void reset() => state = const UpdateSalaryStructureApiState.idle();

  Future<String?> submit() async {
    final formState = _ref.read(salaryStructureCreationProvider);
    final enterpriseId = _ref.read(manageSalaryStructureEnterpriseIdProvider);

    if (enterpriseId == null) {
      state = const UpdateSalaryStructureApiState.failure('No enterprise selected.');
      return state.errorMessage;
    }

    final countryValues =
        await _ref.read(manageSalaryStructureCountryLookupValuesProvider.future);
    final mapped = SalaryStructureSubmissionMapper.buildRequest(
      formState: formState,
      enterpriseId: enterpriseId,
      countryLookupValues: countryValues,
    );

    final request = mapped.request;
    if (request == null) {
      state = UpdateSalaryStructureApiState.failure(
        mapped.error ?? 'Missing required data to submit.',
      );
      return state.errorMessage;
    }

    state = const UpdateSalaryStructureApiState.loading();
    try {
      final repository = _ref.read(_updateSalaryStructureRepositoryProvider);
      await repository.updateSalaryStructure(
        structureGuid: _structureGuid,
        request: request,
      );
      state = const UpdateSalaryStructureApiState.success();
      return null;
    } on AppException catch (e) {
      final message =
          e.message.isNotEmpty ? e.message : 'Failed to update salary structure.';
      state = UpdateSalaryStructureApiState.failure(message);
      return message;
    } catch (e) {
      final message = 'Failed to update salary structure: ${e.toString()}';
      state = UpdateSalaryStructureApiState.failure(message);
      return message;
    }
  }
}
