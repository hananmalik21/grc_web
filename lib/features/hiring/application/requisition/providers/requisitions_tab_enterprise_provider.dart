import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requisitionsTabSelectedEnterpriseProvider = StateNotifierProvider<RequisitionsTabEnterpriseNotifier, int?>((ref) {
  final notifier = RequisitionsTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);

  if (initialActive != null) {
    notifier.setEnterpriseId(initialActive);
  }

  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) {
      notifier.setEnterpriseId(next);
    }
  });

  return notifier;
});

class RequisitionsTabEnterpriseNotifier extends StateNotifier<int?> {
  RequisitionsTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final requisitionsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(requisitionsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final requisitionsTabRefreshTickProvider = StateProvider.autoDispose<int>((ref) => 0);
