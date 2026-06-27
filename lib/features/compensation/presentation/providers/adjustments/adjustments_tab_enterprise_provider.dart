import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/initialization/providers/initialization_providers.dart';

final adjustmentsTabSelectedEnterpriseProvider = StateNotifierProvider<AdjustmentsTabEnterpriseNotifier, int?>((ref) {
  final notifier = AdjustmentsTabEnterpriseNotifier();
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

class AdjustmentsTabEnterpriseNotifier extends StateNotifier<int?> {
  AdjustmentsTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final adjustmentsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(adjustmentsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
