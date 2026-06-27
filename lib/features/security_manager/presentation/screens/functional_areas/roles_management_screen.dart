import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_desktop_layout.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_mobile_layout.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RolesManagementScreen extends ConsumerStatefulWidget {
  const RolesManagementScreen({super.key});

  @override
  ConsumerState<RolesManagementScreen> createState() => _RolesManagementScreenState();
}

class _RolesManagementScreenState extends ConsumerState<RolesManagementScreen> with RolesManagementPermissionMixin {
  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(securityManagerSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(securityManagerEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (!canViewRole) return AppUnauthorizedState();

    if (layout.isMobile) {
      return RolesManagementMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return RolesManagementTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return RolesManagementDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
