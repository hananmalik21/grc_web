import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final leaveRequestTabSelectedEnterpriseProvider = StateNotifierProvider<LeaveRequestTabEnterpriseNotifier, int?>((ref) {
  final notifier = LeaveRequestTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class LeaveRequestTabEnterpriseNotifier extends StateNotifier<int?> {
  LeaveRequestTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final leaveRequestTabEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(leaveRequestTabSelectedEnterpriseProvider);
});
