import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StepSalaryContainer extends StatelessWidget {
  final int stepNumber;
  final String salary;
  final String currencyCode;

  const StepSalaryContainer({super.key, required this.stepNumber, required this.salary, required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 266.4.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: AppColors.tableHeaderBackground, borderRadius: BorderRadius.circular(4.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Step $stepNumber',
            textAlign: TextAlign.center,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          Gap(4.h),
          Text(
            '$salary $currencyCode',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(color: AppColors.dialogTitle),
          ),
        ],
      ),
    );
  }
}
