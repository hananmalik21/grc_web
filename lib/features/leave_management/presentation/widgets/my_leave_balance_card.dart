import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_at_risk_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_breakdown.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_data.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_encashment_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_helpers.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_total_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

export 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_data.dart';

class MyLeaveBalanceCard extends StatelessWidget {
  final MyLeaveBalanceCardData data;
  final bool isDark;

  const MyLeaveBalanceCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border.all(
          color: data.isAtRisk ? AppColors.warning : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MyLeaveBalanceCardHeader(data: data, isDark: isDark),
          Expanded(child: SingleChildScrollView(child: _buildContent(context))),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(21.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyLeaveBalanceCardTotalBalance(totalBalance: data.totalBalance, isDark: isDark),
          Gap(14.h),
          MyLeaveBalanceCardBreakdown(currentYear: data.currentYear, carriedForward: data.carriedForward),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 14.h)),
          CarryForwardInfo(
            carryForwardAllowed: data.carryForwardAllowed,
            carryForwardMax: data.carryForwardMax,
            isDark: isDark,
          ),
          Gap(7.h),
          if (data.isAtRisk && data.atRiskDays != null) ...[
            Gap(7.h),
            MyLeaveBalanceCardAtRiskSection(atRiskDays: data.atRiskDays!, atRiskExpiryDate: data.atRiskExpiryDate),
            Gap(7.h),
          ],
          ExpiryDateInfo(expiryDate: data.expiryDate, isDark: isDark),
          if (data.encashmentAvailable) ...[
            Gap(7.h),
            MyLeaveBalanceCardEncashmentSection(onEncashmentRequest: data.onEncashmentRequest),
          ],
        ],
      ),
    );
  }
}
