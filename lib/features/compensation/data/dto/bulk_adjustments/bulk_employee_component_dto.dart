import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_component.dart';

class BulkEmployeeComponentDto {
  const BulkEmployeeComponentDto({
    required this.assignmentDetailId,
    required this.planId,
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.categoryCode,
    required this.amount,
    required this.currencyCode,
    required this.frequencyCode,
    this.processStatus,
  });

  final int assignmentDetailId;
  final int planId;
  final int componentId;
  final String componentCode;
  final String componentName;
  final String categoryCode;
  final double amount;
  final String currencyCode;
  final String frequencyCode;
  final String? processStatus;

  factory BulkEmployeeComponentDto.fromJson(Map<String, dynamic> json) {
    return BulkEmployeeComponentDto(
      assignmentDetailId: (json['assignment_detail_id'] as num?)?.toInt() ?? 0,
      planId: (json['plan_id'] as num?)?.toInt() ?? 0,
      componentId: (json['component_id'] as num?)?.toInt() ?? 0,
      componentCode: (json['component_code'] as String?) ?? '',
      componentName: (json['component_name'] as String?) ?? '',
      categoryCode: (json['comp_category_code'] as String?) ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currencyCode: (json['currency_code'] as String?) ?? '',
      frequencyCode: (json['frequency_code'] as String?) ?? 'MONTHLY',
      processStatus: json['process_status'] as String?,
    );
  }

  BulkEmployeeComponent toDomain() {
    return BulkEmployeeComponent(
      assignmentDetailId: assignmentDetailId,
      planId: planId,
      componentId: componentId,
      componentCode: componentCode,
      componentName: componentName,
      categoryCode: categoryCode,
      amount: amount,
      currencyCode: currencyCode,
      frequencyCode: frequencyCode,
      processStatus: processStatus,
    );
  }
}
