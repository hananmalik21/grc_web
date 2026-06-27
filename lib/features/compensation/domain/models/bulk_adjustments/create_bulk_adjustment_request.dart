class CreateBulkAdjustmentRequest {
  const CreateBulkAdjustmentRequest({
    required this.enterpriseId,
    required this.adjustmentType,
    required this.effectiveDate,
    required this.reasonCode,
    required this.budgetCode,
    required this.justificationText,
    required this.updatedBy,
    required this.employees,
  });

  final int enterpriseId;
  final String adjustmentType;
  final String effectiveDate;
  final String reasonCode;
  final String budgetCode;
  final String justificationText;
  final String updatedBy;
  final List<BulkAdjustmentEmployeeRequest> employees;
}

class BulkAdjustmentEmployeeRequest {
  const BulkAdjustmentEmployeeRequest({required this.employeeId, required this.planId, required this.components});

  final int employeeId;
  final int planId;
  final List<BulkAdjustmentComponentRequest> components;
}

class BulkAdjustmentComponentRequest {
  const BulkAdjustmentComponentRequest({
    required this.componentId,
    required this.amount,
    required this.currencyCode,
    required this.adjustmentMethod,
    required this.replaceFlag,
    required this.deleteFlag,
    required this.activeFlag,
    this.effectiveEndDate,
  });

  final int componentId;
  final double amount;
  final String currencyCode;
  final String adjustmentMethod;
  final String replaceFlag;
  final String deleteFlag;
  final String activeFlag;
  final String? effectiveEndDate;
}
