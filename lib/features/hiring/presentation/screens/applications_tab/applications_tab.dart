import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/applications_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/applications_tab/applications_desktop_layout.dart';
import 'package:grc/features/hiring/presentation/screens/applications_tab/applications_mobile_layout.dart';
import 'package:grc/features/hiring/presentation/screens/applications_tab/applications_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationsTab extends ConsumerStatefulWidget {
  const ApplicationsTab({super.key});

  @override
  ConsumerState<ApplicationsTab> createState() => _ApplicationsTabState();
}

class _ApplicationsTabState extends ConsumerState<ApplicationsTab> with ApplicationsPermissionMixin {
  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(applicationsControllerProvider.notifier).changeEnterprise(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewApplications) {
      return const AppUnauthorizedState();
    }

    final selectedEnterpriseId = ref.watch(applicationsTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return ApplicationsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return ApplicationsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return ApplicationsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
