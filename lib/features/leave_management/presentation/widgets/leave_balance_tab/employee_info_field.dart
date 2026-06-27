import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeInfoField extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const EmployeeInfoField({super.key, required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText),
        ),
        Gap(3.5.h),
        Text(value, style: context.textTheme.titleSmall?.copyWith(color: AppColors.dialogTitle)),
      ],
    );
  }
}
