import 'package:grc/features/compensation/data/dto/bulk_adjustments/bulk_employee_components_entry_dto.dart';
import 'package:grc/features/compensation/data/dto/employees/employees_pagination_dto.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';

class BulkEmployeeComponentsPageDto {
  const BulkEmployeeComponentsPageDto({required this.count, required this.employees, required this.pagination});

  final int count;
  final List<BulkEmployeeComponentsEntryDto> employees;
  final EmployeesPaginationDto pagination;

  factory BulkEmployeeComponentsPageDto.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    final employeesJson = payload['employees'] as List<dynamic>? ?? json['employees'] as List<dynamic>? ?? [];
    final paginationJson =
        payload['pagination'] as Map<String, dynamic>? ?? json['pagination'] as Map<String, dynamic>? ?? {};

    return BulkEmployeeComponentsPageDto(
      count: (payload['count'] as num?)?.toInt() ?? (json['count'] as num?)?.toInt() ?? 0,
      employees: employeesJson.whereType<Map<String, dynamic>>().map(BulkEmployeeComponentsEntryDto.fromJson).toList(),
      pagination: EmployeesPaginationDto.fromJson(paginationJson),
    );
  }

  BulkEmployeeComponentsPage toDomain() {
    return BulkEmployeeComponentsPage(
      count: count,
      employees: employees.map((employee) => employee.toDomain()).toList(),
      pagination: pagination.toDomain(),
    );
  }
}
