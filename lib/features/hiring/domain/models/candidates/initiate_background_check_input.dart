class InitiateBackgroundCheckInput {
  const InitiateBackgroundCheckInput({
    required this.enterpriseId,
    required this.candidateGuid,
    required this.provider,
    required this.checkType,
    required this.employmentVerFlag,
    required this.educationVerFlag,
    required this.criminalRecordFlag,
    required this.creditCheckFlag,
    required this.drugTestingFlag,
    required this.priority,
    required this.consentObtainedFlag,
    required this.createdBy,
    this.additionalNotes,
  });

  final int enterpriseId;
  final String candidateGuid;
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
  final String createdBy;

  Map<String, dynamic> toJson() => {
    'enterprise_id': enterpriseId,
    'candidate_guid': candidateGuid,
    'provider': provider,
    'check_type': checkType,
    'employment_ver_flag': employmentVerFlag,
    'education_ver_flag': educationVerFlag,
    'criminal_record_flag': criminalRecordFlag,
    'credit_check_flag': creditCheckFlag,
    'drug_testing_flag': drugTestingFlag,
    'priority': priority,
    if (additionalNotes != null && additionalNotes!.trim().isNotEmpty) 'additional_notes': additionalNotes,
    'consent_obtained_flag': consentObtainedFlag,
    'created_by': createdBy,
  };
}
