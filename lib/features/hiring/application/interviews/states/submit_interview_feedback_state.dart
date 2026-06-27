class SubmitInterviewFeedbackParams {
  const SubmitInterviewFeedbackParams({required this.interviewGuid});

  final String interviewGuid;

  @override
  bool operator ==(Object other) {
    return other is SubmitInterviewFeedbackParams && other.interviewGuid == interviewGuid;
  }

  @override
  int get hashCode => interviewGuid.hashCode;
}

class SubmitInterviewFeedbackState {
  const SubmitInterviewFeedbackState({this.isSubmitting = false, this.submitError});

  final bool isSubmitting;
  final String? submitError;

  SubmitInterviewFeedbackState copyWith({bool? isSubmitting, String? submitError, bool clearSubmitError = false}) {
    return SubmitInterviewFeedbackState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }
}
