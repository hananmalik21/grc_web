import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/employee_self_service/presentation/providers/my_payslips/my_payslips_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PayslipMetricItem extends StatelessWidget {
  final PayslipBreakdownItem item;

  const PayslipMetricItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Color valueColor = context.themeTextPrimary;
    if (item.isNegative) {
      valueColor = AppColors.error;
    } else if (item.isHighlighted) {
      valueColor = AppColors.primary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText),
        ),
        Gap(2.h),
        Text(
          item.value,
          style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: valueColor),
        ),
      ],
    );
  }
}
