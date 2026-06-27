import 'package:grc/features/hiring/domain/models/job_offers/job_offer.dart';
import 'package:grc/features/hiring/domain/models/job_offers/job_offers_page.dart';

class JobOffersPageDto {
  const JobOffersPageDto({required this.items, required this.pagination});

  final List<JobOfferDto> items;
  final JobOffersPaginationDto? pagination;

  factory JobOffersPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(JobOfferDto.fromJson)
        .toList();

    final paginationJson = json['pagination'];
    final pagination = paginationJson is Map<String, dynamic> ? JobOffersPaginationDto.fromJson(paginationJson) : null;

    return JobOffersPageDto(items: data, pagination: pagination);
  }

  JobOffersPage toDomain() {
    return JobOffersPage(items: items.map((dto) => dto.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}

class JobOffersPaginationDto {
  const JobOffersPaginationDto({
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

  factory JobOffersPaginationDto.fromJson(Map<String, dynamic> json) {
    final page = _parseInt(json['page'], defaultValue: 1);
    final pageSize = _parseInt(json['limit'] ?? json['page_size'] ?? json['pageSize'], defaultValue: 10);
    final total = _parseInt(json['total']);
    final explicitTotalPages = _parseInt(json['total_pages'] ?? json['totalPages']);
    final totalPages = explicitTotalPages > 0
        ? explicitTotalPages
        : total <= 0
        ? 1
        : (total / pageSize).ceil();
    final hasNext = json.containsKey('has_next') || json.containsKey('hasNext')
        ? _parseBool(json['has_next'] ?? json['hasNext'])
        : page < totalPages;
    final hasPrevious = json.containsKey('has_previous') || json.containsKey('hasPrevious')
        ? _parseBool(json['has_previous'] ?? json['hasPrevious'])
        : page > 1;

    return JobOffersPaginationDto(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }

  JobOffersPagination toDomain() {
    return JobOffersPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class JobOfferDto {
  const JobOfferDto({
    required this.offerId,
    required this.offerGuid,
    required this.enterpriseId,
    required this.offerNumber,
    required this.candidateName,
    required this.jobTitle,
    required this.positionName,
    required this.departmentName,
    required this.location,
    required this.startDate,
    required this.expiryDate,
    required this.annualSalary,
    required this.statusCode,
    required this.gradeName,
    required this.employmentTypeCode,
    required this.workModeCode,
    required this.probationPeriod,
    required this.currencyCode,
  });

  final int offerId;
  final String offerGuid;
  final int enterpriseId;
  final String offerNumber;
  final String candidateName;
  final String jobTitle;
  final String positionName;
  final String departmentName;
  final String location;
  final String startDate;
  final String expiryDate;
  final num annualSalary;
  final String statusCode;
  final String gradeName;
  final String employmentTypeCode;
  final String workModeCode;
  final String probationPeriod;
  final String currencyCode;

  factory JobOfferDto.fromJson(Map<String, dynamic> json) {
    final candidateObj = json['candidate_obj'] as Map<String, dynamic>?;
    final positionObj = json['position_obj'] as Map<String, dynamic>?;
    final departmentObj = json['department_obj'] as Map<String, dynamic>?;
    final gradeObj = json['grade_obj'] as Map<String, dynamic>?;
    final termsJson = json['terms_json'] as Map<String, dynamic>?;
    final components = (json['components_json'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final firstComponent = components.isNotEmpty ? components.first : null;

    return JobOfferDto(
      offerId: _parseInt(json['offer_id']),
      offerGuid: json['offer_guid'] as String? ?? '',
      enterpriseId: _parseInt(json['enterprise_id']),
      offerNumber: json['offer_number'] as String? ?? '',
      candidateName: candidateObj?['candidate_name'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      positionName: positionObj?['position_name'] as String? ?? json['job_title'] as String? ?? '',
      departmentName: departmentObj?['org_unit_name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      expiryDate: json['expiry_date'] as String? ?? '',
      annualSalary: _parseNum(json['annual_salary']),
      statusCode: json['status_code'] as String? ?? '',
      gradeName: gradeObj?['grade_name'] as String? ?? '',
      employmentTypeCode: json['employment_type_code'] as String? ?? '',
      workModeCode: json['work_mode_code'] as String? ?? '',
      probationPeriod: termsJson?['probation_period'] as String? ?? '',
      currencyCode: firstComponent?['currency_code'] as String? ?? '',
    );
  }

  JobOffer toDomain() {
    return JobOffer(
      offerId: offerId,
      offerGuid: offerGuid,
      enterpriseId: enterpriseId,
      offerNumber: offerNumber,
      candidateName: candidateName,
      jobTitle: jobTitle,
      positionName: positionName,
      departmentName: departmentName,
      location: location,
      startDate: startDate,
      expiryDate: expiryDate,
      annualSalary: annualSalary,
      statusCode: statusCode,
      gradeName: gradeName,
      employmentTypeCode: employmentTypeCode,
      workModeCode: workModeCode,
      probationPeriod: probationPeriod,
      currencyCode: currencyCode,
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

num _parseNum(dynamic value, {num defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is num) return value;
  if (value is String) return num.tryParse(value) ?? defaultValue;
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
