import 'package:grc/features/employee_management/data/datasources/edit_employee_assigned_components_remote_data_source.dart';
import 'package:grc/features/employee_management/domain/models/edit_employee_assigned_component.dart';
import 'package:grc/features/employee_management/domain/repositories/edit_employee_assigned_components_repository.dart';

class EditEmployeeAssignedComponentsRepositoryImpl implements EditEmployeeAssignedComponentsRepository {
  EditEmployeeAssignedComponentsRepositoryImpl({required this.remoteDataSource});

  final EditEmployeeAssignedComponentsRemoteDataSource remoteDataSource;

  @override
  Future<List<EditEmployeeAssignedComponent>> getAssignedComponents({required String employeeGuid}) async {
    final items = await remoteDataSource.getAssignedComponents(employeeGuid: employeeGuid);
    return items.map(EditEmployeeAssignedComponent.fromJson).where((component) => component.isActive).toList();
  }
}
