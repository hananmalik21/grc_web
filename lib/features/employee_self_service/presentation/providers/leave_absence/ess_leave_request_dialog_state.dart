class EssLeaveRequestDialogState {
  const EssLeaveRequestDialogState({
    this.leaveType,
    this.startDate,
    this.endDate,
    this.reason = '',
    this.attachments = const [],
    this.isSubmitting = false,
    this.validationMessage,
  });

  final String? leaveType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String reason;
  final List<String> attachments;
  final bool isSubmitting;
  final String? validationMessage;

  EssLeaveRequestDialogState copyWith({
    String? leaveType,
    bool clearLeaveType = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? reason,
    List<String>? attachments,
    bool? isSubmitting,
    String? validationMessage,
    bool clearValidationMessage = false,
  }) {
    return EssLeaveRequestDialogState(
      leaveType: clearLeaveType ? null : (leaveType ?? this.leaveType),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      reason: reason ?? this.reason,
      attachments: attachments ?? this.attachments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validationMessage: clearValidationMessage ? null : (validationMessage ?? this.validationMessage),
    );
  }
}
