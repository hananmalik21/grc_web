import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/compensation_plans/compensation_plans_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/compensation_plans/compensation_plans_repository_impl.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';
import 'package:grc/features/compensation/domain/usecases/compensation_plans/create_employee_compensation_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/compensation_plans/get_eligible_plans_by_criteria_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/compensation_plans/get_eligible_plans_by_position_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/compensation_plans/get_eligible_plans_for_employee_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final compensationPlansApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final compensationPlansRemoteDataSourceProvider = Provider<CompensationPlansRemoteDataSource>((ref) {
  return CompensationPlansRemoteDataSourceImpl(apiClient: ref.watch(compensationPlansApiClientProvider));
});

final compensationPlansRepositoryProvider = Provider<CompensationPlansRepository>((ref) {
  return CompensationPlansRepositoryImpl(remoteDataSource: ref.watch(compensationPlansRemoteDataSourceProvider));
});

final getEligiblePlansForEmployeeUseCaseProvider = Provider<GetEligiblePlansForEmployeeUseCase>((ref) {
  return GetEligiblePlansForEmployeeUseCase(repository: ref.watch(compensationPlansRepositoryProvider));
});

final getEligiblePlansByCriteriaUseCaseProvider = Provider<GetEligiblePlansByCriteriaUseCase>((ref) {
  return GetEligiblePlansByCriteriaUseCase(repository: ref.watch(compensationPlansRepositoryProvider));
});

final getEligiblePlansByPositionUseCaseProvider = Provider<GetEligiblePlansByPositionUseCase>((ref) {
  return GetEligiblePlansByPositionUseCase(repository: ref.watch(compensationPlansRepositoryProvider));
});

final createEmployeeCompensationUseCaseProvider = Provider<CreateEmployeeCompensationUseCase>((ref) {
  return CreateEmployeeCompensationUseCase(repository: ref.watch(compensationPlansRepositoryProvider));
});
