import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestEmployeeDetailError extends StatelessWidget {
  const LeaveRequestEmployeeDetailError({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Text(error.toString(), style: context.textTheme.bodyMedium?.copyWith(color: AppColors.error)),
      ),
    );
  }
}
