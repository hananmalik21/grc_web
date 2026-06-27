import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/create_salary_adjustment_page.dart';
import 'package:flutter/material.dart';

class CreateSalaryAdjustmentMobileSheet extends StatelessWidget {
  const CreateSalaryAdjustmentMobileSheet({super.key});

  static Future<bool> show(BuildContext context, {String? employeeGuid, int? enterpriseId}) async {
    final lockEmployee = employeeGuid != null && employeeGuid.isNotEmpty;
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Salary Adjustment',
      barrierDismissible: false,
      child: CreateSalaryAdjustmentContent(
        showPageHeader: false,
        initialEmployeeGuid: employeeGuid,
        initialEnterpriseId: enterpriseId,
        lockEmployeeSelection: lockEmployee,
        returnResultOnSuccess: lockEmployee,
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return const CreateSalaryAdjustmentContent(showPageHeader: false);
  }
}
