import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final compensationEmployeeTabSelectedEnterpriseProvider =
    StateNotifierProvider<CompensationEmployeeTabEnterpriseNotifier, int?>((ref) {
      final notifier = CompensationEmployeeTabEnterpriseNotifier();
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

class CompensationEmployeeTabEnterpriseNotifier extends StateNotifier<int?> {
  CompensationEmployeeTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final compensationEmployeeTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(compensationEmployeeTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
