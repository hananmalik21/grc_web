import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';

class PositionStatusBadge extends StatelessWidget {
  final String label;
  final bool isActive;

  const PositionStatusBadge({super.key, required this.label, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return DigifyCapsule(
      label: label,
      backgroundColor: isActive ? AppColors.shiftActiveStatusBg : AppColors.inactiveStatusBg,
      textColor: isActive ? AppColors.shiftActiveStatusText : AppColors.inactiveStatusText,
    );
  }
}

class PositionVacancyBadge extends StatelessWidget {
  final int vacancy;
  final String vacantLabel;
  final String fullLabel;

  const PositionVacancyBadge({super.key, required this.vacancy, required this.vacantLabel, required this.fullLabel});

  @override
  Widget build(BuildContext context) {
    final hasVacancy = vacancy > 0;
    final label = hasVacancy ? '$vacancy $vacantLabel' : fullLabel;

    return DigifyCapsule(
      label: label,
      backgroundColor: hasVacancy ? AppColors.vacancyBg : AppColors.shiftActiveStatusBg,
      textColor: hasVacancy ? AppColors.vacancyText : AppColors.shiftActiveStatusText,
    );
  }
}
