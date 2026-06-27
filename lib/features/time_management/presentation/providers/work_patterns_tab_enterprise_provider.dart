import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';

final workPatternsTabSelectedEnterpriseProvider = StateNotifierProvider<WorkPatternsTabEnterpriseNotifier, int?>((ref) {
  final notifier = WorkPatternsTabEnterpriseNotifier(ref);
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

class WorkPatternsTabEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  WorkPatternsTabEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(workPatternsNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
      });
    }
  }
}

final workPatternsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(workPatternsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
