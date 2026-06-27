enum AmountChangeDirection { increase, decrease, same }

/// Domain model for a single compensation component's latest history entry.
class LatestComponentHistory {
  final int historyId;
  final String eventType;
  final String eventTitle;
  final String eventDescription;
  final double? oldAmount;
  final double? newAmount;
  final String currencyCode;
  final String effectiveDate;
  final String approvedBy;
  final String approverName;
  final String approverRole;
  final String changeReason;

  /// Always non-empty. Null amounts shown as 0.
  String get amountChangeText {
    final old = (oldAmount ?? 0).toStringAsFixed(0);
    final next = (newAmount ?? 0).toStringAsFixed(0);
    return '$old → $next';
  }

  /// Direction based on effective amounts (null treated as 0).
  AmountChangeDirection get changeDirection {
    final old = oldAmount ?? 0;
    final next = newAmount ?? 0;
    if (next > old) return AmountChangeDirection.increase;
    if (next < old) return AmountChangeDirection.decrease;
    return AmountChangeDirection.same;
  }

  const LatestComponentHistory({
    required this.historyId,
    required this.eventType,
    required this.eventTitle,
    required this.eventDescription,
    this.oldAmount,
    this.newAmount,
    required this.currencyCode,
    required this.effectiveDate,
    required this.approvedBy,
    required this.approverName,
    required this.approverRole,
    required this.changeReason,
  });
}

/// Domain model for a compensation component with its latest history entry.
class EmployeeComponentHistory {
  final int componentId;
  final String componentGuid;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String? description;
  final bool isActive;
  final String effectiveStartDate;
  final String? effectiveEndDate;
  final LatestComponentHistory latestHistory;

  const EmployeeComponentHistory({
    required this.componentId,
    required this.componentGuid,
    required this.componentCode,
    required this.componentName,
    required this.componentTypeCode,
    this.description,
    required this.isActive,
    required this.effectiveStartDate,
    this.effectiveEndDate,
    required this.latestHistory,
  });
}
