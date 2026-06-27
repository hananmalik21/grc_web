import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';

class ForfeitLeaveTypeBadge extends StatelessWidget {
  final String leaveType;

  const ForfeitLeaveTypeBadge({super.key, required this.leaveType});

  @override
  Widget build(BuildContext context) {
    return DigifyCapsule(label: leaveType, backgroundColor: AppColors.infoBg, textColor: AppColors.primary);
  }
}

class ForfeitDaysBadge extends StatelessWidget {
  final double days;

  const ForfeitDaysBadge({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final isNegative = days < 0;
    return DigifyCapsule(
      label: '${days.toStringAsFixed(days == days.toInt() ? 0 : 1)} days',
      backgroundColor: isNegative ? AppColors.errorBg : AppColors.infoBg,
      textColor: isNegative ? AppColors.error : AppColors.primary,
    );
  }
}
