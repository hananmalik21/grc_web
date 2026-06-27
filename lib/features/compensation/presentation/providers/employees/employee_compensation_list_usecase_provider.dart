import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/employees/employee_compensation_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/employees/employee_compensation_repository_impl.dart';
import 'package:grc/features/compensation/domain/usecases/employees/get_employee_compensation_list_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final getEmployeeCompensationListUseCaseProvider = Provider<GetEmployeeCompensationListUseCase>((ref) {
  final apiClient = ref.watch(_apiClientProvider);

  final remoteDataSource = EmployeeCompensationRemoteDataSourceImpl(apiClient: apiClient);
  final repository = EmployeeCompensationRepositoryImpl(remoteDataSource: remoteDataSource);

  return GetEmployeeCompensationListUseCase(repository: repository);
});
