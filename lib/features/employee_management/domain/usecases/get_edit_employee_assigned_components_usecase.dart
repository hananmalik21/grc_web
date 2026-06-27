import 'package:grc/features/employee_management/domain/models/edit_employee_assigned_component.dart';
import 'package:grc/features/employee_management/domain/repositories/edit_employee_assigned_components_repository.dart';

class GetEditEmployeeAssignedComponentsUseCase {
  const GetEditEmployeeAssignedComponentsUseCase({required this.repository});

  final EditEmployeeAssignedComponentsRepository repository;

  Future<List<EditEmployeeAssignedComponent>> call({required String employeeGuid}) {
    return repository.getAssignedComponents(employeeGuid: employeeGuid);
  }
}
