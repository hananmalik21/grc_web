import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final policyConfigurationTabSelectedEnterpriseProvider =
    StateNotifierProvider<PolicyConfigurationTabEnterpriseNotifier, int?>((ref) {
      final notifier = PolicyConfigurationTabEnterpriseNotifier();
      final initialActive = ref.read(activeEnterpriseIdProvider);
      if (initialActive != null) notifier.setEnterpriseId(initialActive);
      ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
        if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
      });
      return notifier;
    });

class PolicyConfigurationTabEnterpriseNotifier extends StateNotifier<int?> {
  PolicyConfigurationTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final policyConfigurationTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(policyConfigurationTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
