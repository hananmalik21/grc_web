import 'package:grc/features/compensation/domain/models/components/comp_components_pagination.dart';

class CompComponentsPaginationDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const CompComponentsPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory CompComponentsPaginationDto.fromJson(Map<String, dynamic> json) {
    return CompComponentsPaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      hasNext: (json['has_next'] as bool?) ?? false,
      hasPrevious: (json['has_previous'] as bool?) ?? false,
    );
  }

  CompComponentsPagination toDomain() {
    return CompComponentsPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}
