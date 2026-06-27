import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final forfeitProcessingTabSelectedEnterpriseProvider =
    StateNotifierProvider<ForfeitProcessingTabEnterpriseNotifier, int?>((ref) {
      final notifier = ForfeitProcessingTabEnterpriseNotifier();
      final initialActive = ref.read(activeEnterpriseIdProvider);
      if (initialActive != null) notifier.setEnterpriseId(initialActive);
      ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
        if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
      });
      return notifier;
    });

class ForfeitProcessingTabEnterpriseNotifier extends StateNotifier<int?> {
  ForfeitProcessingTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final forfeitProcessingTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(forfeitProcessingTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
