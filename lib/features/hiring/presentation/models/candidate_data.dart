class CandidateEducationData {
  final String degree;
  final String university;
  final String location;
  final String duration;
  final String gpa;
  final bool isVerified;

  const CandidateEducationData({
    required this.degree,
    required this.university,
    required this.location,
    required this.duration,
    required this.gpa,
    this.isVerified = false,
  });
}

class CandidateSkillData {
  final String name;
  final String experience;
  final String level;
  final bool isVerified;

  const CandidateSkillData({
    required this.name,
    required this.experience,
    required this.level,
    this.isVerified = false,
  });
}

class CandidateAssessmentData {
  final String assessmentGuid;
  final String title;
  final String category;
  final int score;
  final int maxScore;
  final String date;
  final String evaluator;
  final String feedback;
  final String status;
  final int? durationMinutes;
  final String assessmentTemplate;
  final String platform;
  final String difficultyLevel;
  final DateTime? completionDueDate;
  final List<String> skills;

  const CandidateAssessmentData({
    required this.assessmentGuid,
    required this.title,
    required this.category,
    required this.score,
    required this.maxScore,
    required this.date,
    required this.evaluator,
    required this.feedback,
    this.status = '',
    this.durationMinutes,
    this.assessmentTemplate = '',
    this.platform = '',
    this.difficultyLevel = '',
    this.completionDueDate,
    this.skills = const [],
  });
}

class CandidateTalentPoolData {
  const CandidateTalentPoolData({
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
}

class CandidateApplicationData {
  final String jobTitle;
  final String applicationId;
  final String appliedDate;
  final String source;
  final String currentStage;
  final String status;

  const CandidateApplicationData({
    required this.jobTitle,
    required this.applicationId,
    required this.appliedDate,
    required this.source,
    required this.currentStage,
    required this.status,
  });
}

class CandidateBackgroundCheckData {
  const CandidateBackgroundCheckData({
    required this.backgroundCheckGuid,
    required this.provider,
    required this.checkType,
    required this.status,
    required this.priority,
    required this.requestedDate,
    required this.completedDate,
    required this.employmentVerification,
    required this.educationVerification,
    required this.criminalRecordCheck,
    required this.creditCheck,
    required this.drugTesting,
    required this.additionalNotes,
    required this.consentObtained,
  });

  final String backgroundCheckGuid;
  final String provider;
  final String checkType;
  final String status;
  final String priority;
  final DateTime? requestedDate;
  final DateTime? completedDate;
  final bool employmentVerification;
  final bool educationVerification;
  final bool criminalRecordCheck;
  final bool creditCheck;
  final bool drugTesting;
  final String? additionalNotes;
  final bool consentObtained;
}

class CandidateResumeData {
  const CandidateResumeData({
    required this.resumeId,
    required this.resumeGuid,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.activeFlag,
    required this.resumeLink,
    required this.createdBy,
    this.creationDate,
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

  String resolveDownloadUrl(String apiBaseUrl) {
    final link = resumeLink.trim();
    if (link.startsWith('http')) return link;
    final base = apiBaseUrl.endsWith('/') ? apiBaseUrl.substring(0, apiBaseUrl.length - 1) : apiBaseUrl;
    return link.startsWith('/') ? '$base$link' : '$base/$link';
  }
}

class CandidateExperienceData {
  final String jobTitle;
  final String company;
  final String type;
  final String location;
  final String duration;
  final String description;
  final List<String> achievements;
  final bool isCurrent;

  const CandidateExperienceData({
    required this.jobTitle,
    required this.company,
    required this.type,
    required this.location,
    required this.duration,
    required this.description,
    required this.achievements,
    this.isCurrent = false,
  });
}

class CandidateData {
  const CandidateData({
    required this.id,
    this.candidateNumericId,
    required this.name,
    required this.jobTitle,
    required this.company,
    required this.rating,
    required this.email,
    required this.phone,
    required this.location,
    required this.experience,
    required this.status,
    required this.topSkills,
    required this.tags,
    this.experiences = const [],
    this.educations = const [],
    this.skills = const [],
    this.assessments = const [],
    this.talentPools = const [],
    this.applications = const [],
    this.avatarUrl,
    this.alternateEmail,
    this.alternatePhone,
    this.preferredLocation,
    this.highestQualification,
    this.noticePeriod,
    this.willingToRelocate = true,
    this.currentSalary,
    this.expectedSalary,
    this.linkedinUrl,
    this.githubUrl,
    this.portfolioUrl,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.visaStatus,
    this.sourcedFrom,
    this.firstContactDate,
    this.backgroundCheckStatus = 'NOT STARTED',
    this.backgroundChecks = const [],
    this.resumes = const [],
  });

  final String id;
  final int? candidateNumericId;
  final String name;
  final String jobTitle;
  final String company;
  final double rating;
  final String email;
  final String phone;
  final String location;
  final String experience;
  final String status;
  final List<String> topSkills;
  final List<String> tags;
  final List<CandidateExperienceData> experiences;
  final List<CandidateEducationData> educations;
  final List<CandidateSkillData> skills;
  final List<CandidateAssessmentData> assessments;
  final List<CandidateTalentPoolData> talentPools;
  final List<CandidateApplicationData> applications;
  final String? avatarUrl;
  final String? alternateEmail;
  final String? alternatePhone;
  final String? preferredLocation;
  final String? highestQualification;
  final String? noticePeriod;
  final bool willingToRelocate;
  final String? currentSalary;
  final String? expectedSalary;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? portfolioUrl;
  final String? dateOfBirth;
  final String? gender;
  final String? nationality;
  final String? visaStatus;
  final String? sourcedFrom;
  final String? firstContactDate;
  final String backgroundCheckStatus;
  final List<CandidateBackgroundCheckData> backgroundChecks;
  final List<CandidateResumeData> resumes;

  CandidateResumeData? get primaryResume {
    final active = resumes.where((resume) => resume.isActive).toList();
    if (active.isNotEmpty) return active.first;
    return resumes.isNotEmpty ? resumes.first : null;
  }

  bool get hasResume => primaryResume != null;

  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  List<String> get talentPoolLabels {
    return talentPools.map((pool) => pool.poolName.trim()).where((name) => name.isNotEmpty).toList();
  }

  Set<String> get assignedTalentPoolGuids {
    return {
      for (final pool in talentPools)
        if (pool.poolGuid.trim().isNotEmpty) pool.poolGuid.trim().toUpperCase(),
    };
  }
}

class CandidateCommunicationData {
  final String title;
  final String type;
  final String direction;
  final String date;
  final String time;
  final String description;
  final String detail;
  final String status;

  const CandidateCommunicationData({
    required this.title,
    required this.type,
    required this.direction,
    required this.date,
    required this.time,
    required this.description,
    required this.detail,
    required this.status,
  });
}

class CandidateNote {
  final String id;
  final String creator;
  final String scope;
  final String timestamp;
  final String content;
  final List<String> tags;
  final bool isPrivate;

  const CandidateNote({
    required this.id,
    required this.creator,
    required this.scope,
    required this.timestamp,
    required this.content,
    required this.tags,
    required this.isPrivate,
  });
}
