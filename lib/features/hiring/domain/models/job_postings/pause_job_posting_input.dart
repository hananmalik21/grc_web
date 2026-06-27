class PauseJobPostingInput {
  const PauseJobPostingInput({required this.postingGuid, required this.enterpriseId, required this.pausedBy});

  final String postingGuid;
  final int enterpriseId;
  final String pausedBy;

  Map<String, dynamic> toJson() => {'enterprise_id': enterpriseId, 'paused_by': pausedBy};
}
