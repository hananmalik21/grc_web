import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_enterprise_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final positionsSelectedEnterpriseProvider = StateNotifierProvider<WorkforceEnterpriseNotifier, int?>((ref) {
  final notifier = WorkforceEnterpriseNotifier();
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

final positionsEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(positionsSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
