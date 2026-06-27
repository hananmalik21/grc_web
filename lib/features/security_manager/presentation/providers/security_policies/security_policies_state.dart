import 'package:flutter/foundation.dart';

enum PasswordComplexity { low, medium, high }

extension PasswordComplexityX on PasswordComplexity {
  String get label {
    switch (this) {
      case PasswordComplexity.low:
        return 'Low';
      case PasswordComplexity.medium:
        return 'Medium';
      case PasswordComplexity.high:
        return 'High';
    }
  }

  PasswordComplexity get next {
    switch (this) {
      case PasswordComplexity.high:
        return PasswordComplexity.medium;
      case PasswordComplexity.medium:
        return PasswordComplexity.low;
      case PasswordComplexity.low:
        return PasswordComplexity.high;
    }
  }
}

enum MfaMode { required, optional }

extension MfaModeX on MfaMode {
  String get label {
    switch (this) {
      case MfaMode.required:
        return 'Required';
      case MfaMode.optional:
        return 'Optional';
    }
  }

  MfaMode get toggled => this == MfaMode.required ? MfaMode.optional : MfaMode.required;
}

@immutable
class SecurityPoliciesValues {
  final bool minPasswordLengthEnabled;
  final String minPasswordLength;
  final bool passwordComplexityEnabled;
  final PasswordComplexity passwordComplexity;
  final bool passwordExpiryEnabled;
  final String passwordExpiryDays;
  final bool maxLoginAttemptsEnabled;
  final String maxLoginAttempts;
  final bool sessionTimeoutEnabled;
  final String sessionTimeoutMinutes;
  final bool mfaEnabled;
  final MfaMode mfaMode;

  const SecurityPoliciesValues({
    this.minPasswordLengthEnabled = true,
    this.minPasswordLength = '8',
    this.passwordComplexityEnabled = true,
    this.passwordComplexity = PasswordComplexity.high,
    this.passwordExpiryEnabled = true,
    this.passwordExpiryDays = '90',
    this.maxLoginAttemptsEnabled = true,
    this.maxLoginAttempts = '5',
    this.sessionTimeoutEnabled = true,
    this.sessionTimeoutMinutes = '30',
    this.mfaEnabled = true,
    this.mfaMode = MfaMode.required,
  });

  SecurityPoliciesValues copyWith({
    bool? minPasswordLengthEnabled,
    String? minPasswordLength,
    bool? passwordComplexityEnabled,
    PasswordComplexity? passwordComplexity,
    bool? passwordExpiryEnabled,
    String? passwordExpiryDays,
    bool? maxLoginAttemptsEnabled,
    String? maxLoginAttempts,
    bool? sessionTimeoutEnabled,
    String? sessionTimeoutMinutes,
    bool? mfaEnabled,
    MfaMode? mfaMode,
  }) {
    return SecurityPoliciesValues(
      minPasswordLengthEnabled: minPasswordLengthEnabled ?? this.minPasswordLengthEnabled,
      minPasswordLength: minPasswordLength ?? this.minPasswordLength,
      passwordComplexityEnabled: passwordComplexityEnabled ?? this.passwordComplexityEnabled,
      passwordComplexity: passwordComplexity ?? this.passwordComplexity,
      passwordExpiryEnabled: passwordExpiryEnabled ?? this.passwordExpiryEnabled,
      passwordExpiryDays: passwordExpiryDays ?? this.passwordExpiryDays,
      maxLoginAttemptsEnabled: maxLoginAttemptsEnabled ?? this.maxLoginAttemptsEnabled,
      maxLoginAttempts: maxLoginAttempts ?? this.maxLoginAttempts,
      sessionTimeoutEnabled: sessionTimeoutEnabled ?? this.sessionTimeoutEnabled,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      mfaMode: mfaMode ?? this.mfaMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SecurityPoliciesValues &&
            other.minPasswordLengthEnabled == minPasswordLengthEnabled &&
            other.minPasswordLength == minPasswordLength &&
            other.passwordComplexityEnabled == passwordComplexityEnabled &&
            other.passwordComplexity == passwordComplexity &&
            other.passwordExpiryEnabled == passwordExpiryEnabled &&
            other.passwordExpiryDays == passwordExpiryDays &&
            other.maxLoginAttemptsEnabled == maxLoginAttemptsEnabled &&
            other.maxLoginAttempts == maxLoginAttempts &&
            other.sessionTimeoutEnabled == sessionTimeoutEnabled &&
            other.sessionTimeoutMinutes == sessionTimeoutMinutes &&
            other.mfaEnabled == mfaEnabled &&
            other.mfaMode == mfaMode;
  }

  @override
  int get hashCode => Object.hash(
    minPasswordLengthEnabled,
    minPasswordLength,
    passwordComplexityEnabled,
    passwordComplexity,
    passwordExpiryEnabled,
    passwordExpiryDays,
    maxLoginAttemptsEnabled,
    maxLoginAttempts,
    sessionTimeoutEnabled,
    sessionTimeoutMinutes,
    mfaEnabled,
    mfaMode,
  );
}

@immutable
class SecurityPoliciesState {
  final SecurityPoliciesValues values;
  final SecurityPoliciesValues savedValues;

  const SecurityPoliciesState({
    this.values = const SecurityPoliciesValues(),
    this.savedValues = const SecurityPoliciesValues(),
  });

  bool get isDirty => values != savedValues;

  SecurityPoliciesState copyWith({SecurityPoliciesValues? values, SecurityPoliciesValues? savedValues}) {
    return SecurityPoliciesState(values: values ?? this.values, savedValues: savedValues ?? this.savedValues);
  }
}
