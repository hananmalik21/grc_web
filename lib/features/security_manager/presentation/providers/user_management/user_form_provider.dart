import 'package:grc/features/employee_management/domain/repositories/empl_lookup_repository.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/security_manager/data/models/user_management/user_policy.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/presentation/providers/security_lookups/security_lookups_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:grc/core/services/toast_service.dart';
import '../../../data/models/user_management/functional_privileges.dart';
import '../../../data/models/user_management/user_role.dart';
import '../../../domain/models/employee_details.dart';
import '../../../domain/models/system_user.dart';
import '../../../domain/models/user_detail_data.dart';
import '../../../domain/repositories/security_lookups_repository.dart';
import '../../../domain/repositories/user_management_repository.dart';
import '../../../domain/usecases/get_employee_details_use_case.dart';
import 'user_management_enterprise_provider.dart';
import 'user_management_provider.dart';

enum CreateUserStep {
  accountInformation,
  rolesAndResponsibilities,
  accessAndPermissions,
  userPreferences,
  securitySettings;

  String get label {
    return switch (this) {
      CreateUserStep.accountInformation => 'Account Information',
      CreateUserStep.rolesAndResponsibilities => 'Roles & Responsibilities',
      CreateUserStep.accessAndPermissions => 'Access & Permissions',
      CreateUserStep.userPreferences => 'User Preferences',
      CreateUserStep.securitySettings => 'Security Settings',
    };
  }
}

const List<CreateUserStep> createUserVisibleSteps = <CreateUserStep>[
  CreateUserStep.accountInformation,
  CreateUserStep.rolesAndResponsibilities,
  CreateUserStep.userPreferences,
  CreateUserStep.securitySettings,
];

class UserFormState {
  final int? selectedEmployeeId;
  final String? selectedEmployeeName;
  // Account Information
  final String? userCode;
  final String? userName;
  final SystemUserStatus accountStatus;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? confirmPassword;
  final DateTime? passwordExpiration;
  final bool? neverExpire;
  final DateTime? accountExpiration;

  // Contact Information
  final String? email;
  final String? secondaryEmail;
  final String? workPhone;
  final String? mobilePhone;
  final String? extension;
  final String? officeLocation;
  final String? mailingAddress;

  // Employment Information
  final String? department;
  final String? departmentId;
  final String? jobTitle;
  final String? jobTitleId;
  final String? employeeType;
  final String? reportToManager;
  final int? reportsToEmployeeId;
  final String? workLocation;
  final int? workLocationId;
  final DateTime? hireDate;
  final DateTime? startDate;
  final DateTime? endDate;

  // Roles & Responsibilities
  final List<int> assignedRoles;
  final List<UserRole> availableRoles;

  // Access & Permissions
  final List<UserPolicy> availablePolicies;
  final List<FunctionalPrivileges> availableFunctionalPrivileges;
  final List<FunctionalPrivileges> filteredFunctionalPrivileges;
  final List<int> selectedFunctionalPrivileges;

  // User Preferences
  final String? language;
  final String? timeZone;
  final String? dateFormat;
  final String? currency;
  final bool? receiveEmailNotifications;
  final bool? receiveSmsNotifications;
  final bool? receivePushNotifications;
  final bool? allowWorkflowAlerts;
  final String? itemsPerPage;
  final bool? compactView;
  final bool? showTooltips;

  // Security Settings
  final bool? enable2FA;
  final bool? forcePasswordChange;
  final bool? accountLockout;
  final int? failedLoginAttempts;
  final int? sessionTimeOut;
  final bool? allowConcurrentSession;
  final bool? ipAddressRestriction;
  final bool? auditUserActions;
  final bool? dataAccessLogging;
  final bool? complianceAlert;

  // Edit mode
  final String? userGuid;
  final bool isEditMode;
  final bool hasEditInitialized;

  // Step Management
  final CreateUserStep step;
  final int maxStepIndex;
  final bool isFetchingEmployeeDetails;
  final bool hasEmployeeDetailsLoaded;
  final bool isSubmitting;

  bool get hasPrefilledWorkPhone => (workPhone ?? '').trim().isNotEmpty;

  bool get hasPrefilledMobilePhone => (mobilePhone ?? '').trim().isNotEmpty;

  UserFormState({
    this.selectedEmployeeId,
    this.selectedEmployeeName,
    this.userCode,
    this.userName,
    this.accountStatus = SystemUserStatus.active,
    this.firstName,
    this.lastName,
    this.password,
    this.confirmPassword,
    this.passwordExpiration,
    this.neverExpire,
    this.accountExpiration,
    this.email,
    this.secondaryEmail,
    this.workPhone,
    this.mobilePhone,
    this.extension,
    this.officeLocation,
    this.mailingAddress,
    this.department,
    this.departmentId,
    this.jobTitle,
    this.jobTitleId,
    this.employeeType,
    this.reportToManager,
    this.reportsToEmployeeId,
    this.workLocation,
    this.workLocationId,
    this.hireDate,
    this.startDate,
    this.endDate,
    this.assignedRoles = const [],
    this.availableRoles = const [],
    this.availablePolicies = const [],
    this.availableFunctionalPrivileges = const [],
    this.filteredFunctionalPrivileges = const [],
    this.selectedFunctionalPrivileges = const [],
    this.language,
    this.timeZone,
    this.dateFormat,
    this.currency,
    this.receiveEmailNotifications,
    this.receiveSmsNotifications,
    this.receivePushNotifications,
    this.allowWorkflowAlerts,
    this.itemsPerPage,
    this.compactView,
    this.showTooltips,
    this.enable2FA,
    this.forcePasswordChange,
    this.accountLockout,
    this.failedLoginAttempts,
    this.sessionTimeOut,
    this.allowConcurrentSession,
    this.ipAddressRestriction,
    this.auditUserActions,
    this.dataAccessLogging,
    this.complianceAlert,
    this.userGuid,
    this.isEditMode = false,
    this.hasEditInitialized = false,
    this.step = CreateUserStep.accountInformation,
    this.maxStepIndex = 0,
    this.isFetchingEmployeeDetails = false,
    this.hasEmployeeDetailsLoaded = false,
    this.isSubmitting = false,
  });

