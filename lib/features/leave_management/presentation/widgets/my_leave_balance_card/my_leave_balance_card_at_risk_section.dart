import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_info_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyLeaveBalanceCardAtRiskSection extends StatelessWidget {
  final double atRiskDays;
  final String? atRiskExpiryDate;

  const MyLeaveBalanceCardAtRiskSection({super.key, required this.atRiskDays, this.atRiskExpiryDate});

  @override
  Widget build(BuildContext context) {
    return MyLeaveBalanceCardInfoSection(
      iconPath: Assets.icons.leaveManagement.warning.path,
      title: 'At-Risk (Forfeitable)',
      subtitle: atRiskExpiryDate != null
          ? 'These days exceed the carry forward limit and will be forfeited after $atRiskExpiryDate'
          : 'These days exceed the carry forward limit and will be forfeited',
      backgroundColor: AppColors.warningBg,
      borderColor: AppColors.warningBorder,
      textColor: AppColors.yellowText,
      subtitleColor: AppColors.yellowSubtitle,
      trailing: Text(
        '$atRiskDays days',
        style: context.textTheme.headlineMedium?.copyWith(fontSize: 15.sp, color: AppColors.yellowText),
      ),
    );
  }
}
