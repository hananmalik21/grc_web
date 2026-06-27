import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final forfeitReportsTabSelectedEnterpriseProvider = StateNotifierProvider<ForfeitReportsTabEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = ForfeitReportsTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class ForfeitReportsTabEnterpriseNotifier extends StateNotifier<int?> {
  ForfeitReportsTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final forfeitReportsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(forfeitReportsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
