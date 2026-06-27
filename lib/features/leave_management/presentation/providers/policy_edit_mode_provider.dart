import 'package:flutter_riverpod/flutter_riverpod.dart';

final policyEditModeProvider = StateNotifierProvider<PolicyEditModeNotifier, bool>((ref) {
  return PolicyEditModeNotifier();
});

final policySaveInProgressProvider = StateProvider<bool>((ref) => false);

class PolicyEditModeNotifier extends StateNotifier<bool> {
  PolicyEditModeNotifier() : super(false);

  void startEditing() {
    state = true;
  }

  void cancelEditing() {
    state = false;
  }

  void saveChanges() {
    state = false;
  }
}
