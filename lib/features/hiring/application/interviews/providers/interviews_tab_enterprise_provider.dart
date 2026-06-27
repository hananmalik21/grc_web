import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InterviewsViewMode { list, calendar }

final interviewsViewModeProvider = StateProvider<InterviewsViewMode>((ref) => InterviewsViewMode.list);

final interviewsTabSelectedEnterpriseProvider = StateNotifierProvider<InterviewsTabEnterpriseNotifier, int?>((ref) {
  final notifier = InterviewsTabEnterpriseNotifier();
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

class InterviewsTabEnterpriseNotifier extends StateNotifier<int?> {
  InterviewsTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final interviewsTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(interviewsTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final interviewsTabRefreshTickProvider = StateProvider<int>((ref) => 0);

final interviewsShowFiltersProvider = StateProvider<bool>((ref) => false);

final interviewsCurrentPageProvider = StateProvider<int>((ref) => 1);
