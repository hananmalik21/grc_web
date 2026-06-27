import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final manageEnterpriseStructureSelectedEnterpriseProvider =
    StateNotifierProvider<ManageEnterpriseStructureEnterpriseNotifier, int?>((ref) {
      final notifier = ManageEnterpriseStructureEnterpriseNotifier();
      final activeId = ref.read(activeEnterpriseIdProvider);
      if (activeId != null) notifier.setEnterpriseId(activeId);
      ref.listen<int?>(activeEnterpriseIdProvider, (_, next) {
        if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
      });
      return notifier;
    });

class ManageEnterpriseStructureEnterpriseNotifier extends StateNotifier<int?> {
  ManageEnterpriseStructureEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final manageEnterpriseStructureEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(manageEnterpriseStructureSelectedEnterpriseProvider);
});
