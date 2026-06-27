class CreateJobPostingState {
  const CreateJobPostingState({
    required this.requisitionGuid,
    this.postingTitle = '',
    this.postingDescription = '',
    this.aboutTheRole = '',
    this.responsibilitiesText = '',
    this.qualificationsText = '',
    this.startDate,
    this.endDate,
    this.internalSiteFlag = 'Y',
    this.externalSiteFlag = 'Y',
    this.linkedinFlag = 'N',
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String requisitionGuid;
  final String postingTitle;
  final String postingDescription;
  final String aboutTheRole;
  final String responsibilitiesText;
  final String qualificationsText;
  final DateTime? startDate;
  final DateTime? endDate;
  final String internalSiteFlag;
  final String externalSiteFlag;
  final String linkedinFlag;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  CreateJobPostingState copyWith({
    String? requisitionGuid,
    String? postingTitle,
    String? postingDescription,
    String? aboutTheRole,
    String? responsibilitiesText,
    String? qualificationsText,
    DateTime? startDate,
    DateTime? endDate,
    String? internalSiteFlag,
    String? externalSiteFlag,
    String? linkedinFlag,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return CreateJobPostingState(
      requisitionGuid: requisitionGuid ?? this.requisitionGuid,
      postingTitle: postingTitle ?? this.postingTitle,
      postingDescription: postingDescription ?? this.postingDescription,
      aboutTheRole: aboutTheRole ?? this.aboutTheRole,
      responsibilitiesText: responsibilitiesText ?? this.responsibilitiesText,
      qualificationsText: qualificationsText ?? this.qualificationsText,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      internalSiteFlag: internalSiteFlag ?? this.internalSiteFlag,
      externalSiteFlag: externalSiteFlag ?? this.externalSiteFlag,
      linkedinFlag: linkedinFlag ?? this.linkedinFlag,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
