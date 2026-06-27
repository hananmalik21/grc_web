import 'package:grc/features/compensation/domain/models/employees/employees_pagination.dart';

class EmployeesPaginationDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const EmployeesPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory EmployeesPaginationDto.fromJson(Map<String, dynamic> json) {
    return EmployeesPaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? (json['pageSize'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? (json['totalPages'] as num?)?.toInt() ?? 1,
      hasNext: (json['has_next'] as bool?) ?? (json['hasNext'] as bool?) ?? false,
      hasPrevious: (json['has_previous'] as bool?) ?? (json['hasPrevious'] as bool?) ?? false,
    );
  }

  EmployeesPagination toDomain() {
    return EmployeesPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}
