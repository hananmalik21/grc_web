import 'package:grc/features/leave_management/presentation/providers/all_leave_balances_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_policy_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_processing_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_reports_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_calendar_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_tab_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_policies_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_request_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_configuration_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/team_leave_risk_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveManagementEnterpriseIdProvider = Provider<int?>((ref) {
  final tabIndex = ref.watch(leaveManagementTabStateProvider).currentTabIndex;
  return switch (tabIndex) {
    0 => ref.watch(leaveRequestTabEnterpriseIdProvider),
    1 => ref.watch(allLeaveBalancesTabEnterpriseIdProvider),
    2 => ref.watch(leaveBalanceTabEnterpriseIdProvider),
    3 => ref.watch(teamLeaveRiskTabEnterpriseIdProvider),
    4 => ref.watch(leavePoliciesTabEnterpriseIdProvider),
    5 => ref.watch(policyConfigurationTabEnterpriseIdProvider),
    6 => ref.watch(forfeitPolicyTabEnterpriseIdProvider),
    7 => ref.watch(forfeitProcessingTabEnterpriseIdProvider),
    8 => ref.watch(forfeitReportsTabEnterpriseIdProvider),
    9 => ref.watch(leaveCalendarTabEnterpriseIdProvider),
    _ => ref.watch(leaveRequestTabEnterpriseIdProvider),
  };
});
