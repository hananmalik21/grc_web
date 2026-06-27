import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_transaction_display.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_transaction_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveDetailsTransactionTableBody extends StatelessWidget {
  const LeaveDetailsTransactionTableBody({
    super.key,
    required this.transactions,
    required this.isDark,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<LeaveBalanceTransactionDisplay> transactions;
  final bool isDark;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return LeaveDetailsTransactionTableLoadingState(isDark: isDark);
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return _TransactionTableErrorState(message: errorMessage!);
    }
    if (transactions.isEmpty) {
      return _TransactionTableEmptyState(isDark: isDark);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: transactions.map((t) => LeaveDetailsTransactionRow(transaction: t, isDark: isDark)).toList(),
    );
  }
}

class LeaveDetailsTransactionTableLoadingState extends StatelessWidget {
  const LeaveDetailsTransactionTableLoadingState({super.key, required this.isDark});

  final bool isDark;

  static const int _skeletonRowCount = 5;

  static List<LeaveBalanceTransactionDisplay> _placeholders() {
    final list = <LeaveBalanceTransactionDisplay>[];
    for (var i = 0; i < _skeletonRowCount; i++) {
      list.add(
        LeaveBalanceTransactionDisplay(
          date: DateTime(2024, 1, 1).add(Duration(days: i * 30)),
          type: 'ACCRUAL',
          description: 'Placeholder description for skeleton row',
          amount: 2.5,
          balance: (i + 1) * 2.5,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _placeholders().map((t) => LeaveDetailsTransactionRow(transaction: t, isDark: isDark)).toList(),
      ),
    );
  }
}

class _TransactionTableErrorState extends StatelessWidget {
  const _TransactionTableErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Text(
          message,
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _TransactionTableEmptyState extends StatelessWidget {
  const _TransactionTableEmptyState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Text(
          'No transactions',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
