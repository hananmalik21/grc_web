import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/initialization/providers/initialization_providers.dart';

final componentsTabSelectedEnterpriseProvider = StateNotifierProvider<ComponentsTabEnterpriseNotifier, int?>((ref) {
  final notifier = ComponentsTabEnterpriseNotifier();
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

class ComponentsTabEnterpriseNotifier extends StateNotifier<int?> {
  ComponentsTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final componentsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(componentsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
