import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_policies_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_policies_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies_desktop_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies_mobile_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeavePoliciesTab extends ConsumerStatefulWidget {
  const LeavePoliciesTab({super.key});

  @override
  ConsumerState<LeavePoliciesTab> createState() => _LeavePoliciesTabState();
}

class _LeavePoliciesTabState extends ConsumerState<LeavePoliciesTab> with LeavePoliciesPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(leavePoliciesTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(leavePoliciesTabAbsPoliciesNotifierProvider.notifier).refresh();
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(leavePoliciesTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewLeavePolicies) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(leavePoliciesTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return LeavePoliciesMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    if (layout.isTablet) {
      return LeavePoliciesTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    return LeavePoliciesDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
