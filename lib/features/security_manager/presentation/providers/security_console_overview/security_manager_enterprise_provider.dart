import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/services/initialization/providers/initialization_providers.dart';

final securityManagerSelectedEnterpriseProvider =
    StateNotifierProvider<SecurityManagerEnterpriseNotifier, int?>((ref) {
      final notifier = SecurityManagerEnterpriseNotifier(ref);
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

class SecurityManagerEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  SecurityManagerEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    // Note: If there's a specific data provider for security manager to refresh, add it here.
    // e.g., ref.read(securityManagerDataProvider.notifier).setEnterpriseId(enterpriseId.toString());
  }
}

final securityManagerEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(securityManagerSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
