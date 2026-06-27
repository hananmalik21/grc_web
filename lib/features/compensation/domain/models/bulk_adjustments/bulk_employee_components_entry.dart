import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_component.dart';

class BulkEmployeeComponentsEntry {
  const BulkEmployeeComponentsEntry({required this.enterpriseId, required this.employeeGuid, required this.components});

  final int enterpriseId;
  final String employeeGuid;
  final List<BulkEmployeeComponent> components;
}
