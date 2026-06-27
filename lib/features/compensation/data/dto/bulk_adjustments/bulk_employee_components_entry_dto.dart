import 'package:grc/features/compensation/data/dto/bulk_adjustments/bulk_employee_component_dto.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_entry.dart';

class BulkEmployeeComponentsEntryDto {
  const BulkEmployeeComponentsEntryDto({
    required this.enterpriseId,
    required this.employeeGuid,
    required this.components,
  });

  final int enterpriseId;
  final String employeeGuid;
  final List<BulkEmployeeComponentDto> components;

  factory BulkEmployeeComponentsEntryDto.fromJson(Map<String, dynamic> json) {
    final componentsJson = json['components'] as List<dynamic>? ?? [];
    return BulkEmployeeComponentsEntryDto(
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeGuid: (json['employee_guid'] as String?) ?? '',
      components: componentsJson.whereType<Map<String, dynamic>>().map(BulkEmployeeComponentDto.fromJson).toList(),
    );
  }

  BulkEmployeeComponentsEntry toDomain() {
    return BulkEmployeeComponentsEntry(
      enterpriseId: enterpriseId,
      employeeGuid: employeeGuid,
      components: components.map((component) => component.toDomain()).toList(),
    );
  }
}
