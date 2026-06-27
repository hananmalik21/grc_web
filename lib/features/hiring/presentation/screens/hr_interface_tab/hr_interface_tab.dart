import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/hiring/presentation/providers/hr_interface/hr_interface_accepted_offers_provider.dart';
import 'package:grc/features/hiring/presentation/providers/hr_interface/hr_interface_offers_controller.dart';
import 'package:grc/features/hiring/presentation/providers/hr_interface/hr_interface_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/hr_interface_tab/hr_interface_desktop_layout.dart';
import 'package:grc/features/hiring/presentation/screens/hr_interface_tab/hr_interface_mobile_layout.dart';
import 'package:grc/features/hiring/presentation/screens/hr_interface_tab/hr_interface_tablet_layout.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/hr_interface_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HrInterfaceTab extends ConsumerStatefulWidget {
  const HrInterfaceTab({super.key});

  @override
  ConsumerState<HrInterfaceTab> createState() => _HrInterfaceTabState();
}

class _HrInterfaceTabState extends ConsumerState<HrInterfaceTab> with HrInterfacePermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(hrInterfaceOffersControllerProvider).refresh();
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(hrInterfaceTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    ref.read(hrInterfaceOffersControllerProvider).onEnterpriseChanged();
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewHrInterface) {
      return const AppUnauthorizedState();
    }

    ref.watch(hrInterfaceAcceptedOffersPageProvider);

    final selectedEnterpriseId = ref.watch(hrInterfaceTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return HrInterfaceMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return HrInterfaceTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return HrInterfaceDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
