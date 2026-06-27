import 'dart:convert';

import 'package:grc/features/hiring/presentation/models/candidate_data.dart';

class CandidatesPagination {
  const CandidatesPagination({
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
}

class CandidatesPage {
  const CandidatesPage({required this.items, required this.pagination});

  final List<Candidate> items;
  final CandidatesPagination? pagination;

  static const empty = CandidatesPage(items: [], pagination: null);
}

class CandidateResume {
  const CandidateResume({
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

  bool get isActive => activeFlag.toUpperCase() == 'Y';

  CandidateResumeData toUIModel() {
    return CandidateResumeData(
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

class CandidateEducation {
  const CandidateEducation({
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

  CandidateEducationData toUIModel() {
    String duration = '';
    if (startDate != null) {
      final startYear = startDate!.year;
      final endYear = endDate != null ? endDate!.year.toString() : 'Present';
      duration = '$startYear - $endYear';
    }

    return CandidateEducationData(
      degree: degreeName,
      university: institutionName,
      location: fieldOfStudy,
      duration: duration,
      gpa: grade,
      isVerified: true,
    );
  }
}

class CandidateBackgroundCheck {
  const CandidateBackgroundCheck({
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

  CandidateBackgroundCheckData toUIModel() {
    return CandidateBackgroundCheckData(
      backgroundCheckGuid: backgroundCheckGuid,
      provider: provider,
      checkType: checkType,
      status: status,
      priority: priority,
      requestedDate: requestedDate,
      completedDate: completedDate,
      employmentVerification: employmentVerFlag == 'Y',
      educationVerification: educationVerFlag == 'Y',
      criminalRecordCheck: criminalRecordFlag == 'Y',
      creditCheck: creditCheckFlag == 'Y',
      drugTesting: drugTestingFlag == 'Y',
      additionalNotes: additionalNotes,
      consentObtained: consentObtainedFlag == 'Y',
    );
  }
}

class CandidateAssessment {
  const CandidateAssessment({
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

  CandidateAssessmentData toUIModel() {
    final isCompleted = status.trim().toUpperCase() == 'COMPLETED';
    final categoryParts = <String>[
      if (platform.isNotEmpty) platform,
      if (assessmentTemplate.isNotEmpty) assessmentTemplate,
      if (difficultyLevel.isNotEmpty) difficultyLevel,
    ];

    return CandidateAssessmentData(
      assessmentGuid: assessmentGuid,
      title: assessmentType,
      category: categoryParts.join(' · '),
      score: isCompleted ? 100 : 0,
      maxScore: 100,
      date: _formatAssessmentDate(completionDueDate ?? creationDate),
      evaluator: createdBy,
      feedback: instructions,
      status: status,
      durationMinutes: durationMinutes,
      assessmentTemplate: assessmentTemplate,
      platform: platform,
      difficultyLevel: difficultyLevel,
      completionDueDate: completionDueDate,
      skills: parsedSkills(),
    );
  }

  List<String> parsedSkills() => _parseSkillsJson(skillsJson);
}

class CandidateTalentPool {
  const CandidateTalentPool({
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

  CandidateTalentPoolData toUIModel() {
    return CandidateTalentPoolData(
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

class CandidateExperience {
  const CandidateExperience({
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

  CandidateExperienceData toUIModel() {
    String duration = '';
    if (startDate != null) {
      final startYear = startDate!.year;
      final endYear = endDate != null ? endDate!.year.toString() : 'Present';
      duration = '$startYear - $endYear';
    }

    return CandidateExperienceData(
      jobTitle: jobTitle,
      company: companyName,
      type: currentJobFlag == 'Y' ? 'Full-time' : 'Previous',
      location: location,
      duration: duration,
      description: description,
      achievements: const [],
      isCurrent: currentJobFlag == 'Y',
    );
  }
}

class Candidate {
  const Candidate({
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
  final List<CandidateEducation> education;
  final List<CandidateExperience> experience;
  final List<CandidateResume> resumes;
  final List<CandidateBackgroundCheck> backgroundChecks;
  final List<CandidateAssessment> assessments;
  final List<CandidateTalentPool> talentPools;
  final String createdBy;
  final DateTime? creationDate;
  final String lastUpdatedBy;
  final DateTime? lastUpdateDate;

  CandidateResume? get primaryResume {
    final active = resumes.where((resume) => resume.isActive).toList();
    if (active.isNotEmpty) return active.first;
    return resumes.isNotEmpty ? resumes.first : null;
  }

  CandidateData toCandidateData() {
    // Generate a default visual rating based on years of experience, e.g. cap at 5.0
    double rating = 4.0;
    if (yearsExperience != null) {
      if (yearsExperience! > 10) {
        rating = 4.8;
      } else if (yearsExperience! > 5) {
        rating = 4.5;
      } else if (yearsExperience! > 2) {
        rating = 4.2;
      }
    }

    final assessmentSkills = _collectAssessmentSkills(assessments);
    final skills = assessmentSkills
        .map(
          (name) => CandidateSkillData(
            name: name,
            experience: yearsExperience != null ? '$yearsExperience years' : 'N/A',
            level: 'Verified',
            isVerified: true,
          ),
        )
        .toList();

    final topSkills = assessmentSkills.isNotEmpty
        ? assessmentSkills.take(5).toList()
        : _deriveTopSkillsFromTitle(currentTitle);

    final experienceText = yearsExperience != null ? '$yearsExperience Years' : 'N/A';
    final sortedAssessments = _sortedAssessments(assessments);
    final activeTalentPools = talentPools.where((pool) => pool.activeFlag == 'Y').toList();

    return CandidateData(
      id: candidateGuid,
      candidateNumericId: candidateId,
      name: fullName.isNotEmpty ? fullName : '$firstName $lastName',
      jobTitle: currentTitle ?? 'Candidate',
      company: currentEmployer ?? 'N/A',
      rating: rating,
      email: email,
      phone: phone,
      location: currentLocation ?? 'N/A',
      experience: experienceText,
      status: status,
      topSkills: topSkills,
      tags: [source ?? 'Direct Application'],
      experiences: experience.map((e) => e.toUIModel()).toList(),
      educations: education.map((e) => e.toUIModel()).toList(),
      skills: skills,
      assessments: sortedAssessments.map((assessment) => assessment.toUIModel()).toList(),
      talentPools: activeTalentPools.map((pool) => pool.toUIModel()).toList(),
      noticePeriod: noticePeriod,
      expectedSalary: expectedSalary != null ? '$expectedSalary ${salaryCurrency ?? ""}'.trim() : null,
      linkedinUrl: linkedinProfile,
      sourcedFrom: source,
      firstContactDate: _formatContactDate(creationDate),
      backgroundCheckStatus: _deriveBackgroundCheckStatus(backgroundChecks),
      backgroundChecks: _sortedBackgroundChecks(backgroundChecks).map((check) => check.toUIModel()).toList(),
      resumes: resumes.map((resume) => resume.toUIModel()).toList(),
    );
  }

  static List<String> _deriveTopSkillsFromTitle(String? title) {
    if (title == null) {
      return const ['Professional', 'Communication'];
    }

    final titleLower = title.toLowerCase();
    if (titleLower.contains('software') ||
        titleLower.contains('developer') ||
        titleLower.contains('engineer') ||
        titleLower.contains('application')) {
      return const ['Software Engineering', 'Enterprise Apps', 'Integration'];
    }
    if (titleLower.contains('manager')) {
      return const ['Management', 'Leadership', 'Operations'];
    }
    return const ['Problem Solving', 'Communication'];
  }

  static List<String> _collectAssessmentSkills(List<CandidateAssessment> items) {
    final skills = <String>{};
    for (final assessment in items) {
      if (assessment.activeFlag != 'Y') continue;
      skills.addAll(assessment.parsedSkills());
    }
    return skills.toList();
  }

  static List<CandidateAssessment> _sortedAssessments(List<CandidateAssessment> items) {
    if (items.isEmpty) return const [];

    final relevant = items.where((item) => item.activeFlag == 'Y').toList();
    final list = relevant.isNotEmpty ? relevant : items;

    return List<CandidateAssessment>.from(list)..sort((a, b) {
      final aDate = a.creationDate ?? a.completionDueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.creationDate ?? b.completionDueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
  }

  static List<CandidateBackgroundCheck> _sortedBackgroundChecks(List<CandidateBackgroundCheck> checks) {
    if (checks.isEmpty) return const [];

    final relevant = checks.where((c) => c.activeFlag == 'Y').toList();
    final list = relevant.isNotEmpty ? relevant : checks;

    return List<CandidateBackgroundCheck>.from(list)..sort((a, b) {
      final aDate = a.creationDate ?? a.requestedDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.creationDate ?? b.requestedDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
  }

  static String _deriveBackgroundCheckStatus(List<CandidateBackgroundCheck> checks) {
    final sorted = _sortedBackgroundChecks(checks);
    if (sorted.isEmpty) return 'NOT STARTED';
    return _mapBackgroundCheckStatus(sorted.first.status);
  }

  static String _mapBackgroundCheckStatus(String apiStatus) {
    switch (apiStatus.trim().toUpperCase()) {
      case 'COMPLETED':
        return 'COMPLETED';
      case 'INITIATED':
      case 'IN_PROGRESS':
      case 'IN PROGRESS':
      case 'PENDING':
        return 'IN PROGRESS';
      default:
        return apiStatus.trim().isEmpty ? 'NOT STARTED' : apiStatus.trim().toUpperCase();
    }
  }

  static String? _formatContactDate(DateTime? date) {
    if (date == null) return null;
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

String _formatAssessmentDate(DateTime? date) {
  if (date == null) return 'N/A';
  final y = date.year;
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

List<String> _parseSkillsJson(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const [];

  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.map((item) => item.toString().trim()).where((item) => item.isNotEmpty).toList();
    }
  } catch (_) {
    return const [];
  }

  return const [];
}
