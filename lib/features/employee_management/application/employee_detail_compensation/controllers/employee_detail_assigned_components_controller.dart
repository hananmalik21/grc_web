import 'package:grc/features/employee_management/application/edit_employee_compensation/providers/edit_employee_assigned_components_providers.dart';
import 'package:grc/features/employee_management/application/employee_detail_compensation/states/employee_detail_assigned_components_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeDetailAssignedComponentsController
    extends AutoDisposeFamilyAsyncNotifier<EmployeeDetailAssignedComponentsState, String> {
  @override
  Future<EmployeeDetailAssignedComponentsState> build(String employeeGuid) async {
    if (employeeGuid.isEmpty) {
      return const EmployeeDetailAssignedComponentsState();
    }

    final useCase = ref.read(getEditEmployeeAssignedComponentsUseCaseProvider);
    final components = await useCase(employeeGuid: employeeGuid);
    return EmployeeDetailAssignedComponentsState(components: components);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}
