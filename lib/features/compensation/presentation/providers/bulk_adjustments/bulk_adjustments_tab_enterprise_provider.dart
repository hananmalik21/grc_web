import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bulkAdjustmentsTabSelectedEnterpriseProvider = StateNotifierProvider<BulkAdjustmentsTabEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = BulkAdjustmentsTabEnterpriseNotifier();
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

class BulkAdjustmentsTabEnterpriseNotifier extends StateNotifier<int?> {
  BulkAdjustmentsTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final bulkAdjustmentsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(bulkAdjustmentsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
