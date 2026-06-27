import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/initialization/providers/initialization_providers.dart';

final manageSalaryStructureSelectedEnterpriseProvider =
    StateNotifierProvider<ManageSalaryStructureEnterpriseNotifier, int?>((ref) {
      final notifier = ManageSalaryStructureEnterpriseNotifier();
      final initialActive = ref.read(activeEnterpriseIdProvider);

      if (initialActive != null) {
        notifier.setEnterpriseId(initialActive);
      }

      ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
        if (next != null && previous != next) {
          notifier.setEnterpriseId(next);
        }
      });

      return notifier;
    });

class ManageSalaryStructureEnterpriseNotifier extends StateNotifier<int?> {
  ManageSalaryStructureEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final manageSalaryStructureEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(manageSalaryStructureSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
