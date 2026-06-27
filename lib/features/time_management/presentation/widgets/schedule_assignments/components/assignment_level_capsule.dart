import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:flutter/material.dart';

class AssignmentLevelCapsule extends StatelessWidget {
  final AssignmentLevel level;
  final bool isDark;

  const AssignmentLevelCapsule({super.key, required this.level, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isEmployee = level == AssignmentLevel.employee;

    final bgColor = isDark
        ? (isEmployee ? AppColors.infoBgDark : AppColors.purpleBgDark)
        : (isEmployee ? AppColors.infoBg : AppColors.purpleBg);
    final textColor = isDark
        ? (isEmployee ? AppColors.infoTextDark : AppColors.purpleTextDark)
        : (isEmployee ? AppColors.infoText : AppColors.purpleText);

    return DigifyCapsule(label: level.name.toUpperCase(), backgroundColor: bgColor, textColor: textColor);
  }
}
