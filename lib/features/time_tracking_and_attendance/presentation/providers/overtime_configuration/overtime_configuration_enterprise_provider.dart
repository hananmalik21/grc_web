import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/initialization/providers/initialization_providers.dart';
import 'overtime_configuration_provider.dart';

final overtimeConfigurationSelectedEnterpriseProvider =
    StateNotifierProvider<OvertimeConfigurationEnterpriseNotifier, int?>((ref) {
      final notifier = OvertimeConfigurationEnterpriseNotifier(ref);
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

class OvertimeConfigurationEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  OvertimeConfigurationEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(overtimeConfigurationProvider.notifier)
            .setCompanyId(enterpriseId.toString());
      });
    }
  }
}

final overtimeConfigurationEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(overtimeConfigurationSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
