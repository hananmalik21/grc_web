class DeleteCandidateInput {
  const DeleteCandidateInput({required this.candidateGuid, required this.enterpriseId, required this.deletedBy});

  final String candidateGuid;
  final int enterpriseId;
  final String deletedBy;

  Map<String, dynamic> toJson() => {'enterprise_id': enterpriseId, 'deleted_by': deletedBy};
}
