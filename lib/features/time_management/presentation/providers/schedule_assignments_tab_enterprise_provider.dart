import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_provider.dart';

final scheduleAssignmentsTabSelectedEnterpriseProvider =
    StateNotifierProvider<ScheduleAssignmentsTabEnterpriseNotifier, int?>((ref) {
      final notifier = ScheduleAssignmentsTabEnterpriseNotifier(ref);
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

class ScheduleAssignmentsTabEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  ScheduleAssignmentsTabEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
      });
    }
  }
}

final scheduleAssignmentsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(scheduleAssignmentsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
