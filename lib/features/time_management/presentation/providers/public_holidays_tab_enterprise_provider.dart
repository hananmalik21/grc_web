import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_provider.dart';

final publicHolidaysTabSelectedEnterpriseProvider = StateNotifierProvider<PublicHolidaysTabEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = PublicHolidaysTabEnterpriseNotifier(ref);
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

class PublicHolidaysTabEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  PublicHolidaysTabEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(publicHolidaysNotifierProvider(enterpriseId).notifier);
        notifier.setEnterpriseId(enterpriseId);
        notifier.loadFirstPage();
      });
    }
  }
}

final publicHolidaysTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(publicHolidaysTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
