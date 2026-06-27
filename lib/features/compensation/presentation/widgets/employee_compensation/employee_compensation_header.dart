import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/employee_compensation_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeCompensationHeader extends StatelessWidget with EmployeeCompensationPermissionMixin {
  const EmployeeCompensationHeader({required this.onCreatePressed, super.key});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: 'Employee Compensation',
      description:
          'Review employee compensation records, track salary distribution, and manage individual pay plans across the organization.',
      trailing: Wrap(
        alignment: WrapAlignment.end,
        runSpacing: 12.h,
        spacing: 12.w,
        children: canCreateEmployeeCompensation
            ? [
                AppButton.primary(
                  label: 'Create New Compensation',
                  onPressed: onCreatePressed,
                  svgPath: Assets.icons.addNewIconFigma.path,
                ),
              ]
            : [],
      ),
    );
  }
}
