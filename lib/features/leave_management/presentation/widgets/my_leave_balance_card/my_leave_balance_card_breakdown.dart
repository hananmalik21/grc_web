import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyLeaveBalanceCardBreakdown extends StatelessWidget {
  final double currentYear;
  final double carriedForward;

  const MyLeaveBalanceCardBreakdown({super.key, required this.currentYear, required this.carriedForward});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BalanceItem(label: 'Current Year', value: currentYear.toString()),
        ),
        Gap(14.w),
        Expanded(
          child: _BalanceItem(label: 'Carried Forward', value: carriedForward.toString()),
        ),
      ],
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final String value;

  const _BalanceItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary)),
          Gap(4.h),
          Text(
            value,
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
