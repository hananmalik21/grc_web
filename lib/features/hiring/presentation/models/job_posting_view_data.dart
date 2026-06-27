enum JobPostingChannelType { internal, external, linkedIn }

class JobPostingChannelViewData {
  const JobPostingChannelViewData({required this.type, required this.postedDate});

  final JobPostingChannelType type;
  final String postedDate;
}

class JobPostingViewData {
  const JobPostingViewData({
    required this.postingGuid,
    required this.statusLabel,
    required this.isPaused,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.startDateTime,
    this.endDateTime,
    required this.visibility,
    required this.applicationsCount,
    required this.channels,
    required this.aboutTheRole,
    required this.responsibilitiesText,
    required this.qualificationsText,
    required this.internalSiteFlag,
    required this.externalSiteFlag,
    required this.linkedinFlag,
    required this.visibilityCode,
  });

  final String postingGuid;
  final String statusLabel;
  final bool isPaused;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String visibility;
  final int applicationsCount;
  final List<JobPostingChannelViewData> channels;
  final String aboutTheRole;
  final String responsibilitiesText;
  final String qualificationsText;
  final String internalSiteFlag;
  final String externalSiteFlag;
  final String linkedinFlag;
  final String visibilityCode;
}
