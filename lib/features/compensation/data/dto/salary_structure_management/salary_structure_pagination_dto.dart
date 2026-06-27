import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_pagination.dart';

class SalaryStructurePaginationDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const SalaryStructurePaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory SalaryStructurePaginationDto.fromJson(Map<String, dynamic> json) {
    return SalaryStructurePaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: (json['has_next'] as bool?) ?? false,
      hasPrevious: (json['has_previous'] as bool?) ?? false,
    );
  }

  SalaryStructurePagination toDomain() {
    return SalaryStructurePagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}
