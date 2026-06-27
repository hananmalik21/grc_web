import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:flutter/material.dart';

import 'compensation_plan_detail_tabs/tabs/compensation_plan_detail_analytics_tab.dart';
import 'compensation_plan_detail_tabs/tabs/compensation_plan_detail_audit_log_tab.dart';
import 'compensation_plan_detail_tabs/tabs/compensation_plan_detail_components_tab.dart';
import 'compensation_plan_detail_tabs/tabs/compensation_plan_detail_employees_tab.dart';
import 'compensation_plan_detail_tabs/tabs/compensation_plan_detail_eligibility_tab.dart';
import 'compensation_plan_detail_tabs/tabs/compensation_plan_detail_overview_tab.dart';
import 'compensation_plan_detail_tabs/tabs/compensation_plan_detail_workflow_tab.dart';

class CompensationPlanDetailTabsView extends StatelessWidget {
  final CompensationPlan plan;

  const CompensationPlanDetailTabsView({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);

    return AnimatedBuilder(
      animation: controller.animation!,
      builder: (context, child) {
        final selectedIndex = controller.index;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(key: ValueKey(selectedIndex), child: _buildTabContent(selectedIndex)),
        );
      },
    );
  }

  Widget _buildTabContent(int selectedIndex) {
    return switch (selectedIndex) {
      0 => CompensationPlanDetailOverviewTab(plan: plan),
      1 => CompensationPlanDetailComponentsTab(plan: plan),
      2 => CompensationPlanDetailEligibilityTab(plan: plan),
      3 => const CompensationPlanDetailEmployeesTab(),
      4 => const CompensationPlanDetailAnalyticsTab(),
      5 => const CompensationPlanDetailWorkflowTab(),
      6 => const CompensationPlanDetailAuditLogTab(),
      _ => const SizedBox.shrink(),
    };
  }
}
