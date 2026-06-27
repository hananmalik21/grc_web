import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/datasources/compensation_plans/compensation_plans_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/compensation_plans/compensation_plans_repository_impl.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';
import 'package:grc/features/compensation/domain/usecases/compensation_plans/create_compensation_plan_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_table_rows_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_compensation_plan_api_state.dart';
import 'create_compensation_plan_provider.dart';
import 'create_compensation_plan_submission_mapper.dart';

final _createCompensationPlanApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _createCompensationPlanRemoteDataSourceProvider = Provider<CompensationPlansRemoteDataSource>((ref) {
  return CompensationPlansRemoteDataSourceImpl(apiClient: ref.watch(_createCompensationPlanApiClientProvider));
});

final _createCompensationPlanRepositoryProvider = Provider<CompensationPlansRepository>((ref) {
  return CompensationPlansRepositoryImpl(remoteDataSource: ref.watch(_createCompensationPlanRemoteDataSourceProvider));
});

final _createCompensationPlanUseCaseProvider = Provider<CreateCompensationPlanUseCase>((ref) {
  return CreateCompensationPlanUseCase(repository: ref.watch(_createCompensationPlanRepositoryProvider));
});

final createCompensationPlanApiProvider =
    StateNotifierProvider.autoDispose<CreateCompensationPlanApiNotifier, CreateCompensationPlanApiState>((ref) {
      return CreateCompensationPlanApiNotifier(ref);
    });

class CreateCompensationPlanApiNotifier extends StateNotifier<CreateCompensationPlanApiState> {
  CreateCompensationPlanApiNotifier(this._ref) : super(const CreateCompensationPlanApiState.idle());

  final Ref _ref;

  void reset() => state = const CreateCompensationPlanApiState.idle();

  Future<String?> submit() async {
    final formState = _ref.read(createCompensationPlanProvider);
    final enterpriseId = _ref.read(compensationPlansTabEnterpriseIdProvider);

    if (enterpriseId == null) {
      state = const CreateCompensationPlanApiState.failure('No enterprise selected.');
      return state.errorMessage;
    }

    final companyScope = _ref.read(compensationPlanCompanyScopeSelectionProvider);
    final attributeLookupValues = await _ref.read(compensationPlansLookupValuesProvider('COMP_PLAN_ATTRUBUTES').future);
    final locationLookupValues = await _ref.read(compensationPlansLookupValuesProvider('COMPONENT_LOCATION').future);

    final componentFrequencies = formState.componentFrequencies.map((id, lookup) => MapEntry(id, lookup.valueCode));
    final componentPayBases = formState.componentPayBases.map((id, lookup) => MapEntry(id, lookup.valueCode));

    final mapped = CreateCompensationPlanSubmissionMapper.buildRequest(
      formState: formState,
      enterpriseId: enterpriseId,
      companyScope: companyScope,
      planAttributeLookupValues: attributeLookupValues,
      locationLookupValues: locationLookupValues,
      componentFrequencies: componentFrequencies,
      componentPayBases: componentPayBases,
    );

    final request = mapped.request;
    if (request == null) {
      state = CreateCompensationPlanApiState.failure(mapped.error ?? 'Missing required data to submit.');
      return state.errorMessage;
    }

    state = const CreateCompensationPlanApiState.loading();
    try {
      final useCase = _ref.read(_createCompensationPlanUseCaseProvider);
      await useCase(request: request);
      _ref.invalidate(compensationPlansPageProvider);
      state = const CreateCompensationPlanApiState.success();
      return null;
    } on AppException catch (e) {
      final message = e.message.isNotEmpty ? e.message : 'Failed to create compensation plan.';
      state = CreateCompensationPlanApiState.failure(message);
      return message;
    } catch (e) {
      final message = 'Failed to create compensation plan: ${e.toString()}';
      state = CreateCompensationPlanApiState.failure(message);
      return message;
    }
  }
}
