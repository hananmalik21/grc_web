class RequestAssessmentInput {
  const RequestAssessmentInput({
    required this.enterpriseId,
    required this.candidateGuid,
    required this.assessmentType,
    required this.assessmentTemplate,
    required this.platform,
    required this.difficultyLevel,
    required this.durationMinutes,
    required this.completionDueDate,
    required this.skillsJson,
    required this.instructions,
    required this.createdBy,
  });

  final int enterpriseId;
  final String candidateGuid;
  final String assessmentType;
  final String assessmentTemplate;
  final String platform;
  final String difficultyLevel;
  final int durationMinutes;
  final String completionDueDate;
  final List<String> skillsJson;
  final String instructions;
  final String createdBy;

  Map<String, dynamic> toJson() => {
    'enterprise_id': enterpriseId,
    'candidate_guid': candidateGuid,
    'assessment_type': assessmentType,
    'assessment_template': assessmentTemplate,
    'platform': platform,
    'difficulty_level': difficultyLevel,
    'duration_minutes': durationMinutes,
    'completion_due_date': completionDueDate,
    'skills_json': skillsJson,
    'instructions': instructions,
    'created_by': createdBy,
  };
}
