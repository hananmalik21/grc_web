import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/all_leave_balances_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_desktop_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_mobile_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveBalanceTab extends ConsumerStatefulWidget {
  const LeaveBalanceTab({super.key});

  @override
  ConsumerState<LeaveBalanceTab> createState() => _LeaveBalanceTabState();
}

class _LeaveBalanceTabState extends ConsumerState<LeaveBalanceTab> with AllLeaveBalancesPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(leaveBalanceTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(leaveBalanceSummaryListProvider.notifier).resetAndLoad(enterpriseId);
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(leaveBalanceTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    if (enterpriseId != null) {
      ref.read(leaveBalanceSummaryListProvider.notifier).resetAndLoad(enterpriseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewLeaveBalance) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(leaveBalanceTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return LeaveBalanceMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    if (layout.isTablet) {
      return LeaveBalanceTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    return LeaveBalanceDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
