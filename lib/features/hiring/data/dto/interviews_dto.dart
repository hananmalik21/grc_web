import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/domain/models/interview_status_code.dart';

class InterviewsPageDto {
  const InterviewsPageDto({required this.items, required this.pagination});

  final List<InterviewListItemDto> items;
  final InterviewsPaginationDto? pagination;

  factory InterviewsPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(InterviewListItemDto.fromJson)
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final paginationJson = metaJson?['pagination'];
    final pagination = paginationJson is Map<String, dynamic> ? InterviewsPaginationDto.fromJson(paginationJson) : null;

    return InterviewsPageDto(items: data, pagination: pagination);
  }

  InterviewsPage toDomain() {
    return InterviewsPage(items: items.map((dto) => dto.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}

class InterviewsPaginationDto {
  const InterviewsPaginationDto({
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

  factory InterviewsPaginationDto.fromJson(Map<String, dynamic> json) {
    return InterviewsPaginationDto(
      page: _parseInt(json['page'], defaultValue: 1),
      pageSize: _parseInt(json['page_size'] ?? json['pageSize'], defaultValue: 10),
      total: _parseInt(json['total']),
      totalPages: _parseInt(json['total_pages'] ?? json['totalPages'], defaultValue: 1),
      hasNext: _parseBool(json['has_next'] ?? json['hasNext']),
      hasPrevious: _parseBool(json['has_previous'] ?? json['hasPrevious']),
    );
  }

  InterviewsPagination toDomain() {
    return InterviewsPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class InterviewInterviewerDto {
  const InterviewInterviewerDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeName,
    required this.primaryInterviewer,
  });

  final int employeeId;
  final String employeeGuid;
  final String employeeName;
  final bool primaryInterviewer;

  factory InterviewInterviewerDto.fromJson(Map<String, dynamic> json) {
    return InterviewInterviewerDto(
      employeeId: _parseInt(json['employee_id']),
      employeeGuid: json['employee_guid'] as String? ?? '',
      employeeName: json['employee_name'] as String? ?? '',
      primaryInterviewer:
          _parseBool(json['primary_interviewer'], defaultValue: false) ||
          (json['primary_interviewer'] as String?)?.toUpperCase() == 'Y',
    );
  }

  InterviewInterviewer toDomain() {
    return InterviewInterviewer(
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      employeeName: employeeName,
      primaryInterviewer: primaryInterviewer,
    );
  }
}

class InterviewFeedbackDto {
  const InterviewFeedbackDto({
    required this.feedbackId,
    required this.feedbackGuid,
    required this.overallRating,
    this.technicalSkills,
    this.communication,
    this.cultureFit,
    this.recommendation,
    this.detailedComments,
  });

  final int feedbackId;
  final String feedbackGuid;
  final int overallRating;
  final String? technicalSkills;
  final String? communication;
  final String? cultureFit;
  final String? recommendation;
  final String? detailedComments;

  factory InterviewFeedbackDto.fromJson(Map<String, dynamic> json) {
    return InterviewFeedbackDto(
      feedbackId: _parseInt(json['feedback_id']),
      feedbackGuid: json['feedback_guid'] as String? ?? '',
      overallRating: _parseInt(json['overall_rating']),
      technicalSkills: json['technical_skills'] as String?,
      communication: json['communication'] as String?,
      cultureFit: json['culture_fit'] as String?,
      recommendation: json['recommendation'] as String?,
      detailedComments: json['detailed_comments'] as String?,
    );
  }

  InterviewFeedback toDomain() {
    return InterviewFeedback(
      feedbackId: feedbackId,
      feedbackGuid: feedbackGuid,
      overallRating: overallRating,
      technicalSkills: technicalSkills,
      communication: communication,
      cultureFit: cultureFit,
      recommendation: recommendation,
      detailedComments: detailedComments,
    );
  }
}

class InterviewListItemDto {
  const InterviewListItemDto({
    required this.candidateId,
    required this.candidateGuid,
    required this.enterpriseId,
    required this.candidateName,
    this.currentTitle,
    required this.interviewId,
    required this.interviewGuid,
    this.interviewTitle,
    this.interviewType,
    required this.interviewRound,
    this.interviewDate,
    this.interviewMode,
    this.location,
    this.meetingLink,
    required this.status,
    this.resultStatus,
    this.feedback,
    this.rating,
    this.interviewStartUtc,
    this.interviewEndUtc,
    this.interviewers = const [],
    this.feedbackObj,
  });

  final int candidateId;
  final String candidateGuid;
  final int enterpriseId;
  final String candidateName;
  final String? currentTitle;
  final int interviewId;
  final String interviewGuid;
  final String? interviewTitle;
  final String? interviewType;
  final int interviewRound;
  final String? interviewDate;
  final String? interviewMode;
  final String? location;
  final String? meetingLink;
  final String status;
  final String? resultStatus;
  final String? feedback;
  final int? rating;
  final DateTime? interviewStartUtc;
  final DateTime? interviewEndUtc;
  final List<InterviewInterviewerDto> interviewers;
  final InterviewFeedbackDto? feedbackObj;

  factory InterviewListItemDto.fromJson(Map<String, dynamic> json) {
    final interviewersJson = json['interviewers_json'];
    final interviewers = interviewersJson is List
        ? interviewersJson.whereType<Map<String, dynamic>>().map(InterviewInterviewerDto.fromJson).toList()
        : <InterviewInterviewerDto>[];

    final feedbackJson = json['feedback_obj'];
    final feedbackObj = feedbackJson is Map<String, dynamic> ? InterviewFeedbackDto.fromJson(feedbackJson) : null;

    return InterviewListItemDto(
      candidateId: _parseInt(json['candidate_id']),
      candidateGuid: json['candidate_guid'] as String? ?? '',
      enterpriseId: _parseInt(json['enterprise_id']),
      candidateName: json['candidate_name'] as String? ?? '',
      currentTitle: json['current_title'] as String?,
      interviewId: _parseInt(json['interview_id']),
      interviewGuid: json['interview_guid'] as String? ?? '',
      interviewTitle: json['interview_title'] as String?,
      interviewType: json['interview_type'] as String?,
      interviewRound: _parseInt(json['interview_round'], defaultValue: 1),
      interviewDate: json['interview_date'] as String?,
      interviewMode: json['interview_mode'] as String?,
      location: json['location'] as String?,
      meetingLink: json['meeting_link'] as String?,
      status: _parseStatusCode(json),
      resultStatus: json['result_status'] as String?,
      feedback: json['feedback'] as String?,
      rating: _parseNullableInt(json['rating']),
      interviewStartUtc: _parseUtcToLocal(json['interview_start_utc']),
      interviewEndUtc: _parseUtcToLocal(json['interview_end_utc']),
      interviewers: interviewers,
      feedbackObj: feedbackObj,
    );
  }

  Interview toDomain() {
    return Interview(
      id: interviewId,
      candidateName: candidateName,
      position: currentTitle ?? interviewTitle ?? '',
      status: _mapStatus(status),
      statusCode: status,
      dateTime: interviewStartUtc ?? _parseLocalInterviewDate(interviewDate),
      endDateTime: interviewEndUtc,
      interviewType: interviewType,
      interviewRound: interviewRound,
      interviewers: interviewers.map((i) => i.employeeName).where((n) => n.isNotEmpty).toList(),
      roundInfo: 'Round $interviewRound',
      meetingLink: meetingLink,
      interviewGuid: interviewGuid,
      candidateGuid: candidateGuid,
      candidateId: candidateId,
      resultStatus: resultStatus,
      rating: rating,
      feedback: feedback,
      interviewTitle: interviewTitle,
      interviewMode: interviewMode,
      interviewerDetails: interviewers.map((dto) => dto.toDomain()).toList(),
      feedbackDetail: feedbackObj?.toDomain(),
    );
  }
}

InterviewStatus _mapStatus(String raw) {
  switch (raw) {
    case InterviewStatusCode.completed:
      return InterviewStatus.completed;
    case InterviewStatusCode.cancelled:
      return InterviewStatus.cancelled;
    case InterviewStatusCode.rescheduled:
      return InterviewStatus.rescheduled;
    case InterviewStatusCode.scheduled:
      return InterviewStatus.scheduled;
    default:
      return InterviewStatus.scheduled;
  }
}

String _parseStatusCode(Map<String, dynamic> json) {
  final raw = json['status_code'] ?? json['status'];
  return InterviewStatusCode.normalize(raw as String?) ?? InterviewStatusCode.scheduled;
}

DateTime? _parseUtcToLocal(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) {
    return value.isUtc ? value.toLocal() : value;
  }
  if (value is String && value.isNotEmpty) {
    return DateTimeUtils.utcStringToLocal(value);
  }
  return null;
}

DateTime? _parseLocalInterviewDate(String? raw) {
  return DateTimeUtils.parseYmd(raw);
}

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool _parseBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is String) {
    return value.toUpperCase() == 'Y' || value.toLowerCase() == 'true' || value == '1';
  }
  if (value is num) return value != 0;
  return defaultValue;
}