  UserFormState copyWith({
    int? selectedEmployeeId,
    String? selectedEmployeeName,
    String? userCode,
    String? userName,
    SystemUserStatus? accountStatus,
    String? firstName,
    String? lastName,
    String? password,
    String? confirmPassword,
    DateTime? passwordExpiration,
    bool? neverExpire,
    DateTime? accountExpiration,
    String? email,
    String? secondaryEmail,
    String? workPhone,
    String? mobilePhone,
    String? extension,
    String? officeLocation,
    String? mailingAddress,
    String? department,
    String? departmentId,
    String? jobTitle,
    String? jobTitleId,
    String? employeeType,
    String? reportToManager,
    int? reportsToEmployeeId,
    String? workLocation,
    int? workLocationId,
    DateTime? hireDate,
    DateTime? startDate,
    DateTime? endDate,
    List<int>? assignedRoles,
    List<UserRole>? availableRoles,
    List<UserPolicy>? availablePolicies,
    List<FunctionalPrivileges>? availableFunctionalPrivileges,
    List<FunctionalPrivileges>? filteredFunctionalPrivileges,
    List<int>? selectedFunctionalPrivileges,
    String? language,
    String? timeZone,
    String? dateFormat,
    String? currency,
    bool? receiveEmailNotifications,
    bool? receiveSmsNotifications,
    bool? receivePushNotifications,
    bool? allowWorkflowAlerts,
    String? itemsPerPage,
    bool? compactView,
    bool? showTooltips,
    bool? enable2FA,
    bool? forcePasswordChange,
    bool? accountLockout,
    int? failedLoginAttempts,
    int? sessionTimeOut,
    bool? allowConcurrentSession,
    bool? ipAddressRestriction,
    bool? auditUserActions,
    bool? dataAccessLogging,
    bool? complianceAlert,
    String? userGuid,
    bool? isEditMode,
    bool? hasEditInitialized,
    CreateUserStep? step,
    int? maxStepIndex,
    bool? isFetchingEmployeeDetails,
    bool? hasEmployeeDetailsLoaded,
    bool? isSubmitting,
  }) {
    return UserFormState(
      selectedEmployeeId: selectedEmployeeId ?? this.selectedEmployeeId,
      selectedEmployeeName: selectedEmployeeName ?? this.selectedEmployeeName,
      userCode: userCode ?? this.userCode,
      userName: userName ?? this.userName,
      accountStatus: accountStatus ?? this.accountStatus,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordExpiration: passwordExpiration ?? this.passwordExpiration,
      neverExpire: neverExpire ?? this.neverExpire,
      accountExpiration: accountExpiration ?? this.accountExpiration,
      email: email ?? this.email,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      workPhone: workPhone ?? this.workPhone,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      extension: extension ?? this.extension,
      officeLocation: officeLocation ?? this.officeLocation,
      mailingAddress: mailingAddress ?? this.mailingAddress,
      department: department ?? this.department,
      departmentId: departmentId ?? this.departmentId,
      jobTitle: jobTitle ?? this.jobTitle,
      jobTitleId: jobTitleId ?? this.jobTitleId,
      employeeType: employeeType ?? this.employeeType,
      reportToManager: reportToManager ?? this.reportToManager,
      reportsToEmployeeId: reportsToEmployeeId ?? this.reportsToEmployeeId,
      workLocation: workLocation ?? this.workLocation,
      workLocationId: workLocationId ?? this.workLocationId,
      hireDate: hireDate ?? this.hireDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      assignedRoles: assignedRoles ?? this.assignedRoles,
      availableRoles: availableRoles ?? this.availableRoles,
      availablePolicies: availablePolicies ?? this.availablePolicies,
      availableFunctionalPrivileges: availableFunctionalPrivileges ?? this.availableFunctionalPrivileges,
      filteredFunctionalPrivileges: filteredFunctionalPrivileges ?? this.filteredFunctionalPrivileges,
      selectedFunctionalPrivileges: selectedFunctionalPrivileges ?? this.selectedFunctionalPrivileges,
      language: language ?? this.language,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      currency: currency ?? this.currency,
      receiveEmailNotifications: receiveEmailNotifications ?? this.receiveEmailNotifications,
      receiveSmsNotifications: receiveSmsNotifications ?? this.receiveSmsNotifications,
      receivePushNotifications: receivePushNotifications ?? this.receivePushNotifications,
      allowWorkflowAlerts: allowWorkflowAlerts ?? this.allowWorkflowAlerts,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      compactView: compactView ?? this.compactView,
      showTooltips: showTooltips ?? this.showTooltips,
      enable2FA: enable2FA ?? this.enable2FA,
      forcePasswordChange: forcePasswordChange ?? this.forcePasswordChange,
      accountLockout: accountLockout ?? this.accountLockout,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      sessionTimeOut: sessionTimeOut ?? this.sessionTimeOut,
      allowConcurrentSession: allowConcurrentSession ?? this.allowConcurrentSession,
      ipAddressRestriction: ipAddressRestriction ?? this.ipAddressRestriction,
      auditUserActions: auditUserActions ?? this.auditUserActions,
      dataAccessLogging: dataAccessLogging ?? this.dataAccessLogging,
      complianceAlert: complianceAlert ?? this.complianceAlert,
      userGuid: userGuid ?? this.userGuid,
      isEditMode: isEditMode ?? this.isEditMode,
      hasEditInitialized: hasEditInitialized ?? this.hasEditInitialized,
      step: step ?? this.step,
      maxStepIndex: maxStepIndex ?? this.maxStepIndex,
      isFetchingEmployeeDetails: isFetchingEmployeeDetails ?? this.isFetchingEmployeeDetails,
      hasEmployeeDetailsLoaded: hasEmployeeDetailsLoaded ?? this.hasEmployeeDetailsLoaded,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class UserFormProvider extends StateNotifier<UserFormState> {
  final GetEmployeeDetailsUseCase _getEmployeeDetailsUseCase;
  final EmplLookupRepository _emplLookupRepository;
  final SecurityLookupsRepository _securityLookupsRepository;
  final UserManagementRepository _userManagementRepository;

  UserFormProvider(
    this._getEmployeeDetailsUseCase,
    this._emplLookupRepository,
    this._securityLookupsRepository,
    this._userManagementRepository,
  ) : super(UserFormState()) {
    loadAvailablePolicies();
    loadFunctionalPrivileges();
  }

  void loadAvailableRoles() {
    state = state.copyWith(
      availableRoles: [
        UserRole(
          id: 1,
          title: "HR Administrator",
          description: "Full access to HR Module",
          type: "Application Role",
          userCount: 4,
        ),
        UserRole(
          id: 2,
          title: "Payroll Administrator",
          description: "Manage payroll operations",
          type: "Application Role",
          userCount: 2,
        ),
        UserRole(
          id: 3,
          title: "Department Manager",
          description: "Manage department employees",
          type: "Job Role",
          userCount: 8,
        ),
        UserRole(id: 4, title: "Employee", description: "Basic employee access", type: "Abstract Role", userCount: 150),
        UserRole(
          id: 5,
          title: "Recruiter",
          description: "Manage recruitment process",
          type: "Function Role",
          userCount: 2,
        ),
        UserRole(
          id: 6,
          title: "Time Administrator",
          description: "Manage time and attendance process",
          type: "Function Role",
          userCount: 4,
        ),
      ],
    );
  }

  void loadAvailablePolicies() {
    state = state.copyWith(
      availablePolicies: [
        UserPolicy(id: 1, title: "Kuwait Operations Data", description: "All Kuwait entities", type: "Business Unit"),
        UserPolicy(id: 2, title: "HR Department Data", description: "HR Department only", type: "Department"),
        UserPolicy(id: 3, title: "Confidential Employee Data", description: "Restricted access", type: "Data Security"),
        UserPolicy(
          id: 4,
          title: "Payroll Sensitive Data",
          description: "Payroll administrators only",
          type: "Data Security",
        ),
      ],
    );
  }

  void loadFunctionalPrivileges() {
    final privileges = [
      FunctionalPrivileges(
        id: 1,
        name: "View All Employees",
        description: "Access to view all employee records",
        type: "Employee Management",
      ),
      FunctionalPrivileges(id: 2, name: "Manage Payroll", description: "Process and approve payroll", type: "Payroll"),
      FunctionalPrivileges(
        id: 3,
        name: "Approve Leave Requests",
        description: "Approve/Reject employee leave ",
        type: "Leave Management",
      ),
      FunctionalPrivileges(id: 4, name: "Access Reports", description: "View and generate reports", type: "Reporting"),
      FunctionalPrivileges(
        id: 5,
        name: "Manage Recruitment",
        description: "Post jobs and manage candidates",
        type: "Recruitment",
      ),
      FunctionalPrivileges(
        id: 6,
        name: "System Administration",
        description: "Configure system settings",
        type: "Administration",
      ),
      FunctionalPrivileges(
        id: 7,
        name: "Edit Employee Records",
        description: "Modify employee information",
        type: "Employee Management",
      ),
      FunctionalPrivileges(
        id: 8,
        name: "View Salary Information",
        description: "Access salary and compensation data",
        type: "Payroll",
      ),
      FunctionalPrivileges(
        id: 9,
        name: "Manage Performance Reviews",
        description: "Create and manage performance evaluations",
        type: "Performance",
      ),
      FunctionalPrivileges(
        id: 10,
        name: "Approve Expense Claims",
        description: "Review and approve expenses",
        type: "Finance",
      ),
      FunctionalPrivileges(
        id: 11,
        name: "Manage Training Programs",
        description: "Create and assign training courses",
        type: "Learning & Development",
      ),
      FunctionalPrivileges(
        id: 12,
        name: "Access Audit Logs",
        description: "View system activity logs",
        type: "Security",
      ),
      FunctionalPrivileges(
        id: 13,
        name: "Configure Workflows",
        description: "Design and modify approval workflows",
        type: "Administration",
      ),
      FunctionalPrivileges(
        id: 14,
        name: "Manage Benefits",
        description: "Administer employee benefits",
        type: "Benefits",
      ),
      FunctionalPrivileges(
        id: 15,
        name: "Time & Attendance Admin",
        description: "Manage attendance and schedules",
        type: "Time Management",
      ),
      FunctionalPrivileges(
        id: 16,
        name: "Create Announcements",
        description: "Post company-wide announcements",
        type: "Communication",
      ),
      FunctionalPrivileges(
        id: 17,
        name: "Manage Positions",
        description: "Create and modify job positions",
        type: "Organization Structure",
      ),
      FunctionalPrivileges(
        id: 18,
        name: "Approve Overtime",
        description: "Review and approve overtime requests",
        type: "Time Management",
      ),
    ];
    state = state.copyWith(availableFunctionalPrivileges: privileges, filteredFunctionalPrivileges: privileges);
  }

  void setUserCode(String userCode) {
    state = state.copyWith(userCode: userCode);
  }

  void setUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  Employee? selectedEmployeeForSearch({required int? enterpriseId}) {
    if (enterpriseId == null || state.selectedEmployeeId == null) return null;
    final name = (state.selectedEmployeeName ?? '').trim();
    final parts = name.isEmpty ? <String>[] : name.split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Employee(
      id: state.selectedEmployeeId!,
      guid: '',
      enterpriseId: enterpriseId,
      firstName: firstName,
      lastName: lastName,
      email: state.email ?? '',
      status: 'active',
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  Future<void> _applyWorkLocationFromLookup({required EmployeeDetails details, int? enterpriseId}) async {
    if (enterpriseId == null || enterpriseId <= 0) return;
    final lookupId = details.workLocationId;
    if (lookupId == null) return;
    try {
      final values = await _emplLookupRepository.getLookupValues(enterpriseId, 'WORK_LOCATION');
      for (final v in values) {
        if (v.lookupId == lookupId) {
          final label = v.meaningEn.trim().isNotEmpty ? v.meaningEn : v.lookupCode;
          state = state.copyWith(workLocation: label);
          return;
        }
      }
    } catch (_) {}
  }

  void _applyEmployeeDetails(EmployeeDetails employee) {
    final nameParts = employee.name.trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : firstName;

    state = state.copyWith(
      selectedEmployeeId: employee.id,
      accountStatus: employee.status,
      firstName: firstName,
      lastName: lastName,
      email: employee.email,
      workPhone: employee.workPhone,
      mobilePhone: employee.mobilePhone,
      department: employee.department,
      departmentId: employee.departmentId,
      jobTitle: employee.designation,
      jobTitleId: employee.jobTitleId,
      employeeType: employee.employeeType,
      reportToManager: employee.reportToManager,
      reportsToEmployeeId: employee.reportsToEmployeeId,
      workLocation: employee.workLocation,
      workLocationId: employee.workLocationId,
      hireDate: employee.hireDate,
      startDate: employee.startDate,
      endDate: employee.endDate,
    );
  }

  void initFromUserDetail(UserDetailData detail) {
    final accountStatus = detail.isLocked
        ? SystemUserStatus.locked
        : (detail.accountStatus.toUpperCase() == 'ACTIVE' ? SystemUserStatus.active : SystemUserStatus.locked);

    String? languageLabel;
    final lang = detail.preferredLanguage?.toUpperCase();
    if (lang == 'EN') {
      languageLabel = 'English';
    } else if (lang == 'AR') {
      languageLabel = 'Arabic';
    } else if (lang == 'EN_AR') {
      languageLabel = 'Both (English/Arabic)';
    } else {
      languageLabel = detail.preferredLanguage;
    }

    state = state.copyWith(
      userGuid: detail.userGuid,
      isEditMode: true,
      hasEditInitialized: true,
      hasEmployeeDetailsLoaded: detail.employeeId != null,
      userCode: detail.userCode,
      userName: detail.username,
      accountStatus: accountStatus,
      firstName: detail.resolvedFirstName,
      lastName: detail.resolvedLastName,
      email: detail.primaryEmail,
      secondaryEmail: detail.secondaryEmail,
      workPhone: detail.workPhone,
      mobilePhone: detail.mobilePhone,
      extension: detail.phoneExtension,
      mailingAddress: detail.mailingAddress,
      selectedEmployeeId: detail.employeeId,
      selectedEmployeeName: detail.employeeFullName,
      department: detail.departmentName,
      departmentId: detail.departmentId,
      jobTitle: detail.positionTitle,
      jobTitleId: detail.jobTitleId,
      employeeType: detail.employeeType,
      reportsToEmployeeId: detail.reportsToEmployeeId,
      workLocation: detail.workLocationName,
      workLocationId: detail.workLocationId,
      hireDate: detail.hireDate,
      startDate: detail.startDate,
      endDate: detail.endDate,
      passwordExpiration: detail.passwordExpirationDate,
      accountExpiration: detail.accountExpirationDate,
      assignedRoles: detail.assignedRoleIds,
      language: languageLabel,
      timeZone: detail.timeZone,
      currency: detail.currencyCode,
      allowWorkflowAlerts: detail.workflowAlertsFlag,
      itemsPerPage: detail.itemsPerPage.toString(),
      compactView: detail.compactViewFlag,
      showTooltips: detail.showTooltipsFlag,
      receiveEmailNotifications: detail.emailNotificationsFlag,
      receiveSmsNotifications: detail.smsNotificationsFlag,
      receivePushNotifications: detail.inappNotificationsFlag,
      enable2FA: detail.mfaRequired,
      forcePasswordChange: detail.forcePasswordChange,
      accountLockout: detail.accountLockout,
      failedLoginAttempts: detail.failedAttemptsBeforeLockout,
      sessionTimeOut: detail.sessionTimeoutMinutes,
      allowConcurrentSession: detail.concurrentSessions,
      ipAddressRestriction: detail.ipRestrictionFlag,
      auditUserActions: detail.auditUserActionsFlag,
      dataAccessLogging: detail.dataAccessLoggingFlag,
      complianceAlert: detail.complianceAlertsFlag,
    );
  }

  Future<void> fetchAndApplySelectedEmployee({
    required int employeeId,
    required String employeeGuid,
    required String employeeName,
    int? enterpriseId,
  }) async {
    state = state.copyWith(
      selectedEmployeeId: employeeId,
      selectedEmployeeName: employeeName,
      userName: '',
      hasEmployeeDetailsLoaded: false,
      isFetchingEmployeeDetails: true,
    );
    try {
      final details = await _getEmployeeDetailsUseCase(employeeGuid: employeeGuid, enterpriseId: enterpriseId);
      _applyEmployeeDetails(details);
      await _applyWorkLocationFromLookup(details: details, enterpriseId: enterpriseId);
      state = state.copyWith(hasEmployeeDetailsLoaded: true);
    } finally {
      state = state.copyWith(isFetchingEmployeeDetails: false);
    }
  }

  void setAccountStatus(SystemUserStatus accountStatus) {
    state = state.copyWith(accountStatus: accountStatus);
  }

  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void setPasswordExpiration(DateTime passwordExpiration) {
    state = state.copyWith(passwordExpiration: passwordExpiration);
  }

  void setNeverExpire(bool neverExpire) {
    state = state.copyWith(neverExpire: neverExpire);
  }

  void setAccountExpiration(DateTime accountExpiration) {
    state = state.copyWith(accountExpiration: accountExpiration);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setSecondaryEmail(String secondaryEmail) {
    state = state.copyWith(secondaryEmail: secondaryEmail);
  }

  void setWorkPhone(String workPhone) {
    state = state.copyWith(workPhone: workPhone);
  }

  void setMobilePhone(String mobilePhone) {
    state = state.copyWith(mobilePhone: mobilePhone);
  }

  void setExtension(String extension) {
    state = state.copyWith(extension: extension);
  }

  void setMailingAddress(String mailingAddress) {
    state = state.copyWith(mailingAddress: mailingAddress);
  }

  void setDepartment(String department) {
    state = state.copyWith(department: department);
  }

  void setJobTitle(String jobTitle) {
    state = state.copyWith(jobTitle: jobTitle);
  }

  void setEmployeeType(String employeeType) {
    state = state.copyWith(employeeType: employeeType);
  }

  void setReportToManager(String reportToManager) {
    state = state.copyWith(reportToManager: reportToManager);
  }

  void setWorkLocation(String workLocation) {
    state = state.copyWith(workLocation: workLocation);
  }

  void setWorkLocationFromLookup(String label, int id) {
    state = state.copyWith(workLocation: label, workLocationId: id);
  }

  void setHireDate(DateTime hireDate) {
    state = state.copyWith(hireDate: hireDate);
  }

  void setStartDate(DateTime startDate) {
    state = state.copyWith(startDate: startDate);
  }

  void setEndDate(DateTime endDate) {
    state = state.copyWith(endDate: endDate);
  }

  void setRole(int id) {
    List<int> roles = List<int>.from(state.assignedRoles);
    if (roles.contains(id)) {
      roles.remove(id);
    } else {
      roles.add(id);
    }
    state = state.copyWith(assignedRoles: roles);
  }

  void setAvailableRoles(List<UserRole> availableRoles) {
    state = state.copyWith(availableRoles: availableRoles);
  }

  void setFunctionalPrivilege(int id) {
    List<int> functionalPrivileges = List<int>.from(state.selectedFunctionalPrivileges);
    if (functionalPrivileges.contains(id)) {
      functionalPrivileges.remove(id);
    } else {
      functionalPrivileges.add(id);
    }
    state = state.copyWith(selectedFunctionalPrivileges: functionalPrivileges);
  }

  void searchFunctionalPrivileges(String query) {
    final filteredPrivileges = state.availableFunctionalPrivileges.where((privilege) {
      return privilege.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredFunctionalPrivileges: filteredPrivileges);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void setTimeZone(String timeZone) {
    state = state.copyWith(timeZone: timeZone);
  }

  void setDateFormat(String dateFormat) {
    state = state.copyWith(dateFormat: dateFormat);
  }

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void setReceiveEmailNotifications(bool receiveEmailNotifications) {
    state = state.copyWith(receiveEmailNotifications: receiveEmailNotifications);
  }

  void setReceiveSmsNotifications(bool receiveSmsNotifications) {
    state = state.copyWith(receiveSmsNotifications: receiveSmsNotifications);
  }

  void setReceivePushNotifications(bool receivePushNotifications) {
    state = state.copyWith(receivePushNotifications: receivePushNotifications);
  }

  void setAllowWorkflowAlerts(bool allowWorkflowAlerts) {
    state = state.copyWith(allowWorkflowAlerts: allowWorkflowAlerts);
  }

  void setItemsPerPage(String itemsPerPage) {
    state = state.copyWith(itemsPerPage: itemsPerPage);
  }

  void setCompactView(bool compactView) {
    state = state.copyWith(compactView: compactView);
  }

  void setShowTooltips(bool showTooltips) {
    state = state.copyWith(showTooltips: showTooltips);
  }

  void setEnable2FA(bool enable2FA) {
    state = state.copyWith(enable2FA: enable2FA);
  }

  void setForcePasswordChange(bool forcePasswordChange) {
    state = state.copyWith(forcePasswordChange: forcePasswordChange);
  }

  void setAccountLockout(bool accountLockout) {
    state = state.copyWith(accountLockout: accountLockout);
  }

  void setFailedLoginAttempts(int failedLoginAttempts) {
    state = state.copyWith(failedLoginAttempts: failedLoginAttempts);
  }

  void setSessionTimeOut(int sessionTimeOut) {
    state = state.copyWith(sessionTimeOut: sessionTimeOut);
  }

  void setAllowConcurrentSession(bool allowConcurrentSession) {
    state = state.copyWith(allowConcurrentSession: allowConcurrentSession);
  }

  void setIpAddressRestriction(bool ipAddressRestriction) {
    state = state.copyWith(ipAddressRestriction: ipAddressRestriction);
  }

  void setAuditUserActions(bool auditUserActions) {
    state = state.copyWith(auditUserActions: auditUserActions);
  }

  void setDataAccessLogging(bool dataAccessLogging) {
    state = state.copyWith(dataAccessLogging: dataAccessLogging);
  }

  void setComplianceAlert(bool complianceAlert) {
    state = state.copyWith(complianceAlert: complianceAlert);
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String? _mapLanguageCode(String? language) {
    final raw = language?.trim();
    if (raw == null || raw.isEmpty) return null;
    final lowered = raw.toLowerCase();
    if (lowered == 'english') return 'EN';
    if (lowered == 'arabic') return 'AR';
    if (lowered == 'both (english/arabic)') return 'EN_AR';
    return raw.toUpperCase();
  }

  String? _extractCurrencyCodeFromLabel(String? currency) {
    final raw = currency?.trim();
    if (raw == null || raw.isEmpty) return null;
    if (!raw.contains(' - ')) return raw.toUpperCase();
    return raw.split(' - ').first.trim().toUpperCase();
  }

  Future<String?> _resolveCurrencyCode({required int enterpriseId}) async {
    final raw = state.currency?.trim();
    if (raw == null || raw.isEmpty) return null;
    final fallbackCode = _extractCurrencyCodeFromLabel(raw);
    try {
      final types = await _securityLookupsRepository.getLookupTypes(enterpriseId: enterpriseId);
      final currencyType = types.firstWhere((t) => t.typeCode.toUpperCase() == 'CURRENCY_CODE');
      final values = await _securityLookupsRepository.getLookupValues(
        enterpriseId: enterpriseId,
        lookupTypeId: currencyType.lookupTypeId,
      );
      for (final value in values) {
        if (value.valueCode.toUpperCase() == raw.toUpperCase()) {
          return value.valueCode;
        }
        if (value.valueName.toLowerCase() == raw.toLowerCase()) {
          return value.valueCode;
        }
        final composed = '${value.valueCode} - ${value.valueName}'.toLowerCase();
        if (composed == raw.toLowerCase()) {
          return value.valueCode;
        }
      }
      return fallbackCode;
    } catch (_) {
      return fallbackCode;
    }
  }

  Future<void> createUser({required int enterpriseId, required BuildContext context, VoidCallback? onSuccess}) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final todayStr = _formatDate(DateTime.now())!;
      final languageCode = _mapLanguageCode(state.language);
      final currencyCode = await _resolveCurrencyCode(enterpriseId: enterpriseId);
      final accountStatus = state.accountStatus == SystemUserStatus.active ? 'ACTIVE' : 'INACTIVE';
      final hasLinkedEmployee = state.selectedEmployeeId != null;
      final body = <String, dynamic>{
        'enterprise_id': enterpriseId,
        'user_code': state.userCode,
        'username': state.userName,
        'first_name': state.firstName,
        'last_name': state.lastName,
        'primary_email': state.email,
        'secondary_email': state.secondaryEmail,
        'account_status': accountStatus,
        'password': state.password,
        'employee_id': hasLinkedEmployee ? state.selectedEmployeeId : null,
        'department_id': hasLinkedEmployee ? state.departmentId : null,
        'job_title_id': hasLinkedEmployee ? state.jobTitleId : null,
        'password_expiration_date': (state.neverExpire ?? false) ? null : _formatDate(state.passwordExpiration),
        'account_expiration_date': _formatDate(state.accountExpiration),
        'reports_to_employee_id': hasLinkedEmployee ? state.reportsToEmployeeId : null,
        'work_location_id': hasLinkedEmployee ? state.workLocationId : null,
        'employee_type': hasLinkedEmployee ? state.employeeType : null,
        'hire_date': hasLinkedEmployee ? _formatDate(state.hireDate) : null,
        'start_date': hasLinkedEmployee ? _formatDate(state.startDate) : null,
        'end_date': hasLinkedEmployee ? _formatDate(state.endDate) : null,
        'failed_login_attempts': 0,
        'locked_flag': state.accountStatus == SystemUserStatus.locked ? 'Y' : 'N',
        'work_phone': state.workPhone,
        'mobile_phone': state.mobilePhone,
        'phone_extension': state.extension,
        'mailing_address': state.mailingAddress,
        'created_by': 'SYSTEM',
        'role_assignments': state.assignedRoles
            .asMap()
            .entries
            .map(
              (e) => <String, dynamic>{
                'role_id': e.value,
                'assigned_date': todayStr,
                'effective_start_date': todayStr,
                'effective_end_date': null,
                'assigned_flag': 'Y',
                'primary_role_flag': e.key == 0 ? 'Y' : 'N',
              },
            )
            .toList(),
        'preferences': <String, dynamic>{
          'preferred_language': languageCode,
          'time_zone': state.timeZone,
          'date_format': 'DD-MON-YYYY',
          'currency_code': currencyCode,
          'workflow_alerts_flag': (state.allowWorkflowAlerts ?? false) ? 'Y' : 'N',
          'items_per_page': int.tryParse(state.itemsPerPage?.split(' ').first ?? '') ?? 10,
          'compact_view_flag': (state.compactView ?? false) ? 'Y' : 'N',
          'show_tooltips_flag': (state.showTooltips ?? false) ? 'Y' : 'N',
          'email_notifications_flag': (state.receiveEmailNotifications ?? false) ? 'Y' : 'N',
          'sms_notifications_flag': (state.receiveSmsNotifications ?? false) ? 'Y' : 'N',
          'inapp_notifications_flag': (state.receivePushNotifications ?? false) ? 'Y' : 'N',
        },
        'security_settings': <String, dynamic>{
          'mfa_required_flag': (state.enable2FA ?? false) ? 'Y' : 'N',
          'force_password_change_flag': (state.forcePasswordChange ?? false) ? 'Y' : 'N',
          'account_lockout_flag': (state.accountLockout ?? false) ? 'Y' : 'N',
          'failed_attempts_before_lockout': state.failedLoginAttempts ?? 5,
          'session_timeout_minutes': state.sessionTimeOut ?? 30,
          'concurrent_sessions_flag': (state.allowConcurrentSession ?? false) ? 'Y' : 'N',
          'ip_restriction_flag': (state.ipAddressRestriction ?? false) ? 'Y' : 'N',
          'audit_user_actions_flag': (state.auditUserActions ?? false) ? 'Y' : 'N',
          'data_access_logging_flag': (state.dataAccessLogging ?? false) ? 'Y' : 'N',
          'compliance_alerts_flag': (state.complianceAlert ?? false) ? 'Y' : 'N',
        },
      };
      await _userManagementRepository.createUser(body: body);
      if (context.mounted) {
        ToastService.success(context, 'User created successfully');
        if (onSuccess != null) {
          onSuccess();
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString());
      }
    } finally {
      if (mounted) {
        state = state.copyWith(isSubmitting: false);
      }
    }
  }

  Future<void> updateUser({required int enterpriseId, required BuildContext context, VoidCallback? onSuccess}) async {
    final guid = state.userGuid;
    if (guid == null || guid.isEmpty) return;
    state = state.copyWith(isSubmitting: true);
    try {
      final todayStr = _formatDate(DateTime.now())!;
      final languageCode = _mapLanguageCode(state.language);
      final currencyCode = await _resolveCurrencyCode(enterpriseId: enterpriseId);
      final accountStatus = state.accountStatus == SystemUserStatus.active ? 'ACTIVE' : 'INACTIVE';
      final hasLinkedEmployee = state.selectedEmployeeId != null;
      final body = <String, dynamic>{
        'user_guid': guid,
        'enterprise_id': enterpriseId,
        'user_code': state.userCode,
        'username': state.userName,
        'first_name': state.firstName,
        'last_name': state.lastName,
        'primary_email': state.email,
        'secondary_email': state.secondaryEmail,
        'account_status': accountStatus,
        if (state.password != null && state.password!.isNotEmpty) 'password': state.password,
        'employee_id': hasLinkedEmployee ? state.selectedEmployeeId : null,
        'department_id': hasLinkedEmployee ? state.departmentId : null,
        'job_title_id': hasLinkedEmployee ? state.jobTitleId : null,
        'password_expiration_date': (state.neverExpire ?? false) ? null : _formatDate(state.passwordExpiration),
        'account_expiration_date': _formatDate(state.accountExpiration),
        'reports_to_employee_id': hasLinkedEmployee ? state.reportsToEmployeeId : null,
        'work_location_id': hasLinkedEmployee ? state.workLocationId : null,
        'employee_type': hasLinkedEmployee ? state.employeeType : null,
        'hire_date': hasLinkedEmployee ? _formatDate(state.hireDate) : null,
        'start_date': hasLinkedEmployee ? _formatDate(state.startDate) : null,
        'end_date': hasLinkedEmployee ? _formatDate(state.endDate) : null,
        'failed_login_attempts': state.accountStatus == SystemUserStatus.locked ? 0 : null,
        'locked_flag': state.accountStatus == SystemUserStatus.locked ? 'Y' : 'N',
        'work_phone': state.workPhone,
        'mobile_phone': state.mobilePhone,
        'phone_extension': state.extension,
        'mailing_address': state.mailingAddress,
        'last_updated_by': 'SYSTEM',
        'role_assignments': state.assignedRoles
            .asMap()
            .entries
            .map(
              (e) => <String, dynamic>{
                'role_id': e.value,
                'assigned_date': todayStr,
                'effective_start_date': todayStr,
                'effective_end_date': null,
                'assigned_flag': 'Y',
                'primary_role_flag': e.key == 0 ? 'Y' : 'N',
              },
            )
            .toList(),
        'preferences': <String, dynamic>{
          'preferred_language': languageCode,
          'time_zone': state.timeZone,
          'date_format': 'DD-MON-YYYY',
          'currency_code': currencyCode,
          'workflow_alerts_flag': (state.allowWorkflowAlerts ?? false) ? 'Y' : 'N',
          'items_per_page': int.tryParse(state.itemsPerPage?.split(' ').first ?? '') ?? 10,
          'compact_view_flag': (state.compactView ?? false) ? 'Y' : 'N',
          'show_tooltips_flag': (state.showTooltips ?? false) ? 'Y' : 'N',
          'email_notifications_flag': (state.receiveEmailNotifications ?? false) ? 'Y' : 'N',
          'sms_notifications_flag': (state.receiveSmsNotifications ?? false) ? 'Y' : 'N',
          'inapp_notifications_flag': (state.receivePushNotifications ?? false) ? 'Y' : 'N',
        },
        'security_settings': <String, dynamic>{
          'mfa_required_flag': (state.enable2FA ?? false) ? 'Y' : 'N',
          'force_password_change_flag': (state.forcePasswordChange ?? false) ? 'Y' : 'N',
          'account_lockout_flag': (state.accountLockout ?? false) ? 'Y' : 'N',
          'failed_attempts_before_lockout': state.failedLoginAttempts ?? 5,
          'session_timeout_minutes': state.sessionTimeOut ?? 30,
          'concurrent_sessions_flag': (state.allowConcurrentSession ?? false) ? 'Y' : 'N',
          'ip_restriction_flag': (state.ipAddressRestriction ?? false) ? 'Y' : 'N',
          'audit_user_actions_flag': (state.auditUserActions ?? false) ? 'Y' : 'N',
          'data_access_logging_flag': (state.dataAccessLogging ?? false) ? 'Y' : 'N',
          'compliance_alerts_flag': (state.complianceAlert ?? false) ? 'Y' : 'N',
        },
      };
      await _userManagementRepository.updateUser(body: body);
      if (context.mounted) {
        ToastService.success(context, 'User updated successfully');
        if (onSuccess != null) {
          onSuccess();
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString());
      }
    } finally {
      if (mounted) {
        state = state.copyWith(isSubmitting: false);
      }
    }
  }

  void setStep(CreateUserStep step) {
    final index = createUserVisibleSteps.indexOf(step);
    if (index < 0) return;
    state = state.copyWith(step: step, maxStepIndex: index > state.maxStepIndex ? index : state.maxStepIndex);
  }

  void nextStep() {
    final currentIndex = createUserVisibleSteps.indexOf(state.step);
    if (currentIndex < 0) {
      setStep(createUserVisibleSteps.first);
      return;
    }
    if (currentIndex < createUserVisibleSteps.length - 1) {
      setStep(createUserVisibleSteps[currentIndex + 1]);
    }
  }

  void previousStep() {
    final currentIndex = createUserVisibleSteps.indexOf(state.step);
    if (currentIndex > 0) {
      setStep(createUserVisibleSteps[currentIndex - 1]);
    }
  }

  int get stepIndex {
    final index = createUserVisibleSteps.indexOf(state.step);
    return index < 0 ? 0 : index;
  }

  int get stepCount => createUserVisibleSteps.length;

  bool validateCurrentStep(BuildContext context) {
    switch (state.step) {
      case CreateUserStep.accountInformation:
        return _validateAccountInformation(context);
      case CreateUserStep.rolesAndResponsibilities:
        return _validateRolesAndResponsibilities(context);
      case CreateUserStep.accessAndPermissions:
        return _validateAccessAndPermissions(context);
      case CreateUserStep.userPreferences:
        return _validateUserPreferences(context);
      case CreateUserStep.securitySettings:
        return _validateSecuritySettings(context);
    }
  }

  bool _validateAccountInformation(BuildContext context) {
    final hasLinkedEmployee = state.selectedEmployeeId != null;
    if (state.userCode == null || state.userCode!.isEmpty) {
      ToastService.error(context, 'User code is required');
      return false;
    }
    if (state.userName == null || state.userName!.isEmpty) {
      ToastService.error(context, 'Username is required');
      return false;
    }
    if (state.firstName == null || state.firstName!.isEmpty) {
      ToastService.error(context, 'First Name is required');
      return false;
    }
    if (state.lastName == null || state.lastName!.isEmpty) {
      ToastService.error(context, 'Last Name is required');
      return false;
    }
    if (!state.isEditMode) {
      if (state.password == null || state.password!.isEmpty) {
        ToastService.error(context, 'Password is required');
        return false;
      }
      if (state.confirmPassword == null || state.confirmPassword!.isEmpty) {
        ToastService.error(context, 'Please confirm your password');
        return false;
      }
    }
    if ((state.password != null && state.password!.isNotEmpty) ||
        (state.confirmPassword != null && state.confirmPassword!.isNotEmpty)) {
      if (state.password != state.confirmPassword) {
        ToastService.error(context, 'Passwords do not match');
        return false;
      }
    }
    if (state.email == null || state.email!.trim().isEmpty) {
      ToastService.error(context, 'Email is required');
      return false;
    }
    if (state.extension == null || state.extension!.trim().isEmpty) {
      ToastService.error(context, 'Extension is required');
      return false;
    }
    if (hasLinkedEmployee) {
      if (state.department == null || state.department!.trim().isEmpty) {
        ToastService.error(context, 'Department is required');
        return false;
      }
      if (state.jobTitle == null || state.jobTitle!.trim().isEmpty) {
        ToastService.error(context, 'Job title is required');
        return false;
      }
      if (state.employeeType == null || state.employeeType!.trim().isEmpty) {
        ToastService.error(context, 'Employee type is required');
        return false;
      }
      if (state.workLocation == null || state.workLocation!.trim().isEmpty) {
        ToastService.error(context, 'Work location is required');
        return false;
      }
      if (state.hireDate == null) {
        ToastService.error(context, 'Hire date is required');
        return false;
      }
      if (state.startDate == null) {
        ToastService.error(context, 'Start date is required');
        return false;
      }
      if (state.endDate == null) {
        ToastService.error(context, 'End date is required');
        return false;
      }
    }
    return true;
  }

  bool _validateRolesAndResponsibilities(BuildContext context) => true;

  bool _validateAccessAndPermissions(BuildContext context) {
    // Implement if needed
    return true;
  }

  bool _validateUserPreferences(BuildContext context) {
    // Implement if needed
    return true;
  }

  bool _validateSecuritySettings(BuildContext context) {
    // Implement if needed
    return true;
  }
}

final userFormProvider = StateNotifierProvider.autoDispose<UserFormProvider, UserFormState>(
  (ref) => UserFormProvider(
    ref.watch(getEmployeeDetailsUseCaseProvider),
    ref.watch(emplLookupRepositoryProvider),
    ref.watch(securityLookupsRepositoryProvider),
    ref.watch(userManagementRepositoryProvider),
  ),
);

final userFormCurrencyValuesAsyncProvider = Provider.autoDispose<AsyncValue<List<SecurityLookupValue>>>((ref) {
  final enterpriseId = ref.watch(userManagementEnterpriseIdProvider);
  if (enterpriseId == null) {
    return const AsyncValue<List<SecurityLookupValue>>.data(<SecurityLookupValue>[]);
  }
  return ref.watch(currencyCodeLookupValuesProvider(enterpriseId));
});

final userFormCurrencyItemsProvider = Provider.autoDispose<List<SecurityLookupValue>>((ref) {
  return ref.watch(userFormCurrencyValuesAsyncProvider).valueOrNull ?? const <SecurityLookupValue>[];
});

final userFormSelectedCurrencyItemProvider = Provider.autoDispose<SecurityLookupValue?>((ref) {
  final currentCurrency = (ref.watch(userFormProvider).currency ?? '').trim();
  if (currentCurrency.isEmpty) return null;
  final items = ref.watch(userFormCurrencyItemsProvider);
  for (final value in items) {
    final composed = '${value.valueCode} - ${value.valueName}';
    if (value.valueCode.toUpperCase() == currentCurrency.toUpperCase() ||
        value.valueName.toLowerCase() == currentCurrency.toLowerCase() ||
        composed.toLowerCase() == currentCurrency.toLowerCase()) {
      return value;
    }
  }
  return null;
});
