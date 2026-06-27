class ChangeApplicationStageInput {
  const ChangeApplicationStageInput({
    required this.applicationGuid,
    required this.enterpriseId,
    required this.currentStageCode,
    required this.updatedBy,
    this.comments,
  });

  final String applicationGuid;
  final int enterpriseId;
  final String currentStageCode;
  final String updatedBy;
  final String? comments;

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'enterprise_id': enterpriseId,
      'current_stage_code': currentStageCode.trim().toUpperCase(),
      'updated_by': updatedBy.trim().isEmpty ? 'ADMIN' : updatedBy.trim(),
    };
    final trimmedComments = comments?.trim();
    if (trimmedComments != null && trimmedComments.isNotEmpty) {
      body['comments'] = trimmedComments.length > 4000 ? trimmedComments.substring(0, 4000) : trimmedComments;
    }
    return body;
  }
}
