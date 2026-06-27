class RejectApplicationParams {
  const RejectApplicationParams({required this.enterpriseId, required this.applicationGuid});

  final int enterpriseId;
  final String applicationGuid;

  @override
  bool operator ==(Object other) {
    return other is RejectApplicationParams &&
        other.enterpriseId == enterpriseId &&
        other.applicationGuid == applicationGuid;
  }

  @override
  int get hashCode => Object.hash(enterpriseId, applicationGuid);
}

class RejectApplicationState {
  const RejectApplicationState({
    this.rejectionReasonCode,
    this.rejectionComments = '',
    this.sendEmail = false,
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String? rejectionReasonCode;
  final String rejectionComments;
  final bool sendEmail;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  RejectApplicationState copyWith({
    String? rejectionReasonCode,
    String? rejectionComments,
    bool? sendEmail,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return RejectApplicationState(
      rejectionReasonCode: rejectionReasonCode ?? this.rejectionReasonCode,
      rejectionComments: rejectionComments ?? this.rejectionComments,
      sendEmail: sendEmail ?? this.sendEmail,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
