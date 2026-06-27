class ApplicationTableRowData {
  final String applicationGuid;
  final String applicationId;
  final String candidateName;
  final String candidateId;
  final String jobTitle;
  final String requisitionId;
  final DateTime appliedDate;
  final String currentStage;
  final String status;
  final String source;

  const ApplicationTableRowData({
    required this.applicationGuid,
    required this.applicationId,
    required this.candidateName,
    required this.candidateId,
    required this.jobTitle,
    required this.requisitionId,
    required this.appliedDate,
    required this.currentStage,
    required this.status,
    required this.source,
  });
}
