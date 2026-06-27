import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalanceCardsSection extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const LeaveBalanceCardsSection({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.annualLeave,
                  leaveTypeArabic: localizations.annualLeaveArabic,
                  iconPath: Assets.icons.leaveManagementIcon.path,
                  totalBalance: 24.5,
                  currentYear: 18,
                  carriedForward: 6.5,
                  carryForwardAllowed: true,
                  carryForwardMax: '10',
                  expiryDate: '2024-03-31',
                  isAtRisk: true,
                  atRiskDays: 3.5,
                  atRiskExpiryDate: '2024-03-31',
                  encashmentAvailable: true,
                  onEncashmentRequest: () {},
                ),
                isDark: isDark,
              ),
            ),
            Gap(21.w),
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.sickLeave,
                  leaveTypeArabic: localizations.sickLeaveArabic,
                  iconPath: Assets.icons.workforce.fillRate.path,
                  totalBalance: 12,
                  currentYear: 12,
                  carriedForward: 0,
                  carryForwardAllowed: false,
                  expiryDate: '2024-12-31',
                ),
                isDark: isDark,
              ),
            ),
          ],
        ),
        Gap(21.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.hajjLeave,
                  leaveTypeArabic: localizations.hajjLeaveArabic,
                  iconPath: Assets.icons.checkIconGreen.path,
                  totalBalance: 15,
                  currentYear: 15,
                  carriedForward: 0,
                  carryForwardAllowed: false,
                  expiryDate: null,
                ),
                isDark: isDark,
              ),
            ),
            Gap(21.w),
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.compassionateLeave,
                  leaveTypeArabic: localizations.compassionateLeaveArabic,
                  iconPath: Assets.icons.clockIcon.path,
                  totalBalance: 5,
                  currentYear: 5,
                  carriedForward: 0,
                  carryForwardAllowed: false,
                  carryForwardMax: '3',
                  expiryDate: '2024-12-31',
                  isAtRisk: false,
                  atRiskDays: 2,
                  atRiskExpiryDate: '2024-12-31',
                ),
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
