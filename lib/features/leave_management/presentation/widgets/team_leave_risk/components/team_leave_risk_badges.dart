import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/leave_management/domain/models/team_leave_risk_employee.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class LeaveTypeBadge extends StatelessWidget {
  final String leaveType;

  const LeaveTypeBadge({super.key, required this.leaveType});

  @override
  Widget build(BuildContext context) {
    return DigifyCapsule(
      label: leaveType,
      backgroundColor: AppColors.jobRoleBg,
      textColor: AppColors.permissionBadgeText,
    );
  }
}

class AtRiskDaysBadge extends StatelessWidget {
  final double days;

  const AtRiskDaysBadge({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return DigifyCapsule(
      label: '${days.toStringAsFixed(days == days.toInt() ? 0 : 1)} days',
      backgroundColor: AppColors.redBg,
      textColor: AppColors.brandRed,
    );
  }
}

class RiskLevelBadge extends StatelessWidget {
  final RiskLevel riskLevel;

  const RiskLevelBadge({super.key, required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    final bgColor = riskLevel == RiskLevel.high
        ? AppColors.orangeBg
        : riskLevel == RiskLevel.medium
        ? AppColors.jobRoleBg
        : AppColors.jobRoleBg;
    final textColor = riskLevel == RiskLevel.high
        ? AppColors.orangeText
        : riskLevel == RiskLevel.medium
        ? AppColors.permissionBadgeText
        : AppColors.permissionBadgeText;
    final iconPath = riskLevel == RiskLevel.high
        ? Assets.icons.leaveManagement.warning.path
        : Assets.icons.infoCircleBlue.path;

    return DigifyCapsule(
      label: riskLevel.displayName,
      iconPath: iconPath,
      backgroundColor: bgColor,
      textColor: textColor,
    );
  }
}
