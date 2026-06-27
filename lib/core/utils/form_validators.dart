class FormValidators {
  FormValidators._();

  static String? required(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    return null;
  }

  static String? requiredWithStateError(
    String? value,
    Map<String, String> stateErrors,
    String fieldKey, {
    String? defaultErrorMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return defaultErrorMessage ?? 'Required';
    }
    if (stateErrors.containsKey(fieldKey)) {
      return stateErrors[fieldKey];
    }
    return null;
  }

  static String? number(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    final numValue = num.tryParse(value);
    if (numValue == null) {
      return 'Must be a valid number';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String? errorMessage}) {
    final numberError = number(value, errorMessage: errorMessage);
    if (numberError != null) {
      return numberError;
    }
    final numValue = num.parse(value!);
    if (numValue <= 0) {
      return 'Must be greater than 0';
    }
    return null;
  }

  static String? positiveInteger(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return errorMessage ?? 'Must be a valid number';
    }
    return null;
  }

  static String? email(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    if (value.length < minLength) {
      return 'Must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    if (value.length > maxLength) {
      return 'Must not exceed $maxLength characters';
    }
    return null;
  }

  static String? lengthRange(String? value, int minLength, int maxLength, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    if (value.length < minLength || value.length > maxLength) {
      return 'Must be between $minLength and $maxLength characters';
    }
    return null;
  }

  static String? phone(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? url(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? match(String? value, String? otherValue, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    if (value != otherValue) {
      return errorMessage ?? 'Values do not match';
    }
    return null;
  }

  static String? iban(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'Required';
    }
    final cleaned = value.trim().replaceAll(RegExp(r'\s'), '');
    if (cleaned.length < 10) {
      return errorMessage ?? 'Please enter a valid IBAN';
    }
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(cleaned)) {
      return errorMessage ?? 'Please enter a valid IBAN';
    }
    return null;
  }

  static String? pattern(String? value, RegExp pattern, {String? errorMessage, String? requiredErrorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return requiredErrorMessage ?? 'Required';
    }
    if (!pattern.hasMatch(value)) {
      return errorMessage ?? 'Invalid format';
    }
    return null;
  }

  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
