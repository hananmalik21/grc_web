import 'package:grc/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_request_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_configuration_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveRequestTabLookupsPreloadProvider = FutureProvider<void>((ref) async {
  final enterpriseId = ref.watch(leaveRequestTabEnterpriseIdProvider);
  if (enterpriseId == null) return;
  await ref.watch(absLookupValuesForEnterpriseProvider(enterpriseId).future);
});

final policyConfigurationTabLookupsPreloadProvider = FutureProvider<void>((ref) async {
  final enterpriseId = ref.watch(policyConfigurationTabEnterpriseIdProvider);
  if (enterpriseId == null) return;
  await ref.watch(absLookupValuesForEnterpriseProvider(enterpriseId).future);
});

List<AbsLookupValue> _lookupValuesForTab(Ref ref, int? enterpriseId, AbsLookupCode code) {
  if (enterpriseId == null) return [];
  return ref.watch(absLookupValuesForEnterpriseAndCodeProvider((enterpriseId: enterpriseId, code: code)));
}

final leaveRequestTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(leaveRequestTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final policyConfigurationTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((
  ref,
  code,
) {
  final enterpriseId = ref.watch(policyConfigurationTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});
