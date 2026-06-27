import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_card_data.dart';
import 'package:grc/features/leave_management/presentation/providers/employee_leave_balance_cards_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveRequestEmployeeDetailBalanceCards extends ConsumerWidget {
  const LeaveRequestEmployeeDetailBalanceCards({super.key, required this.isDark, required this.localizations});

  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(employeeLeaveBalanceCardsProvider);

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 16.w : 0),
              child: _LeaveBalanceCard(data: cards[i], isDark: isDark, localizations: localizations),
            ),
          ),
      ],
    );
  }
}

class _LeaveBalanceCard extends StatelessWidget {
  const _LeaveBalanceCard({required this.data, required this.isDark, required this.localizations});

  final LeaveBalanceCardData data;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final daysLabel = localizations.days.toLowerCase();

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.leaveTypeLabel.capitalizeEachWord,
            style: context.textTheme.titleSmall?.copyWith(color: textPrimary),
          ),
          Gap(10.h),
          _buildRow(context, localizations.leaveBalanceTotal, '${data.totalDays} $daysLabel', textPrimary),
          Gap(7.h),
          _buildRow(context, localizations.leaveBalanceUsed, '${data.usedDays} $daysLabel', AppColors.redButton),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 7.h)),
          _buildRow(
            context,
            localizations.leaveBalanceRemaining,
            '${data.remainingDays} $daysLabel',
            textPrimary,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, Color valueColor, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: context.textTheme.labelMedium?.copyWith(
            color: valueColor,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
