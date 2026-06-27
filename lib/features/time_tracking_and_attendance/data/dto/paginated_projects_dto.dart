import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/project_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/paginated_projects.dart';

class PaginatedProjectsDto {
  final List<ProjectDto> projects;
  final PaginationInfoDto pagination;
  final int total;
  final int count;

  const PaginatedProjectsDto({
    required this.projects,
    required this.pagination,
    required this.total,
    required this.count,
  });

  factory PaginatedProjectsDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final projects = data.map((item) => ProjectDto.fromJson(item as Map<String, dynamic>)).toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = meta['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationInfoDto.fromJson(paginationJson);

    final total = pagination.total;
    final count = projects.length;

    return PaginatedProjectsDto(projects: projects, pagination: pagination, total: total, count: count);
  }

  PaginatedProjects toDomain() {
    return PaginatedProjects(
      projects: projects.map((e) => e.toDomain()).toList(),
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
  final bool hasMore;

  const PaginationInfoDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasMore,
  });

  factory PaginationInfoDto.fromJson(Map<String, dynamic> json) {
    return PaginationInfoDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: json['has_next'] as bool? ?? false,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  PaginationInfo toDomain() {
    return PaginationInfo(
      currentPage: page,
      totalPages: totalPages,
      totalItems: total,
      pageSize: pageSize,
      hasNext: hasNext || hasMore,
      hasPrevious: page > 1,
    );
  }
}
