import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'security_policies_state.dart';

class SecurityPoliciesNotifier extends StateNotifier<SecurityPoliciesState> {
  SecurityPoliciesNotifier() : super(const SecurityPoliciesState());

  SecurityPoliciesValues get _v => state.values;

  void setMinPasswordLengthEnabled(bool enabled) {
    state = state.copyWith(values: _v.copyWith(minPasswordLengthEnabled: enabled));
  }

  void setMinPasswordLength(String value) {
    state = state.copyWith(values: _v.copyWith(minPasswordLength: value));
  }

  void setPasswordComplexityEnabled(bool enabled) {
    state = state.copyWith(values: _v.copyWith(passwordComplexityEnabled: enabled));
  }

  void setPasswordComplexity(PasswordComplexity value) {
    state = state.copyWith(values: _v.copyWith(passwordComplexity: value));
  }

  void setPasswordExpiryEnabled(bool enabled) {
    state = state.copyWith(values: _v.copyWith(passwordExpiryEnabled: enabled));
  }

  void setPasswordExpiryDays(String value) {
    state = state.copyWith(values: _v.copyWith(passwordExpiryDays: value));
  }

  void setMaxLoginAttemptsEnabled(bool enabled) {
    state = state.copyWith(values: _v.copyWith(maxLoginAttemptsEnabled: enabled));
  }

  void setMaxLoginAttempts(String value) {
    state = state.copyWith(values: _v.copyWith(maxLoginAttempts: value));
  }

  void setSessionTimeoutEnabled(bool enabled) {
    state = state.copyWith(values: _v.copyWith(sessionTimeoutEnabled: enabled));
  }

  void setSessionTimeoutMinutes(String value) {
    state = state.copyWith(values: _v.copyWith(sessionTimeoutMinutes: value));
  }

  void setMfaEnabled(bool enabled) {
    state = state.copyWith(values: _v.copyWith(mfaEnabled: enabled));
  }

  void setMfaMode(MfaMode value) {
    state = state.copyWith(values: _v.copyWith(mfaMode: value));
  }

  void save() {
    if (!state.isDirty) return;
    state = state.copyWith(savedValues: state.values);
  }
}

final securityPoliciesProvider = StateNotifierProvider<SecurityPoliciesNotifier, SecurityPoliciesState>((ref) {
  return SecurityPoliciesNotifier();
});
