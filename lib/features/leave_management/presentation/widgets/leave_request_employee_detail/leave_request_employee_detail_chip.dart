import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class LeaveRequestEmployeeDetailChip extends StatelessWidget {
  const LeaveRequestEmployeeDetailChip({super.key, required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return Text(label, style: context.textTheme.bodyMedium?.copyWith(color: color));
  }
}
