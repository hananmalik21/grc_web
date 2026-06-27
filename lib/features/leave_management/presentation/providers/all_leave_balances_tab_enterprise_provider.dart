import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final allLeaveBalancesTabSelectedEnterpriseProvider =
    StateNotifierProvider<AllLeaveBalancesTabEnterpriseNotifier, int?>((ref) {
      final notifier = AllLeaveBalancesTabEnterpriseNotifier();
      final initialActive = ref.read(activeEnterpriseIdProvider);
      if (initialActive != null) notifier.setEnterpriseId(initialActive);
      ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
        if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
      });
      return notifier;
    });

class AllLeaveBalancesTabEnterpriseNotifier extends StateNotifier<int?> {
  AllLeaveBalancesTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final allLeaveBalancesTabEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(allLeaveBalancesTabSelectedEnterpriseProvider);
});
