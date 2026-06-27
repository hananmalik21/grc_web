import 'package:grc/features/hiring/application/interviews/providers/interviews_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createNewInterviewEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(interviewsTabEnterpriseIdProvider);
});
