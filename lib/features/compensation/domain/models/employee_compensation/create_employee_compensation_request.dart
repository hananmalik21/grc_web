class CreateEmployeeCompensationRequest {
  final int enterpriseId;
  final int employeeId;
  final String createdBy;
  final List<EmployeeCompensationComponentRequest> components;

  const CreateEmployeeCompensationRequest({
    required this.enterpriseId,
    required this.employeeId,
    required this.createdBy,
    required this.components,
  });

  Map<String, dynamic> toJson() {
    return {
      'enterprise_id': enterpriseId,
      'employee_id': employeeId,
      'created_by': createdBy,
      'components': components.map((x) => x.toJson()).toList(),
    };
  }
}

class EmployeeCompensationComponentRequest {
  final int planId;
  final int componentId;
  final double amount;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final String currencyCode;
  final String activeFlag;

  const EmployeeCompensationComponentRequest({
    required this.planId,
    required this.componentId,
    required this.amount,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.currencyCode,
    this.activeFlag = 'Y',
  });

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'component_id': componentId,
      'amount': amount,
      'effective_start_date': effectiveStartDate,
      'effective_end_date': effectiveEndDate,
      'currency_code': currencyCode,
      'active_flag': activeFlag,
    };
  }
}
