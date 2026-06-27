import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionManagementEnterpriseNotifier extends StateNotifier<int?> {
  FunctionManagementEnterpriseNotifier(this.ref) : super(null);

  final Ref ref;

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final functionManagementSelectedEnterpriseProvider =
    StateNotifierProvider<FunctionManagementEnterpriseNotifier, int?>((ref) {
      final notifier = FunctionManagementEnterpriseNotifier(ref);
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

/// Resolves the effective enterprise ID: user selection or active fallback.
final functionManagementEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(functionManagementSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
