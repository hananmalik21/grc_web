class UpdateCandidateAssessmentInput {
  const UpdateCandidateAssessmentInput({
    required this.assessmentGuid,
    required this.enterpriseId,
    required this.assessmentType,
    required this.difficultyLevel,
    required this.durationMinutes,
    required this.completionDueDate,
    required this.skillsJson,
    required this.instructions,
    required this.statusCode,
    required this.updatedBy,
  });

  final String assessmentGuid;
  final int enterpriseId;
  final String assessmentType;
  final String difficultyLevel;
  final int durationMinutes;
  final String completionDueDate;
  final List<String> skillsJson;
  final String instructions;
  final String statusCode;
  final String updatedBy;

  Map<String, dynamic> toJson() => {
    'enterprise_id': enterpriseId,
    'assessment_type': assessmentType,
    'difficulty_level': difficultyLevel,
    'duration_minutes': durationMinutes,
    'completion_due_date': completionDueDate,
    'skills_json': skillsJson,
    'instructions': instructions,
    'status_code': statusCode,
    'updated_by': updatedBy,
  };
}
