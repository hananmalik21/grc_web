import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveBalanceTabSelectedEnterpriseProvider = StateNotifierProvider<LeaveBalanceTabEnterpriseNotifier, int?>((ref) {
  final notifier = LeaveBalanceTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class LeaveBalanceTabEnterpriseNotifier extends StateNotifier<int?> {
  LeaveBalanceTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final leaveBalanceTabEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(leaveBalanceTabSelectedEnterpriseProvider);
});
