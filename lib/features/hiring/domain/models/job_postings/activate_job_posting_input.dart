class ActivateJobPostingInput {
  const ActivateJobPostingInput({required this.postingGuid, required this.enterpriseId, required this.activatedBy});

  final String postingGuid;
  final int enterpriseId;
  final String activatedBy;

  Map<String, dynamic> toJson() => {'enterprise_id': enterpriseId, 'activated_by': activatedBy};
}
