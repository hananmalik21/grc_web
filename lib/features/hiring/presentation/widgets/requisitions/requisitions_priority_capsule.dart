import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';

class RequisitionsPriorityCapsule extends StatelessWidget {
  const RequisitionsPriorityCapsule({super.key, required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final normalized = priority.trim().toLowerCase();
    final (background, text) = switch (normalized) {
      'high' => (AppColors.errorBg, AppColors.brandRed),
      'medium' => (AppColors.pendingStatusBackground, AppColors.pendingStatucColor),
      'low' => (AppColors.infoBg, AppColors.infoText),
      _ => (AppColors.cardBackgroundGrey, AppColors.textSecondary),
    };

    return DigifyCapsule(label: priority, backgroundColor: background, textColor: text);
  }
}
