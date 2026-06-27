import 'dart:convert';

import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';

class CandidatesPageDto {
  const CandidatesPageDto({required this.items, required this.pagination});

  final List<CandidateDto> items;
  final CandidatesPaginationDto? pagination;

  factory CandidatesPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CandidateDto.fromJson)
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final paginationJson = metaJson?['pagination'];
    final pagination = paginationJson is Map<String, dynamic> ? CandidatesPaginationDto.fromJson(paginationJson) : null;

    return CandidatesPageDto(items: data, pagination: pagination);
  }

  CandidatesPage toDomain() {
    return CandidatesPage(items: items.map((dto) => dto.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}

class CandidatesPaginationDto {
  const CandidatesPaginationDto({
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

  factory CandidatesPaginationDto.fromJson(Map<String, dynamic> json) {
    return CandidatesPaginationDto(
      page: _parseInt(json['page'], defaultValue: 1),
      pageSize: _parseInt(json['page_size'] ?? json['pageSize'], defaultValue: 10),
      total: _parseInt(json['total']),
      totalPages: _parseInt(json['total_pages'] ?? json['totalPages'], defaultValue: 1),
      hasNext: _parseBool(json['has_next'] ?? json['hasNext']),
      hasPrevious: _parseBool(json['has_previous'] ?? json['hasPrevious']),
    );
  }

  CandidatesPagination toDomain() {
    return CandidatesPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class CandidateResumeDto {
  const CandidateResumeDto({
    required this.resumeId,
    required this.resumeGuid,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.activeFlag,
    required this.resumeLink,
    required this.createdBy,
    required this.creationDate,
  });

  final int resumeId;
  final String resumeGuid;
  final String fileName;
  final String fileType;
  final int fileSize;
  final String activeFlag;
  final String resumeLink;
  final String createdBy;
  final DateTime? creationDate;

  factory CandidateResumeDto.fromJson(Map<String, dynamic> json) {
    return CandidateResumeDto(
      resumeId: _parseInt(json['resume_id']),
      resumeGuid: json['resume_guid'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
      fileType: json['file_type'] as String? ?? '',
      fileSize: _parseInt(json['file_size']),
      activeFlag: json['active_flag'] as String? ?? 'Y',
      resumeLink: json['resume_link'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? '',
      creationDate: _parseDate(json['creation_date']),
    );
  }

  CandidateResume toDomain() {
    return CandidateResume(
      resumeId: resumeId,
      resumeGuid: resumeGuid,
      fileName: fileName,
      fileType: fileType,
      fileSize: fileSize,
      activeFlag: activeFlag,
      resumeLink: resumeLink,
      createdBy: createdBy,
      creationDate: creationDate,
    );
  }
}

class CandidateEducationDto {
  const CandidateEducationDto({
    required this.educationId,
    required this.educationGuid,
    required this.degreeName,
    required this.institutionName,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    required this.grade,
    required this.description,
  });

  final int educationId;
  final String educationGuid;
  final String degreeName;
  final String institutionName;
  final String fieldOfStudy;
  final DateTime? startDate;
  final DateTime? endDate;
  final String grade;
  final String description;

  factory CandidateEducationDto.fromJson(Map<String, dynamic> json) {
    return CandidateEducationDto(
      educationId: _parseInt(json['education_id']),
      educationGuid: json['education_guid'] as String? ?? '',
      degreeName: json['degree_name'] as String? ?? '',
      institutionName: json['institution_name'] as String? ?? '',
      fieldOfStudy: json['field_of_study'] as String? ?? '',
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      grade: json['grade'] as String? ?? '',
      description: _parseOptionalString(json['description']),
    );
  }

  CandidateEducation toDomain() {
    return CandidateEducation(
      educationId: educationId,
      educationGuid: educationGuid,
      degreeName: degreeName,
      institutionName: institutionName,
      fieldOfStudy: fieldOfStudy,
      startDate: startDate,
      endDate: endDate,
      grade: grade,
      description: description,
    );
  }
}

class CandidateBackgroundCheckDto {
  const CandidateBackgroundCheckDto({
    required this.backgroundCheckId,
    required this.backgroundCheckGuid,
    required this.provider,
    required this.checkType,
    required this.employmentVerFlag,
    required this.educationVerFlag,
    required this.criminalRecordFlag,
    required this.creditCheckFlag,
    required this.drugTestingFlag,
    required this.priority,
    required this.additionalNotes,
    required this.consentObtainedFlag,
    required this.status,
    required this.requestedDate,
    required this.completedDate,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
  });

  final int backgroundCheckId;
  final String backgroundCheckGuid;
  final String provider;
  final String checkType;
  final String employmentVerFlag;
  final String educationVerFlag;
  final String criminalRecordFlag;
  final String creditCheckFlag;
  final String drugTestingFlag;
  final String priority;
  final String? additionalNotes;
  final String consentObtainedFlag;
  final String status;
  final DateTime? requestedDate;
  final DateTime? completedDate;
  final String activeFlag;
  final String createdBy;
  final DateTime? creationDate;

  factory CandidateBackgroundCheckDto.fromJson(Map<String, dynamic> json) {
    return CandidateBackgroundCheckDto(
      backgroundCheckId: _parseInt(json['background_check_id']),
      backgroundCheckGuid: json['background_check_guid'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      checkType: json['check_type'] as String? ?? '',
      employmentVerFlag: json['employment_ver_flag'] as String? ?? 'N',
      educationVerFlag: json['education_ver_flag'] as String? ?? 'N',
      criminalRecordFlag: json['criminal_record_flag'] as String? ?? 'N',
      creditCheckFlag: json['credit_check_flag'] as String? ?? 'N',
      drugTestingFlag: json['drug_testing_flag'] as String? ?? 'N',
      priority: json['priority'] as String? ?? '',
      additionalNotes: json['additional_notes'] as String?,
      consentObtainedFlag: json['consent_obtained_flag'] as String? ?? 'N',
      status: json['status'] as String? ?? '',
      requestedDate: _parseDate(json['requested_date']),
      completedDate: _parseDate(json['completed_date']),
      activeFlag: json['active_flag'] as String? ?? 'Y',
      createdBy: json['created_by'] as String? ?? '',
      creationDate: _parseDate(json['creation_date']),
    );
  }

  CandidateBackgroundCheck toDomain() {
    return CandidateBackgroundCheck(
      backgroundCheckId: backgroundCheckId,
      backgroundCheckGuid: backgroundCheckGuid,
      provider: provider,
      checkType: checkType,
      employmentVerFlag: employmentVerFlag,
      educationVerFlag: educationVerFlag,
      criminalRecordFlag: criminalRecordFlag,
      creditCheckFlag: creditCheckFlag,
      drugTestingFlag: drugTestingFlag,
      priority: priority,
      additionalNotes: additionalNotes,
      consentObtainedFlag: consentObtainedFlag,
      status: status,
      requestedDate: requestedDate,
      completedDate: completedDate,
      activeFlag: activeFlag,
      createdBy: createdBy,
      creationDate: creationDate,
    );
  }
}

class CandidateAssessmentDto {
  const CandidateAssessmentDto({
    required this.assessmentId,
    required this.assessmentGuid,
    required this.assessmentType,
    required this.assessmentTemplate,
    required this.platform,
    required this.difficultyLevel,
    required this.durationMinutes,
    required this.completionDueDate,
    required this.skillsJson,
    required this.instructions,
    required this.status,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
  });

  final int assessmentId;
  final String assessmentGuid;
  final String assessmentType;
  final String assessmentTemplate;
  final String platform;
  final String difficultyLevel;
  final int? durationMinutes;
  final DateTime? completionDueDate;
  final String? skillsJson;
  final String instructions;
  final String status;
  final String activeFlag;
  final String createdBy;
  final DateTime? creationDate;

  factory CandidateAssessmentDto.fromJson(Map<String, dynamic> json) {
    return CandidateAssessmentDto(
      assessmentId: _parseInt(json['assessment_id']),
      assessmentGuid: json['assessment_guid'] as String? ?? '',
      assessmentType: json['assessment_type'] as String? ?? '',
      assessmentTemplate: json['assessment_template'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      difficultyLevel: json['difficulty_level'] as String? ?? '',
      durationMinutes: _parseNullableInt(json['duration_minutes']),
      completionDueDate: _parseDate(json['completion_due_date']),
      skillsJson: _parseSkillsJsonField(json['skills_json']),
      instructions: json['instructions'] as String? ?? '',
      status: json['status'] as String? ?? '',
      activeFlag: json['active_flag'] as String? ?? 'Y',
      createdBy: json['created_by'] as String? ?? '',
      creationDate: _parseDate(json['creation_date']),
    );
  }

  CandidateAssessment toDomain() {
    return CandidateAssessment(
      assessmentId: assessmentId,
      assessmentGuid: assessmentGuid,
      assessmentType: assessmentType,
      assessmentTemplate: assessmentTemplate,
      platform: platform,
      difficultyLevel: difficultyLevel,
      durationMinutes: durationMinutes,
      completionDueDate: completionDueDate,
      skillsJson: skillsJson,
      instructions: instructions,
      status: status,
      activeFlag: activeFlag,
      createdBy: createdBy,
      creationDate: creationDate,
    );
  }
}

class CandidateTalentPoolDto {
  const CandidateTalentPoolDto({
    required this.poolId,
    required this.poolGuid,
    required this.poolName,
    required this.poolCandidateId,
    required this.poolCandidateGuid,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
  });

  final int poolId;
  final String poolGuid;
  final String poolName;
  final int poolCandidateId;
  final String poolCandidateGuid;
  final String activeFlag;
  final String createdBy;
  final DateTime? creationDate;

  factory CandidateTalentPoolDto.fromJson(Map<String, dynamic> json) {
    return CandidateTalentPoolDto(
      poolId: _parseInt(json['pool_id']),
      poolGuid: json['pool_guid'] as String? ?? '',
      poolName: json['pool_name'] as String? ?? '',
      poolCandidateId: _parseInt(json['pool_candidate_id']),
      poolCandidateGuid: json['pool_candidate_guid'] as String? ?? '',
      activeFlag: json['active_flag'] as String? ?? 'Y',
      createdBy: json['created_by'] as String? ?? '',
      creationDate: _parseDate(json['creation_date']),
    );
  }

  CandidateTalentPool toDomain() {
    return CandidateTalentPool(
      poolId: poolId,
      poolGuid: poolGuid,
      poolName: poolName,
      poolCandidateId: poolCandidateId,
      poolCandidateGuid: poolCandidateGuid,
      activeFlag: activeFlag,
      createdBy: createdBy,
      creationDate: creationDate,
    );
  }
}

class CandidateExperienceDto {
  const CandidateExperienceDto({
    required this.experienceId,
    required this.experienceGuid,
    required this.companyName,
    required this.jobTitle,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.currentJobFlag,
    required this.description,
  });

  final int experienceId;
  final String experienceGuid;
  final String companyName;
  final String jobTitle;
  final String location;
  final DateTime? startDate;
  final DateTime? endDate;
  final String currentJobFlag;
  final String description;

  factory CandidateExperienceDto.fromJson(Map<String, dynamic> json) {
    return CandidateExperienceDto(
      experienceId: _parseInt(json['experience_id']),
      experienceGuid: json['experience_guid'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      currentJobFlag: json['current_job_flag'] as String? ?? 'N',
      description: _parseOptionalString(json['description']),
    );
  }

  CandidateExperience toDomain() {
    return CandidateExperience(
      experienceId: experienceId,
      experienceGuid: experienceGuid,
      companyName: companyName,
      jobTitle: jobTitle,
      location: location,
      startDate: startDate,
      endDate: endDate,
      currentJobFlag: currentJobFlag,
      description: description,
    );
  }
}

class CandidateDto {
  const CandidateDto({
    required this.candidateId,
    required this.candidateGuid,
    required this.enterpriseId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.currentTitle,
    required this.currentEmployer,
    required this.yearsExperience,
    required this.currentLocation,
    required this.source,
    required this.expectedSalary,
    required this.salaryCurrency,
    required this.noticePeriod,
    required this.linkedinProfile,
    required this.status,
    required this.activeFlag,
    required this.education,
    required this.experience,
    required this.resumes,
    required this.backgroundChecks,
    required this.assessments,
    required this.talentPools,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
  });

  final int candidateId;
  final String candidateGuid;
  final int enterpriseId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String fullName;
  final String email;
  final String phone;
  final String? currentTitle;
  final String? currentEmployer;
  final int? yearsExperience;
  final String? currentLocation;
  final String? source;
  final double? expectedSalary;
  final String? salaryCurrency;
  final String? noticePeriod;
  final String? linkedinProfile;
  final String status;
  final String activeFlag;
  final List<CandidateEducationDto> education;
  final List<CandidateExperienceDto> experience;
  final List<CandidateResumeDto> resumes;
  final List<CandidateBackgroundCheckDto> backgroundChecks;
  final List<CandidateAssessmentDto> assessments;
  final List<CandidateTalentPoolDto> talentPools;
  final String createdBy;
  final DateTime? creationDate;
  final String lastUpdatedBy;
  final DateTime? lastUpdateDate;

  factory CandidateDto.fromJson(Map<String, dynamic> json) {
    return CandidateDto(
      candidateId: _parseInt(json['candidate_id']),
      candidateGuid: json['candidate_guid'] as String? ?? '',
      enterpriseId: _parseInt(json['enterprise_id']),
      firstName: json['first_name'] as String? ?? '',
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      currentTitle: json['current_title'] as String?,
      currentEmployer: json['current_employer'] as String?,
      yearsExperience: _parseNullableInt(json['years_experience']),
      currentLocation: json['current_location'] as String?,
      source: json['source'] as String?,
      expectedSalary: _parseDouble(json['expected_salary']),
      salaryCurrency: json['salary_currency'] as String?,
      noticePeriod: json['notice_period'] as String?,
      linkedinProfile: json['linkedin_profile'] as String?,
      status: json['status'] as String? ?? 'NEW',
      activeFlag: json['active_flag'] as String? ?? 'Y',
      education: _parseEducationList(json['education_json'] ?? json['education']),
      experience: _parseExperienceList(json['experience_json'] ?? json['experience']),
      resumes: _parseResumeList(json['resumes_json'] ?? json['resumes']),
      backgroundChecks: _parseBackgroundCheckList(json['background_checks_json'] ?? json['background_checks']),
      assessments: _parseAssessmentList(json['assessments_json'] ?? json['assessments']),
      talentPools: _parseTalentPoolList(json['talent_pools_json'] ?? json['talent_pools']),
      createdBy: json['created_by'] as String? ?? '',
      creationDate: _parseDate(json['creation_date']),
      lastUpdatedBy: json['last_updated_by'] as String? ?? '',
      lastUpdateDate: _parseDate(json['last_update_date']),
    );
  }

  Candidate toDomain() {
    return Candidate(
      candidateId: candidateId,
      candidateGuid: candidateGuid,
      enterpriseId: enterpriseId,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      fullName: fullName,
      email: email,
      phone: phone,
      currentTitle: currentTitle,
      currentEmployer: currentEmployer,
      yearsExperience: yearsExperience,
      currentLocation: currentLocation,
      source: source,
      expectedSalary: expectedSalary,
      salaryCurrency: salaryCurrency,
      noticePeriod: noticePeriod,
      linkedinProfile: linkedinProfile,
      status: status,
      activeFlag: activeFlag,
      education: education.map((dto) => dto.toDomain()).toList(),
      experience: experience.map((dto) => dto.toDomain()).toList(),
      resumes: resumes.map((dto) => dto.toDomain()).toList(),
      backgroundChecks: backgroundChecks.map((dto) => dto.toDomain()).toList(),
      assessments: assessments.map((dto) => dto.toDomain()).toList(),
      talentPools: talentPools.map((dto) => dto.toDomain()).toList(),
      createdBy: createdBy,
      creationDate: creationDate,
      lastUpdatedBy: lastUpdatedBy,
      lastUpdateDate: lastUpdateDate,
    );
  }
}

List<CandidateEducationDto> _parseEducationList(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(CandidateEducationDto.fromJson).toList();
}

List<CandidateExperienceDto> _parseExperienceList(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(CandidateExperienceDto.fromJson).toList();
}

List<CandidateResumeDto> _parseResumeList(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(CandidateResumeDto.fromJson).toList();
}

List<CandidateBackgroundCheckDto> _parseBackgroundCheckList(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(CandidateBackgroundCheckDto.fromJson).toList();
}

List<CandidateAssessmentDto> _parseAssessmentList(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(CandidateAssessmentDto.fromJson).toList();
}

List<CandidateTalentPoolDto> _parseTalentPoolList(dynamic raw) {
  if (raw is! List<dynamic>) return const [];
  return raw.whereType<Map<String, dynamic>>().map(CandidateTalentPoolDto.fromJson).toList();
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

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
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

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}

String _parseOptionalString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String? _parseSkillsJsonField(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is List) {
    return jsonEncode(value);
  }
  return value.toString();
}
