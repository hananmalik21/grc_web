import 'package:grc/features/compensation/domain/models/employees/employees_page.dart';

import 'employee_dto.dart';
import 'employees_pagination_dto.dart';

class EmployeesPageDto {
  final List<EmployeeDto> items;
  final EmployeesPaginationDto? pagination;

  const EmployeesPageDto({required this.items, required this.pagination});

  factory EmployeesPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(EmployeeDto.fromJson)
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final paginationJson = metaJson?['pagination'];
    final pagination = paginationJson is Map<String, dynamic> ? EmployeesPaginationDto.fromJson(paginationJson) : null;

    return EmployeesPageDto(items: data, pagination: pagination);
  }

  EmployeesPage toDomain() {
    return EmployeesPage(items: items.map((e) => e.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}
