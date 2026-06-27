import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final salaryChangeHistoryTabSelectedEnterpriseProvider =
    StateNotifierProvider<SalaryChangeHistoryTabEnterpriseNotifier, int?>((ref) {
      final notifier = SalaryChangeHistoryTabEnterpriseNotifier();
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

class SalaryChangeHistoryTabEnterpriseNotifier extends StateNotifier<int?> {
  SalaryChangeHistoryTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final salaryChangeHistoryTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(salaryChangeHistoryTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
