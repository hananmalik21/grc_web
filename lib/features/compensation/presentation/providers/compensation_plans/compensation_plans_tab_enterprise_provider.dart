import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/initialization/providers/initialization_providers.dart';

final compensationPlansTabSelectedEnterpriseProvider =
    StateNotifierProvider<CompensationPlansTabEnterpriseNotifier, int?>((ref) {
      final notifier = CompensationPlansTabEnterpriseNotifier();
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

class CompensationPlansTabEnterpriseNotifier extends StateNotifier<int?> {
  CompensationPlansTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final compensationPlansTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(compensationPlansTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
