import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/employee_management/application/add_employee_compensation/controllers/add_employee_compensation_controller.dart';
import 'package:grc/features/employee_management/application/add_employee_compensation/controllers/add_employee_compensation_form_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:grc/features/employee_management/application/add_employee_compensation/controllers/add_employee_compensation_controller.dart';
export 'package:grc/features/employee_management/application/add_employee_compensation/controllers/add_employee_compensation_form_controller.dart';
export 'package:grc/features/employee_management/application/add_employee_compensation/providers/add_employee_compensation_context_providers.dart';
export 'package:grc/features/employee_management/application/add_employee_compensation/states/add_employee_compensation_state.dart';

final addEmployeeCompensationFormControllerProvider = Provider.autoDispose<AddEmployeeCompensationFormController>((
  ref,
) {
  final controller = AddEmployeeCompensationFormController();
  ref.onDispose(controller.dispose);
  return controller;
});

final addEmployeeCompensationProvider = NotifierProvider<CompensationPlansSelectionNotifier, AddCompensationPlansState>(
  AddEmployeeCompensationController.new,
);
