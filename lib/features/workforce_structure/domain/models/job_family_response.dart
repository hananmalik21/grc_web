import 'package:grc/features/workforce_structure/domain/models/job_family.dart';

class JobFamilyResponse {
  final bool success;
  final JobFamilyMeta meta;
  final List<JobFamilyData> data;

  const JobFamilyResponse({
    required this.success,
    required this.meta,
    required this.data,
  });

  factory JobFamilyResponse.fromJson(Map<String, dynamic> json) {
    return JobFamilyResponse(
      success: json['success'] ?? false,
      meta: JobFamilyMeta.fromJson(json['meta'] ?? {}),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => JobFamilyData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class JobFamilyMeta {
  final String version;
  final String timestamp;
  final String requestId;
  final int count;
  final int total;
  final String executionTime;
  final JobFamilyPagination pagination;

  const JobFamilyMeta({
    required this.version,
    required this.timestamp,
    required this.requestId,
    required this.count,
    required this.total,
    required this.executionTime,
    required this.pagination,
  });

  factory JobFamilyMeta.fromJson(Map<String, dynamic> json) {
    return JobFamilyMeta(
      version: json['version'] ?? '',
      timestamp: json['timestamp'] ?? '',
      requestId: json['request_id'] ?? '',
      count: json['count'] ?? 0,
      total: json['total'] ?? 0,
      executionTime: json['execution_time'] ?? '',
      pagination: JobFamilyPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class JobFamilyPagination {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const JobFamilyPagination({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory JobFamilyPagination.fromJson(Map<String, dynamic> json) {
    return JobFamilyPagination(
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      hasNext: json['has_next'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }
}

class JobFamilyData {
  final int jobFamilyId;
  final String jobFamilyCode;
  final String jobFamilyNameEn;
  final String jobFamilyNameAr;
  final String description;
  final String status;
  final String createdBy;
  final DateTime createdDate;
  final String lastUpdatedBy;
  final DateTime lastUpdatedDate;

  const JobFamilyData({
    required this.jobFamilyId,
    required this.jobFamilyCode,
    required this.jobFamilyNameEn,
    required this.jobFamilyNameAr,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
  });

  factory JobFamilyData.fromJson(Map<String, dynamic> json) {
    return JobFamilyData(
      jobFamilyId: json['job_family_id'] ?? 0,
      jobFamilyCode: json['job_family_code'] ?? '',
      jobFamilyNameEn: json['job_family_name_en'] ?? '',
      jobFamilyNameAr: json['job_family_name_ar'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdDate:
          DateTime.tryParse(json['created_date'] ?? '') ?? DateTime.now(),
      lastUpdatedBy: json['last_updated_by'] ?? '',
      lastUpdatedDate:
          DateTime.tryParse(json['last_updated_date'] ?? '') ?? DateTime.now(),
    );
  }

  // Convert to existing JobFamily model
  JobFamily toJobFamily() {
    return JobFamily(
      id: jobFamilyId,
      code: jobFamilyCode,
      nameEnglish: jobFamilyNameEn,
      nameArabic: jobFamilyNameAr,
      description: description,
      totalPositions:
          0, // These would come from separate API calls or additional fields
      filledPositions: 0,
      fillRate: 0.0,
      isActive: status == 'ACTIVE',
      createdAt: createdDate,
      updatedAt: lastUpdatedDate,
    );
  }
}
