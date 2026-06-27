class DeleteCandidateAssessmentInput {
  const DeleteCandidateAssessmentInput({
    required this.assessmentGuid,
    required this.enterpriseId,
    required this.deletedBy,
  });

  final String assessmentGuid;
  final int enterpriseId;
  final String deletedBy;

  Map<String, dynamic> toJson() => {'enterprise_id': enterpriseId, 'deleted_by': deletedBy};
}
