import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final overtimeScreenSelectedEnterpriseProvider = StateNotifierProvider<OvertimeScreenEnterpriseNotifier, int?>((ref) {
  final notifier = OvertimeScreenEnterpriseNotifier();
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) notifier.setEnterpriseId(initialActive);
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) notifier.setEnterpriseId(next);
  });
  return notifier;
});

class OvertimeScreenEnterpriseNotifier extends StateNotifier<int?> {
  OvertimeScreenEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final overtimeScreenEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(overtimeScreenSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final overtimeEnterpriseSyncProvider = Provider<void>((ref) {
  ref.listen<int?>(overtimeScreenEnterpriseIdProvider, (previous, next) {
    if (next != null) {
      ref.read(overtimeManagementProvider.notifier).setCompanyId(next.toString());
    }
  });
});
