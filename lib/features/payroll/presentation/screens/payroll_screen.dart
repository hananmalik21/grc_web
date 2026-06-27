import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/features/payroll/application/payroll/providers/payroll_tab_state_provider.dart';
import 'package:grc/features/payroll/presentation/screens/element_entries/element_entries_tab.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/flow_monitor_tab.dart';
import 'package:grc/features/payroll/presentation/screens/person_results/person_results_tab.dart';
import 'package:grc/features/payroll/presentation/screens/submit_payroll_flow/submit_payroll_flow_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class _PayrollTabIndex {
  static const int personResults = 0;
  static const int manageElementEntries = 1;
  static const int submitPayrollFlow = 2;
  static const int flowMonitor = 3;
}

class PayrollScreen extends ConsumerWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final selectedTabIndex = ref.watch(payrollTabStateProvider.select((s) => s.currentTabIndex));
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('payroll');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTab(selectedTabIndex, loc);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveHelper.getPagePadding(context),
            child: isMobile
                ? null
                : DigifyBreadcrumb(
                    items: [
                      DigifyBreadcrumbItem(label: loc.dashboard, onTap: () => context.go(AppRoutes.dashboard)),
                      DigifyBreadcrumbItem(label: loc.payroll),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(selectedTabIndex, loc)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex, AppLocalizations loc) {
    switch (tabIndex) {
      case _PayrollTabIndex.personResults:
        return const PersonResultsTab();
      case _PayrollTabIndex.manageElementEntries:
        return const ElementEntriesTab();
      case _PayrollTabIndex.submitPayrollFlow:
        return const SubmitPayrollFlowTab();
      case _PayrollTabIndex.flowMonitor:
        return const FlowMonitorTab();
      default:
        return const PersonResultsTab();
    }
  }

  String _childLabelForTab(int tabIndex, AppLocalizations loc) {
    switch (tabIndex) {
      case _PayrollTabIndex.personResults:
        return loc.payrollPersonResults;
      case _PayrollTabIndex.manageElementEntries:
        return loc.payrollManageElementEntries;
      case _PayrollTabIndex.submitPayrollFlow:
        return loc.payrollSubmitPayrollFlow;
      case _PayrollTabIndex.flowMonitor:
        return loc.payrollFlowMonitor;
      default:
        return loc.payrollPersonResults;
    }
  }
}
