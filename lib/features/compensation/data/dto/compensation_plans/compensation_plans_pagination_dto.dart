import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plans_pagination.dart';

class CompensationPlansPaginationDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const CompensationPlansPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory CompensationPlansPaginationDto.fromJson(Map<String, dynamic> json) {
    return CompensationPlansPaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: (json['has_next'] as bool?) ?? false,
      hasPrevious: (json['has_previous'] as bool?) ?? false,
    );
  }

  CompensationPlansPagination toDomain() {
    return CompensationPlansPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}
