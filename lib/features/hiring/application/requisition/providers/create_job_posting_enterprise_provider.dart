import 'package:grc/features/hiring/application/requisition/providers/requisitions_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createJobPostingEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(requisitionsTabEnterpriseIdProvider);
});
