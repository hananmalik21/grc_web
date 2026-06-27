enum BackgroundCheckType {
  standard('STANDARD'),
  comprehensive('COMPREHENSIVE');

  const BackgroundCheckType(this.apiValue);

  final String apiValue;
}

enum BackgroundCheckComponent { employment, education, criminal, credit, drug }

class InitiateBackgroundCheckState {
  const InitiateBackgroundCheckState({
    required this.candidateGuid,
    this.provider = 'CheckrPro',
    this.checkType = BackgroundCheckType.standard,
    this.selectedComponents = const {},
    this.priority,
    this.additionalNotes = '',
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String candidateGuid;
  final String provider;
  final BackgroundCheckType checkType;
  final Set<BackgroundCheckComponent> selectedComponents;
  final String? priority;
  final String additionalNotes;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  bool isComponentSelected(BackgroundCheckComponent component) => selectedComponents.contains(component);

  InitiateBackgroundCheckState copyWith({
    String? candidateGuid,
    String? provider,
    BackgroundCheckType? checkType,
    Set<BackgroundCheckComponent>? selectedComponents,
    String? priority,
    String? additionalNotes,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return InitiateBackgroundCheckState(
      candidateGuid: candidateGuid ?? this.candidateGuid,
      provider: provider ?? this.provider,
      checkType: checkType ?? this.checkType,
      selectedComponents: selectedComponents ?? this.selectedComponents,
      priority: priority ?? this.priority,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
