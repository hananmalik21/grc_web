import 'package:grc/features/employee_management/domain/models/edit_employee_assigned_component.dart';

class EmployeeDetailAssignedComponentsState {
  const EmployeeDetailAssignedComponentsState({this.components = const []});

  final List<EditEmployeeAssignedComponent> components;

  int get activeCount => components.length;

  EmployeeDetailAssignedComponentsState copyWith({List<EditEmployeeAssignedComponent>? components}) {
    return EmployeeDetailAssignedComponentsState(components: components ?? this.components);
  }
}
