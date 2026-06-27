import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final leavePoliciesTabSelectedEnterpriseProvider = StateNotifierProvider<LeavePoliciesTabEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = LeavePoliciesTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class LeavePoliciesTabEnterpriseNotifier extends StateNotifier<int?> {
  LeavePoliciesTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final leavePoliciesTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(leavePoliciesTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
