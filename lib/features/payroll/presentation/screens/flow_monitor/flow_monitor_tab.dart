import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/flow_monitor_content.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/mixins/flow_monitor_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowMonitorTab extends ConsumerStatefulWidget {
  const FlowMonitorTab({super.key});

  @override
  ConsumerState<FlowMonitorTab> createState() => _FlowMonitorTabState();
}

class _FlowMonitorTabState extends ConsumerState<FlowMonitorTab> with FlowMonitorPermissionMixin {
  @override
  Widget build(BuildContext context) {
    if (!canViewFlowMonitor) {
      return const AppUnauthorizedState();
    }

    return FlowMonitorContent(padding: ResponsiveHelper.getScreenPadding(context));
  }
}
