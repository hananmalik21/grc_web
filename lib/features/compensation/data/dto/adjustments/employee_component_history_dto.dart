import '../../../domain/models/adjustments/employee_component_history.dart';

class LatestComponentHistoryDto {
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

  const LatestComponentHistoryDto({
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

  factory LatestComponentHistoryDto.fromJson(Map<String, dynamic> json) {
    return LatestComponentHistoryDto(
      historyId: (json['history_id'] as num?)?.toInt() ?? 0,
      eventType: json['event_type'] as String? ?? '',
      eventTitle: json['event_title'] as String? ?? '',
      eventDescription: json['event_description'] as String? ?? '',
      oldAmount: (json['old_amount'] as num?)?.toDouble(),
      newAmount: (json['new_amount'] as num?)?.toDouble(),
      currencyCode: json['currency_code'] as String? ?? '',
      effectiveDate: json['effective_date'] as String? ?? '',
      approvedBy: json['approved_by'] as String? ?? '',
      approverName: json['approver_name'] as String? ?? '',
      approverRole: json['approver_role'] as String? ?? '',
      changeReason: json['change_reason'] as String? ?? '',
    );
  }

  LatestComponentHistory toDomain() {
    return LatestComponentHistory(
      historyId: historyId,
      eventType: eventType,
      eventTitle: eventTitle,
      eventDescription: eventDescription,
      oldAmount: oldAmount,
      newAmount: newAmount,
      currencyCode: currencyCode,
      effectiveDate: effectiveDate,
      approvedBy: approvedBy,
      approverName: approverName,
      approverRole: approverRole,
      changeReason: changeReason,
    );
  }
}

class EmployeeComponentHistoryDto {
  final int componentId;
  final String componentGuid;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String? description;
  final bool isActive;
  final String effectiveStartDate;
  final String? effectiveEndDate;
  final LatestComponentHistoryDto latestHistory;

  const EmployeeComponentHistoryDto({
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

  factory EmployeeComponentHistoryDto.fromJson(Map<String, dynamic> json) {
    return EmployeeComponentHistoryDto(
      componentId: (json['component_id'] as num?)?.toInt() ?? 0,
      componentGuid: json['component_guid'] as String? ?? '',
      componentCode: json['component_code'] as String? ?? '',
      componentName: json['component_name'] as String? ?? '',
      componentTypeCode: json['component_type_code'] as String? ?? '',
      description: json['description'] as String?,
      isActive: (json['active_flag'] as String?) == 'Y',
      effectiveStartDate: json['effective_start_date'] as String? ?? '',
      effectiveEndDate: json['effective_end_date'] as String?,
      latestHistory: LatestComponentHistoryDto.fromJson(
        json['latest_history'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  EmployeeComponentHistory toDomain() {
    return EmployeeComponentHistory(
      componentId: componentId,
      componentGuid: componentGuid,
      componentCode: componentCode,
      componentName: componentName,
      componentTypeCode: componentTypeCode,
      description: description,
      isActive: isActive,
      effectiveStartDate: effectiveStartDate,
      effectiveEndDate: effectiveEndDate,
      latestHistory: latestHistory.toDomain(),
    );
  }
}
