import 'package:grc/features/hiring/application/hr_interface/config/hr_interface_offers_list_config.dart';
import 'package:grc/features/hiring/application/hr_interface/providers/hr_interface_accepted_offers_provider.dart';
import 'package:grc/features/hiring/application/hr_interface/providers/hr_interface_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HrInterfaceOffersController {
  const HrInterfaceOffersController(this.ref);

  final Ref ref;

  void resetPage() {
    ref.read(hrInterfaceOffersCurrentPageProvider.notifier).state = hrInterfaceOffersDefaultPage;
  }

  void refresh() {
    ref.read(hrInterfaceTabRefreshTickProvider.notifier).state++;
  }

  void onEnterpriseChanged() {
    resetPage();
    refresh();
  }

  void goToPreviousPage() {
    final currentPage = ref.read(hrInterfaceOffersCurrentPageProvider);
    if (currentPage <= hrInterfaceOffersDefaultPage) return;
    ref.read(hrInterfaceOffersCurrentPageProvider.notifier).state = currentPage - 1;
  }

  void goToNextPage() {
    final currentPage = ref.read(hrInterfaceOffersCurrentPageProvider);
    final hasNext = ref.read(hrInterfaceAcceptedOffersHasNextProvider);
    if (!hasNext) return;
    ref.read(hrInterfaceOffersCurrentPageProvider.notifier).state = currentPage + 1;
  }

  void retry() {
    ref.invalidate(hrInterfaceAcceptedOffersPageProvider);
  }
}

final hrInterfaceOffersControllerProvider = Provider.autoDispose<HrInterfaceOffersController>((ref) {
  return HrInterfaceOffersController(ref);
});
