import 'package:grc/core/enums/compensation_enums.dart';

class EmployeeAssignedComponent {
  final int assignmentDetailId;
  final String assignmentDetailGuid;
  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final int planId;
  final int componentId;
  final String componentCode;
  final String componentName;
  final String categoryCode;
  final String frequencyCode;
  final double amount;
  final String currencyCode;
  final DateTime effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String changeSource;
  final int? adjustmentId;
  final String activeFlag;

  const EmployeeAssignedComponent({
    required this.assignmentDetailId,
    required this.assignmentDetailGuid,
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
    required this.planId,
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    this.categoryCode = '',
    required this.frequencyCode,
    required this.amount,
    required this.currencyCode,
    required this.effectiveStartDate,
    this.effectiveEndDate,
    required this.changeSource,
    this.adjustmentId,
    required this.activeFlag,
  });

  // Computed properties for domain-level logic & UI display
  CompensationFrequency get frequency => CompensationFrequency.fromValue(frequencyCode);

  double get annualValue => amount * frequency.annualMultiplier;

  String get formattedAmount => '$currencyCode ${amount.toStringAsFixed(0)}';

  String get formattedAnnualValue => '$currencyCode ${annualValue.toStringAsFixed(0)}';

  String get frequencyLabel => frequency.label;

  static List<EmployeeAssignedComponent> get skeletonData => List.generate(
    3,
    (index) => EmployeeAssignedComponent(
      assignmentDetailId: 0,
      assignmentDetailGuid: '',
      enterpriseId: 0,
      employeeId: 0,
      employeeGuid: '',
      planId: 0,
      componentId: 0,
      componentCode: 'CODE',
      componentName: 'Loading Component Name',
      frequencyCode: 'MONTHLY',
      amount: 0.0,
      currencyCode: 'AED',
      effectiveStartDate: DateTime.now(),
      changeSource: 'MANUAL',
      adjustmentId: null,
      activeFlag: 'Y',
    ),
  );

  factory EmployeeAssignedComponent.fromJson(Map<String, dynamic> json) {
    return EmployeeAssignedComponent(
      assignmentDetailId: json['assignment_detail_id'] as int,
      assignmentDetailGuid: json['assignment_detail_guid'] as String,
      enterpriseId: json['enterprise_id'] as int,
      employeeId: json['employee_id'] as int,
      employeeGuid: json['employee_guid'] as String,
      planId: json['plan_id'] as int,
      componentId: json['component_id'] as int,
      componentCode: json['component_code'] as String,
      componentName: json['component_name'] as String,
      categoryCode: json['comp_category_code'] as String? ?? '',
      frequencyCode: json['frequency_code'] as String? ?? 'MONTHLY',
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currency_code'] as String,
      effectiveStartDate: DateTime.parse(json['effective_start_date'] as String),
      effectiveEndDate: json['effective_end_date'] != null
          ? DateTime.parse(json['effective_end_date'] as String)
          : null,
      changeSource: json['change_source'] as String,
      adjustmentId: json['adjustment_id'] as int?,
      activeFlag: json['active_flag'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignment_detail_id': assignmentDetailId,
      'assignment_detail_guid': assignmentDetailGuid,
      'enterprise_id': enterpriseId,
      'employee_id': employeeId,
      'employee_guid': employeeGuid,
      'plan_id': planId,
      'component_id': componentId,
      'component_code': componentCode,
      'component_name': componentName,
      'comp_category_code': categoryCode,
      'frequency_code': frequencyCode,
      'amount': amount,
      'currency_code': currencyCode,
      'effective_start_date': effectiveStartDate.toIso8601String(),
      'effective_end_date': effectiveEndDate?.toIso8601String(),
      'change_source': changeSource,
      'adjustment_id': adjustmentId,
      'active_flag': activeFlag,
    };
  }
}
