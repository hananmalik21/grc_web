class AddApplicationNoteParams {
  const AddApplicationNoteParams({required this.enterpriseId, required this.applicationGuid});

  final int enterpriseId;
  final String applicationGuid;

  @override
  bool operator ==(Object other) {
    return other is AddApplicationNoteParams &&
        other.enterpriseId == enterpriseId &&
        other.applicationGuid == applicationGuid;
  }

  @override
  int get hashCode => Object.hash(enterpriseId, applicationGuid);
}

class AddApplicationNoteState {
  const AddApplicationNoteState({
    this.noteTypeCode = 'GENERAL',
    this.noteText = '',
    this.isPrivate = false,
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String noteTypeCode;
  final String noteText;
  final bool isPrivate;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  AddApplicationNoteState copyWith({
    String? noteTypeCode,
    String? noteText,
    bool? isPrivate,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return AddApplicationNoteState(
      noteTypeCode: noteTypeCode ?? this.noteTypeCode,
      noteText: noteText ?? this.noteText,
      isPrivate: isPrivate ?? this.isPrivate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
