import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/widgets.dart';

class AttendanceStatusChip extends StatelessWidget {
  final String status;

  const AttendanceStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = _AttendanceStatusChipStyle.fromStatus(status);

    return DigifyCapsule(label: status, backgroundColor: style.backgroundColor, textColor: style.textColor);
  }
}

class _AttendanceStatusChipStyle {
  final Color backgroundColor;
  final Color textColor;

  const _AttendanceStatusChipStyle({required this.backgroundColor, required this.textColor});

  static _AttendanceStatusChipStyle fromStatus(String status) {
    switch (status) {
      case 'Present':
        return const _AttendanceStatusChipStyle(backgroundColor: AppColors.infoBg, textColor: AppColors.infoText);
      case 'Late':
        return const _AttendanceStatusChipStyle(
          backgroundColor: AppColors.pendingStatusBackground,
          textColor: AppColors.pendingStatucColor,
        );
      case 'Absent':
        return const _AttendanceStatusChipStyle(backgroundColor: AppColors.errorBg, textColor: AppColors.errorText);
      case 'Early':
        return const _AttendanceStatusChipStyle(backgroundColor: AppColors.greenBg, textColor: AppColors.greenText);
      case 'On Leave':
        return const _AttendanceStatusChipStyle(backgroundColor: AppColors.grayBg, textColor: AppColors.grayText);
      case 'Official Work':
      case 'Business Trip':
        return const _AttendanceStatusChipStyle(backgroundColor: AppColors.infoBg, textColor: AppColors.infoText);
      case 'Half Day':
        return const _AttendanceStatusChipStyle(backgroundColor: AppColors.warningBg, textColor: AppColors.warningText);
      default:
        return const _AttendanceStatusChipStyle(
          backgroundColor: AppColors.cardBackgroundGrey,
          textColor: AppColors.textSecondary,
        );
    }
  }
}
