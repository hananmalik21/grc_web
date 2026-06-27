import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final manageEmployeesSelectedEnterpriseProvider = StateNotifierProvider<ManageEmployeesEnterpriseNotifier, int?>((ref) {
  final notifier = ManageEmployeesEnterpriseNotifier();
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

class ManageEmployeesEnterpriseNotifier extends StateNotifier<int?> {
  ManageEmployeesEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final manageEmployeesEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(manageEmployeesSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
