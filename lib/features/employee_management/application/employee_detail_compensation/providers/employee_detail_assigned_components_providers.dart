import 'package:grc/features/employee_management/application/employee_detail_compensation/controllers/employee_detail_assigned_components_controller.dart';
import 'package:grc/features/employee_management/application/employee_detail_compensation/states/employee_detail_assigned_components_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeDetailAssignedComponentsProvider = AsyncNotifierProvider.autoDispose
    .family<EmployeeDetailAssignedComponentsController, EmployeeDetailAssignedComponentsState, String>(
      EmployeeDetailAssignedComponentsController.new,
    );
