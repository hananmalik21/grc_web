class MoveApplicationStageParams {
  const MoveApplicationStageParams({
    required this.enterpriseId,
    required this.applicationGuid,
    required this.currentStageCode,
  });

  final int enterpriseId;
  final String applicationGuid;
  final String currentStageCode;

  @override
  bool operator ==(Object other) {
    return other is MoveApplicationStageParams &&
        other.enterpriseId == enterpriseId &&
        other.applicationGuid == applicationGuid &&
        other.currentStageCode == currentStageCode;
  }

  @override
  int get hashCode => Object.hash(enterpriseId, applicationGuid, currentStageCode);
}

class MoveApplicationStageState {
  const MoveApplicationStageState({
    required this.currentStageCode,
    this.selectedStageCode,
    this.comments = '',
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String currentStageCode;
  final String? selectedStageCode;
  final String comments;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  MoveApplicationStageState copyWith({
    String? currentStageCode,
    String? selectedStageCode,
    String? comments,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return MoveApplicationStageState(
      currentStageCode: currentStageCode ?? this.currentStageCode,
      selectedStageCode: selectedStageCode ?? this.selectedStageCode,
      comments: comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
