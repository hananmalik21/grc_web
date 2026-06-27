class ApplicationDetailData {
  const ApplicationDetailData({
    required this.applicationGuid,
    required this.applicationNumber,
    required this.candidateName,
    required this.candidateGuid,
    required this.candidateEmail,
    required this.candidatePhone,
    required this.candidateTitle,
    required this.candidateEmployer,
    required this.candidateLocation,
    required this.yearsExperience,
    required this.postingTitle,
    required this.postingGuid,
    required this.requisitionTitle,
    required this.requisitionNumber,
    required this.requisitionGuid,
    required this.currentStage,
    required this.currentStageCode,
    required this.effectivePipelineStageCode,
    required this.status,
    required this.statusCode,
    required this.source,
    required this.appliedDate,
    required this.isRejected,
    required this.hasResume,
    required this.resumeFileName,
    required this.resumeUrl,
    required this.daysInPipeline,
    required this.stageHistory,
    required this.notesCount,
    required this.rejectionComments,
  });

  final String applicationGuid;
  final String applicationNumber;
  final String candidateName;
  final String candidateGuid;
  final String candidateEmail;
  final String candidatePhone;
  final String? candidateTitle;
  final String? candidateEmployer;
  final String? candidateLocation;
  final int? yearsExperience;
  final String postingTitle;
  final String postingGuid;
  final String requisitionTitle;
  final String requisitionNumber;
  final String requisitionGuid;
  final String currentStage;
  final String currentStageCode;
  final String effectivePipelineStageCode;
  final String status;
  final String statusCode;
  final String source;
  final DateTime? appliedDate;
  final bool isRejected;
  final bool hasResume;
  final String? resumeFileName;
  final String? resumeUrl;
  final int daysInPipeline;
  final List<ApplicationTimelineEntry> stageHistory;
  final int notesCount;
  final String? rejectionComments;

  String get candidateSubtitle {
    final parts = <String>[];
    if (candidateTitle != null && candidateTitle!.isNotEmpty) {
      parts.add(candidateTitle!);
    }
    if (candidateEmployer != null && candidateEmployer!.isNotEmpty) {
      parts.add('at ${candidateEmployer!}');
    }
    return parts.join(' ');
  }
}

class ApplicationTimelineEntry {
  const ApplicationTimelineEntry({required this.title, required this.dateLabel, required this.comments});

  final String title;
  final String dateLabel;
  final String? comments;
}
