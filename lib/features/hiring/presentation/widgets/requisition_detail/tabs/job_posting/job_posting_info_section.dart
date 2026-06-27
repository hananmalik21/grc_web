import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobPostingInfoSection extends StatelessWidget {
  const JobPostingInfoSection({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.isTitle = false,
  });

  final String label;
  final String value;
  final bool isDark;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
