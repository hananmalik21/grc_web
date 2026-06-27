import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddElementSectionTitle extends StatelessWidget {
  const AddElementSectionTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Text(
      title.toUpperCase(),
      style: context.textTheme.titleMedium?.copyWith(
        fontSize: 15.sp,
        color: isDark ? AppColors.textSecondaryDark : AppColors.holidayIslamicText,
      ),
    );
  }
}
