import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';

final timeManagementEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(activeEnterpriseIdProvider);
});
