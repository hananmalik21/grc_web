import 'package:grc/features/leave_management/domain/models/leave_balance_transaction_display.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class LeaveBalanceTransactionsResponseDto {
  const LeaveBalanceTransactionsResponseDto({
    required this.success,
    required this.message,
    required this.meta,
    required this.data,
  });

  final bool success;
  final String message;
  final LeaveBalanceTransactionsMetaDto meta;
  final List<LeaveBalanceTransactionItemDto> data;

  factory LeaveBalanceTransactionsResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List<dynamic>? ?? [];
    return LeaveBalanceTransactionsResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      meta: LeaveBalanceTransactionsMetaDto.fromJson(metaJson),
      data: dataList.map((e) => LeaveBalanceTransactionItemDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  LeaveBalanceTransactionsResult toDomain() {
    final pagination = meta.pagination.toDomain();
    final sorted = List<LeaveBalanceTransactionItemDto>.from(data)..sort((a, b) => a.txnDate.compareTo(b.txnDate));
    double runningBalance = 0.0;
    final rows = <LeaveBalanceTransactionDisplay>[];
    for (final item in sorted) {
      runningBalance += item.amountDays;
      rows.add(item.toDisplay(balance: runningBalance));
    }
    rows.sort((a, b) => b.date.compareTo(a.date));
    return LeaveBalanceTransactionsResult(transactions: rows, pagination: pagination);
  }
}

class LeaveBalanceTransactionsMetaDto {
  const LeaveBalanceTransactionsMetaDto({required this.pagination});

  final LeaveBalanceTransactionsPaginationDto pagination;

  factory LeaveBalanceTransactionsMetaDto.fromJson(Map<String, dynamic> json) {
    final pagJson = json['pagination'] as Map<String, dynamic>? ?? {};
    return LeaveBalanceTransactionsMetaDto(pagination: LeaveBalanceTransactionsPaginationDto.fromJson(pagJson));
  }
}

class LeaveBalanceTransactionsPaginationDto {
  const LeaveBalanceTransactionsPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory LeaveBalanceTransactionsPaginationDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      if (value is num) return value.toInt();
      return defaultValue;
    }

    bool parseBool(dynamic value, {bool defaultValue = false}) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return defaultValue;
    }

    return LeaveBalanceTransactionsPaginationDto(
      page: parseInt(json['page'], defaultValue: 1),
      pageSize: parseInt(json['page_size'], defaultValue: 10),
      total: parseInt(json['total']),
      totalPages: parseInt(json['total_pages'], defaultValue: 1),
      hasNext: parseBool(json['has_next']),
      hasPrevious: parseBool(json['has_previous']),
    );
  }

  PaginationInfo toDomain() {
    return PaginationInfo(
      currentPage: page,
      totalPages: totalPages,
      totalItems: total,
      pageSize: pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class LeaveBalanceTransactionItemDto {
  const LeaveBalanceTransactionItemDto({
    required this.txnGuid,
    required this.txnDate,
    required this.txnType,
    required this.amountDays,
    required this.comments,
  });

  final String txnGuid;
  final DateTime txnDate;
  final String txnType;
  final double amountDays;
  final String comments;

  factory LeaveBalanceTransactionItemDto.fromJson(Map<String, dynamic> json) {
    final txnDateRaw = json['txn_date'];
    DateTime date = DateTime.now();
    if (txnDateRaw != null) {
      if (txnDateRaw is String) {
        date = DateTime.tryParse(txnDateRaw) ?? date;
      } else if (txnDateRaw is DateTime) {
        date = txnDateRaw;
      }
    }
    final amount = json['amount_days'];
    final amountDays = amount is num ? amount.toDouble() : (double.tryParse(amount?.toString() ?? '0') ?? 0.0);
    return LeaveBalanceTransactionItemDto(
      txnGuid: json['txn_guid'] as String? ?? '',
      txnDate: date,
      txnType: json['txn_type'] as String? ?? 'ACCRUAL',
      amountDays: amountDays,
      comments: json['comments'] as String? ?? '',
    );
  }

  LeaveBalanceTransactionDisplay toDisplay({double? balance}) {
    return LeaveBalanceTransactionDisplay(
      date: txnDate,
      type: txnType,
      description: comments,
      amount: amountDays,
      balance: balance ?? 0.0,
    );
  }
}
