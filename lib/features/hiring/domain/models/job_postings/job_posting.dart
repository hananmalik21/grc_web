class JobPosting {
  const JobPosting({
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

  bool get isInternalSiteEnabled => internalSiteFlag.trim().toUpperCase() == 'Y';

  bool get isExternalSiteEnabled => externalSiteFlag.trim().toUpperCase() == 'Y';

  bool get isLinkedInEnabled => linkedinFlag.trim().toUpperCase() == 'Y';
}
