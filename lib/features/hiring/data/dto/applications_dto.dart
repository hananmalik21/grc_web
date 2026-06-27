import 'package:grc/features/hiring/domain/models/applications/application.dart';

class ApplicationsPageDto {
  const ApplicationsPageDto({required this.items, required this.pagination});

  final List<ApplicationDto> items;
  final ApplicationsPaginationDto? pagination;

  factory ApplicationsPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ApplicationDto.fromJson)
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final paginationJson = metaJson?['pagination'];
    final pagination = paginationJson is Map<String, dynamic>
        ? ApplicationsPaginationDto.fromJson(paginationJson)
        : null;

    return ApplicationsPageDto(items: data, pagination: pagination);
  }

  ApplicationsPage toDomain() {
    return ApplicationsPage(items: items.map((dto) => dto.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}

class ApplicationsPaginationDto {
  const ApplicationsPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory ApplicationsPaginationDto.fromJson(Map<String, dynamic> json) {
    return ApplicationsPaginationDto(
      page: _parseInt(json['page'], defaultValue: 1),
      pageSize: _parseInt(json['page_size'] ?? json['pageSize'], defaultValue: 10),
      total: _parseInt(json['total']),
      totalPages: _parseInt(json['total_pages'] ?? json['totalPages'], defaultValue: 1),
      hasNext: _parseBool(json['has_next'] ?? json['hasNext']),
      hasPrevious: _parseBool(json['has_previous'] ?? json['hasPrevious']),
    );
  }

  ApplicationsPagination toDomain() {
    return ApplicationsPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class ApplicationDto {
  const ApplicationDto({
    required this.applicationId,
    required this.applicationGuid,
    required this.applicationNumber,
    required this.enterpriseId,
    required this.postingId,
    required this.postingTitle,
    required this.requisitionId,
    required this.requisitionNumber,
    required this.requisitionTitle,
    required this.candidateId,
    required this.candidateName,
    required this.email,
    required this.phone,
    required this.sourceCode,
    required this.currentStageCode,
    required this.statusCode,
    required this.appliedDate,
    required this.hasResume,
    required this.resumeUrl,
  });

  final int applicationId;
  final String applicationGuid;
  final String applicationNumber;
  final int enterpriseId;
  final int postingId;
  final String postingTitle;
  final int requisitionId;
  final String requisitionNumber;
  final String requisitionTitle;
  final int candidateId;
  final String candidateName;
  final String email;
  final String phone;
  final String sourceCode;
  final String currentStageCode;
  final String statusCode;
  final DateTime? appliedDate;
  final bool hasResume;
  final String? resumeUrl;

  factory ApplicationDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDto(
      applicationId: _parseInt(json['application_id']),
      applicationGuid: json['application_guid'] as String? ?? '',
      applicationNumber: json['application_number'] as String? ?? '',
      enterpriseId: _parseInt(json['enterprise_id']),
      postingId: _parseInt(json['posting_id']),
      postingTitle: json['posting_title'] as String? ?? '',
      requisitionId: _parseInt(json['requisition_id']),
      requisitionNumber: json['requisition_number'] as String? ?? '',
      requisitionTitle: json['requisition_title'] as String? ?? '',
      candidateId: _parseInt(json['candidate_id']),
      candidateName: json['candidate_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      sourceCode: json['source_code'] as String? ?? '',
      currentStageCode: json['current_stage_code'] as String? ?? '',
      statusCode: json['status_code'] as String? ?? '',
      appliedDate: _parseDate(json['applied_date']),
      hasResume: _parseYesNo(json['has_resume']),
      resumeUrl: json['resume_url'] as String?,
    );
  }

  Application toDomain() {
    return Application(
      applicationId: applicationId,
      applicationGuid: applicationGuid,
      applicationNumber: applicationNumber,
      enterpriseId: enterpriseId,
      postingId: postingId,
      postingTitle: postingTitle,
      requisitionId: requisitionId,
      requisitionNumber: requisitionNumber,
      requisitionTitle: requisitionTitle,
      candidateId: candidateId,
      candidateName: candidateName,
      email: email,
      phone: phone,
      sourceCode: sourceCode,
      currentStageCode: currentStageCode,
      statusCode: statusCode,
      appliedDate: appliedDate,
      hasResume: hasResume,
      resumeUrl: resumeUrl,
    );
  }
}

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

bool _parseBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  if (value is num) return value != 0;
  return defaultValue;
}

bool _parseYesNo(dynamic value) {
  if (value == null) return false;
  final text = value.toString().trim().toUpperCase();
  return text == 'Y' || text == 'YES' || text == 'TRUE' || text == '1';
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}
