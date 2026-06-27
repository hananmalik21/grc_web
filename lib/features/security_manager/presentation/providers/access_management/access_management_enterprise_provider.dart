import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/services/initialization/providers/initialization_providers.dart';
import 'access_management_provider.dart';

final accessManagementSelectedEnterpriseProvider =
    StateNotifierProvider<AccessManagementEnterpriseNotifier, int?>((ref) {
      final notifier = AccessManagementEnterpriseNotifier(ref);
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

class AccessManagementEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  AccessManagementEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(accessManagementProvider.notifier)
            .setCompanyId(enterpriseId.toString());
      });
    }
  }
}

final accessManagementEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(accessManagementSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
