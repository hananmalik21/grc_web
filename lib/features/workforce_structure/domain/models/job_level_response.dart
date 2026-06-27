import 'job_level.dart';

class JobLevelResponse {
  final bool success;
  final JobLevelMeta meta;
  final List<JobLevel> data;

  const JobLevelResponse({
    required this.success,
    required this.meta,
    required this.data,
  });
}

class JobLevelMeta {
  final String version;
  final String timestamp;
  final String requestId;
  final int count;
  final int total;
  final String executionTime;
  final JobLevelPagination pagination;

  const JobLevelMeta({
    required this.version,
    required this.timestamp,
    required this.requestId,
    required this.count,
    required this.total,
    required this.executionTime,
    required this.pagination,
  });
}

class JobLevelPagination {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const JobLevelPagination({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
