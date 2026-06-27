class RequisitionBudget {
  const RequisitionBudget({
    this.reqBudgetId,
    this.reqBudgetGuid,
    required this.currencyCode,
    required this.compensationTypeCode,
    this.minimumSalary,
    this.maximumSalary,
    required this.compensationRange,
    this.bonusEligibleFlag,
    this.equityEligibleFlag,
    this.additionalBenefits,
    this.budgetCode,
    this.approvedBudgetAmount,
  });

  final int? reqBudgetId;
  final String? reqBudgetGuid;
  final String currencyCode;
  final String compensationTypeCode;
  final double? minimumSalary;
  final double? maximumSalary;
  final String compensationRange;
  final String? bonusEligibleFlag;
  final String? equityEligibleFlag;
  final String? additionalBenefits;
  final String? budgetCode;
  final double? approvedBudgetAmount;
}
