import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BankDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool compactLabel;

  const BankDetailItem({super.key, required this.label, required this.value, this.compactLabel = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            fontSize: compactLabel ? 10.sp : 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.dashboardCircleBlue,
            letterSpacing: compactLabel ? 0.4 : null,
          ),
        ),
        Gap(2.h),
        Text(
          value,
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: context.themeTextPrimary,
          ),
        ),
      ],
    );
  }
}
