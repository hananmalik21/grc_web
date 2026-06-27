import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final forfeitPolicyTabSelectedEnterpriseProvider = StateNotifierProvider<ForfeitPolicyTabEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = ForfeitPolicyTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class ForfeitPolicyTabEnterpriseNotifier extends StateNotifier<int?> {
  ForfeitPolicyTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final forfeitPolicyTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(forfeitPolicyTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
