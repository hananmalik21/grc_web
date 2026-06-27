import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalaryComponentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const SalaryComponentRow({super.key, required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.5.w, vertical: 10.h),
      decoration: BoxDecoration(color: AppColors.sidebarSearchBg, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                color: isTotal ? context.themeTextPrimary : AppColors.tableHeaderText,
              ),
            ),
          ),
          Text(
            value,
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: isTotal ? 16.sp : 14.sp,
              color: isTotal ? AppColors.primary : context.themeTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
