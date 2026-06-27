import 'system_user.dart';

class UserDetailData {
  const UserDetailData({
    required this.userGuid,
    required this.username,
    required this.fullName,
    required this.primaryEmail,
    required this.accountStatus,
    required this.isActiveFlagY,
    required this.isLocked,
    required this.failedLoginAttempts,
    required this.roleNames,
    required this.mfaRequired,
    required this.forcePasswordChange,
    required this.accountLockout,
    required this.failedAttemptsBeforeLockout,
    required this.sessionTimeoutMinutes,
    required this.concurrentSessions,
    this.userCode,
    this.firstName,
    this.lastName,
    this.secondaryEmail,
    this.lockedDate,
    this.workPhone,
    this.mobilePhone,
    this.phoneExtension,
    this.mailingAddress,
    this.employeeNumber,
    this.employeeId,
    this.employeeFullName,
    this.departmentName,
    this.departmentId,
    this.positionTitle,
    this.jobTitleId,
    this.reportingManagerName,
    this.reportsToEmployeeId,
    this.workLocationName,
    this.workLocationId,
    this.employeeType,
    this.hireDate,
    this.startDate,
    this.endDate,
    this.passwordExpirationDate,
    this.accountExpirationDate,
    this.assignedRoleIds = const [],
    this.preferredLanguage,
    this.timeZone,
    this.dateFormat,
    this.currencyCode,
    this.workflowAlertsFlag = false,
    this.itemsPerPage = 10,
    this.compactViewFlag = false,
    this.showTooltipsFlag = false,
    this.emailNotificationsFlag = false,
    this.smsNotificationsFlag = false,
    this.inappNotificationsFlag = false,
    this.ipRestrictionFlag = false,
    this.auditUserActionsFlag = false,
    this.dataAccessLoggingFlag = false,
    this.complianceAlertsFlag = false,
    this.permissionKeys = const [],
  });

  final String userGuid;
  final String username;
  final String fullName;
  final String primaryEmail;
  final String? userCode;
  final String? firstName;
  final String? lastName;
  final String? secondaryEmail;
  final String accountStatus;
  final bool isActiveFlagY;
  final bool isLocked;
  final DateTime? lockedDate;
  final int failedLoginAttempts;
  final String? workPhone;
  final String? mobilePhone;
  final String? phoneExtension;
  final String? mailingAddress;
  final String? employeeNumber;
  final int? employeeId;
  final String? employeeFullName;
  final String? departmentName;
  final String? departmentId;
  final String? positionTitle;
  final String? jobTitleId;
  final String? reportingManagerName;
  final int? reportsToEmployeeId;
  final String? workLocationName;
  final int? workLocationId;
  final String? employeeType;
  final DateTime? hireDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? passwordExpirationDate;
  final DateTime? accountExpirationDate;
  final List<int> assignedRoleIds;
  final List<String> roleNames;
  final bool mfaRequired;
  final bool forcePasswordChange;
  final bool accountLockout;
  final int failedAttemptsBeforeLockout;
  final int sessionTimeoutMinutes;
  final bool concurrentSessions;
  final String? preferredLanguage;
  final String? timeZone;
  final String? dateFormat;
  final String? currencyCode;
  final bool workflowAlertsFlag;
  final int itemsPerPage;
  final bool compactViewFlag;
  final bool showTooltipsFlag;
  final bool emailNotificationsFlag;
  final bool smsNotificationsFlag;
  final bool inappNotificationsFlag;
  final bool ipRestrictionFlag;
  final bool auditUserActionsFlag;
  final bool dataAccessLoggingFlag;
  final bool complianceAlertsFlag;
  final List<String> permissionKeys;

  bool hasPermission(String key) => permissionKeys.contains(key);

  String get displayUsername => username.trim().isNotEmpty ? username : '--';

  String get displayFullName => fullName.trim().isNotEmpty ? fullName : '--';

  String get displayEmail => primaryEmail.trim().isNotEmpty ? primaryEmail : '--';

  String get displaySecondaryEmail => (secondaryEmail?.trim().isNotEmpty == true) ? secondaryEmail! : '--';

  String get displayAccountStatus =>
      accountStatus.toUpperCase() == 'ACTIVE' ? 'Active' : (accountStatus.trim().isNotEmpty ? accountStatus : '--');

  String get displayMfaStatus => mfaRequired ? 'Enabled' : 'Disabled';

  String get displayPasswordStatus => forcePasswordChange ? 'Change Required' : 'Valid';

  String get displayFailedAttempts => failedLoginAttempts.toString();

  String get displaySessionTimeout => '$sessionTimeoutMinutes minutes';

  String get displayWorkPhone => (workPhone?.trim().isNotEmpty == true) ? workPhone! : '--';

  String get displayMobilePhone => (mobilePhone?.trim().isNotEmpty == true) ? mobilePhone! : '--';

  String get displayMailingAddress => (mailingAddress?.trim().isNotEmpty == true) ? mailingAddress! : '--';

  String get displayDepartment => (departmentName?.trim().isNotEmpty == true) ? departmentName! : '--';

  String get displayPosition => (positionTitle?.trim().isNotEmpty == true) ? positionTitle! : '--';

  String get displayReportingManager =>
      (reportingManagerName?.trim().isNotEmpty == true) ? reportingManagerName! : '--';

  String get displayEmployeeType => (employeeType?.trim().isNotEmpty == true) ? employeeType! : '--';

  String get displayEmployeeNumber => (employeeNumber?.trim().isNotEmpty == true) ? employeeNumber! : '--';

  String get displayWorkLocation => (workLocationName?.trim().isNotEmpty == true) ? workLocationName! : '--';

  bool get isAccountActive => accountStatus.toUpperCase() == 'ACTIVE' && !isLocked;

  SystemUserStatus get userStatus => isLocked
      ? SystemUserStatus.locked
      : (accountStatus.toUpperCase() == 'ACTIVE' ? SystemUserStatus.active : SystemUserStatus.locked);

  String get initials {
    final name = fullName.trim();
    if (name.isEmpty) return '--';
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  String get resolvedFirstName {
    if (firstName != null && firstName!.trim().isNotEmpty) return firstName!.trim();
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : '';
  }

  String get resolvedLastName {
    if (lastName != null && lastName!.trim().isNotEmpty) return lastName!.trim();
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }
}
