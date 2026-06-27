import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/compensation/presentation/providers/employees/compensation_employees_assigned_components_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<EmployeeAssignedComponent> _activeAssignedComponents(List<EmployeeAssignedComponent> components) {
  return components.where((component) {
    final flag = component.activeFlag.trim().toUpperCase();
    return flag == 'Y' || flag == 'TRUE';
  }).toList();
}

final addElementAssignedComponentsProvider = FutureProvider.autoDispose.family<List<EmployeeAssignedComponent>, String>(
  (ref, employeeGuid) async {
    final trimmedGuid = employeeGuid.trim();
    if (trimmedGuid.isEmpty) return const [];

    final components = await ref.watch(employeeAssignedComponentsProvider(trimmedGuid).future);
    return _activeAssignedComponents(components);
  },
);
