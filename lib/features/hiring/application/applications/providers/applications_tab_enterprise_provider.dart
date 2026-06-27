import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsTabSelectedEnterpriseProvider = StateNotifierProvider<ApplicationsTabEnterpriseNotifier, int?>((ref) {
  final notifier = ApplicationsTabEnterpriseNotifier();
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

class ApplicationsTabEnterpriseNotifier extends StateNotifier<int?> {
  ApplicationsTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final applicationsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(applicationsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
