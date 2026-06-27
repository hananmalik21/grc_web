import 'package:grc/core/utils/int_parse_utils.dart';
import 'package:grc/features/workforce_structure/data/models/job_level_model.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level_response.dart';

class JobLevelResponseModel {
  static JobLevelResponse fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};

    return JobLevelResponse(
      success: json['success'] as bool? ?? false,
      meta: JobLevelMeta(
        version: metaJson['version'] as String? ?? '',
        timestamp: metaJson['timestamp'] as String? ?? '',
        requestId: metaJson['request_id'] as String? ?? '',
        count: IntParseUtils.asInt(metaJson['count']),
        total: IntParseUtils.asInt(metaJson['total']),
        executionTime: metaJson['execution_time'] as String? ?? '',
        pagination: JobLevelPagination(
          page: IntParseUtils.asInt(paginationJson['page'], fallback: 1),
          pageSize: IntParseUtils.asInt(paginationJson['page_size'], fallback: 10),
          total: IntParseUtils.asInt(paginationJson['total']),
          totalPages: IntParseUtils.asInt(paginationJson['total_pages']),
          hasNext: paginationJson['has_next'] as bool? ?? false,
          hasPrevious: paginationJson['has_previous'] as bool? ?? false,
        ),
      ),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => JobLevelModel.fromJson(item as Map<String, dynamic>).toEntity())
              .toList() ??
          [],
    );
  }
}
