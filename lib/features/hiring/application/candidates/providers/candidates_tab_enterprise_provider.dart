import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CandidatesViewMode { grid, list }

final candidatesViewModeProvider = StateProvider<CandidatesViewMode>((ref) => CandidatesViewMode.grid);

final candidatesTabSelectedEnterpriseProvider = StateNotifierProvider<CandidatesTabEnterpriseNotifier, int?>((ref) {
  final notifier = CandidatesTabEnterpriseNotifier();
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

class CandidatesTabEnterpriseNotifier extends StateNotifier<int?> {
  CandidatesTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final candidatesTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(candidatesTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final candidatesTabRefreshTickProvider = StateProvider<int>((ref) => 0);

final candidatesShowFiltersProvider = StateProvider<bool>((ref) => false);

final candidatesCurrentPageProvider = StateProvider<int>((ref) => 1);
