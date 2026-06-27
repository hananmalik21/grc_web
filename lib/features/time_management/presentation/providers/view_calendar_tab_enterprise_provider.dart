import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final viewCalendarTabSelectedEnterpriseProvider = StateNotifierProvider<ViewCalendarTabEnterpriseNotifier, int?>((ref) {
  final notifier = ViewCalendarTabEnterpriseNotifier(ref);
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null && !notifier.hasSelection) {
    notifier.setEnterpriseId(initialActive);
  }
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) {
      notifier.setEnterpriseId(next);
    }
  });
  return notifier;
});

class ViewCalendarTabEnterpriseNotifier extends StateNotifier<int?> {
  ViewCalendarTabEnterpriseNotifier(Ref ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final viewCalendarTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(viewCalendarTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
