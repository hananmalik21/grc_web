import 'package:grc/features/hiring/domain/models/applications/application_detail.dart';

class ApplicationDetailDto {
  const ApplicationDetailDto({required this.detail});

  final ApplicationDetailDataDto detail;

  factory ApplicationDetailDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Application detail response missing data');
    }
    return ApplicationDetailDto(detail: ApplicationDetailDataDto.fromJson(data));
  }

  ApplicationDetail toDomain() => detail.toDomain();
}

class ApplicationDetailDataDto {
  const ApplicationDetailDataDto({
    required this.applicationGuid,
    required this.applicationNumber,
    required this.candidateName,
    required this.resumeFileName,
    required this.resumeFileType,
    required this.resumeFileSize,
    required this.hasResume,
    required this.resumeUrl,
    required this.candidate,
    required this.posting,
    required this.requisition,
    required this.currentStageCode,
    required this.statusCode,
    required this.sourceCode,
    required this.appliedDate,
    required this.rejectionReasonCode,
    required this.rejectionComments,
    required this.rejectionEmailFlag,
    required this.stageHistory,
    required this.notes,
  });

  final String applicationGuid;
  final String applicationNumber;
  final String candidateName;
  final String? resumeFileName;
  final String? resumeFileType;
  final int? resumeFileSize;
  final bool hasResume;
  final String? resumeUrl;
  final ApplicationDetailCandidateDto candidate;
  final ApplicationDetailPostingDto posting;
  final ApplicationDetailRequisitionDto requisition;
  final String currentStageCode;
  final String statusCode;
  final String sourceCode;
  final DateTime? appliedDate;
  final String? rejectionReasonCode;
  final String? rejectionComments;
  final bool rejectionEmailFlag;
  final List<ApplicationStageHistoryDto> stageHistory;
  final List<ApplicationNoteDto> notes;

  factory ApplicationDetailDataDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailDataDto(
      applicationGuid: json['application_guid'] as String? ?? '',
      applicationNumber: json['application_number'] as String? ?? '',
      candidateName: json['candidate_name'] as String? ?? '',
      resumeFileName: json['resume_file_name'] as String?,
      resumeFileType: json['resume_file_type'] as String?,
      resumeFileSize: _parseNullableInt(json['resume_file_size']),
      hasResume: _parseYesNo(json['has_resume']),
      resumeUrl: json['resume_url'] as String?,
      candidate: ApplicationDetailCandidateDto.fromJson(json['candidate'] as Map<String, dynamic>? ?? const {}),
      posting: ApplicationDetailPostingDto.fromJson(json['posting'] as Map<String, dynamic>? ?? const {}),
      requisition: ApplicationDetailRequisitionDto.fromJson(json['requisition'] as Map<String, dynamic>? ?? const {}),
      currentStageCode: json['current_stage_code'] as String? ?? '',
      statusCode: json['status_code'] as String? ?? '',
      sourceCode: json['source_code'] as String? ?? '',
      appliedDate: _parseDate(json['applied_date']),
      rejectionReasonCode: json['rejection_reason_code'] as String?,
      rejectionComments: json['rejection_comments'] as String?,
      rejectionEmailFlag: _parseYesNo(json['rejection_email_flag']),
      stageHistory: _parseHistory(json['stage_history']),
      notes: _parseNotes(json['notes']),
    );
  }

  ApplicationDetail toDomain() {
    return ApplicationDetail(
      applicationGuid: applicationGuid,
      applicationNumber: applicationNumber,
      candidateName: candidateName,
      resumeFileName: resumeFileName,
      resumeFileType: resumeFileType,
      resumeFileSize: resumeFileSize,
      hasResume: hasResume,
      resumeUrl: resumeUrl,
      candidate: candidate.toDomain(),
      posting: posting.toDomain(),
      requisition: requisition.toDomain(),
      currentStageCode: currentStageCode,
      statusCode: statusCode,
      sourceCode: sourceCode,
      appliedDate: appliedDate,
      rejectionReasonCode: rejectionReasonCode,
      rejectionComments: rejectionComments,
      rejectionEmailFlag: rejectionEmailFlag,
      stageHistory: stageHistory.map((dto) => dto.toDomain()).toList(),
      notes: notes.map((dto) => dto.toDomain()).toList(),
    );
  }
}

class ApplicationDetailCandidateDto {
  const ApplicationDetailCandidateDto({
    required this.candidateGuid,
    required this.candidateName,
    required this.email,
    required this.phone,
    required this.currentTitle,
    required this.currentEmployer,
    required this.yearsExperience,
    required this.currentLocation,
    required this.currentSalary,
    required this.expectedSalary,
    required this.salaryCurrency,
    required this.portfolioLink,
    required this.githubLink,
    required this.linkedinProfile,
    required this.willingToRelocate,
  });

  final String candidateGuid;
  final String candidateName;
  final String email;
  final String phone;
  final String? currentTitle;
  final String? currentEmployer;
  final int? yearsExperience;
  final String? currentLocation;
  final double? currentSalary;
  final double? expectedSalary;
  final String? salaryCurrency;
  final String? portfolioLink;
  final String? githubLink;
  final String? linkedinProfile;
  final bool willingToRelocate;

  factory ApplicationDetailCandidateDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailCandidateDto(
      candidateGuid: json['candidate_guid'] as String? ?? '',
      candidateName: json['candidate_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      currentTitle: json['current_title'] as String?,
      currentEmployer: json['current_employer'] as String?,
      yearsExperience: _parseNullableInt(json['years_experience']),
      currentLocation: json['current_location'] as String?,
      currentSalary: _parseDouble(json['current_salary']),
      expectedSalary: _parseDouble(json['expected_salary']),
      salaryCurrency: json['salary_currency'] as String?,
      portfolioLink: json['portfolio_link'] as String?,
      githubLink: json['github_link'] as String?,
      linkedinProfile: json['linkedin_profile'] as String?,
      willingToRelocate: _parseYesNo(json['willing_to_relocate']),
    );
  }

  ApplicationDetailCandidate toDomain() {
    return ApplicationDetailCandidate(
      candidateGuid: candidateGuid,
      candidateName: candidateName,
      email: email,
      phone: phone,
      currentTitle: currentTitle,
      currentEmployer: currentEmployer,
      yearsExperience: yearsExperience,
      currentLocation: currentLocation,
      currentSalary: currentSalary,
      expectedSalary: expectedSalary,
      salaryCurrency: salaryCurrency,
      portfolioLink: portfolioLink,
      githubLink: githubLink,
      linkedinProfile: linkedinProfile,
      willingToRelocate: willingToRelocate,
    );
  }
}

class ApplicationDetailPostingDto {
  const ApplicationDetailPostingDto({required this.postingGuid, required this.postingTitle});

  final String postingGuid;
  final String postingTitle;

  factory ApplicationDetailPostingDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailPostingDto(
      postingGuid: json['posting_guid'] as String? ?? '',
      postingTitle: json['posting_title'] as String? ?? '',
    );
  }

  ApplicationDetailPosting toDomain() {
    return ApplicationDetailPosting(postingGuid: postingGuid, postingTitle: postingTitle);
  }
}

class ApplicationDetailRequisitionDto {
  const ApplicationDetailRequisitionDto({
    required this.requisitionGuid,
    required this.requisitionNumber,
    required this.requisitionTitle,
  });

  final String requisitionGuid;
  final String requisitionNumber;
  final String requisitionTitle;

  factory ApplicationDetailRequisitionDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailRequisitionDto(
      requisitionGuid: json['requisition_guid'] as String? ?? '',
      requisitionNumber: json['requisition_number'] as String? ?? '',
      requisitionTitle: json['requisition_title'] as String? ?? '',
    );
  }

  ApplicationDetailRequisition toDomain() {
    return ApplicationDetailRequisition(
      requisitionGuid: requisitionGuid,
      requisitionNumber: requisitionNumber,
      requisitionTitle: requisitionTitle,
    );
  }
}

class ApplicationStageHistoryDto {
  const ApplicationStageHistoryDto({
    required this.fromStageCode,
    required this.toStageCode,
    required this.comments,
    required this.createdBy,
    required this.creationDate,
  });

  final String? fromStageCode;
  final String toStageCode;
  final String? comments;
  final String createdBy;
  final DateTime? creationDate;

  factory ApplicationStageHistoryDto.fromJson(Map<String, dynamic> json) {
    return ApplicationStageHistoryDto(
      fromStageCode: json['from_stage_code'] as String?,
      toStageCode: json['to_stage_code'] as String? ?? '',
      comments: json['comments'] as String?,
      createdBy: json['created_by'] as String? ?? '',
      creationDate: _parseDateTime(json['creation_date']),
    );
  }

  ApplicationStageHistory toDomain() {
    return ApplicationStageHistory(
      fromStageCode: fromStageCode,
      toStageCode: toStageCode,
      comments: comments,
      createdBy: createdBy,
      creationDate: creationDate,
    );
  }
}

class ApplicationNoteDto {
  const ApplicationNoteDto({
    required this.noteType,
    required this.noteText,
    required this.isPrivate,
    required this.createdBy,
    required this.creationDate,
  });

  final String? noteType;
  final String? noteText;
  final bool isPrivate;
  final String? createdBy;
  final DateTime? creationDate;

  factory ApplicationNoteDto.fromJson(Map<String, dynamic> json) {
    return ApplicationNoteDto(
      noteType: json['note_type'] as String?,
      noteText: json['note_text'] as String?,
      isPrivate: _parseYesNo(json['is_private']),
      createdBy: json['created_by'] as String?,
      creationDate: _parseDateTime(json['creation_date']),
    );
  }

  ApplicationNote toDomain() {
    return ApplicationNote(
      noteType: noteType,
      noteText: noteText,
      isPrivate: isPrivate,
      createdBy: createdBy,
      creationDate: creationDate,
    );
  }
}

List<ApplicationStageHistoryDto> _parseHistory(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(ApplicationStageHistoryDto.fromJson).toList();
}

List<ApplicationNoteDto> _parseNotes(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(ApplicationNoteDto.fromJson).toList();
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
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

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text.replaceFirst(' ', 'T'));
}
