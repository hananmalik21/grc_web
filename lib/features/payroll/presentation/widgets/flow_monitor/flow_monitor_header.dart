import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/payroll/presentation/widgets/flow_monitor/flow_monitor_header_actions.dart';
import 'package:flutter/material.dart';

class FlowMonitorHeader extends StatelessWidget {
  const FlowMonitorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenLayout.isMobile;

    return DigifyTabHeader(
      title: '',
      trailing: FlowMonitorHeaderActions(compact: isMobile),
    );
  }
}
