class RequestAssessmentState {
  const RequestAssessmentState({
    required this.candidateGuid,
    this.assessmentTypeCode,
    this.platformCode,
    this.difficultyLevelCode,
    this.durationMinutes,
    this.dueDate,
    this.assessmentTemplate = '',
    this.instructions = '',
    this.skills = const [],
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String candidateGuid;
  final String? assessmentTypeCode;
  final String? platformCode;
  final String? difficultyLevelCode;
  final int? durationMinutes;
  final DateTime? dueDate;
  final String assessmentTemplate;
  final String instructions;
  final List<String> skills;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  RequestAssessmentState copyWith({
    String? candidateGuid,
    String? assessmentTypeCode,
    String? platformCode,
    String? difficultyLevelCode,
    int? durationMinutes,
    DateTime? dueDate,
    String? assessmentTemplate,
    String? instructions,
    List<String>? skills,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return RequestAssessmentState(
      candidateGuid: candidateGuid ?? this.candidateGuid,
      assessmentTypeCode: assessmentTypeCode ?? this.assessmentTypeCode,
      platformCode: platformCode ?? this.platformCode,
      difficultyLevelCode: difficultyLevelCode ?? this.difficultyLevelCode,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      dueDate: dueDate ?? this.dueDate,
      assessmentTemplate: assessmentTemplate ?? this.assessmentTemplate,
      instructions: instructions ?? this.instructions,
      skills: skills ?? this.skills,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
