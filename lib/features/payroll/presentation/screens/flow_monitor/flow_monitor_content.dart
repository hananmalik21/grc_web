import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/presentation/widgets/flow_monitor/flow_monitor_header.dart';
import 'package:grc/features/payroll/presentation/widgets/flow_monitor/flow_monitor_stats_section.dart';
import 'package:grc/features/payroll/presentation/widgets/flow_monitor/flow_monitor_activities_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlowMonitorContent extends StatelessWidget {
  const FlowMonitorContent({required this.padding, super.key});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);

    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FlowMonitorHeader(),
            Gap(sectionSpacing),
            const FlowMonitorStatsSection(),
            Gap(sectionSpacing),
            const FlowMonitorActivitiesSection(),
          ],
        ),
      ),
    );
  }
}
