import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/services/initialization/providers/initialization_providers.dart';
import 'user_management_enterprise_notifier.dart';

final userManagementSelectedEnterpriseProvider = StateNotifierProvider<UserManagementEnterpriseNotifier, int?>((ref) {
  final notifier = UserManagementEnterpriseNotifier(ref);
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

final userManagementEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(userManagementSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

@Deprecated('Use userManagementEnterpriseIdProvider')
final securityManagerEnterpriseIdProvider = userManagementEnterpriseIdProvider;
