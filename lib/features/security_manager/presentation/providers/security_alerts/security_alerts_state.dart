import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

enum SecurityAlertLevel { all, critical, high, medium, newAlert, resolved }

extension SecurityAlertLevelX on SecurityAlertLevel {
  String get label => switch (this) {
    SecurityAlertLevel.all => 'All Levels',
    SecurityAlertLevel.critical => 'Critical',
    SecurityAlertLevel.high => 'High',
    SecurityAlertLevel.medium => 'Medium',
    SecurityAlertLevel.newAlert => 'New Alerts',
    SecurityAlertLevel.resolved => 'Resolved',
  };

  Color capsuleBackgroundColor({required bool isDark}) => switch (this) {
    SecurityAlertLevel.all => isDark ? AppColors.grayBgDark : AppColors.grayBg,
    SecurityAlertLevel.critical => isDark ? AppColors.alertCriticalBg : AppColors.alertCriticalBg,
    SecurityAlertLevel.high => isDark ? AppColors.alertHighBg : AppColors.alertHighBg,
    SecurityAlertLevel.medium => isDark ? AppColors.alertMediumBg : AppColors.alertMediumBg,
    SecurityAlertLevel.newAlert => isDark ? AppColors.alertNewBg : AppColors.alertNewBg,
    SecurityAlertLevel.resolved => isDark ? AppColors.alertResolvedBg : AppColors.alertResolvedBg,
  };

  Color capsuleBorderColor({required bool isDark}) => switch (this) {
    SecurityAlertLevel.all => isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
    SecurityAlertLevel.critical => AppColors.alertCriticalBorder,
    SecurityAlertLevel.high => AppColors.alertHighBorder,
    SecurityAlertLevel.medium => AppColors.alertMediumBorder,
    SecurityAlertLevel.newAlert => AppColors.alertNewBorder,
    SecurityAlertLevel.resolved => AppColors.alertResolvedBorder,
  };

  Color capsuleTextColor({required bool isDark}) => switch (this) {
    SecurityAlertLevel.all => isDark ? AppColors.grayTextDark : AppColors.grayText,
    SecurityAlertLevel.critical => AppColors.alertCriticalText,
    SecurityAlertLevel.high => AppColors.alertHighText,
    SecurityAlertLevel.medium => AppColors.alertMediumText,
    SecurityAlertLevel.newAlert => AppColors.alertNewText,
    SecurityAlertLevel.resolved => AppColors.alertResolvedText,
  };
}

enum SecurityAlertStatus { all, newAlert, resolved, acknowledged }

extension SecurityAlertStatusX on SecurityAlertStatus {
  String get label => switch (this) {
    SecurityAlertStatus.all => 'All Status',
    SecurityAlertStatus.newAlert => 'New Alerts',
    SecurityAlertStatus.resolved => 'Resolved',
    SecurityAlertStatus.acknowledged => 'Acknowledged',
  };
}

enum SecurityAlertAction { view, acknowledge, dismiss, resolve }

extension SecurityAlertActionX on SecurityAlertAction {
  String get label => switch (this) {
    SecurityAlertAction.view => 'Investigate',
    SecurityAlertAction.acknowledge => 'Resolve',
    SecurityAlertAction.dismiss => 'Dismiss',
    SecurityAlertAction.resolve => 'Resolve',
  };

  String get iconPath => switch (this) {
    SecurityAlertAction.view => Assets.icons.blueEyeIcon.path,
    SecurityAlertAction.acknowledge => Assets.icons.checkIconGreen.path,
    SecurityAlertAction.dismiss => Assets.icons.leaveManagement.rejected.path,
    SecurityAlertAction.resolve => Assets.icons.checkIconGreen.path,
  };
}

enum SecurityAlertIssueType { accessAnomaly, loginSuspicion, policyViolation, dataExposure, configurationDrift }

extension SecurityAlertIssueTypeX on SecurityAlertIssueType {
  String get label => switch (this) {
    SecurityAlertIssueType.accessAnomaly => 'Access Anomaly',
    SecurityAlertIssueType.loginSuspicion => 'Login Suspicion',
    SecurityAlertIssueType.policyViolation => 'Policy Violation',
    SecurityAlertIssueType.dataExposure => 'Data Exposure',
    SecurityAlertIssueType.configurationDrift => 'Configuration Drift',
  };
}

class SecurityAlertItem {
  final SecurityAlertIssueType issueType;
  final String alertId;
  final String description;
  final SecurityAlertLevel level;
  final SecurityAlertStatus status;
  final String iconPath;
  final int userCount;
  final String lastUpdated;
  final bool isProtectedModule;
  final bool isDelegated;
  final List<SecurityAlertAction> actions;

  const SecurityAlertItem({
    required this.issueType,
    required this.alertId,
    required this.description,
    required this.level,
    required this.status,
    required this.iconPath,
    required this.userCount,
    required this.lastUpdated,
    required this.isProtectedModule,
    required this.isDelegated,
    required this.actions,
  });
}

class SecurityAlertsState {
  final String query;
  final SecurityAlertLevel levelFilter;
  final SecurityAlertStatus statusFilter;
  final List<SecurityAlertItem> alerts;

  const SecurityAlertsState({
    this.query = '',
    this.levelFilter = SecurityAlertLevel.all,
    this.statusFilter = SecurityAlertStatus.all,
    this.alerts = const [],
  });

  SecurityAlertsState copyWith({
    String? query,
    SecurityAlertLevel? levelFilter,
    SecurityAlertStatus? statusFilter,
    List<SecurityAlertItem>? alerts,
  }) {
    return SecurityAlertsState(
      query: query ?? this.query,
      levelFilter: levelFilter ?? this.levelFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      alerts: alerts ?? this.alerts,
    );
  }
}
