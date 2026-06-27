import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_transaction_display.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_transaction_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveDetailsTransactionRow extends StatelessWidget {
  const LeaveDetailsTransactionRow({super.key, required this.transaction, required this.isDark});

  final LeaveBalanceTransactionDisplay transaction;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final amountText = transaction.amount >= 0
        ? '+${transaction.amount.toStringAsFixed(1)} days'
        : '${transaction.amount.toStringAsFixed(1)} days';
    final amountColor = transaction.amount >= 0 ? AppColors.activeStatusTextLight : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: LeaveDetailsTransactionTableConfig.cellPaddingHorizontal.w,
        vertical: LeaveDetailsTransactionTableConfig.rowPaddingVertical.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.dateWidth.w,
            child: Text(
              DateFormat('MMM d, yyyy').format(transaction.date),
              style: context.textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.typeWidth.w,
            child: Align(
              alignment: Alignment.centerLeft,
              child: DigifyCapsule(label: transaction.type),
            ),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          Expanded(
            child: Text(transaction.description, style: context.textTheme.labelMedium?.copyWith(color: textColor)),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.amountWidth.w,
            child: Center(
              child: Text(amountText, style: context.textTheme.labelMedium?.copyWith(color: amountColor)),
            ),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.balanceWidth.w,
            child: Center(
              child: Text(
                '${transaction.balance.toStringAsFixed(1)} days',
                style: context.textTheme.labelMedium?.copyWith(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
