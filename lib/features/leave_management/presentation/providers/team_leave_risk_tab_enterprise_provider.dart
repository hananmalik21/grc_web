import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final teamLeaveRiskTabSelectedEnterpriseProvider = StateNotifierProvider<TeamLeaveRiskTabEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = TeamLeaveRiskTabEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class TeamLeaveRiskTabEnterpriseNotifier extends StateNotifier<int?> {
  TeamLeaveRiskTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final teamLeaveRiskTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(teamLeaveRiskTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
