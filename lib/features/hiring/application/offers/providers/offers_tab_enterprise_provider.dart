import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/hiring/application/offers/config/offers_list_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offersTabSelectedEnterpriseProvider = StateNotifierProvider<OffersTabEnterpriseNotifier, int?>((ref) {
  final notifier = OffersTabEnterpriseNotifier();
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

class OffersTabEnterpriseNotifier extends StateNotifier<int?> {
  OffersTabEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final offersTabEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(offersTabSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});

final offersTabRefreshTickProvider = StateProvider<int>((ref) => 0);

final offersShowFiltersProvider = StateProvider<bool>((ref) => false);

final offersCurrentPageProvider = StateProvider<int>((ref) => offersDefaultPage);
