import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/datasources/compensation_plans/compensation_plans_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/compensation_plans/compensation_plans_repository_impl.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';
import 'package:grc/features/compensation/domain/usecases/compensation_plans/update_compensation_plan_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_table_rows_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_submission_mapper.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EditCompensationPlanApiStatus { idle, loading, success, failure }

class EditCompensationPlanApiState {
  final EditCompensationPlanApiStatus status;
  final String? errorMessage;

  const EditCompensationPlanApiState._(this.status, {this.errorMessage});

  const EditCompensationPlanApiState.idle() : this._(EditCompensationPlanApiStatus.idle);
  const EditCompensationPlanApiState.loading() : this._(EditCompensationPlanApiStatus.loading);
  const EditCompensationPlanApiState.success() : this._(EditCompensationPlanApiStatus.success);
  const EditCompensationPlanApiState.failure(String message)
    : this._(EditCompensationPlanApiStatus.failure, errorMessage: message);

  bool get isLoading => status == EditCompensationPlanApiStatus.loading;
  bool get isSuccess => status == EditCompensationPlanApiStatus.success;
  bool get isFailure => status == EditCompensationPlanApiStatus.failure;
}

final _editCompensationPlanApiClientProvider = Provider.autoDispose<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _editCompensationPlanRemoteDataSourceProvider = Provider.autoDispose<CompensationPlansRemoteDataSource>((ref) {
  return CompensationPlansRemoteDataSourceImpl(apiClient: ref.watch(_editCompensationPlanApiClientProvider));
});

final _editCompensationPlanRepositoryProvider = Provider.autoDispose<CompensationPlansRepository>((ref) {
  return CompensationPlansRepositoryImpl(remoteDataSource: ref.watch(_editCompensationPlanRemoteDataSourceProvider));
});

final _updateCompensationPlanUseCaseProvider = Provider.autoDispose<UpdateCompensationPlanUseCase>((ref) {
  return UpdateCompensationPlanUseCase(repository: ref.watch(_editCompensationPlanRepositoryProvider));
});

final editCompensationPlanApiProvider =
    StateNotifierProvider.autoDispose<EditCompensationPlanApiNotifier, EditCompensationPlanApiState>(
      dependencies: [createCompensationPlanProvider, compensationPlanCompanyScopeSelectionProvider],
      (ref) => EditCompensationPlanApiNotifier(ref),
    );

class EditCompensationPlanApiNotifier extends StateNotifier<EditCompensationPlanApiState> {
  EditCompensationPlanApiNotifier(this._ref) : super(const EditCompensationPlanApiState.idle());

  final Ref _ref;

  void reset() => state = const EditCompensationPlanApiState.idle();

  Future<String?> submit({required String planGuid}) async {
    final formState = _ref.read(createCompensationPlanProvider);
    final enterpriseId = _ref.read(compensationPlansTabEnterpriseIdProvider);

    if (enterpriseId == null) {
      state = const EditCompensationPlanApiState.failure('No enterprise selected.');
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
      state = EditCompensationPlanApiState.failure(mapped.error ?? 'Missing required data to submit.');
      return state.errorMessage;
    }

    state = const EditCompensationPlanApiState.loading();
    try {
      final useCase = _ref.read(_updateCompensationPlanUseCaseProvider);
      await useCase(planGuid: planGuid, request: request);
      _ref.invalidate(compensationPlansPageProvider);
      state = const EditCompensationPlanApiState.success();
      return null;
    } on AppException catch (e) {
      final message = e.message.isNotEmpty ? e.message : 'Failed to update compensation plan.';
      state = EditCompensationPlanApiState.failure(message);
      return message;
    } catch (e) {
      final message = 'Failed to update compensation plan: ${e.toString()}';
      state = EditCompensationPlanApiState.failure(message);
      return message;
    }
  }
}
