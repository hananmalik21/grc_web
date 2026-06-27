import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/gen/assets.gen.dart';

class LeaveManagementTab {
  final String id;
  final String labelKey;
  final String iconPath;

  const LeaveManagementTab({required this.id, required this.labelKey, required this.iconPath});
}

class LeaveManagementTabsConfig {
  static List<LeaveManagementTab> tabs = [
    LeaveManagementTab(id: 'leaveRequests', labelKey: 'leaveRequests', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(id: 'leaveBalance', labelKey: 'leaveBalance', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(
      id: 'myLeaveBalance',
      labelKey: 'myLeaveBalance',
      iconPath: Assets.icons.leaveManagementIcon.path,
    ),
    LeaveManagementTab(id: 'teamLeaveRisk', labelKey: 'teamLeaveRisk', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(id: 'leavePolicies', labelKey: 'leavePolicies', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(
      id: 'policyConfiguration',
      labelKey: 'policyConfiguration',
      iconPath: Assets.icons.leaveManagementIcon.path,
    ),
    LeaveManagementTab(id: 'forfeitPolicy', labelKey: 'forfeitPolicy', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(
      id: 'forfeitProcessing',
      labelKey: 'forfeitProcessing',
      iconPath: Assets.icons.leaveManagementIcon.path,
    ),
    LeaveManagementTab(
      id: 'forfeitReports',
      labelKey: 'forfeitReports',
      iconPath: Assets.icons.leaveManagementIcon.path,
    ),
    LeaveManagementTab(id: 'leaveCalendar', labelKey: 'leaveCalendar', iconPath: Assets.icons.leaveManagementIcon.path),
  ];

  static List<LeaveManagementTab> getTabs() {
    return tabs;
  }

  static String getLocalizedLabel(String labelKey, AppLocalizations localizations) {
    switch (labelKey) {
      case 'leaveRequests':
        return localizations.leaveRequests;
      case 'leaveBalance':
        return localizations.leaveBalance;
      case 'myLeaveBalance':
        return localizations.myLeaveBalance;
      case 'teamLeaveRisk':
        return localizations.teamLeaveRisk;
      case 'leavePolicies':
        return localizations.leavePolicies;
      case 'policyConfiguration':
        return localizations.policyConfiguration;
      case 'forfeitPolicy':
        return localizations.forfeitPolicy;
      case 'forfeitProcessing':
        return localizations.forfeitProcessing;
      case 'forfeitReports':
        return localizations.forfeitReports;
      case 'leaveCalendar':
        return localizations.leaveCalendar;
      default:
        return labelKey;
    }
  }
}
