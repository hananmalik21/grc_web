import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance_summary/attendance_summary_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceScreenSelectedEnterpriseProvider = StateNotifierProvider<AttendanceScreenEnterpriseNotifier, int?>((
  ref,
) {
  final notifier = AttendanceScreenEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class AttendanceScreenEnterpriseNotifier extends StateNotifier<int?> {
  AttendanceScreenEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final attendanceScreenEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(attendanceScreenSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final attendanceEnterpriseSyncProvider = Provider<void>((ref) {
  ref.listen<int?>(attendanceScreenEnterpriseIdProvider, (previous, next) {
    if (next != null) {
      ref.read(attendanceNotifierProvider.notifier).setCompanyId(next.toString());
      ref.read(attendanceSummaryProvider.notifier).setCompanyId(next.toString());
    }
  });
});
