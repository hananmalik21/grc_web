import 'package:grc/features/employee_management/application/edit_employee_compensation/providers/edit_employee_assigned_components_providers.dart';
import 'package:grc/features/employee_management/domain/models/edit_employee_assigned_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditEmployeeAssignedComponentsController
    extends AutoDisposeFamilyAsyncNotifier<List<EditEmployeeAssignedComponent>, String> {
  @override
  Future<List<EditEmployeeAssignedComponent>> build(String employeeGuid) async {
    if (employeeGuid.isEmpty) return [];
    final useCase = ref.read(getEditEmployeeAssignedComponentsUseCaseProvider);
    return useCase(employeeGuid: employeeGuid);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}
