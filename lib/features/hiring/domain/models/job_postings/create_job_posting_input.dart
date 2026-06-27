class CreateJobPostingInput {
  const CreateJobPostingInput({
    required this.enterpriseId,
    required this.requisitionGuid,
    required this.postingTitle,
    required this.postingDescription,
    required this.visibilityCode,
    required this.startDate,
    this.endDate,
    required this.aboutTheRole,
    required this.responsibilities,
    required this.qualifications,
    required this.internalSiteFlag,
    required this.externalSiteFlag,
    required this.linkedinFlag,
    required this.createdBy,
  });

  final int enterpriseId;
  final String requisitionGuid;
  final String postingTitle;
  final String postingDescription;
  final String visibilityCode;
  final String startDate;
  final String? endDate;
  final String aboutTheRole;
  final List<String> responsibilities;
  final List<String> qualifications;
  final String internalSiteFlag;
  final String externalSiteFlag;
  final String linkedinFlag;
  final String createdBy;

  Map<String, dynamic> toJson() => {
    'enterprise_id': enterpriseId,
    'requisition_guid': requisitionGuid,
    'posting_title': postingTitle,
    'posting_description': postingDescription,
    'visibility_code': visibilityCode,
    'start_date': startDate,
    if (endDate != null && endDate!.trim().isNotEmpty) 'end_date': endDate,
    'about_the_role': aboutTheRole,
    'responsibilities': responsibilities,
    'qualifications': qualifications,
    'internal_site_flag': internalSiteFlag,
    'external_site_flag': externalSiteFlag,
    'linkedin_flag': linkedinFlag,
    'created_by': createdBy,
  };
}
