import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_desktop_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_mobile_layout.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestTab extends ConsumerStatefulWidget {
  const LeaveRequestTab({super.key});

  @override
  ConsumerState<LeaveRequestTab> createState() => _LeaveRequestTabState();
}

class _LeaveRequestTabState extends ConsumerState<LeaveRequestTab> with LeaveRequestPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(leaveRequestTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(leaveRequestsNotifierProvider.notifier).refresh();
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(leaveRequestTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewLeaveRequest) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(leaveRequestTabEnterpriseIdProvider);
    ref.watch(leaveRequestTabLookupsPreloadProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return LeaveRequestMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    if (layout.isTablet) {
      return LeaveRequestTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }
    return LeaveRequestDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
