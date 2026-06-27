import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/datasources/salary_structure_management/salary_structure_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/salary_structure_management/salary_structure_repository_impl.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/manage_salary_structure_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/salary_structure_management/salary_structure_repository.dart';
import 'create_salary_structure_api_state.dart';
import 'salary_structure_creation_provider.dart';
import 'salary_structure_submission_mapper.dart';

final _salaryStructureApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _salaryStructureRemoteDataSourceProvider = Provider<SalaryStructureRemoteDataSource>((ref) {
  return SalaryStructureRemoteDataSourceImpl(apiClient: ref.watch(_salaryStructureApiClientProvider));
});

final _salaryStructureRepositoryProvider = Provider<SalaryStructureRepository>((ref) {
  return SalaryStructureRepositoryImpl(remoteDataSource: ref.watch(_salaryStructureRemoteDataSourceProvider));
});

final createSalaryStructureApiProvider =
    StateNotifierProvider.autoDispose<CreateSalaryStructureApiNotifier, CreateSalaryStructureApiState>((ref) {
      return CreateSalaryStructureApiNotifier(ref);
    });

class CreateSalaryStructureApiNotifier extends StateNotifier<CreateSalaryStructureApiState> {
  CreateSalaryStructureApiNotifier(this._ref) : super(const CreateSalaryStructureApiState.idle());

  final Ref _ref;

  void reset() => state = const CreateSalaryStructureApiState.idle();

  Future<String?> submit() async {
    final formState = _ref.read(salaryStructureCreationProvider);
    final enterpriseId = _ref.read(manageSalaryStructureEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = const CreateSalaryStructureApiState.failure('No enterprise selected.');
      return state.errorMessage;
    }

    final countryValues = await _ref.read(manageSalaryStructureCountryLookupValuesProvider.future);
    final mapped = SalaryStructureSubmissionMapper.buildRequest(
      formState: formState,
      enterpriseId: enterpriseId,
      countryLookupValues: countryValues,
    );

    final request = mapped.request;
    if (request == null) {
      state = CreateSalaryStructureApiState.failure(mapped.error ?? 'Missing required data to submit.');
      return state.errorMessage;
    }

    state = const CreateSalaryStructureApiState.loading();
    try {
      final repository = _ref.read(_salaryStructureRepositoryProvider);
      await repository.createSalaryStructure(request);
      state = const CreateSalaryStructureApiState.success();
      return null;
    } on AppException catch (e) {
      final message = e.message.isNotEmpty ? e.message : 'Failed to create salary structure.';
      state = CreateSalaryStructureApiState.failure(message);
      return message;
    } catch (e) {
      final message = 'Failed to create salary structure: ${e.toString()}';
      state = CreateSalaryStructureApiState.failure(message);
      return message;
    }
  }
}
