import 'package:grc/core/enums/compensation_enums.dart';

class BulkEmployeeComponent {
  const BulkEmployeeComponent({
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

  CompensationFrequency get frequency => CompensationFrequency.fromValue(frequencyCode);

  double get annualValue => amount * frequency.annualMultiplier;

  String get formattedAmount => '$currencyCode ${amount.toStringAsFixed(0)}';

  String get formattedAnnualValue => '$currencyCode ${annualValue.toStringAsFixed(0)}';

  String get frequencyLabel => frequency.label;
}
