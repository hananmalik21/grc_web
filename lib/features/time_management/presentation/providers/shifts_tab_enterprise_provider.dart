import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';

final shiftsTabSelectedEnterpriseProvider = StateNotifierProvider<ShiftsTabEnterpriseNotifier, int?>((ref) {
  final notifier = ShiftsTabEnterpriseNotifier(ref);
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

class ShiftsTabEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  ShiftsTabEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(shiftsNotifierProvider(enterpriseId).notifier);
        notifier.setEnterpriseId(enterpriseId);
        notifier.refresh();
      });
    }
  }
}

final shiftsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(shiftsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
