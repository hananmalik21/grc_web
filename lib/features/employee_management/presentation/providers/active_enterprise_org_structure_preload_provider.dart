import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_org_structure_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _preloadOrgStructureForEnterprise(Ref ref, int enterpriseId) {
  final notifier = ref.read(manageEmployeesOrgStructureNotifierProvider(enterpriseId).notifier);
  notifier.fetchLevelsByEnterpriseId(enterpriseId);
}

final activeEnterpriseOrgStructurePreloadProvider = Provider<void>((ref) {
  final current = ref.watch(manageEmployeesEnterpriseIdProvider);
  if (current != null) {
    Future.microtask(() => _preloadOrgStructureForEnterprise(ref, current));
  }
});
