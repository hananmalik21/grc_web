import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleInterviewEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(candidatesTabEnterpriseIdProvider);
});
