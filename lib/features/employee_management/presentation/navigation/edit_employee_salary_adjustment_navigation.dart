import 'package:grc/core/navigation/root_navigator_key.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/create_salary_adjustment_page.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_stepper_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/edit_employee_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum EditEmployeeSalaryAdjustmentOutcome { completed, cancelled }

/// Compensation step index in the edit-employee stepper.
const int kEditEmployeeCompensationStepIndex = 5;

Future<EditEmployeeSalaryAdjustmentOutcome> openEditEmployeeSalaryAdjustment({
  required String employeeGuid,
  required int enterpriseId,
  required BuildContext context,
}) async {
  final router = GoRouter.of(context);
  final container = ProviderScope.containerOf(context);
  final rootContext = rootNavigatorKey.currentContext;

  container.read(addEmployeeStepperProvider.notifier).setStep(kEditEmployeeCompensationStepIndex);

  if (context.mounted) {
    Navigator.of(context).pop();
  }

  final pushContext = rootContext;
  if (pushContext == null || !pushContext.mounted) {
    return EditEmployeeSalaryAdjustmentOutcome.cancelled;
  }

  final result = await router.pushNamed<bool?>(
    CreateSalaryAdjustmentPage.routeName,
    queryParameters: {'employeeGuid': employeeGuid, 'enterpriseId': enterpriseId.toString()},
  );

  if (!pushContext.mounted) {
    return EditEmployeeSalaryAdjustmentOutcome.cancelled;
  }

  if (result == true) {
    await EditEmployeeDialog.resume(pushContext, employeeGuid);
    return EditEmployeeSalaryAdjustmentOutcome.completed;
  }

  await EditEmployeeDialog.resume(pushContext, employeeGuid);
  return EditEmployeeSalaryAdjustmentOutcome.cancelled;
}
