class CreateElementEntryRequestDto {
  const CreateElementEntryRequestDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.componentId,
    required this.elementClassificationCode,
    required this.effectiveAsOfDate,
    required this.effectiveStartDate,
    required this.entryTypeCode,
    required this.sourceCode,
    required this.elementProcessingTypeCode,
    required this.subpriority,
    required this.creatorTypeCode,
    required this.processedFlag,
    required this.retroactiveFlag,
    required this.automaticEntryFlag,
    required this.sequenceNumber,
    required this.reasonText,
    required this.payValue,
    required this.amount,
    required this.currencyCode,
    required this.costingTypeCode,
    required this.accountCode,
    required this.costCenterCode,
    required this.contextSegmentCode,
    required this.contextValue,
    required this.approvalStatusCode,
    required this.comments,
    this.payrollId,
    this.effectiveEndDate,
    this.costAllocationKeyflexId,
    this.sourceReference,
    this.batchId,
  });

  final int enterpriseId;
  final int employeeId;
  final int? payrollId;
  final int componentId;
  final String elementClassificationCode;
  final String effectiveAsOfDate;
  final String effectiveStartDate;
  final String? effectiveEndDate;
  final String entryTypeCode;
  final String sourceCode;
  final String elementProcessingTypeCode;
  final int subpriority;
  final String creatorTypeCode;
  final String processedFlag;
  final String retroactiveFlag;
  final String automaticEntryFlag;
  final int sequenceNumber;
  final String reasonText;
  final double payValue;
  final double amount;
  final String currencyCode;
  final String? costAllocationKeyflexId;
  final String costingTypeCode;
  final String accountCode;
  final String costCenterCode;
  final String contextSegmentCode;
  final String contextValue;
  final String approvalStatusCode;
  final String comments;
  final String? sourceReference;
  final String? batchId;

  Map<String, dynamic> toJson() {
    return {
      'enterprise_id': enterpriseId,
      'employee_id': employeeId,
      'payroll_id': payrollId,
      'component_id': componentId,
      'element_classification_code': elementClassificationCode,
      'effective_as_of_date': effectiveAsOfDate,
      'effective_start_date': effectiveStartDate,
      'effective_end_date': effectiveEndDate,
      'entry_type_code': entryTypeCode,
      'source_code': sourceCode,
      'element_processing_type_code': elementProcessingTypeCode,
      'subpriority': subpriority,
      'creator_type_code': creatorTypeCode,
      'processed_flag': processedFlag,
      'retroactive_flag': retroactiveFlag,
      'automatic_entry_flag': automaticEntryFlag,
      'sequence_number': sequenceNumber,
      'reason_text': reasonText,
      'pay_value': payValue,
      'amount': amount,
      'currency_code': currencyCode,
      'cost_allocation_keyflex_id': costAllocationKeyflexId,
      'costing_type_code': costingTypeCode,
      'account_code': accountCode,
      'cost_center_code': costCenterCode,
      'context_segment_code': contextSegmentCode,
      'context_value': contextValue,
      'approval_status_code': approvalStatusCode,
      'comments': comments,
      'source_reference': sourceReference,
      'batch_id': batchId,
    };
  }
}
