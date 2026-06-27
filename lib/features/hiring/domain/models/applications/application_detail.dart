import 'package:grc/features/hiring/domain/models/applications/application_pipeline_stage.dart';

class ApplicationDetail {
  const ApplicationDetail({
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
  final ApplicationDetailCandidate candidate;
  final ApplicationDetailPosting posting;
  final ApplicationDetailRequisition requisition;
  final String currentStageCode;
  final String statusCode;
  final String sourceCode;
  final DateTime? appliedDate;
  final String? rejectionReasonCode;
  final String? rejectionComments;
  final bool rejectionEmailFlag;
  final List<ApplicationStageHistory> stageHistory;
  final List<ApplicationNote> notes;

  bool get isRejected =>
      ApplicationPipelineStage.isRejected(currentStageCode) || ApplicationPipelineStage.isRejected(statusCode);
}

class ApplicationDetailCandidate {
  const ApplicationDetailCandidate({
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
}

class ApplicationDetailPosting {
  const ApplicationDetailPosting({required this.postingGuid, required this.postingTitle});

  final String postingGuid;
  final String postingTitle;
}

class ApplicationDetailRequisition {
  const ApplicationDetailRequisition({
    required this.requisitionGuid,
    required this.requisitionNumber,
    required this.requisitionTitle,
  });

  final String requisitionGuid;
  final String requisitionNumber;
  final String requisitionTitle;
}

class ApplicationStageHistory {
  const ApplicationStageHistory({
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
}

class ApplicationNote {
  const ApplicationNote({
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
}
