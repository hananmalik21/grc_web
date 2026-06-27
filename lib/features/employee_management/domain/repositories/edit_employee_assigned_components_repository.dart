import 'package:grc/features/employee_management/domain/models/edit_employee_assigned_component.dart';

abstract class EditEmployeeAssignedComponentsRepository {
  Future<List<EditEmployeeAssignedComponent>> getAssignedComponents({required String employeeGuid});
}
