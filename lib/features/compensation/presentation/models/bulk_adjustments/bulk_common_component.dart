import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_component.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_entry.dart';

class BulkCommonComponent {
  const BulkCommonComponent({
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.categoryCode,
    required this.frequencyCode,
    required this.currencyCode,
    required this.amountsByEmployeeGuid,
  });

  final int componentId;
  final String componentCode;
  final String componentName;
  final String categoryCode;
  final String frequencyCode;
  final String currencyCode;
  final Map<String, double> amountsByEmployeeGuid;

  bool get hasUniformAmount {
    if (amountsByEmployeeGuid.isEmpty) return true;
    final values = amountsByEmployeeGuid.values.toSet();
    return values.length == 1;
  }

  String formattedAmountFor(double amount) => '$currencyCode ${amount.toStringAsFixed(0)}';
}

List<BulkCommonComponent> findCommonBulkComponents(List<BulkEmployeeComponentsEntry> employees) {
  if (employees.isEmpty) return [];

  final activeEmployees = employees.where((entry) => entry.components.isNotEmpty).toList();
  if (activeEmployees.isEmpty) return [];

  if (activeEmployees.length == 1) {
    return activeEmployees.first.components.map((component) => _toCommon(component, activeEmployees)).toList();
  }

  var commonIds = activeEmployees.first.components.map((component) => component.componentId).toSet();
  for (var index = 1; index < activeEmployees.length; index++) {
    final ids = activeEmployees[index].components.map((component) => component.componentId).toSet();
    commonIds = commonIds.intersection(ids);
  }

  if (commonIds.isEmpty) return [];

  return activeEmployees.first.components
      .where((component) => commonIds.contains(component.componentId))
      .map((component) => _toCommon(component, activeEmployees))
      .toList();
}

BulkCommonComponent _toCommon(BulkEmployeeComponent reference, List<BulkEmployeeComponentsEntry> employees) {
  final amounts = <String, double>{};
  for (final entry in employees) {
    final match = entry.components.where((component) => component.componentId == reference.componentId);
    if (match.isEmpty) continue;
    amounts[entry.employeeGuid] = match.first.amount;
  }

  return BulkCommonComponent(
    componentId: reference.componentId,
    componentCode: reference.componentCode,
    componentName: reference.componentName,
    categoryCode: reference.categoryCode,
    frequencyCode: reference.frequencyCode,
    currencyCode: reference.currencyCode,
    amountsByEmployeeGuid: amounts,
  );
}
