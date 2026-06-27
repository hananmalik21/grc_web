import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_tab_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/all_leave_balances_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_balance_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_calendar_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_policies_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/policy_configuration_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/forfeit_policy_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/forfeit_processing_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/forfeit_reports_tab.dart';
import 'package:grc/features/leave_management/presentation/screens/team_leave_risk_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class _LeaveManagementTabIndex {
  static const int leaveRequests = 0;
  static const int leaveBalance = 1;
  static const int myLeaveBalance = 2;
  static const int teamLeaveRisk = 3;
  static const int leavePolicies = 4;
  static const int policyConfiguration = 5;
  static const int forfeitPolicy = 6;
  static const int forfeitProcessing = 7;
  static const int forfeitReports = 8;
  static const int leaveCalendar = 9;
}

class LeaveManagementScreen extends ConsumerWidget {
  const LeaveManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final selectedTabIndex = ref.watch(leaveManagementTabStateProvider.select((s) => s.currentTabIndex));
    final isMobile = ResponsiveHelper.isMobile(context);
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('leaveManagement');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTab(localizations, selectedTabIndex);

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
                      DigifyBreadcrumbItem(label: 'Dashboard', onTap: () => context.go(AppRoutes.dashboard)),
                      DigifyBreadcrumbItem(label: localizations.leaveManagement),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(selectedTabIndex)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    return switch (tabIndex) {
      _LeaveManagementTabIndex.leaveRequests => const LeaveRequestTab(),
      _LeaveManagementTabIndex.leaveBalance => const AllLeaveBalancesTab(),
      _LeaveManagementTabIndex.myLeaveBalance => const LeaveBalanceTab(),
      _LeaveManagementTabIndex.teamLeaveRisk => const TeamLeaveRiskTab(),
      _LeaveManagementTabIndex.leavePolicies => const LeavePoliciesTab(),
      _LeaveManagementTabIndex.policyConfiguration => const PolicyConfigurationTab(),
      _LeaveManagementTabIndex.forfeitPolicy => const ForfeitPolicyTab(),
      _LeaveManagementTabIndex.forfeitProcessing => const ForfeitProcessingTab(),
      _LeaveManagementTabIndex.forfeitReports => const ForfeitReportsTab(),
      _LeaveManagementTabIndex.leaveCalendar => const LeaveCalendarTab(),
      _ => const LeaveRequestTab(),
    };
  }

  String _childLabelForTab(AppLocalizations localizations, int tabIndex) {
    switch (tabIndex) {
      case _LeaveManagementTabIndex.leaveRequests:
        return localizations.leaveRequests;
      case _LeaveManagementTabIndex.leaveBalance:
        return localizations.leaveBalance;
      case _LeaveManagementTabIndex.myLeaveBalance:
        return localizations.myLeaveBalance;
      case _LeaveManagementTabIndex.teamLeaveRisk:
        return localizations.teamLeaveRisk;
      case _LeaveManagementTabIndex.leavePolicies:
        return localizations.leavePolicies;
      case _LeaveManagementTabIndex.policyConfiguration:
        return localizations.policyConfiguration;
      case _LeaveManagementTabIndex.forfeitPolicy:
        return localizations.forfeitPolicy;
      case _LeaveManagementTabIndex.forfeitProcessing:
        return localizations.forfeitProcessing;
      case _LeaveManagementTabIndex.forfeitReports:
        return localizations.forfeitReports;
      case _LeaveManagementTabIndex.leaveCalendar:
        return localizations.leaveCalendar;
      default:
        return localizations.leaveRequests;
    }
  }
}
