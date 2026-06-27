import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/screens/employee_compensation/create_employee_compensation_plan_page.dart';
import 'package:flutter/material.dart';

class CreateEmployeeCompensationPlanMobileSheet extends StatelessWidget {
  const CreateEmployeeCompensationPlanMobileSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Employee Compensation',
      barrierDismissible: false,
      child: const CreateEmployeeCompensationPlanContent(showPageHeader: false),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return const CreateEmployeeCompensationPlanContent(showPageHeader: false);
  }
}
