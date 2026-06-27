import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_info_section.dart';
import 'package:flutter/material.dart';

class MyLeaveBalanceCardEncashmentSection extends StatelessWidget {
  final VoidCallback? onEncashmentRequest;

  const MyLeaveBalanceCardEncashmentSection({super.key, this.onEncashmentRequest});

  @override
  Widget build(BuildContext context) {
    return MyLeaveBalanceCardInfoSection(
      iconPath: Assets.icons.leaveManagement.dollar.path,
      title: 'Encashment Available',
      subtitle: 'You can request to encash unused leave days for monetary compensation',
      backgroundColor: AppColors.jobRoleBg,
      textColor: AppColors.statIconBlue,
      borderColor: AppColors.permissionBadgeBorder,
      subtitleColor: AppColors.textSecondary,
      trailing: onEncashmentRequest != null
          ? GestureDetector(
              onTap: onEncashmentRequest,
              child: Text('Request →', style: context.textTheme.labelSmall?.copyWith(color: AppColors.statIconBlue)),
            )
          : null,
    );
  }
}
