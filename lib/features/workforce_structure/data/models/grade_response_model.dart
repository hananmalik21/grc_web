import 'package:grc/features/workforce_structure/data/models/grade_model.dart';
import 'package:grc/features/workforce_structure/domain/models/grade_response.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level_response.dart';

class GradeResponseModel {
  final List<GradeModel> data;
  final JobLevelMeta meta;

  const GradeResponseModel({required this.data, required this.meta});

  factory GradeResponseModel.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson =
        metaJson['pagination'] as Map<String, dynamic>? ?? {};

    return GradeResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => GradeModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      meta: JobLevelMeta(
        version: metaJson['version'] as String? ?? '',
        timestamp: metaJson['timestamp'] as String? ?? '',
        requestId: metaJson['request_id'] as String? ?? '',
        count: metaJson['count'] as int? ?? 0,
        total:
            metaJson['total'] as int? ?? (paginationJson['total'] as int? ?? 0),
        executionTime: metaJson['execution_time'] as String? ?? '',
        pagination: JobLevelPagination(
          page: paginationJson['page'] as int? ?? 1,
          pageSize: paginationJson['page_size'] as int? ?? 10,
          total: paginationJson['total'] as int? ?? 0,
          totalPages: paginationJson['total_pages'] as int? ?? 0,
          hasNext: paginationJson['has_next'] as bool? ?? false,
          hasPrevious: paginationJson['has_previous'] as bool? ?? false,
        ),
      ),
    );
  }

  GradeResponse toEntity() {
    return GradeResponse(
      data: data.map((model) => model.toEntity()).toList(),
      meta: meta,
    );
  }
}
