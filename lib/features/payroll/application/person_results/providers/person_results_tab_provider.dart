import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personResultsEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(activeEnterpriseIdProvider);
});

final personResultsEnterpriseNameProvider = Provider<String>((ref) {
  final enterpriseId = ref.watch(personResultsEnterpriseIdProvider);
  final enterprises = ref.watch(enterprisesCacheProvider) ?? const [];

  if (enterpriseId == null) return '';

  for (final enterprise in enterprises) {
    if (enterprise.id == enterpriseId) return enterprise.name;
  }

  return '';
});
