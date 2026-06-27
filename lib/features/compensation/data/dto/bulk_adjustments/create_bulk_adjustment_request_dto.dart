import 'package:grc/features/compensation/domain/models/bulk_adjustments/create_bulk_adjustment_request.dart';

class CreateBulkAdjustmentRequestDto {
  const CreateBulkAdjustmentRequestDto({required this.request});

  final CreateBulkAdjustmentRequest request;

  Map<String, dynamic> toJson() {
    return {
      'enterprise_id': request.enterpriseId,
      'adjustment_type': request.adjustmentType,
      'effective_date': request.effectiveDate,
      'reason_code': request.reasonCode,
      'budget_code': request.budgetCode,
      'justification_text': request.justificationText,
      'updated_by': request.updatedBy,
      'employees': request.employees.map(_employeeToJson).toList(),
    };
  }

  Map<String, dynamic> _employeeToJson(BulkAdjustmentEmployeeRequest employee) {
    return {
      'employee_id': employee.employeeId,
      'plan_id': employee.planId,
      'components': employee.components.map(_componentToJson).toList(),
    };
  }

  Map<String, dynamic> _componentToJson(BulkAdjustmentComponentRequest component) {
    return {
      'component_id': component.componentId,
      'amount': component.amount,
      'currency_code': component.currencyCode,
      'adjustment_method': component.adjustmentMethod,
      'replace_flag': component.replaceFlag,
      'delete_flag': component.deleteFlag,
      'active_flag': component.activeFlag,
      'effective_end_date': component.effectiveEndDate,
    };
  }
}
