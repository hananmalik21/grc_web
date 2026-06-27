import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_configuration_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/policy_configuration_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration_desktop_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration_mobile_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PolicyConfigurationTab extends ConsumerStatefulWidget {
  const PolicyConfigurationTab({super.key});

  @override
  ConsumerState<PolicyConfigurationTab> createState() => _PolicyConfigurationTabState();
}

class _PolicyConfigurationTabState extends ConsumerState<PolicyConfigurationTab>
    with PolicyConfigurationPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(policyConfigurationTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(policyConfigurationTabAbsPoliciesNotifierProvider.notifier).refresh();
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(policyConfigurationTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewPolicyConfiguration) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(policyConfigurationTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return PolicyConfigurationMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    if (layout.isTablet) {
      return PolicyConfigurationTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    return PolicyConfigurationDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
