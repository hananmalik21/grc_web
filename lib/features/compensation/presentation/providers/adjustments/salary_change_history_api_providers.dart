import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/remote/salary_change_history_remote_datasource.dart';
import 'package:grc/features/compensation/data/repositories/salary_change_history_repository_impl.dart';
import 'package:grc/features/compensation/domain/repositories/salary_change_history_repository.dart';
import 'package:grc/features/compensation/domain/usecases/adjustments/get_salary_change_history_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final salaryChangeHistoryApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final salaryChangeHistoryRemoteDataSourceProvider = Provider<SalaryChangeHistoryRemoteDataSource>((ref) {
  return SalaryChangeHistoryRemoteDataSourceImpl(apiClient: ref.watch(salaryChangeHistoryApiClientProvider));
});

final salaryChangeHistoryRepositoryProvider = Provider<SalaryChangeHistoryRepository>((ref) {
  return SalaryChangeHistoryRepositoryImpl(remoteDataSource: ref.watch(salaryChangeHistoryRemoteDataSourceProvider));
});

final getSalaryChangeHistoryUseCaseProvider = Provider<GetSalaryChangeHistoryUseCase>((ref) {
  return GetSalaryChangeHistoryUseCase(repository: ref.watch(salaryChangeHistoryRepositoryProvider));
});
