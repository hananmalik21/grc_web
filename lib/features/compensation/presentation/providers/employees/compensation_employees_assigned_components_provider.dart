import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/employees/compensation_employees_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/employees/employees_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employees_repository.dart';
import 'package:grc/features/compensation/domain/usecases/employees/create_salary_adjustment_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/employees/get_employee_adjustment_details_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/employees/get_employee_assigned_components_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _employeeAssignedComponentsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _employeeAssignedComponentsRemoteDataSourceProvider = Provider<CompensationEmployeesRemoteDataSource>((ref) {
  return CompensationEmployeesRemoteDataSourceImpl(apiClient: ref.watch(_employeeAssignedComponentsApiClientProvider));
});

final _employeeAssignedComponentsRepositoryProvider = Provider<EmployeesRepository>((ref) {
  return EmployeesRepositoryImpl(remoteDataSource: ref.watch(_employeeAssignedComponentsRemoteDataSourceProvider));
});

final getEmployeeAssignedComponentsUseCaseProvider = Provider<GetEmployeeAssignedComponentsUseCase>((ref) {
  return GetEmployeeAssignedComponentsUseCase(repository: ref.watch(_employeeAssignedComponentsRepositoryProvider));
});

final createSalaryAdjustmentUseCaseProvider = Provider<CreateSalaryAdjustmentUseCase>((ref) {
  return CreateSalaryAdjustmentUseCase(repository: ref.watch(_employeeAssignedComponentsRepositoryProvider));
});

final getEmployeeAdjustmentDetailsUseCaseProvider = Provider<GetEmployeeAdjustmentDetailsUseCase>((ref) {
  return GetEmployeeAdjustmentDetailsUseCase(repository: ref.watch(_employeeAssignedComponentsRepositoryProvider));
});

final employeeAssignedComponentsProvider = FutureProvider.family<List<EmployeeAssignedComponent>, String>((
  ref,
  employeeGuid,
) async {
  final useCase = ref.watch(getEmployeeAssignedComponentsUseCaseProvider);
  return useCase(employeeGuid: employeeGuid);
});
