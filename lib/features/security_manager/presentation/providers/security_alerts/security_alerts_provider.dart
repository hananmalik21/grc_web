import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/security_manager/presentation/providers/security_alerts/security_alerts_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecurityAlertsNotifier extends StateNotifier<SecurityAlertsState> {
  SecurityAlertsNotifier() : super(const SecurityAlertsState()) {
    state = state.copyWith(alerts: _mockAlerts);
  }

  static final _mockAlerts = <SecurityAlertItem>[
    SecurityAlertItem(
      issueType: SecurityAlertIssueType.accessAnomaly,
      alertId: 'ALRT-001',
      description: 'Urgent policy or access control alert requiring immediate review.',
      level: SecurityAlertLevel.critical,
      status: SecurityAlertStatus.newAlert,
      iconPath: Assets.icons.securityManager.securityAlerts.path,
      userCount: 6,
      lastUpdated: '2026-03-05 09:15',
      isProtectedModule: true,
      isDelegated: false,
      actions: [SecurityAlertAction.view, SecurityAlertAction.resolve, SecurityAlertAction.dismiss],
    ),
    SecurityAlertItem(
      issueType: SecurityAlertIssueType.loginSuspicion,
      alertId: 'ALRT-002',
      description: 'Suspicious login activity detected across multiple access attempts.',
      level: SecurityAlertLevel.high,
      status: SecurityAlertStatus.newAlert,
      iconPath: Assets.icons.securityManager.securityAlerts.path,
      userCount: 1,
      lastUpdated: '2026-03-04 18:45',
      isProtectedModule: false,
      isDelegated: false,
      actions: [SecurityAlertAction.view, SecurityAlertAction.resolve, SecurityAlertAction.dismiss],
    ),
    SecurityAlertItem(
      issueType: SecurityAlertIssueType.policyViolation,
      alertId: 'ALRT-003',
      description: 'Policy exception observed in a restricted workflow.',
      level: SecurityAlertLevel.medium,
      status: SecurityAlertStatus.acknowledged,
      iconPath: Assets.icons.securityManager.securityAlerts.path,
      userCount: 0,
      lastUpdated: '2026-03-03 11:22',
      isProtectedModule: false,
      isDelegated: true,
      actions: [SecurityAlertAction.view, SecurityAlertAction.resolve, SecurityAlertAction.dismiss],
    ),
    SecurityAlertItem(
      issueType: SecurityAlertIssueType.dataExposure,
      alertId: 'ALRT-004',
      description: 'New alert for a potential data exposure event.',
      level: SecurityAlertLevel.newAlert,
      status: SecurityAlertStatus.newAlert,
      iconPath: Assets.icons.securityManager.securityAlerts.path,
      userCount: 2,
      lastUpdated: '2026-03-02 14:03',
      isProtectedModule: true,
      isDelegated: false,
      actions: [SecurityAlertAction.view, SecurityAlertAction.resolve, SecurityAlertAction.dismiss],
    ),
    SecurityAlertItem(
      issueType: SecurityAlertIssueType.configurationDrift,
      alertId: 'ALRT-005',
      description: 'Resolved configuration drift tracked for audit history.',
      level: SecurityAlertLevel.resolved,
      status: SecurityAlertStatus.resolved,
      iconPath: Assets.icons.securityManager.securityAlerts.path,
      userCount: 0,
      lastUpdated: '2026-03-01 10:20',
      isProtectedModule: false,
      isDelegated: false,
      actions: [SecurityAlertAction.view, SecurityAlertAction.resolve, SecurityAlertAction.dismiss],
    ),
  ];

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setLevelFilter(SecurityAlertLevel value) {
    state = state.copyWith(levelFilter: value);
  }

  void setStatusFilter(SecurityAlertStatus value) {
    state = state.copyWith(statusFilter: value);
  }

  void clearFilters() {
    state = state.copyWith(query: '', levelFilter: SecurityAlertLevel.all, statusFilter: SecurityAlertStatus.all);
  }

  List<SecurityAlertItem> get filteredAlerts {
    final query = state.query.trim().toLowerCase();
    return state.alerts.where((alert) {
      final matchesLevel = state.levelFilter == SecurityAlertLevel.all || alert.level == state.levelFilter;
      final matchesStatus = state.statusFilter == SecurityAlertStatus.all || alert.status == state.statusFilter;
      if (!matchesLevel || !matchesStatus) return false;
      if (query.isEmpty) return true;
      final haystack = [
        alert.issueType.label,
        alert.alertId,
        alert.description,
        alert.level.label,
        alert.status.label,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  int get totalAlerts => state.alerts.length;
  int get criticalAlerts => state.alerts.where((alert) => alert.level == SecurityAlertLevel.critical).length;
  int get highAlerts => state.alerts.where((alert) => alert.level == SecurityAlertLevel.high).length;
  int get mediumAlerts => state.alerts.where((alert) => alert.level == SecurityAlertLevel.medium).length;
  int get newAlerts => state.alerts.where((alert) => alert.level == SecurityAlertLevel.newAlert).length;
  int get resolvedAlerts => state.alerts.where((alert) => alert.level == SecurityAlertLevel.resolved).length;
}

final securityAlertsProvider = StateNotifierProvider<SecurityAlertsNotifier, SecurityAlertsState>(
  (ref) => SecurityAlertsNotifier(),
);
