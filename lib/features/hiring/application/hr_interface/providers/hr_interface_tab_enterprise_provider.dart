import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hrInterfaceTabSelectedEnterpriseProvider = StateNotifierProvider<HrInterfaceTabEnterpriseNotifier, int?>((ref) {
  final notifier = HrInterfaceTabEnterpriseNotifier();
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

class HrInterfaceTabEnterpriseNotifier extends StateNotifier<int?> {
  HrInterfaceTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final hrInterfaceTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(hrInterfaceTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final hrInterfaceTabRefreshTickProvider = StateProvider<int>((ref) => 0);
