import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import '../../../data/datasources/compensation_plans/compensation_plans_remote_data_source.dart';
import '../../../data/repositories/compensation_plans/compensation_plans_repository_impl.dart';
import '../../../domain/models/compensation_plans/compensation_plan.dart';
import '../../../domain/repositories/compensation_plans/compensation_plans_repository.dart';
import '../../../domain/usecases/compensation_plans/get_compensation_plan_detail_usecase.dart';

final _compensationPlansApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _compensationPlansRemoteDataSourceProvider = Provider<CompensationPlansRemoteDataSource>((ref) {
  return CompensationPlansRemoteDataSourceImpl(apiClient: ref.watch(_compensationPlansApiClientProvider));
});

final _compensationPlansRepositoryProvider = Provider<CompensationPlansRepository>((ref) {
  return CompensationPlansRepositoryImpl(remoteDataSource: ref.watch(_compensationPlansRemoteDataSourceProvider));
});

final _getCompensationPlanDetailUseCaseProvider = Provider<GetCompensationPlanDetailUseCase>((ref) {
  return GetCompensationPlanDetailUseCase(repository: ref.watch(_compensationPlansRepositoryProvider));
});

final compensationPlanDetailProvider = FutureProvider.family.autoDispose<CompensationPlan, String>((
  ref,
  planGuid,
) async {
  final useCase = ref.watch(_getCompensationPlanDetailUseCaseProvider);
  return useCase(planGuid: planGuid);
});
