import 'package:grc/features/hiring/domain/models/job_postings/job_posting.dart';

class JobPostingsListDto {
  const JobPostingsListDto({required this.items});

  final List<JobPostingDto> items;

  factory JobPostingsListDto.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<JobPostingDto> items;

    if (rawData is List<dynamic>) {
      items = rawData.whereType<Map<String, dynamic>>().map(JobPostingDto.fromJson).toList();
    } else if (rawData is Map<String, dynamic>) {
      items = [JobPostingDto.fromJson(rawData)];
    } else {
      items = const [];
    }

    return JobPostingsListDto(items: items);
  }

  List<JobPosting> toDomain() => items.map((dto) => dto.toDomain()).toList();
}

class JobPostingDto {
  const JobPostingDto({
    required this.postingGuid,
    required this.requisitionGuid,
    required this.postingTitle,
    required this.postingDescription,
    required this.visibilityCode,
    required this.startDate,
    required this.endDate,
    required this.aboutTheRole,
    required this.responsibilities,
    required this.qualifications,
    required this.internalSiteFlag,
    required this.externalSiteFlag,
    required this.linkedinFlag,
    required this.statusCode,
    required this.applicationCount,
    this.internalPostedDate,
    this.externalPostedDate,
    this.linkedinPostedDate,
  });

  final String postingGuid;
  final String requisitionGuid;
  final String postingTitle;
  final String postingDescription;
  final String visibilityCode;
  final String startDate;
  final String endDate;
  final String aboutTheRole;
  final List<String> responsibilities;
  final List<String> qualifications;
  final String internalSiteFlag;
  final String externalSiteFlag;
  final String linkedinFlag;
  final String statusCode;
  final int applicationCount;
  final String? internalPostedDate;
  final String? externalPostedDate;
  final String? linkedinPostedDate;

  factory JobPostingDto.fromJson(Map<String, dynamic> json) {
    return JobPostingDto(
      postingGuid: json['posting_guid'] as String? ?? '',
      requisitionGuid: json['requisition_guid'] as String? ?? '',
      postingTitle: json['posting_title'] as String? ?? '',
      postingDescription: json['posting_description'] as String? ?? '',
      visibilityCode: json['visibility_code'] as String? ?? '',
      startDate: json['start_date'] as String? ?? json['start_date_display'] as String? ?? '',
      endDate: json['end_date'] as String? ?? json['end_date_display'] as String? ?? '',
      aboutTheRole: json['about_the_role'] as String? ?? '',
      responsibilities: _parseStringList(json['responsibilities']),
      qualifications: _parseStringList(json['qualifications']),
      internalSiteFlag: json['internal_site_flag'] as String? ?? 'N',
      externalSiteFlag: json['external_site_flag'] as String? ?? 'N',
      linkedinFlag: json['linkedin_flag'] as String? ?? 'N',
      statusCode: _parseStatusCode(json),
      applicationCount: _parseInt(
        json['application_count'] ?? json['applications_count'] ?? json['total_applications'],
      ),
      internalPostedDate: _parseOptionalString(json['internal_posted_date'] ?? json['internal_site_posted_date']),
      externalPostedDate: _parseOptionalString(json['external_posted_date'] ?? json['external_site_posted_date']),
      linkedinPostedDate: _parseOptionalString(json['linkedin_posted_date']),
    );
  }

  JobPosting toDomain() {
    return JobPosting(
      postingGuid: postingGuid,
      requisitionGuid: requisitionGuid,
      postingTitle: postingTitle,
      postingDescription: postingDescription,
      visibilityCode: visibilityCode,
      startDate: startDate,
      endDate: endDate,
      aboutTheRole: aboutTheRole,
      responsibilities: responsibilities,
      qualifications: qualifications,
      internalSiteFlag: internalSiteFlag,
      externalSiteFlag: externalSiteFlag,
      linkedinFlag: linkedinFlag,
      statusCode: statusCode,
      applicationCount: applicationCount,
      internalPostedDate: internalPostedDate,
      externalPostedDate: externalPostedDate,
      linkedinPostedDate: linkedinPostedDate,
    );
  }

  static String _parseStatusCode(Map<String, dynamic> json) {
    final raw = json['posting_status_code'] ?? json['status_code'] ?? json['status'];
    return raw?.toString().trim() ?? '';
  }

  static List<String> _parseStringList(dynamic raw) {
    if (raw is! List<dynamic>) return const [];

    return raw.map((item) => item?.toString().trim() ?? '').where((item) => item.isNotEmpty).toList();
  }

  static int _parseInt(dynamic raw, {int defaultValue = 0}) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? defaultValue;
  }

  static String? _parseOptionalString(dynamic raw) {
    final value = raw?.toString().trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }
}
