import '../../models/employees/employee_assigned_component.dart';
import '../../repositories/employees/employees_repository.dart';

class GetEmployeeAssignedComponentsUseCase {
  final EmployeesRepository repository;

  GetEmployeeAssignedComponentsUseCase({required this.repository});

  Future<List<EmployeeAssignedComponent>> call({required String employeeGuid}) {
    return repository.getEmployeeAssignedComponents(employeeGuid: employeeGuid);
  }
}
