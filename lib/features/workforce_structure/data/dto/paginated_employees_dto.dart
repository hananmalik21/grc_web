import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/workforce_structure/data/dto/employee_dto.dart';
import 'package:grc/features/workforce_structure/domain/models/paginated_employees.dart';

class PaginatedEmployeesDto {
  final List<EmployeeDto> employees;
  final PaginationInfoDto pagination;
  final int total;
  final int count;

  const PaginatedEmployeesDto({
    required this.employees,
    required this.pagination,
    required this.total,
    required this.count,
  });

  factory PaginatedEmployeesDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final employees = data.map((item) => EmployeeDto.fromJson(item as Map<String, dynamic>)).toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = meta['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationInfoDto.fromJson(paginationJson);

    final total = pagination.total;
    final count = employees.length;

    return PaginatedEmployeesDto(employees: employees, pagination: pagination, total: total, count: count);
  }

  PaginatedEmployees toDomain() {
    return PaginatedEmployees(
      employees: employees.map((e) => e.toDomain()).toList(),
      pagination: pagination.toDomain(),
      total: total,
      count: count,
    );
  }
}

class PaginationInfoDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationInfoDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfoDto.fromJson(Map<String, dynamic> json) {
    return PaginationInfoDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }

  PaginationInfo toDomain() {
    return PaginationInfo(
      currentPage: page,
      totalPages: totalPages,
      totalItems: total,
      pageSize: pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}
