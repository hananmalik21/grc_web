import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/employee_management/application/edit_employee_compensation/controllers/edit_employee_assigned_components_controller.dart';
import 'package:grc/features/employee_management/data/datasources/edit_employee_assigned_components_remote_data_source.dart';
import 'package:grc/features/employee_management/data/repositories/edit_employee_assigned_components_repository_impl.dart';
import 'package:grc/features/employee_management/domain/models/edit_employee_assigned_component.dart';
import 'package:grc/features/employee_management/domain/repositories/edit_employee_assigned_components_repository.dart';
import 'package:grc/features/employee_management/domain/usecases/get_edit_employee_assigned_components_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _editEmployeeAssignedComponentsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final editEmployeeAssignedComponentsRemoteDataSourceProvider = Provider<EditEmployeeAssignedComponentsRemoteDataSource>(
  (ref) {
    return EditEmployeeAssignedComponentsRemoteDataSourceImpl(
      apiClient: ref.watch(_editEmployeeAssignedComponentsApiClientProvider),
    );
  },
);

final editEmployeeAssignedComponentsRepositoryProvider = Provider<EditEmployeeAssignedComponentsRepository>((ref) {
  return EditEmployeeAssignedComponentsRepositoryImpl(
    remoteDataSource: ref.watch(editEmployeeAssignedComponentsRemoteDataSourceProvider),
  );
});

final getEditEmployeeAssignedComponentsUseCaseProvider = Provider<GetEditEmployeeAssignedComponentsUseCase>((ref) {
  return GetEditEmployeeAssignedComponentsUseCase(
    repository: ref.watch(editEmployeeAssignedComponentsRepositoryProvider),
  );
});

final editEmployeeAssignedComponentsProvider = AsyncNotifierProvider.autoDispose
    .family<EditEmployeeAssignedComponentsController, List<EditEmployeeAssignedComponent>, String>(
      EditEmployeeAssignedComponentsController.new,
    );
