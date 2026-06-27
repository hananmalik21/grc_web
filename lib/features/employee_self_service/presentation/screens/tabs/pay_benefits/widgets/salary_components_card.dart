import 'package:grc/features/employee_self_service/presentation/providers/pay_benefits/pay_benefits_state.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/pay_benefits/widgets/salary_component_row.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SalaryComponentsCard extends StatelessWidget {
  final List<SalaryComponentItem> salaryComponents;
  final String totalMonthlyPay;

  const SalaryComponentsCard({super.key, required this.salaryComponents, required this.totalMonthlyPay});

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      title: 'Salary Components',
      titleIconPath: Assets.icons.leaveManagement.dollar.path,
      child: Column(
        children: [
          for (var index = 0; index < salaryComponents.length; index++) ...[
            SalaryComponentRow(label: salaryComponents[index].label, value: salaryComponents[index].value),
            Gap(13.5.h),
          ],
          SalaryComponentRow(label: 'Total Monthly Pay', value: totalMonthlyPay, isTotal: true),
        ],
      ),
    );
  }
}
