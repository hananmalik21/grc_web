import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class LeaveBalanceTransactionDisplay {
  const LeaveBalanceTransactionDisplay({
    required this.date,
    required this.type,
    required this.description,
    required this.amount,
    required this.balance,
  });

  final DateTime date;
  final String type;
  final String description;
  final double amount;
  final double balance;
}

class LeaveBalanceTransactionsResult {
  const LeaveBalanceTransactionsResult({required this.transactions, required this.pagination});

  final List<LeaveBalanceTransactionDisplay> transactions;
  final PaginationInfo pagination;
}
