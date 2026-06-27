import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/employee_management/domain/models/assignment_status_enum.dart';
import 'package:flutter/material.dart';

class EmployeeEmploymentStatusCapsule extends StatelessWidget {
  const EmployeeEmploymentStatusCapsule({super.key, required this.status, required this.isDark});

  final String? status;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final safeStatus = (status ?? '—').trim();
    final assignmentStatus = AssignmentStatus.fromRaw(status);

    final backgroundColor = switch (assignmentStatus) {
      AssignmentStatus.active => isDark ? AppColors.successBgDark : AppColors.successBg,
      AssignmentStatus.inactive => isDark ? AppColors.grayBgDark : AppColors.grayBg,
      AssignmentStatus.probation => isDark ? AppColors.warningBgDark : AppColors.warningBg,
      AssignmentStatus.ended => isDark ? AppColors.errorBgDark : AppColors.errorBg,
      _ => isDark ? AppColors.infoBgDark : AppColors.infoBg,
    };

    final borderColor = switch (assignmentStatus) {
      AssignmentStatus.active => isDark ? AppColors.successBorderDark : AppColors.successBorder,
      AssignmentStatus.inactive => isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
      AssignmentStatus.probation => isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
      AssignmentStatus.ended => isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
      _ => isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
    };

    final textColor = switch (assignmentStatus) {
      AssignmentStatus.active => isDark ? AppColors.successTextDark : AppColors.successText,
      AssignmentStatus.inactive => isDark ? AppColors.grayTextDark : AppColors.grayText,
      AssignmentStatus.probation => isDark ? AppColors.warningTextDark : AppColors.warningText,
      AssignmentStatus.ended => isDark ? AppColors.errorTextDark : AppColors.errorText,
      _ => isDark ? AppColors.infoTextDark : AppColors.infoText,
    };

    return DigifyCapsule(
      label: safeStatus.isEmpty ? '—' : safeStatus,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      textColor: textColor,
    );
  }
}
