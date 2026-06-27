import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/leave_management/presentation/providers/all_leave_balances_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/all_leave_balances_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances_desktop_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances_mobile_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllLeaveBalancesTab extends ConsumerStatefulWidget {
  const AllLeaveBalancesTab({super.key});

  @override
  ConsumerState<AllLeaveBalancesTab> createState() => _AllLeaveBalancesTabState();
}

class _AllLeaveBalancesTabState extends ConsumerState<AllLeaveBalancesTab> with AllLeaveBalancesPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaveTypesNotifierProvider.notifier).loadLeaveTypes();
      final enterpriseId = ref.read(allLeaveBalancesTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(leaveBalanceSummaryListProvider.notifier).resetAndLoad(enterpriseId);
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(allLeaveBalancesTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    if (enterpriseId != null) {
      ref.read(leaveBalanceSummaryListProvider.notifier).resetAndLoad(enterpriseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewLeaveBalance) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(allLeaveBalancesTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return AllLeaveBalancesMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    if (layout.isTablet) {
      return AllLeaveBalancesTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    return AllLeaveBalancesDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
