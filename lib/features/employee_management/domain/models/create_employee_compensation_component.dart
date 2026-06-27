class CreateEmployeeCompensationComponent {
  final int planId;
  final int componentId;
  final double amount;
  final String currencyCode;
  final String effectiveStartDate;
  final String? effectiveEndDate;
  final String activeFlag;

  const CreateEmployeeCompensationComponent({
    required this.planId,
    required this.componentId,
    required this.amount,
    required this.currencyCode,
    required this.effectiveStartDate,
    this.effectiveEndDate,
    this.activeFlag = 'Y',
  });

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'component_id': componentId,
      'amount': amount,
      'currency_code': currencyCode,
      'effective_start_date': effectiveStartDate,
      'effective_end_date': effectiveEndDate,
      'active_flag': activeFlag,
    };
  }
}
