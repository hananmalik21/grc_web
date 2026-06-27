import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/initialization/providers/initialization_providers.dart';
import 'attendance_summary_provider.dart';

final attendanceSummarySelectedEnterpriseProvider =
    StateNotifierProvider<AttendanceSummaryEnterpriseNotifier, int?>((ref) {
      final notifier = AttendanceSummaryEnterpriseNotifier(ref);
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

class AttendanceSummaryEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  AttendanceSummaryEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(attendanceSummaryProvider.notifier)
            .setCompanyId(enterpriseId.toString());
      });
    }
  }
}

final attendanceSummaryEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(attendanceSummarySelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
