import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timesheetScreenSelectedEnterpriseProvider = StateNotifierProvider<TimesheetScreenEnterpriseNotifier, int?>((ref) {
  final notifier = TimesheetScreenEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class TimesheetScreenEnterpriseNotifier extends StateNotifier<int?> {
  TimesheetScreenEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final timesheetScreenEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(timesheetScreenSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final timesheetEnterpriseSyncProvider = Provider<void>((ref) {
  ref.listen<int?>(timesheetScreenEnterpriseIdProvider, (previous, next) {
    if (next != null) {
      ref.read(timesheetNotifierProvider.notifier).setCompanyId(next.toString());
    }
  });
});
