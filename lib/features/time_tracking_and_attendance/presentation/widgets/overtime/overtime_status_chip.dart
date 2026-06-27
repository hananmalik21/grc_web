import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/widgets.dart';

class OvertimeStatusChip extends StatelessWidget {
  final OvertimeStatus status;

  const OvertimeStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = _OvertimeStatusChipStyle.fromStatus(status);

    return DigifyCapsule(label: status.label, backgroundColor: style.backgroundColor, textColor: style.textColor);
  }
}

class _OvertimeStatusChipStyle {
  final Color backgroundColor;
  final Color textColor;

  const _OvertimeStatusChipStyle({required this.backgroundColor, required this.textColor});

  static _OvertimeStatusChipStyle fromStatus(OvertimeStatus status) {
    switch (status) {
      case OvertimeStatus.draft:
        return const _OvertimeStatusChipStyle(
          backgroundColor: AppColors.cardBackgroundGrey,
          textColor: AppColors.textSecondary,
        );
      case OvertimeStatus.submitted:
      case OvertimeStatus.pending:
        return const _OvertimeStatusChipStyle(
          backgroundColor: AppColors.pendingStatusBackground,
          textColor: AppColors.pendingStatucColor,
        );
      case OvertimeStatus.approved:
        return const _OvertimeStatusChipStyle(backgroundColor: AppColors.successBg, textColor: AppColors.successText);
      case OvertimeStatus.rejected:
        return const _OvertimeStatusChipStyle(backgroundColor: AppColors.errorBg, textColor: AppColors.errorText);
      case OvertimeStatus.withdrawn:
        return const _OvertimeStatusChipStyle(
          backgroundColor: AppColors.cardBackgroundGrey,
          textColor: AppColors.textSecondary,
        );
    }
  }
}
