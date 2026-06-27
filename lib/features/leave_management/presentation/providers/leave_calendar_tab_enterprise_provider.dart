import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final leaveCalendarTabSelectedEnterpriseProvider = StateNotifierProvider<LeaveCalendarTabEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = LeaveCalendarTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class LeaveCalendarTabEnterpriseNotifier extends StateNotifier<int?> {
  LeaveCalendarTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final leaveCalendarTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(leaveCalendarTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
