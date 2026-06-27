class UpdateCandidateAssessmentState {
  const UpdateCandidateAssessmentState({
    required this.candidateGuid,
    required this.assessmentGuid,
    this.assessmentTypeCode,
    this.difficultyLevelCode,
    this.durationMinutes,
    this.dueDate,
    this.instructions = '',
    this.skills = const [],
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String candidateGuid;
  final String assessmentGuid;
  final String? assessmentTypeCode;
  final String? difficultyLevelCode;
  final int? durationMinutes;
  final DateTime? dueDate;
  final String instructions;
  final List<String> skills;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  UpdateCandidateAssessmentState copyWith({
    String? candidateGuid,
    String? assessmentGuid,
    String? assessmentTypeCode,
    String? difficultyLevelCode,
    int? durationMinutes,
    DateTime? dueDate,
    String? instructions,
    List<String>? skills,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return UpdateCandidateAssessmentState(
      candidateGuid: candidateGuid ?? this.candidateGuid,
      assessmentGuid: assessmentGuid ?? this.assessmentGuid,
      assessmentTypeCode: assessmentTypeCode ?? this.assessmentTypeCode,
      difficultyLevelCode: difficultyLevelCode ?? this.difficultyLevelCode,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      dueDate: dueDate ?? this.dueDate,
      instructions: instructions ?? this.instructions,
      skills: skills ?? this.skills,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
