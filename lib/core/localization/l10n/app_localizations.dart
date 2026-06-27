import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Digify ERP'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get usernameHint;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @enterCredentialsToAccess.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access your account.'**
  String get enterCredentialsToAccess;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'OR SIGN IN WITH'**
  String get orSignInWith;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'REMEMBER ME'**
  String get rememberMe;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'FORGOT PASSWORD?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'To reset your password, please contact your system administrator.'**
  String get forgotPasswordDialogMessage;

  /// No description provided for @signInBtn.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signInBtn;

  /// No description provided for @endToEndEncrypted.
  ///
  /// In en, this message translates to:
  /// **'END-TO-END ENCRYPTED'**
  String get endToEndEncrypted;

  /// No description provided for @copyrightInfo.
  ///
  /// In en, this message translates to:
  /// **'2026 DIGIFY INTELLIGENCE SYSTEMS.\nCORE: KUWAIT.'**
  String get copyrightInfo;

  /// No description provided for @signInToAccessDashboard.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your HR dashboard'**
  String get signInToAccessDashboard;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo Credentials:'**
  String get demoCredentials;

  /// No description provided for @resetDemoUsers.
  ///
  /// In en, this message translates to:
  /// **'Reset Demo Users'**
  String get resetDemoUsers;

  /// No description provided for @copyrightText.
  ///
  /// In en, this message translates to:
  /// **'© 2024 Digify HR. Kuwait Labor Law Compliant.'**
  String get copyrightText;

  /// No description provided for @kuwaitLaborLawCompliant.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law Compliant'**
  String get kuwaitLaborLawCompliant;

  /// No description provided for @digifyHrTitle.
  ///
  /// In en, this message translates to:
  /// **'Digify HR'**
  String get digifyHrTitle;

  /// No description provided for @loginDesktopBrandName.
  ///
  /// In en, this message translates to:
  /// **'DigifyHR'**
  String get loginDesktopBrandName;

  /// No description provided for @loginDesktopWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to DigifyHR'**
  String get loginDesktopWelcomeTitle;

  /// No description provided for @loginDesktopWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'A modern HR platform for managing employees, automating admin tasks, and improving employee satisfaction. Access your workspace and start managing your team efficiently.'**
  String get loginDesktopWelcomeDescription;

  /// No description provided for @loginDesktopSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginDesktopSignInTitle;

  /// No description provided for @loginDesktopSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue to your account.'**
  String get loginDesktopSignInSubtitle;

  /// No description provided for @loginDesktopEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your work email'**
  String get loginDesktopEmailHint;

  /// No description provided for @loginDesktopPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginDesktopPasswordHint;

  /// No description provided for @loginDesktopEnterpriseCode.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Code'**
  String get loginDesktopEnterpriseCode;

  /// No description provided for @loginDesktopEnterpriseCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your enterprise code'**
  String get loginDesktopEnterpriseCodeHint;

  /// No description provided for @loginDesktopEnterpriseCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid enterprise code'**
  String get loginDesktopEnterpriseCodeInvalid;

  /// No description provided for @loginDesktopRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Keep me logged in'**
  String get loginDesktopRememberMe;

  /// No description provided for @loginDesktopForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginDesktopForgotPassword;

  /// No description provided for @loginDesktopSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginDesktopSignInButton;

  /// No description provided for @loginDesktopOrSignInWithSso.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginDesktopOrSignInWithSso;

  /// No description provided for @loginDesktopContinueWithSso.
  ///
  /// In en, this message translates to:
  /// **'Continue with SSO'**
  String get loginDesktopContinueWithSso;

  /// No description provided for @loginDesktopNewToDigifyHr.
  ///
  /// In en, this message translates to:
  /// **'New to DigifyHR? '**
  String get loginDesktopNewToDigifyHr;

  /// No description provided for @loginDesktopCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get loginDesktopCreateAccount;

  /// No description provided for @loginDesktopFooterSecureAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Access'**
  String get loginDesktopFooterSecureAccessTitle;

  /// No description provided for @loginDesktopFooterSecureAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Enterprise-grade security and data protection'**
  String get loginDesktopFooterSecureAccessDescription;

  /// No description provided for @loginDesktopFooterPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Best-Rated Permissions'**
  String get loginDesktopFooterPermissionsTitle;

  /// No description provided for @loginDesktopFooterPermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Granular access control for your team'**
  String get loginDesktopFooterPermissionsDescription;

  /// No description provided for @loginDesktopFooterAutomationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise HR Automation'**
  String get loginDesktopFooterAutomationTitle;

  /// No description provided for @loginDesktopFooterAutomationDescription.
  ///
  /// In en, this message translates to:
  /// **'Streamline workflows and reduce admin tasks'**
  String get loginDesktopFooterAutomationDescription;

  /// No description provided for @loginDesktopFooterInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Workforce Insights'**
  String get loginDesktopFooterInsightsTitle;

  /// No description provided for @loginDesktopFooterInsightsDescription.
  ///
  /// In en, this message translates to:
  /// **'Track performance and analytics instantly'**
  String get loginDesktopFooterInsightsDescription;

  /// No description provided for @systemDescription.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Human Resource Management System with advanced security and compliance features.'**
  String get systemDescription;

  /// No description provided for @completeHrSuite.
  ///
  /// In en, this message translates to:
  /// **'Complete HR Suite'**
  String get completeHrSuite;

  /// No description provided for @completeHrSuiteDescription.
  ///
  /// In en, this message translates to:
  /// **'19 integrated modules managing all aspects of human resources'**
  String get completeHrSuiteDescription;

  /// No description provided for @advancedSecurity.
  ///
  /// In en, this message translates to:
  /// **'Advanced Security'**
  String get advancedSecurity;

  /// No description provided for @advancedSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Role-based access control with 60+ security functions'**
  String get advancedSecurityDescription;

  /// No description provided for @kuwaitCompliance.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Compliance'**
  String get kuwaitCompliance;

  /// No description provided for @kuwaitComplianceDescription.
  ///
  /// In en, this message translates to:
  /// **'Fully compliant with Kuwait Labor Law No. 6/2010'**
  String get kuwaitComplianceDescription;

  /// No description provided for @realTimeAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Real-time Analytics'**
  String get realTimeAnalytics;

  /// No description provided for @realTimeAnalyticsDescription.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive reporting and analytics dashboard'**
  String get realTimeAnalyticsDescription;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get invalidCredentials;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get connectionError;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful!'**
  String get signupSuccess;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @enterpriseStructure.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Structure'**
  String get enterpriseStructure;

  /// No description provided for @generalLedger.
  ///
  /// In en, this message translates to:
  /// **'General Ledger'**
  String get generalLedger;

  /// No description provided for @chartOfAccounts.
  ///
  /// In en, this message translates to:
  /// **'Chart of Accounts'**
  String get chartOfAccounts;

  /// No description provided for @journalEntries.
  ///
  /// In en, this message translates to:
  /// **'Journal Entries'**
  String get journalEntries;

  /// No description provided for @accountBalances.
  ///
  /// In en, this message translates to:
  /// **'Account Balances'**
  String get accountBalances;

  /// No description provided for @intercompanyAccounting.
  ///
  /// In en, this message translates to:
  /// **'Intercompany Accounting'**
  String get intercompanyAccounting;

  /// No description provided for @budgetManagement.
  ///
  /// In en, this message translates to:
  /// **'Budget Management'**
  String get budgetManagement;

  /// No description provided for @financialReportSets.
  ///
  /// In en, this message translates to:
  /// **'Financial Report Sets'**
  String get financialReportSets;

  /// No description provided for @accountsPayable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Payable'**
  String get accountsPayable;

  /// No description provided for @accountsReceivable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Receivable'**
  String get accountsReceivable;

  /// No description provided for @cashManagement.
  ///
  /// In en, this message translates to:
  /// **'Cash Management'**
  String get cashManagement;

  /// No description provided for @fixedAssets.
  ///
  /// In en, this message translates to:
  /// **'Fixed Assets'**
  String get fixedAssets;

  /// No description provided for @treasury.
  ///
  /// In en, this message translates to:
  /// **'Treasury'**
  String get treasury;

  /// No description provided for @expenseManagement.
  ///
  /// In en, this message translates to:
  /// **'Expense Management'**
  String get expenseManagement;

  /// No description provided for @financialReporting.
  ///
  /// In en, this message translates to:
  /// **'Financial Reporting'**
  String get financialReporting;

  /// No description provided for @periodClose.
  ///
  /// In en, this message translates to:
  /// **'Period Close'**
  String get periodClose;

  /// No description provided for @workflowApprovals.
  ///
  /// In en, this message translates to:
  /// **'Workflow Approvals'**
  String get workflowApprovals;

  /// No description provided for @securityConsole.
  ///
  /// In en, this message translates to:
  /// **'Security Console'**
  String get securityConsole;

  /// No description provided for @securityDashboard.
  ///
  /// In en, this message translates to:
  /// **'Security Dashboard'**
  String get securityDashboard;

  /// No description provided for @userAccounts.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get userAccounts;

  /// No description provided for @userAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage user accounts and permissions'**
  String get userAccountsSubtitle;

  /// No description provided for @userRoleAssignment.
  ///
  /// In en, this message translates to:
  /// **'User Role Assignment'**
  String get userRoleAssignment;

  /// No description provided for @roleManagement.
  ///
  /// In en, this message translates to:
  /// **'Role Management'**
  String get roleManagement;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @roleHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Role Hierarchy'**
  String get roleHierarchy;

  /// No description provided for @roleTemplates.
  ///
  /// In en, this message translates to:
  /// **'Role Templates'**
  String get roleTemplates;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @securityPolicies.
  ///
  /// In en, this message translates to:
  /// **'Security Policies'**
  String get securityPolicies;

  /// No description provided for @dataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Data Access Sets'**
  String get dataAccessSets;

  /// No description provided for @securityProfiles.
  ///
  /// In en, this message translates to:
  /// **'Security Profiles'**
  String get securityProfiles;

  /// No description provided for @functionPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Function Privileges'**
  String get functionPrivileges;

  /// No description provided for @auditCompliance.
  ///
  /// In en, this message translates to:
  /// **'Audit & Compliance'**
  String get auditCompliance;

  /// No description provided for @auditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get auditLogs;

  /// No description provided for @loginHistory.
  ///
  /// In en, this message translates to:
  /// **'Login History'**
  String get loginHistory;

  /// No description provided for @accessReports.
  ///
  /// In en, this message translates to:
  /// **'Access Reports'**
  String get accessReports;

  /// No description provided for @complianceReports.
  ///
  /// In en, this message translates to:
  /// **'Compliance Reports'**
  String get complianceReports;

  /// No description provided for @sessionManagement.
  ///
  /// In en, this message translates to:
  /// **'Session Management'**
  String get sessionManagement;

  /// No description provided for @securityReports.
  ///
  /// In en, this message translates to:
  /// **'Security Reports'**
  String get securityReports;

  /// No description provided for @dataSecurityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data Security & Privacy'**
  String get dataSecurityPrivacy;

  /// No description provided for @securityReportsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Security Reports & Analytics'**
  String get securityReportsAnalytics;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @securityConsoleOverview.
  ///
  /// In en, this message translates to:
  /// **'Security Console Overview'**
  String get securityConsoleOverview;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @inactiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Inactive Users'**
  String get inactiveUsers;

  /// No description provided for @lockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Locked Users'**
  String get lockedUsers;

  /// No description provided for @pendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get pendingApprovals;

  /// No description provided for @totalRoles.
  ///
  /// In en, this message translates to:
  /// **'Total Roles'**
  String get totalRoles;

  /// No description provided for @activeRoles.
  ///
  /// In en, this message translates to:
  /// **'Active Roles'**
  String get activeRoles;

  /// No description provided for @customRoles.
  ///
  /// In en, this message translates to:
  /// **'Custom Roles'**
  String get customRoles;

  /// No description provided for @standardRoles.
  ///
  /// In en, this message translates to:
  /// **'Standard Roles'**
  String get standardRoles;

  /// No description provided for @totalPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Total Privileges'**
  String get totalPrivileges;

  /// No description provided for @mfaProtected.
  ///
  /// In en, this message translates to:
  /// **'MFA Protected'**
  String get mfaProtected;

  /// No description provided for @userAccessStatus.
  ///
  /// In en, this message translates to:
  /// **'User Access Status'**
  String get userAccessStatus;

  /// No description provided for @withRoles.
  ///
  /// In en, this message translates to:
  /// **'With Roles'**
  String get withRoles;

  /// No description provided for @mfaEnabled.
  ///
  /// In en, this message translates to:
  /// **'MFA Enabled'**
  String get mfaEnabled;

  /// No description provided for @userDistributionByDepartment.
  ///
  /// In en, this message translates to:
  /// **'User Distribution by Department'**
  String get userDistributionByDepartment;

  /// No description provided for @roleTypeDistribution.
  ///
  /// In en, this message translates to:
  /// **'Role Type Distribution'**
  String get roleTypeDistribution;

  /// No description provided for @applicationRoles.
  ///
  /// In en, this message translates to:
  /// **'Application Roles'**
  String get applicationRoles;

  /// No description provided for @functionRoles.
  ///
  /// In en, this message translates to:
  /// **'Function Roles'**
  String get functionRoles;

  /// No description provided for @dataRoles.
  ///
  /// In en, this message translates to:
  /// **'Data Roles'**
  String get dataRoles;

  /// No description provided for @jobRoles.
  ///
  /// In en, this message translates to:
  /// **'Job Roles'**
  String get jobRoles;

  /// No description provided for @dutyRoles.
  ///
  /// In en, this message translates to:
  /// **'Duty Roles'**
  String get dutyRoles;

  /// No description provided for @applicationRolesDesc.
  ///
  /// In en, this message translates to:
  /// **'Top-level permissions'**
  String get applicationRolesDesc;

  /// No description provided for @functionRolesDesc.
  ///
  /// In en, this message translates to:
  /// **'Feature access control'**
  String get functionRolesDesc;

  /// No description provided for @functionRolesDirectoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Function Roles Directory'**
  String get functionRolesDirectoryTitle;

  /// Subtitle showing how many roles are listed in the directory.
  ///
  /// In en, this message translates to:
  /// **'({count} roles)'**
  String rolesDirectoryRoleCount(int count);

  /// No description provided for @functionRolesDirectoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No function roles found for the current search and filter.'**
  String get functionRolesDirectoryEmpty;

  /// Section title above the list of functions assigned to a function role.
  ///
  /// In en, this message translates to:
  /// **'Included functions ({count})'**
  String functionRoleIncludedFunctionsHeading(int count);

  /// No description provided for @functionRoleDetailNoFunctions.
  ///
  /// In en, this message translates to:
  /// **'No functions are linked to this role.'**
  String get functionRoleDetailNoFunctions;

  /// No description provided for @functionRoleFormCreateSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Functional Role'**
  String get functionRoleFormCreateSheetTitle;

  /// No description provided for @functionRoleFormEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Functional Role'**
  String get functionRoleFormEditSheetTitle;

  /// No description provided for @stepperBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get stepperBack;

  /// No description provided for @stepperContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get stepperContinue;

  /// No description provided for @dataRolesDesc.
  ///
  /// In en, this message translates to:
  /// **'Data access control'**
  String get dataRolesDesc;

  /// No description provided for @jobRolesDesc.
  ///
  /// In en, this message translates to:
  /// **'Position-based access'**
  String get jobRolesDesc;

  /// No description provided for @dutyRolesDesc.
  ///
  /// In en, this message translates to:
  /// **'Task-specific permissions'**
  String get dutyRolesDesc;

  /// No description provided for @dutyRolesDirectoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Duty Roles Directory'**
  String get dutyRolesDirectoryTitle;

  /// No description provided for @dutyRolesDirectoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No duty roles found for the current search and filter.'**
  String get dutyRolesDirectoryEmpty;

  /// No description provided for @createDutyRole.
  ///
  /// In en, this message translates to:
  /// **'Create Duty Role'**
  String get createDutyRole;

  /// No description provided for @usersUnit.
  ///
  /// In en, this message translates to:
  /// **'users'**
  String get usersUnit;

  /// No description provided for @rolesUnit.
  ///
  /// In en, this message translates to:
  /// **'roles'**
  String get rolesUnit;

  /// No description provided for @executive.
  ///
  /// In en, this message translates to:
  /// **'Executive'**
  String get executive;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @roleUsage.
  ///
  /// In en, this message translates to:
  /// **'Role Usage'**
  String get roleUsage;

  /// No description provided for @modules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modules;

  /// No description provided for @recentSecurityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Recent Security Alerts'**
  String get recentSecurityAlerts;

  /// No description provided for @failedLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'Failed Login Attempts'**
  String get failedLoginAttempts;

  /// No description provided for @unauthorizedAccess.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized Access Attempt'**
  String get unauthorizedAccess;

  /// No description provided for @passwordExpiringUsers.
  ///
  /// In en, this message translates to:
  /// **'Password Expiring for Multiple Users'**
  String get passwordExpiringUsers;

  /// No description provided for @unusualActivity.
  ///
  /// In en, this message translates to:
  /// **'Unusual Activity Detected'**
  String get unusualActivity;

  /// No description provided for @investigateAll.
  ///
  /// In en, this message translates to:
  /// **'Investigate All'**
  String get investigateAll;

  /// No description provided for @recentUserActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent User Activity'**
  String get recentUserActivity;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// No description provided for @mfaEnabledActivity.
  ///
  /// In en, this message translates to:
  /// **'MFA enabled'**
  String get mfaEnabledActivity;

  /// No description provided for @accessGranted.
  ///
  /// In en, this message translates to:
  /// **'Access granted'**
  String get accessGranted;

  /// No description provided for @topAssignedRoles.
  ///
  /// In en, this message translates to:
  /// **'Top Assigned Roles'**
  String get topAssignedRoles;

  /// No description provided for @employeeSelfService.
  ///
  /// In en, this message translates to:
  /// **'Employee Self Service'**
  String get employeeSelfService;

  /// No description provided for @employeeSelfServiceProfileIdentity.
  ///
  /// In en, this message translates to:
  /// **'Profile & Identity'**
  String get employeeSelfServiceProfileIdentity;

  /// No description provided for @employeeSelfServiceEmploymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Employment Info'**
  String get employeeSelfServiceEmploymentInfo;

  /// No description provided for @employeeSelfServicePayBenefits.
  ///
  /// In en, this message translates to:
  /// **'Pay & Benefits'**
  String get employeeSelfServicePayBenefits;

  /// No description provided for @employeeSelfServiceMyPayslips.
  ///
  /// In en, this message translates to:
  /// **'My Payslips'**
  String get employeeSelfServiceMyPayslips;

  /// No description provided for @employeeSelfServiceLeaveAbsence.
  ///
  /// In en, this message translates to:
  /// **'Leave & Absence'**
  String get employeeSelfServiceLeaveAbsence;

  /// No description provided for @employeeSelfServiceTimeAttendance.
  ///
  /// In en, this message translates to:
  /// **'Time & Attendance'**
  String get employeeSelfServiceTimeAttendance;

  /// No description provided for @employeeSelfServicePerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get employeeSelfServicePerformance;

  /// No description provided for @employeeSelfServiceLearningDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Learning & Development'**
  String get employeeSelfServiceLearningDevelopment;

  /// No description provided for @employeeSelfServiceDocumentsLetters.
  ///
  /// In en, this message translates to:
  /// **'Documents & Letters'**
  String get employeeSelfServiceDocumentsLetters;

  /// No description provided for @employeeSelfServiceRequestsWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Requests & Workflow'**
  String get employeeSelfServiceRequestsWorkflow;

  /// No description provided for @employeeSelfServiceMobileExperience.
  ///
  /// In en, this message translates to:
  /// **'Mobile Experience'**
  String get employeeSelfServiceMobileExperience;

  /// No description provided for @applicationRole.
  ///
  /// In en, this message translates to:
  /// **'Application Role'**
  String get applicationRole;

  /// No description provided for @payrollProcessor.
  ///
  /// In en, this message translates to:
  /// **'Payroll Processor'**
  String get payrollProcessor;

  /// No description provided for @departmentManager.
  ///
  /// In en, this message translates to:
  /// **'Department Manager'**
  String get departmentManager;

  /// No description provided for @configureAccess.
  ///
  /// In en, this message translates to:
  /// **'Configure access'**
  String get configureAccess;

  /// No description provided for @activeLogins.
  ///
  /// In en, this message translates to:
  /// **'Active logins'**
  String get activeLogins;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User account created'**
  String get userCreated;

  /// No description provided for @roleModified.
  ///
  /// In en, this message translates to:
  /// **'Role permissions modified'**
  String get roleModified;

  /// No description provided for @policyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Security policy updated'**
  String get policyUpdated;

  /// No description provided for @privilegesRevoked.
  ///
  /// In en, this message translates to:
  /// **'Privileges revoked'**
  String get privilegesRevoked;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @assignRole.
  ///
  /// In en, this message translates to:
  /// **'Assign Role'**
  String get assignRole;

  /// No description provided for @reviewAccess.
  ///
  /// In en, this message translates to:
  /// **'Review Access'**
  String get reviewAccess;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @systemComplianceStatus.
  ///
  /// In en, this message translates to:
  /// **'System Compliance Status'**
  String get systemComplianceStatus;

  /// No description provided for @userAuthentication.
  ///
  /// In en, this message translates to:
  /// **'User Authentication'**
  String get userAuthentication;

  /// No description provided for @dataEncryption.
  ///
  /// In en, this message translates to:
  /// **'Data Encryption'**
  String get dataEncryption;

  /// No description provided for @accessControl.
  ///
  /// In en, this message translates to:
  /// **'Access Control'**
  String get accessControl;

  /// No description provided for @auditLogging.
  ///
  /// In en, this message translates to:
  /// **'Audit Logging'**
  String get auditLogging;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get activeSessions;

  /// No description provided for @pendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get pendingReviews;

  /// No description provided for @criticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical Alerts'**
  String get criticalAlerts;

  /// No description provided for @searchAccounts.
  ///
  /// In en, this message translates to:
  /// **'Search accounts...'**
  String get searchAccounts;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters'**
  String get moreFilters;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @standardUser.
  ///
  /// In en, this message translates to:
  /// **'Standard User'**
  String get standardUser;

  /// No description provided for @financeUser.
  ///
  /// In en, this message translates to:
  /// **'Finance User'**
  String get financeUser;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @active2FA.
  ///
  /// In en, this message translates to:
  /// **'Active (2FA)'**
  String get active2FA;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @showingResults.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} of {total} accounts'**
  String showingResults(int count, int total);

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @userID.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userID;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @leaveType.
  ///
  /// In en, this message translates to:
  /// **'Leave Type'**
  String get leaveType;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get riskLevel;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @lockedUserAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get lockedUserAccountStatus;

  /// No description provided for @neverExpires.
  ///
  /// In en, this message translates to:
  /// **'Never expires'**
  String get neverExpires;

  /// No description provided for @infiniteDisplay.
  ///
  /// In en, this message translates to:
  /// **'Infinite'**
  String get infiniteDisplay;

  /// No description provided for @mfaStatus.
  ///
  /// In en, this message translates to:
  /// **'MFA Status'**
  String get mfaStatus;

  /// No description provided for @securityInformation.
  ///
  /// In en, this message translates to:
  /// **'Security Information'**
  String get securityInformation;

  /// No description provided for @assignedRoles.
  ///
  /// In en, this message translates to:
  /// **'Assigned Roles'**
  String get assignedRoles;

  /// No description provided for @lastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get lastLogin;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get accountCreated;

  /// No description provided for @passwordLastChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Last Changed'**
  String get passwordLastChanged;

  /// No description provided for @failedAttempts.
  ///
  /// In en, this message translates to:
  /// **'Failed Attempts'**
  String get failedAttempts;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History (Last 7 days)'**
  String get sessionHistory;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @manageRoles.
  ///
  /// In en, this message translates to:
  /// **'Manage Roles'**
  String get manageRoles;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @refreshUser.
  ///
  /// In en, this message translates to:
  /// **'Refresh User'**
  String get refreshUser;

  /// No description provided for @manageUserRoles.
  ///
  /// In en, this message translates to:
  /// **'Manage User Roles'**
  String get manageUserRoles;

  /// No description provided for @loggedInUser.
  ///
  /// In en, this message translates to:
  /// **'Logged In User'**
  String get loggedInUser;

  /// No description provided for @rolesLoadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{count} roles loaded successfully'**
  String rolesLoadedSuccessfully(int count);

  /// No description provided for @currentlyAssignedRoles.
  ///
  /// In en, this message translates to:
  /// **'Currently Assigned Roles'**
  String get currentlyAssignedRoles;

  /// No description provided for @availableRolesToAssign.
  ///
  /// In en, this message translates to:
  /// **'Available Roles to Assign'**
  String get availableRolesToAssign;

  /// No description provided for @searchRoles.
  ///
  /// In en, this message translates to:
  /// **'Search roles...'**
  String get searchRoles;

  /// No description provided for @assignSelected.
  ///
  /// In en, this message translates to:
  /// **'Assign Selected'**
  String get assignSelected;

  /// No description provided for @removeSelected.
  ///
  /// In en, this message translates to:
  /// **'Remove Selected'**
  String get removeSelected;

  /// No description provided for @noRolesAssigned.
  ///
  /// In en, this message translates to:
  /// **'No roles assigned'**
  String get noRolesAssigned;

  /// No description provided for @noRolesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No available roles'**
  String get noRolesAvailable;

  /// No description provided for @rolesAssignedLabel.
  ///
  /// In en, this message translates to:
  /// **'Roles Assigned'**
  String get rolesAssignedLabel;

  /// No description provided for @rolesAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Roles Available'**
  String get rolesAvailableLabel;

  /// No description provided for @roleAssignmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Role Assignment History'**
  String get roleAssignmentHistory;

  /// No description provided for @assignedBy.
  ///
  /// In en, this message translates to:
  /// **'Assigned By'**
  String get assignedBy;

  /// No description provided for @assignedOn.
  ///
  /// In en, this message translates to:
  /// **'Assigned On'**
  String get assignedOn;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveUpdates.
  ///
  /// In en, this message translates to:
  /// **'Save Updates'**
  String get saveUpdates;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @userRoleAssignmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assign and manage security roles for users'**
  String get userRoleAssignmentSubtitle;

  /// No description provided for @usersWithRoles.
  ///
  /// In en, this message translates to:
  /// **'Users with Roles'**
  String get usersWithRoles;

  /// No description provided for @avgRolesPerUser.
  ///
  /// In en, this message translates to:
  /// **'Avg Roles/User'**
  String get avgRolesPerUser;

  /// No description provided for @availableRoles.
  ///
  /// In en, this message translates to:
  /// **'Available Roles'**
  String get availableRoles;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No description provided for @totalAssignments.
  ///
  /// In en, this message translates to:
  /// **'Total Assignments'**
  String get totalAssignments;

  /// No description provided for @rolesInUse.
  ///
  /// In en, this message translates to:
  /// **'Roles in Use'**
  String get rolesInUse;

  /// No description provided for @usersWithMultipleRoles.
  ///
  /// In en, this message translates to:
  /// **'Users with Multiple Roles'**
  String get usersWithMultipleRoles;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @currentRoles.
  ///
  /// In en, this message translates to:
  /// **'Current Roles'**
  String get currentRoles;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @roleManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage roles, permissions, and access levels'**
  String get roleManagementSubtitle;

  /// No description provided for @dutyRolesOnly.
  ///
  /// In en, this message translates to:
  /// **'Duty Roles'**
  String get dutyRolesOnly;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @allTypesFilter.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypesFilter;

  /// No description provided for @allStatusFilter.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatusFilter;

  /// No description provided for @searchRolesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search roles by name or code...'**
  String get searchRolesPlaceholder;

  /// No description provided for @roleType.
  ///
  /// In en, this message translates to:
  /// **'Role Type'**
  String get roleType;

  /// No description provided for @usersAssigned.
  ///
  /// In en, this message translates to:
  /// **'Users Assigned ({count})'**
  String usersAssigned(int count);

  /// No description provided for @privileges.
  ///
  /// In en, this message translates to:
  /// **'Privileges'**
  String get privileges;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created On'**
  String get createdOn;

  /// No description provided for @createRole.
  ///
  /// In en, this message translates to:
  /// **'Create Role'**
  String get createRole;

  /// No description provided for @createNewRole.
  ///
  /// In en, this message translates to:
  /// **'Create New Role'**
  String get createNewRole;

  /// No description provided for @editRole.
  ///
  /// In en, this message translates to:
  /// **'Edit Role'**
  String get editRole;

  /// No description provided for @roleInformation.
  ///
  /// In en, this message translates to:
  /// **'Role Information'**
  String get roleInformation;

  /// No description provided for @roleName.
  ///
  /// In en, this message translates to:
  /// **'Role Name'**
  String get roleName;

  /// No description provided for @enterRoleName.
  ///
  /// In en, this message translates to:
  /// **'Enter role name'**
  String get enterRoleName;

  /// No description provided for @roleCode.
  ///
  /// In en, this message translates to:
  /// **'Role Code'**
  String get roleCode;

  /// No description provided for @enterRoleCode.
  ///
  /// In en, this message translates to:
  /// **'Enter role code (e.g., FIN_MGR_001)'**
  String get enterRoleCode;

  /// No description provided for @roleDescription.
  ///
  /// In en, this message translates to:
  /// **'Role Description'**
  String get roleDescription;

  /// No description provided for @enterRoleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter role description'**
  String get enterRoleDescription;

  /// No description provided for @roleConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Role Configuration'**
  String get roleConfiguration;

  /// No description provided for @selectRoleType.
  ///
  /// In en, this message translates to:
  /// **'Select Role Type'**
  String get selectRoleType;

  /// No description provided for @jobRole.
  ///
  /// In en, this message translates to:
  /// **'Job Role'**
  String get jobRole;

  /// No description provided for @dutyRole.
  ///
  /// In en, this message translates to:
  /// **'Duty Role'**
  String get dutyRole;

  /// No description provided for @effectiveDates.
  ///
  /// In en, this message translates to:
  /// **'Effective Dates'**
  String get effectiveDates;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @setActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Set Active Status'**
  String get setActiveStatus;

  /// No description provided for @setStatus.
  ///
  /// In en, this message translates to:
  /// **'Set Status'**
  String get setStatus;

  /// No description provided for @privilegesAndAccess.
  ///
  /// In en, this message translates to:
  /// **'Privileges & Access'**
  String get privilegesAndAccess;

  /// No description provided for @functionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Function Security'**
  String get functionSecurity;

  /// No description provided for @function.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get function;

  /// No description provided for @accessLevel.
  ///
  /// In en, this message translates to:
  /// **'Access Level'**
  String get accessLevel;

  /// No description provided for @addPrivilege.
  ///
  /// In en, this message translates to:
  /// **'Add Privilege'**
  String get addPrivilege;

  /// No description provided for @dataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Data Access Set'**
  String get dataAccessSet;

  /// No description provided for @assignDataSets.
  ///
  /// In en, this message translates to:
  /// **'Assign Data Sets'**
  String get assignDataSets;

  /// No description provided for @roleCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Role created successfully'**
  String get roleCreatedSuccessfully;

  /// No description provided for @roleUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Role updated successfully'**
  String get roleUpdatedSuccessfully;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @roleHierarchySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage role hierarchy structure'**
  String get roleHierarchySubtitle;

  /// No description provided for @totalNodes.
  ///
  /// In en, this message translates to:
  /// **'Total Nodes'**
  String get totalNodes;

  /// No description provided for @maxDepth.
  ///
  /// In en, this message translates to:
  /// **'Max Depth'**
  String get maxDepth;

  /// No description provided for @parentRoles.
  ///
  /// In en, this message translates to:
  /// **'Parent Roles'**
  String get parentRoles;

  /// No description provided for @parentRole.
  ///
  /// In en, this message translates to:
  /// **'Parent Role'**
  String get parentRole;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @childRoles.
  ///
  /// In en, this message translates to:
  /// **'Child Roles'**
  String get childRoles;

  /// No description provided for @searchHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Search hierarchy...'**
  String get searchHierarchy;

  /// No description provided for @expandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand All'**
  String get expandAll;

  /// No description provided for @collapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse All'**
  String get collapseAll;

  /// No description provided for @createRootRole.
  ///
  /// In en, this message translates to:
  /// **'Create Root Role'**
  String get createRootRole;

  /// No description provided for @usersAssignedLabel.
  ///
  /// In en, this message translates to:
  /// **'Users Assigned'**
  String get usersAssignedLabel;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryAdjustingSearchCriteria.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get tryAdjustingSearchCriteria;

  /// No description provided for @addRoleToHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Add Role to Hierarchy'**
  String get addRoleToHierarchy;

  /// No description provided for @selectParentRole.
  ///
  /// In en, this message translates to:
  /// **'Select Parent Role (Optional)'**
  String get selectParentRole;

  /// No description provided for @selectParent.
  ///
  /// In en, this message translates to:
  /// **'Select parent role...'**
  String get selectParent;

  /// No description provided for @noParentRole.
  ///
  /// In en, this message translates to:
  /// **'No Parent (Root Level)'**
  String get noParentRole;

  /// No description provided for @existingRole.
  ///
  /// In en, this message translates to:
  /// **'Existing Role'**
  String get existingRole;

  /// No description provided for @selectExistingRole.
  ///
  /// In en, this message translates to:
  /// **'Select existing role'**
  String get selectExistingRole;

  /// No description provided for @newRoleName.
  ///
  /// In en, this message translates to:
  /// **'New Role Name'**
  String get newRoleName;

  /// No description provided for @enterNewRoleName.
  ///
  /// In en, this message translates to:
  /// **'Enter new role name'**
  String get enterNewRoleName;

  /// No description provided for @roleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Role Type'**
  String get roleTypeLabel;

  /// No description provided for @addRole.
  ///
  /// In en, this message translates to:
  /// **'Add Role'**
  String get addRole;

  /// No description provided for @roleTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-configured role templates for quick setup'**
  String get roleTemplatesSubtitle;

  /// No description provided for @totalTemplates.
  ///
  /// In en, this message translates to:
  /// **'Total Templates'**
  String get totalTemplates;

  /// No description provided for @industrySpecific.
  ///
  /// In en, this message translates to:
  /// **'Industry Specific'**
  String get industrySpecific;

  /// No description provided for @recentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently Used'**
  String get recentlyUsed;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @operations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'HR'**
  String get hr;

  /// No description provided for @it.
  ///
  /// In en, this message translates to:
  /// **'IT'**
  String get it;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplate;

  /// No description provided for @useTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use Template'**
  String get useTemplate;

  /// No description provided for @includes.
  ///
  /// In en, this message translates to:
  /// **'Includes'**
  String get includes;

  /// No description provided for @privilegesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Privileges'**
  String privilegesCount(int count);

  /// No description provided for @dataSetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Data Sets'**
  String dataSetsCount(int count);

  /// No description provided for @createNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create New Template'**
  String get createNewTemplate;

  /// No description provided for @creatingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Creating Template'**
  String get creatingTemplate;

  /// No description provided for @templateInstructions.
  ///
  /// In en, this message translates to:
  /// **'Create a reusable role template with pre-configured permissions and access settings'**
  String get templateInstructions;

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get templateName;

  /// No description provided for @enterTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Enter template name'**
  String get enterTemplateName;

  /// No description provided for @templateCode.
  ///
  /// In en, this message translates to:
  /// **'Template Code'**
  String get templateCode;

  /// No description provided for @enterTemplateCode.
  ///
  /// In en, this message translates to:
  /// **'Enter unique template code'**
  String get enterTemplateCode;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @templateDescription.
  ///
  /// In en, this message translates to:
  /// **'Template Description'**
  String get templateDescription;

  /// No description provided for @enterTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter template description'**
  String get enterTemplateDescription;

  /// No description provided for @includedPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Included Privileges'**
  String get includedPrivileges;

  /// No description provided for @selectPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Select Privileges'**
  String get selectPrivileges;

  /// No description provided for @selectedPrivileges.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedPrivileges(int count);

  /// No description provided for @includedDataSets.
  ///
  /// In en, this message translates to:
  /// **'Included Data Sets'**
  String get includedDataSets;

  /// No description provided for @selectDataSets.
  ///
  /// In en, this message translates to:
  /// **'Select Data Sets'**
  String get selectDataSets;

  /// No description provided for @selectedDataSets.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedDataSets(int count);

  /// No description provided for @makeDefaultTemplate.
  ///
  /// In en, this message translates to:
  /// **'Make Default Template'**
  String get makeDefaultTemplate;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default for this category'**
  String get setAsDefault;

  /// No description provided for @createTemplateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplateButton;

  /// No description provided for @securityPoliciesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure and manage security policies'**
  String get securityPoliciesSubtitle;

  /// No description provided for @activePolicies.
  ///
  /// In en, this message translates to:
  /// **'Active Policies'**
  String get activePolicies;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get pendingReview;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @searchPolicies.
  ///
  /// In en, this message translates to:
  /// **'Search policies...'**
  String get searchPolicies;

  /// No description provided for @createPolicy.
  ///
  /// In en, this message translates to:
  /// **'Create Policy'**
  String get createPolicy;

  /// No description provided for @policyType.
  ///
  /// In en, this message translates to:
  /// **'Policy Type'**
  String get policyType;

  /// No description provided for @enforcementLevel.
  ///
  /// In en, this message translates to:
  /// **'Enforcement Level'**
  String get enforcementLevel;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last Modified'**
  String get lastModified;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @createNewPolicy.
  ///
  /// In en, this message translates to:
  /// **'Create New Policy'**
  String get createNewPolicy;

  /// No description provided for @editPolicy.
  ///
  /// In en, this message translates to:
  /// **'Edit Policy'**
  String get editPolicy;

  /// No description provided for @creatingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Creating Policy'**
  String get creatingPolicy;

  /// No description provided for @policyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Define security policies to enforce access control and compliance'**
  String get policyInstructions;

  /// No description provided for @policyName.
  ///
  /// In en, this message translates to:
  /// **'Policy Name'**
  String get policyName;

  /// No description provided for @enterPolicyName.
  ///
  /// In en, this message translates to:
  /// **'Enter policy name'**
  String get enterPolicyName;

  /// No description provided for @policyCode.
  ///
  /// In en, this message translates to:
  /// **'Policy Code'**
  String get policyCode;

  /// No description provided for @enterPolicyCode.
  ///
  /// In en, this message translates to:
  /// **'Enter policy code'**
  String get enterPolicyCode;

  /// No description provided for @policyDescription.
  ///
  /// In en, this message translates to:
  /// **'Policy Description'**
  String get policyDescription;

  /// No description provided for @enterPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter policy description'**
  String get enterPolicyDescription;

  /// No description provided for @selectPolicyType.
  ///
  /// In en, this message translates to:
  /// **'Select Policy Type'**
  String get selectPolicyType;

  /// No description provided for @passwordPolicy.
  ///
  /// In en, this message translates to:
  /// **'Password Policy'**
  String get passwordPolicy;

  /// No description provided for @accessPolicy.
  ///
  /// In en, this message translates to:
  /// **'Access Policy'**
  String get accessPolicy;

  /// No description provided for @compliancePolicy.
  ///
  /// In en, this message translates to:
  /// **'Compliance Policy'**
  String get compliancePolicy;

  /// No description provided for @selectEnforcementLevel.
  ///
  /// In en, this message translates to:
  /// **'Select Enforcement Level'**
  String get selectEnforcementLevel;

  /// No description provided for @mandatory.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get mandatory;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @enterExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Enter expiry date'**
  String get enterExpiryDate;

  /// No description provided for @policyRules.
  ///
  /// In en, this message translates to:
  /// **'Policy Rules'**
  String get policyRules;

  /// No description provided for @addRule.
  ///
  /// In en, this message translates to:
  /// **'Add Rule'**
  String get addRule;

  /// No description provided for @createPolicyButton.
  ///
  /// In en, this message translates to:
  /// **'Create Policy'**
  String get createPolicyButton;

  /// No description provided for @dataAccessSetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage data access sets and permissions'**
  String get dataAccessSetsSubtitle;

  /// No description provided for @totalDataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Total Data Access Sets'**
  String get totalDataAccessSets;

  /// No description provided for @ledgerBased.
  ///
  /// In en, this message translates to:
  /// **'Ledger Based'**
  String get ledgerBased;

  /// No description provided for @entityBased.
  ///
  /// In en, this message translates to:
  /// **'Entity Based'**
  String get entityBased;

  /// No description provided for @searchDataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Search data access sets...'**
  String get searchDataAccessSets;

  /// No description provided for @createDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Create Data Access Set'**
  String get createDataAccessSet;

  /// No description provided for @accessScope.
  ///
  /// In en, this message translates to:
  /// **'Access Scope'**
  String get accessScope;

  /// No description provided for @createNewDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Create New Data Access Set'**
  String get createNewDataAccessSet;

  /// No description provided for @creatingDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Creating Data Access Set'**
  String get creatingDataAccessSet;

  /// No description provided for @dataAccessSetInstructions.
  ///
  /// In en, this message translates to:
  /// **'Define data access boundaries for controlling which data users can view and modify'**
  String get dataAccessSetInstructions;

  /// No description provided for @setName.
  ///
  /// In en, this message translates to:
  /// **'Set Name'**
  String get setName;

  /// No description provided for @enterDataAccessSetName.
  ///
  /// In en, this message translates to:
  /// **'Enter data access set name'**
  String get enterDataAccessSetName;

  /// No description provided for @setCode.
  ///
  /// In en, this message translates to:
  /// **'Set Code'**
  String get setCode;

  /// No description provided for @enterSetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter set code'**
  String get enterSetCode;

  /// No description provided for @accessType.
  ///
  /// In en, this message translates to:
  /// **'Access Type'**
  String get accessType;

  /// No description provided for @dataAccessConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Data Access Configuration'**
  String get dataAccessConfiguration;

  /// No description provided for @accessCriteriaChooseOne.
  ///
  /// In en, this message translates to:
  /// **'Access Criteria (Choose One)'**
  String get accessCriteriaChooseOne;

  /// No description provided for @selectAccessCriteria.
  ///
  /// In en, this message translates to:
  /// **'Select access criteria'**
  String get selectAccessCriteria;

  /// No description provided for @ledgersSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} Ledgers Selected'**
  String ledgersSelected(int count);

  /// No description provided for @noLedgersFound.
  ///
  /// In en, this message translates to:
  /// **'No ledgers found'**
  String get noLedgersFound;

  /// No description provided for @legalEntitiesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} Legal Entities Selected'**
  String legalEntitiesSelected(int count);

  /// No description provided for @noLegalEntitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No legal entities found'**
  String get noLegalEntitiesFound;

  /// No description provided for @createSet.
  ///
  /// In en, this message translates to:
  /// **'Create Set'**
  String get createSet;

  /// No description provided for @editDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Edit Data Access Set'**
  String get editDataAccessSet;

  /// No description provided for @updateSet.
  ///
  /// In en, this message translates to:
  /// **'Update Set'**
  String get updateSet;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description (optional)'**
  String get enterDescription;

  /// No description provided for @noDataAccessSetsFound.
  ///
  /// In en, this message translates to:
  /// **'No data access sets found'**
  String get noDataAccessSetsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search criteria'**
  String get tryAdjustingFilters;

  /// No description provided for @noPoliciesFound.
  ///
  /// In en, this message translates to:
  /// **'No policies found'**
  String get noPoliciesFound;

  /// No description provided for @noTemplatesFound.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get noTemplatesFound;

  /// No description provided for @noRolesFound.
  ///
  /// In en, this message translates to:
  /// **'No roles found'**
  String get noRolesFound;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @noPrivilegesFound.
  ///
  /// In en, this message translates to:
  /// **'No privileges found'**
  String get noPrivilegesFound;

  /// No description provided for @functionPrivilegesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage function-level security privileges'**
  String get functionPrivilegesSubtitle;

  /// No description provided for @createPrivilege.
  ///
  /// In en, this message translates to:
  /// **'Create Privilege'**
  String get createPrivilege;

  /// No description provided for @searchPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Search privileges...'**
  String get searchPrivileges;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @usedInRolesCount.
  ///
  /// In en, this message translates to:
  /// **'Used in {count} roles'**
  String usedInRolesCount(int count);

  /// No description provided for @functionArea.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get functionArea;

  /// No description provided for @actionType.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get actionType;

  /// No description provided for @selectActionType.
  ///
  /// In en, this message translates to:
  /// **'Select Operation'**
  String get selectActionType;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// No description provided for @createPrivilegeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Function Privilege'**
  String get createPrivilegeTitle;

  /// No description provided for @editPrivilegeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Function Privilege'**
  String get editPrivilegeTitle;

  /// No description provided for @privilegeName.
  ///
  /// In en, this message translates to:
  /// **'Privilege Name'**
  String get privilegeName;

  /// No description provided for @enterPrivilegeName.
  ///
  /// In en, this message translates to:
  /// **'Enter privilege name'**
  String get enterPrivilegeName;

  /// No description provided for @privilegeCode.
  ///
  /// In en, this message translates to:
  /// **'Privilege Code'**
  String get privilegeCode;

  /// No description provided for @enterPrivilegeCode.
  ///
  /// In en, this message translates to:
  /// **'Enter privilege code'**
  String get enterPrivilegeCode;

  /// No description provided for @privilegeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get privilegeDescription;

  /// No description provided for @selectModule.
  ///
  /// In en, this message translates to:
  /// **'Select Module'**
  String get selectModule;

  /// No description provided for @privilegeCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Privilege created successfully'**
  String get privilegeCreatedSuccessfully;

  /// No description provided for @privilegeUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Privilege updated successfully'**
  String get privilegeUpdatedSuccessfully;

  /// No description provided for @module.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get module;

  /// No description provided for @privilege.
  ///
  /// In en, this message translates to:
  /// **'Privilege'**
  String get privilege;

  /// No description provided for @rootRoles.
  ///
  /// In en, this message translates to:
  /// **'Root Roles'**
  String get rootRoles;

  /// No description provided for @hierarchyStructure.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Structure'**
  String get hierarchyStructure;

  /// No description provided for @saveRole.
  ///
  /// In en, this message translates to:
  /// **'Save Role'**
  String get saveRole;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @pleaseEnterRoleName.
  ///
  /// In en, this message translates to:
  /// **'Please enter role name'**
  String get pleaseEnterRoleName;

  /// No description provided for @pleaseEnterRoleCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter role code'**
  String get pleaseEnterRoleCode;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @activeRole.
  ///
  /// In en, this message translates to:
  /// **'Active Role'**
  String get activeRole;

  /// No description provided for @assignPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Assign Privileges'**
  String get assignPrivileges;

  /// No description provided for @functions.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get functions;

  /// No description provided for @securityIncidents.
  ///
  /// In en, this message translates to:
  /// **'Security Incidents'**
  String get securityIncidents;

  /// No description provided for @securityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Security Alerts'**
  String get securityAlerts;

  /// No description provided for @recentSecurityActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Security Activities'**
  String get recentSecurityActivities;

  /// No description provided for @configureDataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Configure Data Security'**
  String get configureDataSecurity;

  /// No description provided for @viewAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'View Audit Logs'**
  String get viewAuditLogs;

  /// No description provided for @passwordPolicyCompliance.
  ///
  /// In en, this message translates to:
  /// **'Password Policy Compliance'**
  String get passwordPolicyCompliance;

  /// No description provided for @multiFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Multi-Factor Authentication'**
  String get multiFactorAuthentication;

  /// No description provided for @activeUserReview.
  ///
  /// In en, this message translates to:
  /// **'Active User Review'**
  String get activeUserReview;

  /// No description provided for @segregationOfDuties.
  ///
  /// In en, this message translates to:
  /// **'Segregation of Duties'**
  String get segregationOfDuties;

  /// No description provided for @complianceStatus.
  ///
  /// In en, this message translates to:
  /// **'Compliance Status'**
  String get complianceStatus;

  /// No description provided for @passwordsExpiring.
  ///
  /// In en, this message translates to:
  /// **'Passwords Expiring'**
  String get passwordsExpiring;

  /// No description provided for @complianceScore.
  ///
  /// In en, this message translates to:
  /// **'Compliance Score'**
  String get complianceScore;

  /// No description provided for @tasksEvents.
  ///
  /// In en, this message translates to:
  /// **'Tasks & Events'**
  String get tasksEvents;

  /// No description provided for @attendanceLeaves.
  ///
  /// In en, this message translates to:
  /// **'Attendance & Leaves'**
  String get attendanceLeaves;

  /// No description provided for @myTasks.
  ///
  /// In en, this message translates to:
  /// **'MY TASKS'**
  String get myTasks;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING EVENTS'**
  String get upcomingEvents;

  /// No description provided for @reviewLeaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Review pending leave requests'**
  String get reviewLeaveRequests;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @processMonthlyPayroll.
  ///
  /// In en, this message translates to:
  /// **'Process monthly payroll'**
  String get processMonthlyPayroll;

  /// No description provided for @dueIn3Days.
  ///
  /// In en, this message translates to:
  /// **'Due in 3 days'**
  String get dueIn3Days;

  /// No description provided for @updateEmployeeRecords.
  ///
  /// In en, this message translates to:
  /// **'Update employee records'**
  String get updateEmployeeRecords;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @teamMeeting.
  ///
  /// In en, this message translates to:
  /// **'Team Meeting'**
  String get teamMeeting;

  /// No description provided for @payrollProcessing.
  ///
  /// In en, this message translates to:
  /// **'Payroll Processing'**
  String get payrollProcessing;

  /// No description provided for @allDay.
  ///
  /// In en, this message translates to:
  /// **'All-day'**
  String get allDay;

  /// No description provided for @viewAllTasksEvents.
  ///
  /// In en, this message translates to:
  /// **'View All Tasks & Events'**
  String get viewAllTasksEvents;

  /// No description provided for @todaysAttendance.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S ATTENDANCE'**
  String get todaysAttendance;

  /// No description provided for @checkInTime.
  ///
  /// In en, this message translates to:
  /// **'Check In Time'**
  String get checkInTime;

  /// No description provided for @statusOnTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get statusOnTime;

  /// No description provided for @myUpcomingLeaves.
  ///
  /// In en, this message translates to:
  /// **'MY UPCOMING LEAVES'**
  String get myUpcomingLeaves;

  /// No description provided for @annualLeave.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave'**
  String get annualLeave;

  /// No description provided for @leaveDates.
  ///
  /// In en, this message translates to:
  /// **'Dec 25 - Dec 30, 2024'**
  String get leaveDates;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @teamOnLeaveToday.
  ///
  /// In en, this message translates to:
  /// **'TEAM ON LEAVE TODAY'**
  String get teamOnLeaveToday;

  /// No description provided for @ahmadHassan.
  ///
  /// In en, this message translates to:
  /// **'Ahmad Hassan'**
  String get ahmadHassan;

  /// No description provided for @sickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick Leave'**
  String get sickLeave;

  /// No description provided for @mohammedKhan.
  ///
  /// In en, this message translates to:
  /// **'Mohammed Khan'**
  String get mohammedKhan;

  /// No description provided for @emergencyLeave.
  ///
  /// In en, this message translates to:
  /// **'Emergency Leave'**
  String get emergencyLeave;

  /// No description provided for @viewFullCalendar.
  ///
  /// In en, this message translates to:
  /// **'View Full Calendar'**
  String get viewFullCalendar;

  /// No description provided for @adminUser.
  ///
  /// In en, this message translates to:
  /// **'Admin User'**
  String get adminUser;

  /// No description provided for @welcomeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Admin User'**
  String get welcomeAdmin;

  /// No description provided for @timeManagement.
  ///
  /// In en, this message translates to:
  /// **'Time Management'**
  String get timeManagement;

  /// No description provided for @leaveManagement.
  ///
  /// In en, this message translates to:
  /// **'Leave Management'**
  String get leaveManagement;

  /// No description provided for @workforceStructure.
  ///
  /// In en, this message translates to:
  /// **'Workforce Structure'**
  String get workforceStructure;

  /// No description provided for @eosCalculator.
  ///
  /// In en, this message translates to:
  /// **'EOS Calculator'**
  String get eosCalculator;

  /// No description provided for @governmentForms.
  ///
  /// In en, this message translates to:
  /// **'Government Forms'**
  String get governmentForms;

  /// No description provided for @hrOperations.
  ///
  /// In en, this message translates to:
  /// **'HR Operations'**
  String get hrOperations;

  /// No description provided for @hiring.
  ///
  /// In en, this message translates to:
  /// **'Hiring'**
  String get hiring;

  /// No description provided for @hiringRequisitions.
  ///
  /// In en, this message translates to:
  /// **'Requisitions'**
  String get hiringRequisitions;

  /// No description provided for @hiringRequisitionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Requisitions'**
  String get hiringRequisitionsTitle;

  /// No description provided for @hiringRequisitionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive requisition management and tracking'**
  String get hiringRequisitionsDescription;

  /// No description provided for @hiringRequisitionsExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get hiringRequisitionsExport;

  /// No description provided for @hiringNewRequisition.
  ///
  /// In en, this message translates to:
  /// **'New Requisition'**
  String get hiringNewRequisition;

  /// No description provided for @hiringCreateRequisitionPositionInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Position Information'**
  String get hiringCreateRequisitionPositionInformationTitle;

  /// No description provided for @hiringCreateRequisitionPositionInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Core requisition configuration and metadata'**
  String get hiringCreateRequisitionPositionInformationSubtitle;

  /// No description provided for @hiringCreateRequisitionOrgStructureCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Org unit selection'**
  String get hiringCreateRequisitionOrgStructureCardTitle;

  /// No description provided for @hiringCreateRequisitionOrgStructureCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose units along your enterprise hierarchy. You can stop at any level.'**
  String get hiringCreateRequisitionOrgStructureCardSubtitle;

  /// No description provided for @hiringCreateRequisitionDepartmentOrgLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load organization structure: {error}'**
  String hiringCreateRequisitionDepartmentOrgLoadError(String error);

  /// No description provided for @hiringCreateRequisitionOrgStructureLevelsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No organization structure levels are configured. Contact your administrator.'**
  String get hiringCreateRequisitionOrgStructureLevelsEmpty;

  /// No description provided for @hiringCreateRequisitionOrgUnitRequired.
  ///
  /// In en, this message translates to:
  /// **'Organization unit is required'**
  String get hiringCreateRequisitionOrgUnitRequired;

  /// No description provided for @hiringCreateRequisitionEnterpriseMissing.
  ///
  /// In en, this message translates to:
  /// **'Select an enterprise to load the organization structure.'**
  String get hiringCreateRequisitionEnterpriseMissing;

  /// No description provided for @hiringCreateRequisitionLocationWorkArrangementTitle.
  ///
  /// In en, this message translates to:
  /// **'Location & Work Arrangement'**
  String get hiringCreateRequisitionLocationWorkArrangementTitle;

  /// No description provided for @hiringCreateRequisitionLocationWorkArrangementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Primary location and work mode settings'**
  String get hiringCreateRequisitionLocationWorkArrangementSubtitle;

  /// No description provided for @hiringCreateRequisitionNumberOfOpenings.
  ///
  /// In en, this message translates to:
  /// **'Number of Openings'**
  String get hiringCreateRequisitionNumberOfOpenings;

  /// No description provided for @hiringCreateRequisitionPrimaryLocation.
  ///
  /// In en, this message translates to:
  /// **'Primary Location'**
  String get hiringCreateRequisitionPrimaryLocation;

  /// No description provided for @hiringCreateRequisitionPrimaryLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., San Francisco, CA'**
  String get hiringCreateRequisitionPrimaryLocationHint;

  /// No description provided for @hiringCreateRequisitionWorkMode.
  ///
  /// In en, this message translates to:
  /// **'Work Mode'**
  String get hiringCreateRequisitionWorkMode;

  /// No description provided for @hiringCreateRequisitionWorkModeHint.
  ///
  /// In en, this message translates to:
  /// **'Select work mode'**
  String get hiringCreateRequisitionWorkModeHint;

  /// No description provided for @hiringCreateRequisitionWorkModeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Work Mode'**
  String get hiringCreateRequisitionWorkModeDialogTitle;

  /// No description provided for @hiringCreateRequisitionWorkModeDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how this role is performed'**
  String get hiringCreateRequisitionWorkModeDialogSubtitle;

  /// No description provided for @hiringCreateRequisitionWorkModeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search work mode...'**
  String get hiringCreateRequisitionWorkModeSearchHint;

  /// No description provided for @hiringCreateRequisitionWorkModeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No work modes available'**
  String get hiringCreateRequisitionWorkModeEmpty;

  /// No description provided for @hiringCreateRequisitionTargetStartDate.
  ///
  /// In en, this message translates to:
  /// **'Target Start Date'**
  String get hiringCreateRequisitionTargetStartDate;

  /// No description provided for @hiringCreateRequisitionExpectedEndDate.
  ///
  /// In en, this message translates to:
  /// **'Expected End Date'**
  String get hiringCreateRequisitionExpectedEndDate;

  /// No description provided for @hiringCreateRequisitionExpectedEndDateTooltip.
  ///
  /// In en, this message translates to:
  /// **'For temporary or contract positions'**
  String get hiringCreateRequisitionExpectedEndDateTooltip;

  /// No description provided for @hiringCreateRequisitionPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get hiringCreateRequisitionPriority;

  /// No description provided for @hiringCreateRequisitionPriorityHint.
  ///
  /// In en, this message translates to:
  /// **'Select priority'**
  String get hiringCreateRequisitionPriorityHint;

  /// No description provided for @hiringCreateRequisitionDateHint.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get hiringCreateRequisitionDateHint;

  /// No description provided for @hiringRequisitionsStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Requisitions'**
  String get hiringRequisitionsStatTotal;

  /// No description provided for @hiringRequisitionsStatTotalSubtext.
  ///
  /// In en, this message translates to:
  /// **'12% from last month'**
  String get hiringRequisitionsStatTotalSubtext;

  /// No description provided for @hiringRequisitionsStatOpenings.
  ///
  /// In en, this message translates to:
  /// **'Total Openings'**
  String get hiringRequisitionsStatOpenings;

  /// No description provided for @hiringRequisitionsStatOpeningsSubtext.
  ///
  /// In en, this message translates to:
  /// **'Across all departments'**
  String get hiringRequisitionsStatOpeningsSubtext;

  /// No description provided for @hiringRequisitionsStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get hiringRequisitionsStatPending;

  /// No description provided for @hiringRequisitionsStatPendingSubtext.
  ///
  /// In en, this message translates to:
  /// **'Awaiting action'**
  String get hiringRequisitionsStatPendingSubtext;

  /// No description provided for @hiringRequisitionsStatPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get hiringRequisitionsStatPriority;

  /// No description provided for @hiringRequisitionsStatPrioritySubtext.
  ///
  /// In en, this message translates to:
  /// **'Urgent requisitions'**
  String get hiringRequisitionsStatPrioritySubtext;

  /// No description provided for @hiringRequisitionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title, department, location, or ID...'**
  String get hiringRequisitionsSearchHint;

  /// No description provided for @hiringRequisitionsSearchHintMobile.
  ///
  /// In en, this message translates to:
  /// **'Search requisitions...'**
  String get hiringRequisitionsSearchHintMobile;

  /// No description provided for @hiringRequisitionsFilterAllDepartments.
  ///
  /// In en, this message translates to:
  /// **'All Departments'**
  String get hiringRequisitionsFilterAllDepartments;

  /// No description provided for @hiringRequisitionsFilterAllPriorities.
  ///
  /// In en, this message translates to:
  /// **'All Priorities'**
  String get hiringRequisitionsFilterAllPriorities;

  /// No description provided for @hiringRequisitionsFilterAllWorkModes.
  ///
  /// In en, this message translates to:
  /// **'All Work Modes'**
  String get hiringRequisitionsFilterAllWorkModes;

  /// No description provided for @hiringRequisitionsFilterAllEmploymentTypes.
  ///
  /// In en, this message translates to:
  /// **'All Employment Types'**
  String get hiringRequisitionsFilterAllEmploymentTypes;

  /// No description provided for @hiringRequisitionsFilterAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get hiringRequisitionsFilterAllStatuses;

  /// No description provided for @hiringRequisitionsTableColDetails.
  ///
  /// In en, this message translates to:
  /// **'Requisition Details'**
  String get hiringRequisitionsTableColDetails;

  /// No description provided for @hiringRequisitionsTableColDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department & Team'**
  String get hiringRequisitionsTableColDepartment;

  /// No description provided for @hiringRequisitionsTableColLocation.
  ///
  /// In en, this message translates to:
  /// **'Location & Mode'**
  String get hiringRequisitionsTableColLocation;

  /// No description provided for @hiringRequisitionsTableColOpenings.
  ///
  /// In en, this message translates to:
  /// **'Openings'**
  String get hiringRequisitionsTableColOpenings;

  /// No description provided for @hiringRequisitionsTableColCompensation.
  ///
  /// In en, this message translates to:
  /// **'Compensation'**
  String get hiringRequisitionsTableColCompensation;

  /// No description provided for @hiringRequisitionsTableColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get hiringRequisitionsTableColStatus;

  /// No description provided for @hiringRequisitionsTableColApproval.
  ///
  /// In en, this message translates to:
  /// **'Approval'**
  String get hiringRequisitionsTableColApproval;

  /// No description provided for @hiringRequisitionsTableColPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get hiringRequisitionsTableColPriority;

  /// No description provided for @hiringRequisitionsTableColTargetStart.
  ///
  /// In en, this message translates to:
  /// **'Target Start'**
  String get hiringRequisitionsTableColTargetStart;

  /// No description provided for @hiringRequisitionsTableColActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get hiringRequisitionsTableColActions;

  /// No description provided for @hiringRequisitionsTableEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Requisitions Found'**
  String get hiringRequisitionsTableEmptyTitle;

  /// No description provided for @hiringRequisitionsTableEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no job requisitions matching your search or filters.'**
  String get hiringRequisitionsTableEmptyMessage;

  /// No description provided for @hiringRequisitionsTableErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load requisitions'**
  String get hiringRequisitionsTableErrorTitle;

  /// No description provided for @hiringRequisitionsCompensationAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get hiringRequisitionsCompensationAnnual;

  /// No description provided for @hiringRequisitionsHiringManagerLabel.
  ///
  /// In en, this message translates to:
  /// **'HM:'**
  String get hiringRequisitionsHiringManagerLabel;

  /// No description provided for @hiringRequisitionsApprovalsLabel.
  ///
  /// In en, this message translates to:
  /// **'approvals'**
  String get hiringRequisitionsApprovalsLabel;

  /// No description provided for @hiringRequisitionsActionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get hiringRequisitionsActionView;

  /// No description provided for @hiringRequisitionsActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get hiringRequisitionsActionEdit;

  /// No description provided for @hiringRequisitionDetailsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Requisition Details'**
  String get hiringRequisitionDetailsCardTitle;

  /// No description provided for @hiringRequisitionCompensationCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Compensation Range'**
  String get hiringRequisitionCompensationCardTitle;

  /// No description provided for @hiringRequisitionJobDescriptionCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get hiringRequisitionJobDescriptionCardTitle;

  /// No description provided for @hiringRequisitionRequirementsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get hiringRequisitionRequirementsCardTitle;

  /// No description provided for @hiringRequisitionHiringTeamCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Hiring Team'**
  String get hiringRequisitionHiringTeamCardTitle;

  /// No description provided for @hiringCreateRequisitionHiringTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assign the core team for this requisition'**
  String get hiringCreateRequisitionHiringTeamSubtitle;

  /// No description provided for @hiringCreateRequisitionInterviewPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Interview Panel (Optional)'**
  String get hiringCreateRequisitionInterviewPanelTitle;

  /// No description provided for @hiringCreateRequisitionInterviewPanelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add team members who will participate in interviews'**
  String get hiringCreateRequisitionInterviewPanelSubtitle;

  /// No description provided for @hiringCreateRequisitionAddInterviewer.
  ///
  /// In en, this message translates to:
  /// **'Add Another Interviewer'**
  String get hiringCreateRequisitionAddInterviewer;

  /// No description provided for @hiringCreateRequisitionSelectEnterpriseForEmployees.
  ///
  /// In en, this message translates to:
  /// **'Select enterprise first to search employees'**
  String get hiringCreateRequisitionSelectEnterpriseForEmployees;

  /// No description provided for @hiringCreateRequisitionCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get hiringCreateRequisitionCurrency;

  /// No description provided for @hiringCreateRequisitionCurrencyHint.
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get hiringCreateRequisitionCurrencyHint;

  /// No description provided for @hiringCreateRequisitionCompensationType.
  ///
  /// In en, this message translates to:
  /// **'Compensation Type'**
  String get hiringCreateRequisitionCompensationType;

  /// No description provided for @hiringCreateRequisitionCompensationTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get hiringCreateRequisitionCompensationTypeHint;

  /// No description provided for @hiringCreateRequisitionMinimumSalaryWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'Minimum Salary ({currency})'**
  String hiringCreateRequisitionMinimumSalaryWithCurrency(String currency);

  /// No description provided for @hiringCreateRequisitionMaximumSalaryWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'Maximum Salary ({currency})'**
  String hiringCreateRequisitionMaximumSalaryWithCurrency(String currency);

  /// No description provided for @hiringCreateRequisitionBudgetAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50000'**
  String get hiringCreateRequisitionBudgetAmountHint;

  /// No description provided for @hiringRequisitionPriorityCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get hiringRequisitionPriorityCardTitle;

  /// No description provided for @hiringRequisitionQuickStatsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get hiringRequisitionQuickStatsCardTitle;

  /// No description provided for @hiringRequisitionDetailGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get hiringRequisitionDetailGrade;

  /// No description provided for @hiringRequisitionDetailEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get hiringRequisitionDetailEmploymentType;

  /// No description provided for @hiringRequisitionDetailWorkMode.
  ///
  /// In en, this message translates to:
  /// **'Work Mode'**
  String get hiringRequisitionDetailWorkMode;

  /// No description provided for @hiringRequisitionDetailOpenings.
  ///
  /// In en, this message translates to:
  /// **'Number of Openings'**
  String get hiringRequisitionDetailOpenings;

  /// No description provided for @hiringRequisitionDetailTargetStart.
  ///
  /// In en, this message translates to:
  /// **'Target Start Date'**
  String get hiringRequisitionDetailTargetStart;

  /// No description provided for @hiringRequisitionDetailCompensationUSDPerYear.
  ///
  /// In en, this message translates to:
  /// **'USD per year'**
  String get hiringRequisitionDetailCompensationUSDPerYear;

  /// No description provided for @hiringRequisitionDetailQualifications.
  ///
  /// In en, this message translates to:
  /// **'Qualifications'**
  String get hiringRequisitionDetailQualifications;

  /// No description provided for @hiringRequisitionDetailSkillsRequired.
  ///
  /// In en, this message translates to:
  /// **'Skills Required'**
  String get hiringRequisitionDetailSkillsRequired;

  /// No description provided for @hiringRequisitionDetailHiringManager.
  ///
  /// In en, this message translates to:
  /// **'Hiring Manager'**
  String get hiringRequisitionDetailHiringManager;

  /// No description provided for @hiringRequisitionDetailRecruiter.
  ///
  /// In en, this message translates to:
  /// **'Recruiter'**
  String get hiringRequisitionDetailRecruiter;

  /// No description provided for @hiringRequisitionDetailHrbp.
  ///
  /// In en, this message translates to:
  /// **'HR Business Partner'**
  String get hiringRequisitionDetailHrbp;

  /// No description provided for @hiringRequisitionDetailStatShortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get hiringRequisitionDetailStatShortlisted;

  /// No description provided for @hiringRequisitionDetailStatInInterview.
  ///
  /// In en, this message translates to:
  /// **'In Interview'**
  String get hiringRequisitionDetailStatInInterview;

  /// No description provided for @hiringRequisitionDetailStatDaysOpen.
  ///
  /// In en, this message translates to:
  /// **'Days Open'**
  String get hiringRequisitionDetailStatDaysOpen;

  /// No description provided for @hiringRequisitionDetailActionViewOnCareerSite.
  ///
  /// In en, this message translates to:
  /// **'View on Career Site'**
  String get hiringRequisitionDetailActionViewOnCareerSite;

  /// No description provided for @hiringRequisitionDetailActionPutOnHold.
  ///
  /// In en, this message translates to:
  /// **'Put On Hold'**
  String get hiringRequisitionDetailActionPutOnHold;

  /// No description provided for @hiringRequisitionActivateConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate Requisition'**
  String get hiringRequisitionActivateConfirmTitle;

  /// No description provided for @hiringRequisitionActivateConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will reopen the requisition and make it active for applications. Do you want to continue?'**
  String get hiringRequisitionActivateConfirmMessage;

  /// No description provided for @hiringRequisitionCloseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Requisition'**
  String get hiringRequisitionCloseConfirmTitle;

  /// No description provided for @hiringRequisitionCloseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently close the requisition and stop all hiring activity. Do you want to continue?'**
  String get hiringRequisitionCloseConfirmMessage;

  /// No description provided for @hiringRequisitionHoldConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Put Requisition On Hold'**
  String get hiringRequisitionHoldConfirmTitle;

  /// No description provided for @hiringRequisitionHoldConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will pause all hiring activity for this requisition. You can reactivate it at any time. Do you want to continue?'**
  String get hiringRequisitionHoldConfirmMessage;

  /// No description provided for @hiringRequisitionDetailTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get hiringRequisitionDetailTabOverview;

  /// No description provided for @hiringRequisitionDetailTabApprovalWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Approval Workflow'**
  String get hiringRequisitionDetailTabApprovalWorkflow;

  /// No description provided for @hiringRequisitionDetailTabJobPosting.
  ///
  /// In en, this message translates to:
  /// **'Job Posting'**
  String get hiringRequisitionDetailTabJobPosting;

  /// No description provided for @hiringRequisitionDetailTabApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get hiringRequisitionDetailTabApplications;

  /// No description provided for @hiringRequisitionDetailTabFindCandidates.
  ///
  /// In en, this message translates to:
  /// **'Find Candidates'**
  String get hiringRequisitionDetailTabFindCandidates;

  /// No description provided for @hiringRequisitionDetailTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get hiringRequisitionDetailTabHistory;

  /// No description provided for @hiringRequisitionJobPostingStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get hiringRequisitionJobPostingStatusActive;

  /// No description provided for @hiringRequisitionJobPostingTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Posting Title'**
  String get hiringRequisitionJobPostingTitleLabel;

  /// No description provided for @hiringRequisitionJobPostingDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get hiringRequisitionJobPostingDescriptionLabel;

  /// No description provided for @hiringRequisitionJobPostingStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get hiringRequisitionJobPostingStartDateLabel;

  /// No description provided for @hiringRequisitionJobPostingEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get hiringRequisitionJobPostingEndDateLabel;

  /// No description provided for @hiringRequisitionJobPostingVisibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get hiringRequisitionJobPostingVisibilityLabel;

  /// No description provided for @hiringRequisitionJobPostingPostedChannelsLabel.
  ///
  /// In en, this message translates to:
  /// **'Posted Channels'**
  String get hiringRequisitionJobPostingPostedChannelsLabel;

  /// No description provided for @hiringRequisitionJobPostingApplicationsReceivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Applications Received'**
  String get hiringRequisitionJobPostingApplicationsReceivedLabel;

  /// No description provided for @hiringRequisitionJobPostingActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Posting'**
  String get hiringRequisitionJobPostingActionEdit;

  /// No description provided for @hiringRequisitionJobPostingActionPause.
  ///
  /// In en, this message translates to:
  /// **'Pause Posting'**
  String get hiringRequisitionJobPostingActionPause;

  /// No description provided for @hiringRequisitionJobPostingPauseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause Job Posting'**
  String get hiringRequisitionJobPostingPauseConfirmTitle;

  /// No description provided for @hiringRequisitionJobPostingPauseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will temporarily stop accepting applications for this posting. You can resume it later. Do you want to continue?'**
  String get hiringRequisitionJobPostingPauseConfirmMessage;

  /// No description provided for @hiringRequisitionJobPostingPauseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Job posting paused successfully'**
  String get hiringRequisitionJobPostingPauseSuccess;

  /// No description provided for @hiringRequisitionJobPostingPauseError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pause job posting. Please try again.'**
  String get hiringRequisitionJobPostingPauseError;

  /// No description provided for @hiringRequisitionJobPostingActionActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate Posting'**
  String get hiringRequisitionJobPostingActionActivate;

  /// No description provided for @hiringRequisitionJobPostingActivateConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate Job Posting'**
  String get hiringRequisitionJobPostingActivateConfirmTitle;

  /// No description provided for @hiringRequisitionJobPostingActivateConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will resume accepting applications for this posting. Do you want to continue?'**
  String get hiringRequisitionJobPostingActivateConfirmMessage;

  /// No description provided for @hiringRequisitionJobPostingActivateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Job posting activated successfully'**
  String get hiringRequisitionJobPostingActivateSuccess;

  /// No description provided for @hiringRequisitionJobPostingActivateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to activate job posting. Please try again.'**
  String get hiringRequisitionJobPostingActivateError;

  /// No description provided for @hiringRequisitionJobPostingChannelInternal.
  ///
  /// In en, this message translates to:
  /// **'Internal Career Site'**
  String get hiringRequisitionJobPostingChannelInternal;

  /// No description provided for @hiringRequisitionJobPostingChannelExternal.
  ///
  /// In en, this message translates to:
  /// **'External Career Site'**
  String get hiringRequisitionJobPostingChannelExternal;

  /// No description provided for @hiringRequisitionJobPostingChannelLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get hiringRequisitionJobPostingChannelLinkedIn;

  /// No description provided for @hiringRequisitionJobPostingPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get hiringRequisitionJobPostingPosted;

  /// No description provided for @hiringRequisitionJobPostingActionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Job Posting'**
  String get hiringRequisitionJobPostingActionCreate;

  /// No description provided for @hiringRequisitionJobPostingCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Job posting created successfully'**
  String get hiringRequisitionJobPostingCreateSuccess;

  /// No description provided for @hiringRequisitionJobPostingUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Job posting updated successfully'**
  String get hiringRequisitionJobPostingUpdateSuccess;

  /// No description provided for @hiringRequisitionJobPostingAboutTheRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'About the Role'**
  String get hiringRequisitionJobPostingAboutTheRoleLabel;

  /// No description provided for @hiringRequisitionJobPostingResponsibilitiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities'**
  String get hiringRequisitionJobPostingResponsibilitiesLabel;

  /// No description provided for @hiringRequisitionJobPostingResponsibilitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter items separated by commas'**
  String get hiringRequisitionJobPostingResponsibilitiesHint;

  /// No description provided for @hiringRequisitionJobPostingQualificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Qualifications'**
  String get hiringRequisitionJobPostingQualificationsLabel;

  /// No description provided for @hiringRequisitionJobPostingQualificationsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter items separated by commas'**
  String get hiringRequisitionJobPostingQualificationsHint;

  /// No description provided for @hiringRequisitionJobPostingScheduleSection.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get hiringRequisitionJobPostingScheduleSection;

  /// No description provided for @hiringRequisitionJobPostingChannelsSection.
  ///
  /// In en, this message translates to:
  /// **'Posting Channels'**
  String get hiringRequisitionJobPostingChannelsSection;

  /// No description provided for @hiringRequisitionJobPostingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No job posting yet'**
  String get hiringRequisitionJobPostingEmptyTitle;

  /// No description provided for @hiringRequisitionJobPostingEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a job posting to publish this requisition.'**
  String get hiringRequisitionJobPostingEmptyMessage;

  /// No description provided for @hiringCommonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get hiringCommonYes;

  /// No description provided for @hiringCommonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get hiringCommonNo;

  /// No description provided for @hiringCandidates.
  ///
  /// In en, this message translates to:
  /// **'Candidates'**
  String get hiringCandidates;

  /// No description provided for @hiringCandidatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Candidates'**
  String get hiringCandidatesTitle;

  /// No description provided for @hiringCandidatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage and track candidate profiles and applications'**
  String get hiringCandidatesDescription;

  /// No description provided for @hiringCandidatesExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get hiringCandidatesExport;

  /// No description provided for @hiringCandidatesNew.
  ///
  /// In en, this message translates to:
  /// **'New Candidate'**
  String get hiringCandidatesNew;

  /// No description provided for @hiringNewCandidate.
  ///
  /// In en, this message translates to:
  /// **'New Candidate'**
  String get hiringNewCandidate;

  /// No description provided for @hiringCandidatesStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Candidates'**
  String get hiringCandidatesStatTotal;

  /// No description provided for @hiringCandidatesStatTotalSubtext.
  ///
  /// In en, this message translates to:
  /// **'8% from last month'**
  String get hiringCandidatesStatTotalSubtext;

  /// No description provided for @hiringCandidatesStatShortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get hiringCandidatesStatShortlisted;

  /// No description provided for @hiringCandidatesStatShortlistedSubtext.
  ///
  /// In en, this message translates to:
  /// **'Ready for review'**
  String get hiringCandidatesStatShortlistedSubtext;

  /// No description provided for @hiringCandidatesStatInterviewed.
  ///
  /// In en, this message translates to:
  /// **'Interviewed'**
  String get hiringCandidatesStatInterviewed;

  /// No description provided for @hiringCandidatesStatInterviewedSubtext.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get hiringCandidatesStatInterviewedSubtext;

  /// No description provided for @hiringCandidatesStatHired.
  ///
  /// In en, this message translates to:
  /// **'Hired'**
  String get hiringCandidatesStatHired;

  /// No description provided for @hiringCandidatesStatHiredSubtext.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get hiringCandidatesStatHiredSubtext;

  /// No description provided for @allCandidates.
  ///
  /// In en, this message translates to:
  /// **'All Candidates'**
  String get allCandidates;

  /// No description provided for @blacklisted.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get blacklisted;

  /// No description provided for @hiringCandidatesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email, phone, or skill...'**
  String get hiringCandidatesSearchHint;

  /// No description provided for @hiringCandidatesSearchHintMobile.
  ///
  /// In en, this message translates to:
  /// **'Search candidates...'**
  String get hiringCandidatesSearchHintMobile;

  /// No description provided for @hiringCandidatesTableColCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate'**
  String get hiringCandidatesTableColCandidate;

  /// No description provided for @hiringCandidatesTableColCurrentRole.
  ///
  /// In en, this message translates to:
  /// **'Current Role'**
  String get hiringCandidatesTableColCurrentRole;

  /// No description provided for @hiringCandidatesTableColExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get hiringCandidatesTableColExperience;

  /// No description provided for @hiringCandidatesTableColLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get hiringCandidatesTableColLocation;

  /// No description provided for @hiringCandidatesTableColRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get hiringCandidatesTableColRating;

  /// No description provided for @hiringCandidatesTableColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get hiringCandidatesTableColStatus;

  /// No description provided for @hiringCandidatesTableColActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get hiringCandidatesTableColActions;

  /// No description provided for @hiringCandidatesAddToPool.
  ///
  /// In en, this message translates to:
  /// **'Add to pool'**
  String get hiringCandidatesAddToPool;

  /// No description provided for @hiringCandidatesTableEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No candidates found'**
  String get hiringCandidatesTableEmptyTitle;

  /// No description provided for @hiringCandidatesTableEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no candidates matching your search or filters.'**
  String get hiringCandidatesTableEmptyMessage;

  /// No description provided for @hiringCandidatesDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this candidate?'**
  String get hiringCandidatesDeleteConfirmMessage;

  /// No description provided for @hiringCandidatesDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Candidate deleted successfully'**
  String get hiringCandidatesDeletedMessage;

  /// No description provided for @hiringApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get hiringApplications;

  /// No description provided for @hiringApplicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get hiringApplicationsTitle;

  /// No description provided for @hiringApplicationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Track and manage candidate applications across the hiring pipeline'**
  String get hiringApplicationsDescription;

  /// No description provided for @hiringApplicationsStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Applications'**
  String get hiringApplicationsStatTotal;

  /// No description provided for @hiringApplicationsStatTotalSubtext.
  ///
  /// In en, this message translates to:
  /// **'8% from last week'**
  String get hiringApplicationsStatTotalSubtext;

  /// No description provided for @hiringApplicationsStatNew.
  ///
  /// In en, this message translates to:
  /// **'New Applications'**
  String get hiringApplicationsStatNew;

  /// No description provided for @hiringApplicationsStatNewSubtext.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review'**
  String get hiringApplicationsStatNewSubtext;

  /// No description provided for @hiringApplicationsStatInterview.
  ///
  /// In en, this message translates to:
  /// **'In Interview'**
  String get hiringApplicationsStatInterview;

  /// No description provided for @hiringApplicationsStatInterviewSubtext.
  ///
  /// In en, this message translates to:
  /// **'Active candidates'**
  String get hiringApplicationsStatInterviewSubtext;

  /// No description provided for @hiringApplicationsStatCareerSite.
  ///
  /// In en, this message translates to:
  /// **'Career Site Applications'**
  String get hiringApplicationsStatCareerSite;

  /// No description provided for @hiringApplicationsStatCareerSiteSubtext.
  ///
  /// In en, this message translates to:
  /// **'Online submissions'**
  String get hiringApplicationsStatCareerSiteSubtext;

  /// No description provided for @hiringInterviews.
  ///
  /// In en, this message translates to:
  /// **'Interviews'**
  String get hiringInterviews;

  /// No description provided for @hiringInterviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Interviews'**
  String get hiringInterviewsTitle;

  /// No description provided for @hiringInterviewsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage interview schedules, feedback, and coordination'**
  String get hiringInterviewsDescription;

  /// No description provided for @hiringInterviewsNew.
  ///
  /// In en, this message translates to:
  /// **'Schedule Interview'**
  String get hiringInterviewsNew;

  /// No description provided for @hiringInterviewsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by candidate or requisition...'**
  String get hiringInterviewsSearchHint;

  /// No description provided for @hiringInterviewsSearchHintMobile.
  ///
  /// In en, this message translates to:
  /// **'Search interviews...'**
  String get hiringInterviewsSearchHintMobile;

  /// No description provided for @totalInterviews.
  ///
  /// In en, this message translates to:
  /// **'Total Interviews'**
  String get totalInterviews;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @rescheduled.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get rescheduled;

  /// No description provided for @upcomingInterviews.
  ///
  /// In en, this message translates to:
  /// **'Upcoming interviews'**
  String get upcomingInterviews;

  /// No description provided for @pendingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Pending Schedule'**
  String get pendingSchedule;

  /// No description provided for @needsScheduling.
  ///
  /// In en, this message translates to:
  /// **'Needs scheduling'**
  String get needsScheduling;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @allOffers.
  ///
  /// In en, this message translates to:
  /// **'All Offers'**
  String get allOffers;

  /// No description provided for @allInterviews.
  ///
  /// In en, this message translates to:
  /// **'All Interviews'**
  String get allInterviews;

  /// No description provided for @scheduledInterviews.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Interviews'**
  String get scheduledInterviews;

  /// No description provided for @pendingScheduling.
  ///
  /// In en, this message translates to:
  /// **'Pending Scheduling'**
  String get pendingScheduling;

  /// No description provided for @joinMeeting.
  ///
  /// In en, this message translates to:
  /// **'Join Meeting'**
  String get joinMeeting;

  /// No description provided for @addFeedback.
  ///
  /// In en, this message translates to:
  /// **'Add Feedback'**
  String get addFeedback;

  /// No description provided for @interviewDetails.
  ///
  /// In en, this message translates to:
  /// **'Interview Details'**
  String get interviewDetails;

  /// No description provided for @overallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overallRating;

  /// No description provided for @technicalSkills.
  ///
  /// In en, this message translates to:
  /// **'Technical Skills'**
  String get technicalSkills;

  /// No description provided for @communication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communication;

  /// No description provided for @cultureFit.
  ///
  /// In en, this message translates to:
  /// **'Culture Fit'**
  String get cultureFit;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @detailedComments.
  ///
  /// In en, this message translates to:
  /// **'Detailed Comments'**
  String get detailedComments;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @selectRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Select recommendation'**
  String get selectRecommendation;

  /// No description provided for @feedbackCommentsHint.
  ///
  /// In en, this message translates to:
  /// **'Provide detailed feedback about the candidate\'s performance, strengths, areas for improvement, and any other relevant observations...'**
  String get feedbackCommentsHint;

  /// No description provided for @interviewFeedbackSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully'**
  String get interviewFeedbackSubmitSuccess;

  /// No description provided for @interviewFeedbackSkillStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get interviewFeedbackSkillStrong;

  /// No description provided for @interviewFeedbackSkillGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get interviewFeedbackSkillGood;

  /// No description provided for @interviewFeedbackSkillAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get interviewFeedbackSkillAverage;

  /// No description provided for @interviewFeedbackSkillBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get interviewFeedbackSkillBad;

  /// No description provided for @interviewFeedbackSkillVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get interviewFeedbackSkillVeryBad;

  /// No description provided for @interviewFeedbackRecHire.
  ///
  /// In en, this message translates to:
  /// **'Hire'**
  String get interviewFeedbackRecHire;

  /// No description provided for @interviewFeedbackRecSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get interviewFeedbackRecSelected;

  /// No description provided for @interviewFeedbackRecNoHire.
  ///
  /// In en, this message translates to:
  /// **'No Hire'**
  String get interviewFeedbackRecNoHire;

  /// No description provided for @interviewFeedbackRecRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get interviewFeedbackRecRejected;

  /// No description provided for @hiringInterviewRejectConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this candidate for the interview? This action will mark the interview result as rejected.'**
  String get hiringInterviewRejectConfirmMessage;

  /// No description provided for @hiringInterviewRejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Interview candidate rejected successfully'**
  String get hiringInterviewRejectSuccess;

  /// No description provided for @hiringInterviewRejectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject interview candidate. Please try again.'**
  String get hiringInterviewRejectFailed;

  /// No description provided for @hiringInterviewRejectMissingId.
  ///
  /// In en, this message translates to:
  /// **'Interview identifier is missing'**
  String get hiringInterviewRejectMissingId;

  /// No description provided for @hiringInterviewEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Interview'**
  String get hiringInterviewEditTitle;

  /// No description provided for @hiringInterviewEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Interview updated successfully'**
  String get hiringInterviewEditSuccess;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @hiringInterviewAcceptConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this candidate for the interview? This will mark the interview result as selected.'**
  String get hiringInterviewAcceptConfirmMessage;

  /// No description provided for @hiringInterviewAcceptSuccess.
  ///
  /// In en, this message translates to:
  /// **'Interview candidate accepted successfully'**
  String get hiringInterviewAcceptSuccess;

  /// No description provided for @hiringInterviewAcceptFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept interview candidate. Please try again.'**
  String get hiringInterviewAcceptFailed;

  /// No description provided for @hiringInterviewAcceptMissingId.
  ///
  /// In en, this message translates to:
  /// **'Interview identifier is missing'**
  String get hiringInterviewAcceptMissingId;

  /// No description provided for @interviewFeedbackRecHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get interviewFeedbackRecHold;

  /// No description provided for @interviewFeedbackRecNoHold.
  ///
  /// In en, this message translates to:
  /// **'No Hold'**
  String get interviewFeedbackRecNoHold;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @interviewTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get interviewTime;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selectApplication.
  ///
  /// In en, this message translates to:
  /// **'Select Application'**
  String get selectApplication;

  /// No description provided for @chooseApplicationHint.
  ///
  /// In en, this message translates to:
  /// **'Choose an application...'**
  String get chooseApplicationHint;

  /// No description provided for @interviewType.
  ///
  /// In en, this message translates to:
  /// **'Interview Type'**
  String get interviewType;

  /// No description provided for @interviewRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get interviewRound;

  /// No description provided for @interviewLocationMode.
  ///
  /// In en, this message translates to:
  /// **'Location/Mode'**
  String get interviewLocationMode;

  /// No description provided for @videoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get videoCall;

  /// No description provided for @inPerson.
  ///
  /// In en, this message translates to:
  /// **'In-Person'**
  String get inPerson;

  /// No description provided for @phoneCall.
  ///
  /// In en, this message translates to:
  /// **'Phone Call'**
  String get phoneCall;

  /// No description provided for @meetingLink.
  ///
  /// In en, this message translates to:
  /// **'Meeting Link (for video calls)'**
  String get meetingLink;

  /// No description provided for @meetingLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://meet.company.com/...'**
  String get meetingLinkHint;

  /// No description provided for @interviewers.
  ///
  /// In en, this message translates to:
  /// **'Interviewers'**
  String get interviewers;

  /// No description provided for @enterInterviewerNamesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter interviewer names (comma separated)'**
  String get enterInterviewerNamesHint;

  /// No description provided for @interviewerNamesExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., Sarah Chen, Tom Wilson'**
  String get interviewerNamesExample;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any special instructions or notes...'**
  String get notesHint;

  /// No description provided for @interviewDuration15Minutes.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get interviewDuration15Minutes;

  /// No description provided for @interviewDuration30Minutes.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get interviewDuration30Minutes;

  /// No description provided for @interviewDuration45Minutes.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get interviewDuration45Minutes;

  /// No description provided for @interviewDuration60Minutes.
  ///
  /// In en, this message translates to:
  /// **'60 minutes'**
  String get interviewDuration60Minutes;

  /// No description provided for @interviewDuration90Minutes.
  ///
  /// In en, this message translates to:
  /// **'90 minutes'**
  String get interviewDuration90Minutes;

  /// No description provided for @hiringOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get hiringOffers;

  /// No description provided for @hiringOffersLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load offers'**
  String get hiringOffersLoadErrorTitle;

  /// No description provided for @offerStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get offerStatusDraft;

  /// No description provided for @offerStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get offerStatusApproved;

  /// No description provided for @offerStatusApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get offerStatusApprove;

  /// No description provided for @offerStatusDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get offerStatusDecline;

  /// No description provided for @offerStatusWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get offerStatusWithdraw;

  /// No description provided for @offerStatusExtend.
  ///
  /// In en, this message translates to:
  /// **'Extend'**
  String get offerStatusExtend;

  /// No description provided for @hiringOffersChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get hiringOffersChangeStatus;

  /// No description provided for @hiringOffersUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get hiringOffersUpdateStatus;

  /// No description provided for @hiringOffersChangeStatusConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Change offer status'**
  String get hiringOffersChangeStatusConfirmTitle;

  /// No description provided for @hiringOffersChangeStatusConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Move this offer from {currentStatus} to {targetStatus}?'**
  String hiringOffersChangeStatusConfirmMessage(
    String currentStatus,
    String targetStatus,
  );

  /// No description provided for @hiringOffersStatusChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Offer status updated successfully'**
  String get hiringOffersStatusChangeSuccess;

  /// No description provided for @hiringOffersStatusChangeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to change offer status'**
  String get hiringOffersStatusChangeError;

  /// No description provided for @hiringOffersStatusChangeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to change status for this offer'**
  String get hiringOffersStatusChangeUnavailable;

  /// No description provided for @hiringOffersStatusActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No API action is available for status \"{status}\".'**
  String hiringOffersStatusActionUnavailable(String status);

  /// No description provided for @hiringOffersDeclineConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline offer'**
  String get hiringOffersDeclineConfirmTitle;

  /// No description provided for @hiringOffersDeclineCommentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Decline comments'**
  String get hiringOffersDeclineCommentsLabel;

  /// No description provided for @hiringOffersDeclineCommentsRequired.
  ///
  /// In en, this message translates to:
  /// **'Decline comments are required'**
  String get hiringOffersDeclineCommentsRequired;

  /// No description provided for @offerManagement.
  ///
  /// In en, this message translates to:
  /// **'Offer Management'**
  String get offerManagement;

  /// No description provided for @offerManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, track, and manage job offers with e-signature'**
  String get offerManagementSubtitle;

  /// No description provided for @totalOffers.
  ///
  /// In en, this message translates to:
  /// **'Total Offers'**
  String get totalOffers;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @sentToCandidates.
  ///
  /// In en, this message translates to:
  /// **'Sent to Candidates'**
  String get sentToCandidates;

  /// No description provided for @avgOfferValue.
  ///
  /// In en, this message translates to:
  /// **'Avg. Offer Value'**
  String get avgOfferValue;

  /// No description provided for @readyToOnboard.
  ///
  /// In en, this message translates to:
  /// **'Ready to onboard'**
  String get readyToOnboard;

  /// No description provided for @annualSalary.
  ///
  /// In en, this message translates to:
  /// **'Annual salary'**
  String get annualSalary;

  /// No description provided for @createOffer.
  ///
  /// In en, this message translates to:
  /// **'Create Offer'**
  String get createOffer;

  /// No description provided for @awaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review'**
  String get awaitingReview;

  /// No description provided for @awaitingResponse.
  ///
  /// In en, this message translates to:
  /// **'Awaiting response'**
  String get awaitingResponse;

  /// No description provided for @hiringHrInterface.
  ///
  /// In en, this message translates to:
  /// **'HR Interface'**
  String get hiringHrInterface;

  /// No description provided for @hiringHrInterfaceTitle.
  ///
  /// In en, this message translates to:
  /// **'HR Integration Interface'**
  String get hiringHrInterfaceTitle;

  /// No description provided for @hiringHrInterfaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer accepted offers to HR system as pending employees'**
  String get hiringHrInterfaceSubtitle;

  /// No description provided for @hiringHrInterfaceStatAcceptedOffers.
  ///
  /// In en, this message translates to:
  /// **'Accepted Offers'**
  String get hiringHrInterfaceStatAcceptedOffers;

  /// No description provided for @hiringHrInterfaceStatAcceptedOffersSub.
  ///
  /// In en, this message translates to:
  /// **'Ready for HR transfer'**
  String get hiringHrInterfaceStatAcceptedOffersSub;

  /// No description provided for @hiringHrInterfaceStatPendingTransfer.
  ///
  /// In en, this message translates to:
  /// **'Pending Transfer'**
  String get hiringHrInterfaceStatPendingTransfer;

  /// No description provided for @hiringHrInterfaceStatPendingTransferSub.
  ///
  /// In en, this message translates to:
  /// **'Awaiting HR sync'**
  String get hiringHrInterfaceStatPendingTransferSub;

  /// No description provided for @hiringHrInterfaceStatTransferred.
  ///
  /// In en, this message translates to:
  /// **'Transferred'**
  String get hiringHrInterfaceStatTransferred;

  /// No description provided for @hiringHrInterfaceStatNewHires.
  ///
  /// In en, this message translates to:
  /// **'New Hires'**
  String get hiringHrInterfaceStatNewHires;

  /// No description provided for @hiringHrInterfaceOfferAccepted.
  ///
  /// In en, this message translates to:
  /// **'Offer Accepted'**
  String get hiringHrInterfaceOfferAccepted;

  /// No description provided for @hiringHrInterfaceAcceptedOn.
  ///
  /// In en, this message translates to:
  /// **'Accepted on'**
  String get hiringHrInterfaceAcceptedOn;

  /// No description provided for @hiringHrInterfacePosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get hiringHrInterfacePosition;

  /// No description provided for @hiringHrInterfaceDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get hiringHrInterfaceDepartment;

  /// No description provided for @hiringHrInterfaceGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get hiringHrInterfaceGrade;

  /// No description provided for @hiringHrInterfaceLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get hiringHrInterfaceLocation;

  /// No description provided for @hiringHrInterfaceStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get hiringHrInterfaceStartDate;

  /// No description provided for @hiringHrInterfaceEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get hiringHrInterfaceEmploymentType;

  /// No description provided for @hiringHrInterfaceAnnualSalary.
  ///
  /// In en, this message translates to:
  /// **'Annual Salary'**
  String get hiringHrInterfaceAnnualSalary;

  /// No description provided for @hiringHrInterfaceProbation.
  ///
  /// In en, this message translates to:
  /// **'Probation'**
  String get hiringHrInterfaceProbation;

  /// No description provided for @hiringHrInterfaceReadyForTransferDesc.
  ///
  /// In en, this message translates to:
  /// **'This candidate has accepted the offer and is ready to be transferred to the HR system as a pending employee. All necessary documentation and background checks should be completed before transfer.'**
  String get hiringHrInterfaceReadyForTransferDesc;

  /// No description provided for @hiringHrInterfaceViewOffer.
  ///
  /// In en, this message translates to:
  /// **'View Offer'**
  String get hiringHrInterfaceViewOffer;

  /// No description provided for @hiringHrInterfaceViewDocuments.
  ///
  /// In en, this message translates to:
  /// **'View Documents'**
  String get hiringHrInterfaceViewDocuments;

  /// No description provided for @hiringHrInterfaceExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get hiringHrInterfaceExportData;

  /// No description provided for @hiringHrInterfaceTransferToHr.
  ///
  /// In en, this message translates to:
  /// **'Transfer to HR'**
  String get hiringHrInterfaceTransferToHr;

  /// No description provided for @hiringCareerSite.
  ///
  /// In en, this message translates to:
  /// **'Career Site'**
  String get hiringCareerSite;

  /// No description provided for @deiDashboard.
  ///
  /// In en, this message translates to:
  /// **'DEI Dashboard'**
  String get deiDashboard;

  /// No description provided for @moduleCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Module Catalogue'**
  String get moduleCatalogue;

  /// No description provided for @productIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Product Introduction'**
  String get productIntroduction;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @manageEmployees.
  ///
  /// In en, this message translates to:
  /// **'Manage Employees'**
  String get manageEmployees;

  /// No description provided for @manageEmployeesDescription.
  ///
  /// In en, this message translates to:
  /// **'View and manage employees'**
  String get manageEmployeesDescription;

  /// No description provided for @employeesExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get employeesExportSuccess;

  /// No description provided for @employeesExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export employees'**
  String get employeesExportFailed;

  /// No description provided for @orgUnitsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get orgUnitsExportSuccess;

  /// No description provided for @orgUnitsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export org units'**
  String get orgUnitsExportFailed;

  /// No description provided for @addNewEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add New Employee'**
  String get addNewEmployee;

  /// No description provided for @editEmployee.
  ///
  /// In en, this message translates to:
  /// **'Edit Employee'**
  String get editEmployee;

  /// No description provided for @addEmployeeStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 9'**
  String addEmployeeStepSubtitle(int step);

  /// No description provided for @addEmployeeStepBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get addEmployeeStepBasicInfo;

  /// No description provided for @addEmployeeStepDemographics.
  ///
  /// In en, this message translates to:
  /// **'Demographics'**
  String get addEmployeeStepDemographics;

  /// No description provided for @addEmployeeStepAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addEmployeeStepAddress;

  /// No description provided for @addEmployeeStepAssignmentInfo.
  ///
  /// In en, this message translates to:
  /// **'Assignment Info'**
  String get addEmployeeStepAssignmentInfo;

  /// No description provided for @addEmployeeStepWorkSchedule.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule'**
  String get addEmployeeStepWorkSchedule;

  /// No description provided for @addEmployeeStepCompensation.
  ///
  /// In en, this message translates to:
  /// **'Compensation'**
  String get addEmployeeStepCompensation;

  /// No description provided for @addEmployeeStepBanking.
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get addEmployeeStepBanking;

  /// No description provided for @addEmployeeStepDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get addEmployeeStepDocuments;

  /// No description provided for @addEmployeeStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get addEmployeeStepReview;

  /// No description provided for @addEmployeeBasicInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name and primary contact details'**
  String get addEmployeeBasicInfoSubtitle;

  /// No description provided for @addEmployeeNameFieldsConfigured.
  ///
  /// In en, this message translates to:
  /// **'Name fields are configured from Enterprise Structure → Name Structure Settings'**
  String get addEmployeeNameFieldsConfigured;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @secondName.
  ///
  /// In en, this message translates to:
  /// **'Second Name'**
  String get secondName;

  /// No description provided for @thirdName.
  ///
  /// In en, this message translates to:
  /// **'Third Name'**
  String get thirdName;

  /// No description provided for @fourthName.
  ///
  /// In en, this message translates to:
  /// **'Fourth Name'**
  String get fourthName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleName;

  /// No description provided for @editCandidateProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Candidate Profile'**
  String get editCandidateProfile;

  /// No description provided for @primaryEmail.
  ///
  /// In en, this message translates to:
  /// **'Primary Email'**
  String get primaryEmail;

  /// No description provided for @alternateEmail.
  ///
  /// In en, this message translates to:
  /// **'Alternate Email'**
  String get alternateEmail;

  /// No description provided for @primaryPhone.
  ///
  /// In en, this message translates to:
  /// **'Primary Phone'**
  String get primaryPhone;

  /// No description provided for @alternatePhone.
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone'**
  String get alternatePhone;

  /// No description provided for @professionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInformation;

  /// No description provided for @currentTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Title'**
  String get currentTitle;

  /// No description provided for @currentEmployer.
  ///
  /// In en, this message translates to:
  /// **'Current Employer'**
  String get currentEmployer;

  /// No description provided for @yearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get yearsOfExperience;

  /// No description provided for @noticePeriod.
  ///
  /// In en, this message translates to:
  /// **'Notice Period'**
  String get noticePeriod;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @preferredLocation.
  ///
  /// In en, this message translates to:
  /// **'Preferred Location'**
  String get preferredLocation;

  /// No description provided for @willingToRelocate.
  ///
  /// In en, this message translates to:
  /// **'Willing to Relocate'**
  String get willingToRelocate;

  /// No description provided for @compensation.
  ///
  /// In en, this message translates to:
  /// **'Compensation'**
  String get compensation;

  /// No description provided for @currentSalary.
  ///
  /// In en, this message translates to:
  /// **'Current Salary (USD)'**
  String get currentSalary;

  /// No description provided for @expectedSalary.
  ///
  /// In en, this message translates to:
  /// **'Expected Salary (USD)'**
  String get expectedSalary;

  /// No description provided for @socialLinks.
  ///
  /// In en, this message translates to:
  /// **'Social Links'**
  String get socialLinks;

  /// No description provided for @linkedinProfile.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Profile'**
  String get linkedinProfile;

  /// No description provided for @githubProfile.
  ///
  /// In en, this message translates to:
  /// **'GitHub Profile'**
  String get githubProfile;

  /// No description provided for @portfolioWebsite.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Website'**
  String get portfolioWebsite;

  /// No description provided for @middleNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Middle Name (Arabic)'**
  String get middleNameArabic;

  /// No description provided for @secondNameArabic.
  ///
  /// In en, this message translates to:
  /// **'الاسم الثاني'**
  String get secondNameArabic;

  /// No description provided for @thirdNameArabic.
  ///
  /// In en, this message translates to:
  /// **'الاسم الثالث'**
  String get thirdNameArabic;

  /// No description provided for @fourthNameArabic.
  ///
  /// In en, this message translates to:
  /// **'الاسم الرابع'**
  String get fourthNameArabic;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @firstNameArabic.
  ///
  /// In en, this message translates to:
  /// **'الاسم الأول'**
  String get firstNameArabic;

  /// No description provided for @lastNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Last Name (Arabic)'**
  String get lastNameArabic;

  /// No description provided for @hintFirstName.
  ///
  /// In en, this message translates to:
  /// **'e.g. John'**
  String get hintFirstName;

  /// No description provided for @hintSecondName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Robert'**
  String get hintSecondName;

  /// No description provided for @hintThirdName.
  ///
  /// In en, this message translates to:
  /// **'e.g. James'**
  String get hintThirdName;

  /// No description provided for @hintFourthName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Smith'**
  String get hintFourthName;

  /// No description provided for @hintLastName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Smith'**
  String get hintLastName;

  /// No description provided for @hintMiddleName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Robert'**
  String get hintMiddleName;

  /// No description provided for @hintMiddleNameArabic.
  ///
  /// In en, this message translates to:
  /// **'e.g. محمد'**
  String get hintMiddleNameArabic;

  /// No description provided for @hintMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5555 5555'**
  String get hintMobileNumber;

  /// No description provided for @hintNationalPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2222 2222'**
  String get hintNationalPhoneNumber;

  /// No description provided for @hintNationalMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5555 5555'**
  String get hintNationalMobileNumber;

  /// No description provided for @hintDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15/06/1990'**
  String get hintDateOfBirth;

  /// No description provided for @hintFirstNameArabic.
  ///
  /// In en, this message translates to:
  /// **'مثال: جون'**
  String get hintFirstNameArabic;

  /// No description provided for @hintSecondNameArabic.
  ///
  /// In en, this message translates to:
  /// **'مثال: محمد'**
  String get hintSecondNameArabic;

  /// No description provided for @hintThirdNameArabic.
  ///
  /// In en, this message translates to:
  /// **'مثال: أحمد'**
  String get hintThirdNameArabic;

  /// No description provided for @hintFourthNameArabic.
  ///
  /// In en, this message translates to:
  /// **'مثال: العلي'**
  String get hintFourthNameArabic;

  /// No description provided for @hintLastNameArabic.
  ///
  /// In en, this message translates to:
  /// **'e.g. سميث'**
  String get hintLastNameArabic;

  /// No description provided for @demographicsAndIdentity.
  ///
  /// In en, this message translates to:
  /// **'Demographics & Identity'**
  String get demographicsAndIdentity;

  /// No description provided for @demographicsAndIdentitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal demographics and identification documents.'**
  String get demographicsAndIdentitySubtitle;

  /// No description provided for @demographics.
  ///
  /// In en, this message translates to:
  /// **'Demographics'**
  String get demographics;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @identificationDocuments.
  ///
  /// In en, this message translates to:
  /// **'Identification Documents'**
  String get identificationDocuments;

  /// No description provided for @civilIdNumber.
  ///
  /// In en, this message translates to:
  /// **'Civil ID Number'**
  String get civilIdNumber;

  /// No description provided for @passportNumber.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportNumber;

  /// No description provided for @hintGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get hintGender;

  /// No description provided for @hintNationality.
  ///
  /// In en, this message translates to:
  /// **'Select nationality'**
  String get hintNationality;

  /// No description provided for @hintMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select marital status'**
  String get hintMaritalStatus;

  /// No description provided for @hintReligion.
  ///
  /// In en, this message translates to:
  /// **'Enter religion'**
  String get hintReligion;

  /// No description provided for @hintCivilIdNumber.
  ///
  /// In en, this message translates to:
  /// **'e.g. 123456789012'**
  String get hintCivilIdNumber;

  /// No description provided for @hintPassportNumber.
  ///
  /// In en, this message translates to:
  /// **'e.g. AB1234567'**
  String get hintPassportNumber;

  /// No description provided for @addressAndEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Address & Emergency Contact'**
  String get addressAndEmergencyContact;

  /// No description provided for @addressAndEmergencyContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Residential address and emergency contact information'**
  String get addressAndEmergencyContactSubtitle;

  /// No description provided for @residentialAddress.
  ///
  /// In en, this message translates to:
  /// **'Residential Address'**
  String get residentialAddress;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @hintGovernorate.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hawally'**
  String get hintGovernorate;

  /// No description provided for @hintSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get hintSelectCountry;

  /// No description provided for @searchCountryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search country or dial code...'**
  String get searchCountryPlaceholder;

  /// No description provided for @noCountryFound.
  ///
  /// In en, this message translates to:
  /// **'No country found'**
  String get noCountryFound;

  /// No description provided for @frequentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Frequently used'**
  String get frequentlyUsed;

  /// No description provided for @allCountries.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get allCountries;

  /// No description provided for @selectDialCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your country dial code'**
  String get selectDialCodeSubtitle;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @hintContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter contact name'**
  String get hintContactName;

  /// No description provided for @hintRelationship.
  ///
  /// In en, this message translates to:
  /// **'Enter relationship'**
  String get hintRelationship;

  /// No description provided for @assignmentInformation.
  ///
  /// In en, this message translates to:
  /// **'Assignment Information'**
  String get assignmentInformation;

  /// No description provided for @assignmentInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organizational structure and job details.'**
  String get assignmentInformationSubtitle;

  /// No description provided for @assignmentStartDate.
  ///
  /// In en, this message translates to:
  /// **'Assignment Start Date'**
  String get assignmentStartDate;

  /// No description provided for @assignmentEndDate.
  ///
  /// In en, this message translates to:
  /// **'Assignment End Date'**
  String get assignmentEndDate;

  /// No description provided for @assignmentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Assignment Period'**
  String get assignmentPeriod;

  /// No description provided for @organizationalStructure.
  ///
  /// In en, this message translates to:
  /// **'Organizational Structure'**
  String get organizationalStructure;

  /// No description provided for @jobAndEmploymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Job & Employment Details'**
  String get jobAndEmploymentDetails;

  /// No description provided for @workLocation.
  ///
  /// In en, this message translates to:
  /// **'Work Location'**
  String get workLocation;

  /// No description provided for @gradeLevel.
  ///
  /// In en, this message translates to:
  /// **'Grade Level'**
  String get gradeLevel;

  /// No description provided for @contractType.
  ///
  /// In en, this message translates to:
  /// **'Contract Type'**
  String get contractType;

  /// No description provided for @reportingTo.
  ///
  /// In en, this message translates to:
  /// **'Reporting To'**
  String get reportingTo;

  /// No description provided for @enterpriseHireDate.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Hire Date'**
  String get enterpriseHireDate;

  /// No description provided for @probationPeriodDays.
  ///
  /// In en, this message translates to:
  /// **'Probation Period (days)'**
  String get probationPeriodDays;

  /// No description provided for @employmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Employment Status'**
  String get employmentStatus;

  /// No description provided for @hintWorkLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter work location'**
  String get hintWorkLocation;

  /// No description provided for @hintEmployeeNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter employee number'**
  String get hintEmployeeNumber;

  /// No description provided for @hintGradeLevel.
  ///
  /// In en, this message translates to:
  /// **'Select grade level'**
  String get hintGradeLevel;

  /// No description provided for @hintContractType.
  ///
  /// In en, this message translates to:
  /// **'Select contract type'**
  String get hintContractType;

  /// No description provided for @hintReportingTo.
  ///
  /// In en, this message translates to:
  /// **'Enter reporting to'**
  String get hintReportingTo;

  /// No description provided for @hintEnterpriseHireDate.
  ///
  /// In en, this message translates to:
  /// **'Select hire date'**
  String get hintEnterpriseHireDate;

  /// No description provided for @hintProbationPeriodDays.
  ///
  /// In en, this message translates to:
  /// **'Enter days'**
  String get hintProbationPeriodDays;

  /// No description provided for @hintEmploymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Select employment status'**
  String get hintEmploymentStatus;

  /// No description provided for @hintJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Select job level'**
  String get hintJobLevel;

  /// No description provided for @timeManagementWorkSchedule.
  ///
  /// In en, this message translates to:
  /// **'Time Management - Work Schedule'**
  String get timeManagementWorkSchedule;

  /// No description provided for @timeManagementWorkScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assign work schedule for attendance tracking'**
  String get timeManagementWorkScheduleSubtitle;

  /// No description provided for @workScheduleAssignment.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule Assignment'**
  String get workScheduleAssignment;

  /// No description provided for @workSchedule.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule'**
  String get workSchedule;

  /// No description provided for @workScheduleStartDate.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule Start Date'**
  String get workScheduleStartDate;

  /// No description provided for @workScheduleEndDate.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule End Date'**
  String get workScheduleEndDate;

  /// No description provided for @workSchedulePeriod.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule Period'**
  String get workSchedulePeriod;

  /// No description provided for @hintSelectWorkSchedule.
  ///
  /// In en, this message translates to:
  /// **'Select work schedule'**
  String get hintSelectWorkSchedule;

  /// No description provided for @compensationAndBenefits.
  ///
  /// In en, this message translates to:
  /// **'Compensation & Benefits'**
  String get compensationAndBenefits;

  /// No description provided for @compensationAndBenefitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Salary structure and allowances'**
  String get compensationAndBenefitsSubtitle;

  /// No description provided for @editEmployeeCompensationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage compensation via salary adjustment'**
  String get editEmployeeCompensationSubtitle;

  /// No description provided for @editEmployeeCompensationDescription.
  ///
  /// In en, this message translates to:
  /// **'Compensation changes for existing employees are applied through a salary adjustment. Open the adjustment flow to update salary components, effective dates, and related details.'**
  String get editEmployeeCompensationDescription;

  /// No description provided for @editEmployeeOpenSalaryAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Open salary adjustment'**
  String get editEmployeeOpenSalaryAdjustment;

  /// No description provided for @editEmployeeSalaryAdjustmentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Salary adjustment saved successfully'**
  String get editEmployeeSalaryAdjustmentSuccess;

  /// No description provided for @bulkCompensationAdjustmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Compensation Adjustments'**
  String get bulkCompensationAdjustmentsTitle;

  /// No description provided for @bulkCompensationAdjustmentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select multiple employees and apply comprehensive compensation changes with detailed component-level control'**
  String get bulkCompensationAdjustmentsDescription;

  /// No description provided for @bulkAdjustmentsComponentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Select rows to configure components'**
  String get bulkAdjustmentsComponentsEmptyTitle;

  /// No description provided for @bulkAdjustmentsComponentsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Select one or more rows in the list above to view and modify compensation components for bulk adjustments.'**
  String get bulkAdjustmentsComponentsEmptyMessage;

  /// No description provided for @bulkAdjustmentsComponentsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Compensation Components Management'**
  String get bulkAdjustmentsComponentsSectionTitle;

  /// No description provided for @bulkAdjustmentsComponentsSelectedEmployees.
  ///
  /// In en, this message translates to:
  /// **'{count} selected employees'**
  String bulkAdjustmentsComponentsSelectedEmployees(int count);

  /// No description provided for @bulkAdjustmentsComponentsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active components'**
  String bulkAdjustmentsComponentsActiveCount(int count);

  /// No description provided for @bulkAdjustmentsComponentsNoComponentsMessage.
  ///
  /// In en, this message translates to:
  /// **'No compensation components were returned for the selected employees.'**
  String get bulkAdjustmentsComponentsNoComponentsMessage;

  /// No description provided for @bulkAdjustmentsComponentsFetchError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load compensation components'**
  String get bulkAdjustmentsComponentsFetchError;

  /// No description provided for @bulkAdjustmentsComponentsMissingEmployeeIdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot load components'**
  String get bulkAdjustmentsComponentsMissingEmployeeIdsTitle;

  /// No description provided for @bulkAdjustmentsComponentsMissingEmployeeIdsMessage.
  ///
  /// In en, this message translates to:
  /// **'Selected rows are missing an employee identifier. Try another row or refresh the adjustments list.'**
  String get bulkAdjustmentsComponentsMissingEmployeeIdsMessage;

  /// No description provided for @bulkAdjustmentsNoChangesYet.
  ///
  /// In en, this message translates to:
  /// **'No Changes Yet'**
  String get bulkAdjustmentsNoChangesYet;

  /// No description provided for @bulkAdjustmentsCommonComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Existing Components (Common Across Selected Employees)'**
  String get bulkAdjustmentsCommonComponentsTitle;

  /// No description provided for @bulkAdjustmentsNoCommonComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No common components'**
  String get bulkAdjustmentsNoCommonComponentsTitle;

  /// No description provided for @bulkAdjustmentsNoCommonComponentsMessage.
  ///
  /// In en, this message translates to:
  /// **'The selected employees do not share any compensation components. Adjust your selection to continue.'**
  String get bulkAdjustmentsNoCommonComponentsMessage;

  /// No description provided for @bulkAdjustmentsDetailsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Details'**
  String get bulkAdjustmentsDetailsSectionTitle;

  /// No description provided for @bulkAdjustmentsCreateAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Create Adjustment'**
  String get bulkAdjustmentsCreateAdjustment;

  /// No description provided for @bulkAdjustmentsSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bulk adjustment submitted successfully'**
  String get bulkAdjustmentsSubmitSuccess;

  /// No description provided for @bulkAdjustmentsSubmitNoChanges.
  ///
  /// In en, this message translates to:
  /// **'Update at least one component before submitting'**
  String get bulkAdjustmentsSubmitNoChanges;

  /// No description provided for @bulkAdjustmentsValidationReasonCode.
  ///
  /// In en, this message translates to:
  /// **'Reason Code is required'**
  String get bulkAdjustmentsValidationReasonCode;

  /// No description provided for @bulkAdjustmentsValidationEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective Date is required'**
  String get bulkAdjustmentsValidationEffectiveDate;

  /// No description provided for @bulkAdjustmentsValidationBudgetCode.
  ///
  /// In en, this message translates to:
  /// **'Budget Code is required'**
  String get bulkAdjustmentsValidationBudgetCode;

  /// No description provided for @bulkAdjustmentsValidationJustification.
  ///
  /// In en, this message translates to:
  /// **'Justification is required'**
  String get bulkAdjustmentsValidationJustification;

  /// No description provided for @bulkAdjustmentsEffectiveDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Effective Date'**
  String get bulkAdjustmentsEffectiveDateLabel;

  /// No description provided for @bulkAdjustmentsReasonCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason Code'**
  String get bulkAdjustmentsReasonCodeLabel;

  /// No description provided for @bulkAdjustmentsBudgetCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Code'**
  String get bulkAdjustmentsBudgetCodeLabel;

  /// No description provided for @bulkAdjustmentsEffectiveDateHint.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get bulkAdjustmentsEffectiveDateHint;

  /// No description provided for @bulkAdjustmentsSelectReasonCode.
  ///
  /// In en, this message translates to:
  /// **'Select Reason Code'**
  String get bulkAdjustmentsSelectReasonCode;

  /// No description provided for @bulkAdjustmentsSelectBudgetCode.
  ///
  /// In en, this message translates to:
  /// **'Select Budget Code'**
  String get bulkAdjustmentsSelectBudgetCode;

  /// No description provided for @bulkAdjustmentsJustificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Justification / Business Case'**
  String get bulkAdjustmentsJustificationLabel;

  /// No description provided for @bulkAdjustmentsJustificationHint.
  ///
  /// In en, this message translates to:
  /// **'Provide detailed justification for this bulk salary adjustment including performance metrics, market data, or retention risk.'**
  String get bulkAdjustmentsJustificationHint;

  /// No description provided for @bulkAdjustmentsApplyToAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply to all selected employees'**
  String get bulkAdjustmentsApplyToAllTitle;

  /// No description provided for @bulkAdjustmentsEmployeeBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee breakdown'**
  String get bulkAdjustmentsEmployeeBreakdownTitle;

  /// No description provided for @bulkAdjustmentsEmployeeBreakdownCount.
  ///
  /// In en, this message translates to:
  /// **'{count} employees'**
  String bulkAdjustmentsEmployeeBreakdownCount(int count);

  /// No description provided for @bulkAdjustmentsManualUniformAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Manual entry sets the same new amount for every employee. Current amounts differ — use Percentage or Amount instead.'**
  String get bulkAdjustmentsManualUniformAmountHint;

  /// No description provided for @bulkAdjustmentsPreviewEmployeeColumn.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get bulkAdjustmentsPreviewEmployeeColumn;

  /// No description provided for @bulkAdjustmentsPreviewCurrentColumn.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get bulkAdjustmentsPreviewCurrentColumn;

  /// No description provided for @bulkAdjustmentsNewComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Components'**
  String get bulkAdjustmentsNewComponentsTitle;

  /// No description provided for @bulkAdjustmentsNewComponentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select components from eligible plans shared across all selected employees.'**
  String get bulkAdjustmentsNewComponentsSubtitle;

  /// No description provided for @bulkAdjustmentsAddComponentFromPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Component from Plan'**
  String get bulkAdjustmentsAddComponentFromPlanLabel;

  /// No description provided for @bulkAdjustmentsSelectPlanHint.
  ///
  /// In en, this message translates to:
  /// **'Select a plan...'**
  String get bulkAdjustmentsSelectPlanHint;

  /// No description provided for @bulkAdjustmentsAddComponentsButton.
  ///
  /// In en, this message translates to:
  /// **'Add Components'**
  String get bulkAdjustmentsAddComponentsButton;

  /// No description provided for @bulkAdjustmentsAllPlanComponentsAdded.
  ///
  /// In en, this message translates to:
  /// **'All components from this plan have already been added.'**
  String get bulkAdjustmentsAllPlanComponentsAdded;

  /// No description provided for @bulkAdjustmentsEligiblePlansLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading eligible plans...'**
  String get bulkAdjustmentsEligiblePlansLoading;

  /// No description provided for @compensationAdjustmentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Type'**
  String get compensationAdjustmentTypeLabel;

  /// No description provided for @compensationAdjustmentValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get compensationAdjustmentValueLabel;

  /// No description provided for @compensationAdjustmentNewAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'NEW AMOUNT'**
  String get compensationAdjustmentNewAmountLabel;

  /// No description provided for @compensationAdjustmentCurrentAmount.
  ///
  /// In en, this message translates to:
  /// **'Current: {amount}'**
  String compensationAdjustmentCurrentAmount(String amount);

  /// No description provided for @compensationAdjustmentRemoveComponent.
  ///
  /// In en, this message translates to:
  /// **'Remove Component'**
  String get compensationAdjustmentRemoveComponent;

  /// No description provided for @compensationAdjustmentMethodLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading adjustment methods...'**
  String get compensationAdjustmentMethodLoading;

  /// No description provided for @compensationAdjustmentValueHintPercentage.
  ///
  /// In en, this message translates to:
  /// **'Enter percentage value'**
  String get compensationAdjustmentValueHintPercentage;

  /// No description provided for @compensationAdjustmentValueHintCurrency.
  ///
  /// In en, this message translates to:
  /// **'Enter value in {currency}'**
  String compensationAdjustmentValueHintCurrency(String currency);

  /// No description provided for @compensationAdjustmentValueHintDefault.
  ///
  /// In en, this message translates to:
  /// **'Enter value...'**
  String get compensationAdjustmentValueHintDefault;

  /// No description provided for @editEmployeeSalaryAdjustmentOpenedInNewTab.
  ///
  /// In en, this message translates to:
  /// **'Salary adjustment opened in a new tab. Complete it there, then return to this dialog.'**
  String get editEmployeeSalaryAdjustmentOpenedInNewTab;

  /// No description provided for @editEmployeeAssignedComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assigned Compensation Components'**
  String get editEmployeeAssignedComponentsTitle;

  /// No description provided for @editEmployeeAssignedComponentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current Compensation Components'**
  String get editEmployeeAssignedComponentsSubtitle;

  /// No description provided for @editEmployeeAssignedComponentsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active components'**
  String editEmployeeAssignedComponentsActiveCount(int count);

  /// No description provided for @editEmployeeNoAssignedComponentsMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no compensation components assigned to this employee.'**
  String get editEmployeeNoAssignedComponentsMessage;

  /// No description provided for @compensationComponentName.
  ///
  /// In en, this message translates to:
  /// **'Component Name'**
  String get compensationComponentName;

  /// No description provided for @compensationFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get compensationFrequency;

  /// No description provided for @compensationCurrentAmount.
  ///
  /// In en, this message translates to:
  /// **'Current Amount'**
  String get compensationCurrentAmount;

  /// No description provided for @compensationAnnualValue.
  ///
  /// In en, this message translates to:
  /// **'Annual Value'**
  String get compensationAnnualValue;

  /// No description provided for @basicSalaryKwd.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary (KWD)'**
  String get basicSalaryKwd;

  /// No description provided for @compensationStartDate.
  ///
  /// In en, this message translates to:
  /// **'Compensation Start Date'**
  String get compensationStartDate;

  /// No description provided for @compensationEndDate.
  ///
  /// In en, this message translates to:
  /// **'Compensation End Date'**
  String get compensationEndDate;

  /// No description provided for @pleaseSelectCompensationStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a compensation start date.'**
  String get pleaseSelectCompensationStartDate;

  /// No description provided for @compensationEndDateBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Compensation end date must be on or after the start date.'**
  String get compensationEndDateBeforeStart;

  /// No description provided for @compensationPeriod.
  ///
  /// In en, this message translates to:
  /// **'Compensation Period'**
  String get compensationPeriod;

  /// No description provided for @allowances.
  ///
  /// In en, this message translates to:
  /// **'Allowances'**
  String get allowances;

  /// No description provided for @housingAllowanceKwd.
  ///
  /// In en, this message translates to:
  /// **'Housing Allowance (KWD)'**
  String get housingAllowanceKwd;

  /// No description provided for @transportationKwd.
  ///
  /// In en, this message translates to:
  /// **'Transportation (KWD)'**
  String get transportationKwd;

  /// No description provided for @foodAllowanceKwd.
  ///
  /// In en, this message translates to:
  /// **'Food Allowance (KWD)'**
  String get foodAllowanceKwd;

  /// No description provided for @mobileAllowanceKwd.
  ///
  /// In en, this message translates to:
  /// **'Mobile Allowance (KWD)'**
  String get mobileAllowanceKwd;

  /// No description provided for @otherAllowancesKwd.
  ///
  /// In en, this message translates to:
  /// **'Other Allowances (KWD)'**
  String get otherAllowancesKwd;

  /// No description provided for @totalMonthlyCompensation.
  ///
  /// In en, this message translates to:
  /// **'Total Monthly Compensation'**
  String get totalMonthlyCompensation;

  /// No description provided for @annualKwd.
  ///
  /// In en, this message translates to:
  /// **'Annual: {value} KWD'**
  String annualKwd(String value);

  /// No description provided for @hintEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get hintEnterAmount;

  /// No description provided for @bankingInformation.
  ///
  /// In en, this message translates to:
  /// **'Banking Information'**
  String get bankingInformation;

  /// No description provided for @bankingInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bank account details for salary transfer'**
  String get bankingInformationSubtitle;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @hintBankName.
  ///
  /// In en, this message translates to:
  /// **'Enter bank name'**
  String get hintBankName;

  /// No description provided for @hintSelectBank.
  ///
  /// In en, this message translates to:
  /// **'Select bank'**
  String get hintSelectBank;

  /// No description provided for @hintAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter account number'**
  String get hintAccountNumber;

  /// No description provided for @hintIban.
  ///
  /// In en, this message translates to:
  /// **'e.g. KW81CBKU0000000000001234560101'**
  String get hintIban;

  /// No description provided for @invalidIban.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid IBAN'**
  String get invalidIban;

  /// No description provided for @documentsAndCompliance.
  ///
  /// In en, this message translates to:
  /// **'Documents & Compliance'**
  String get documentsAndCompliance;

  /// No description provided for @documentsAndComplianceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Document expiry dates and compliance tracking'**
  String get documentsAndComplianceSubtitle;

  /// No description provided for @documentExpiryDates.
  ///
  /// In en, this message translates to:
  /// **'Document Expiry Dates'**
  String get documentExpiryDates;

  /// No description provided for @noDocumentsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No document available'**
  String get noDocumentsAvailable;

  /// No description provided for @civilIdExpiry.
  ///
  /// In en, this message translates to:
  /// **'Civil ID Expiry'**
  String get civilIdExpiry;

  /// No description provided for @passportExpiry.
  ///
  /// In en, this message translates to:
  /// **'Passport Expiry'**
  String get passportExpiry;

  /// No description provided for @visaNumber.
  ///
  /// In en, this message translates to:
  /// **'Visa Number'**
  String get visaNumber;

  /// No description provided for @visaExpiry.
  ///
  /// In en, this message translates to:
  /// **'Visa Expiry'**
  String get visaExpiry;

  /// No description provided for @workPermitNumber.
  ///
  /// In en, this message translates to:
  /// **'Work Permit Number'**
  String get workPermitNumber;

  /// No description provided for @workPermitExpiry.
  ///
  /// In en, this message translates to:
  /// **'Work Permit Expiry'**
  String get workPermitExpiry;

  /// No description provided for @hintSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get hintSelectDate;

  /// No description provided for @hintVisaNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter visa number'**
  String get hintVisaNumber;

  /// No description provided for @hintWorkPermitNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter work permit number'**
  String get hintWorkPermitNumber;

  /// No description provided for @reviewAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get reviewAndConfirm;

  /// No description provided for @reviewAndConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review all information before creating the employee record'**
  String get reviewAndConfirmSubtitle;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @employmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Employment Details'**
  String get employmentDetails;

  /// No description provided for @reviewName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get reviewName;

  /// No description provided for @reviewDob.
  ///
  /// In en, this message translates to:
  /// **'DOB'**
  String get reviewDob;

  /// No description provided for @reviewBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get reviewBank;

  /// No description provided for @reviewAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get reviewAccount;

  /// No description provided for @reviewTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reviewTotal;

  /// No description provided for @reviewProbation.
  ///
  /// In en, this message translates to:
  /// **'Probation'**
  String get reviewProbation;

  /// No description provided for @reviewPermanent.
  ///
  /// In en, this message translates to:
  /// **'Permanent'**
  String get reviewPermanent;

  /// No description provided for @addEmployeeStepContentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Content for this step coming soon.'**
  String get addEmployeeStepContentPlaceholder;

  /// No description provided for @addEmployeeFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields.'**
  String get addEmployeeFillRequiredFields;

  /// No description provided for @addEmployeeCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Employee created successfully.'**
  String get addEmployeeCreatedSuccess;

  /// No description provided for @newHiresThisMonth.
  ///
  /// In en, this message translates to:
  /// **'New This Month'**
  String get newHiresThisMonth;

  /// No description provided for @employeeStatDescriptionAll.
  ///
  /// In en, this message translates to:
  /// **'All employees in organization'**
  String get employeeStatDescriptionAll;

  /// No description provided for @employeeStatDescriptionActive.
  ///
  /// In en, this message translates to:
  /// **'Currently active'**
  String get employeeStatDescriptionActive;

  /// No description provided for @employeeStatDescriptionDepartments.
  ///
  /// In en, this message translates to:
  /// **'Across organization'**
  String get employeeStatDescriptionDepartments;

  /// No description provided for @employeeStatDescriptionNewHires.
  ///
  /// In en, this message translates to:
  /// **'Joined this month'**
  String get employeeStatDescriptionNewHires;

  /// No description provided for @onProbation.
  ///
  /// In en, this message translates to:
  /// **'On Probation'**
  String get onProbation;

  /// No description provided for @advancedFilters.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFilters;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @employeeStatus.
  ///
  /// In en, this message translates to:
  /// **'Employee Status'**
  String get employeeStatus;

  /// No description provided for @selectEmployeeStatus.
  ///
  /// In en, this message translates to:
  /// **'Select employee status'**
  String get selectEmployeeStatus;

  /// No description provided for @allPositions.
  ///
  /// In en, this message translates to:
  /// **'All Positions'**
  String get allPositions;

  /// No description provided for @allWorkforceStructures.
  ///
  /// In en, this message translates to:
  /// **'All Workforce Structures'**
  String get allWorkforceStructures;

  /// No description provided for @allJobFamilies.
  ///
  /// In en, this message translates to:
  /// **'All Job Families'**
  String get allJobFamilies;

  /// No description provided for @allJobLevels.
  ///
  /// In en, this message translates to:
  /// **'All Job Levels'**
  String get allJobLevels;

  /// No description provided for @allGrades.
  ///
  /// In en, this message translates to:
  /// **'All Grades'**
  String get allGrades;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @payroll.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payroll;

  /// No description provided for @payrollPersonResults.
  ///
  /// In en, this message translates to:
  /// **'Person Results'**
  String get payrollPersonResults;

  /// No description provided for @payrollPersonResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll Results · {enterpriseName}'**
  String payrollPersonResultsSubtitle(String enterpriseName);

  /// No description provided for @payrollPersonResultsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by Name, Business Title, Work Email, or Person Number'**
  String get payrollPersonResultsSearchHint;

  /// No description provided for @payrollPersonResultsBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Title'**
  String get payrollPersonResultsBusinessTitle;

  /// No description provided for @payrollPersonResultsAssignmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Assignment Status'**
  String get payrollPersonResultsAssignmentStatus;

  /// No description provided for @payrollPersonResultsEffectiveAsOfDate.
  ///
  /// In en, this message translates to:
  /// **'Effective As-of Date'**
  String get payrollPersonResultsEffectiveAsOfDate;

  /// No description provided for @payrollPersonResultsIncludeTerminated.
  ///
  /// In en, this message translates to:
  /// **'Include Terminated Work Relationships'**
  String get payrollPersonResultsIncludeTerminated;

  /// No description provided for @payrollPersonResultsTerminationDate.
  ///
  /// In en, this message translates to:
  /// **'Termination Date'**
  String get payrollPersonResultsTerminationDate;

  /// No description provided for @payrollPersonResultsWorkerType.
  ///
  /// In en, this message translates to:
  /// **'Worker Type'**
  String get payrollPersonResultsWorkerType;

  /// No description provided for @payrollPersonResultsRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} records found'**
  String payrollPersonResultsRecordsFound(int count);

  /// No description provided for @payrollPersonResultsTableFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Filter employees...'**
  String get payrollPersonResultsTableFilterHint;

  /// No description provided for @payrollPersonResultsSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get payrollPersonResultsSortBy;

  /// No description provided for @payrollPersonResultsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get payrollPersonResultsName;

  /// No description provided for @payrollPersonResultsPersonNumber.
  ///
  /// In en, this message translates to:
  /// **'Person Number'**
  String get payrollPersonResultsPersonNumber;

  /// No description provided for @payrollPersonResultsAssignmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Assignment Number'**
  String get payrollPersonResultsAssignmentNumber;

  /// No description provided for @payrollPersonResultsWorkEmail.
  ///
  /// In en, this message translates to:
  /// **'Work Email'**
  String get payrollPersonResultsWorkEmail;

  /// No description provided for @payrollPersonResultsWorkPhone.
  ///
  /// In en, this message translates to:
  /// **'Work Phone'**
  String get payrollPersonResultsWorkPhone;

  /// No description provided for @payrollPersonResultsNoEmployeesFound.
  ///
  /// In en, this message translates to:
  /// **'No Employees Found'**
  String get payrollPersonResultsNoEmployeesFound;

  /// No description provided for @payrollPersonResultsNoEmployeesMessage.
  ///
  /// In en, this message translates to:
  /// **'No employees match your search or filters.'**
  String get payrollPersonResultsNoEmployeesMessage;

  /// No description provided for @payrollPersonResultsDetailUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Employee detail view is under development'**
  String get payrollPersonResultsDetailUnderDevelopment;

  /// No description provided for @payrollPersonResultsProcessResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll Process Results'**
  String get payrollPersonResultsProcessResultsTitle;

  /// No description provided for @payrollPersonResultsTasksSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks · {period}'**
  String payrollPersonResultsTasksSummary(int count, String period);

  /// No description provided for @payrollPersonResultsTaskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get payrollPersonResultsTaskName;

  /// No description provided for @payrollPersonResultsFlowName.
  ///
  /// In en, this message translates to:
  /// **'Flow Name'**
  String get payrollPersonResultsFlowName;

  /// No description provided for @payrollPersonResultsProcessDate.
  ///
  /// In en, this message translates to:
  /// **'Process Date'**
  String get payrollPersonResultsProcessDate;

  /// No description provided for @payrollPersonResultsPayrollColumn.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payrollPersonResultsPayrollColumn;

  /// No description provided for @payrollPersonResultsPayrollPeriod.
  ///
  /// In en, this message translates to:
  /// **'Payroll Period'**
  String get payrollPersonResultsPayrollPeriod;

  /// No description provided for @payrollPersonResultsTaskStatusComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get payrollPersonResultsTaskStatusComplete;

  /// No description provided for @payrollPersonResultsTaskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get payrollPersonResultsTaskStatusInProgress;

  /// No description provided for @payrollPersonResultsNoTasksFound.
  ///
  /// In en, this message translates to:
  /// **'No Tasks Found'**
  String get payrollPersonResultsNoTasksFound;

  /// No description provided for @payrollPersonResultsNoTasksMessage.
  ///
  /// In en, this message translates to:
  /// **'No payroll process results are available for this employee.'**
  String get payrollPersonResultsNoTasksMessage;

  /// No description provided for @payrollPersonResultsTaskInformation.
  ///
  /// In en, this message translates to:
  /// **'Task Information'**
  String get payrollPersonResultsTaskInformation;

  /// No description provided for @payrollPersonResultsEmployeeInformation.
  ///
  /// In en, this message translates to:
  /// **'Employee Information'**
  String get payrollPersonResultsEmployeeInformation;

  /// No description provided for @payrollPersonResultsArchiveResultDetails.
  ///
  /// In en, this message translates to:
  /// **'Archive Result Details'**
  String get payrollPersonResultsArchiveResultDetails;

  /// No description provided for @payrollPersonResultsArchiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Archive Status'**
  String get payrollPersonResultsArchiveStatus;

  /// No description provided for @payrollPersonResultsRecordsArchived.
  ///
  /// In en, this message translates to:
  /// **'Records Archived'**
  String get payrollPersonResultsRecordsArchived;

  /// No description provided for @payrollPersonResultsArchiveDate.
  ///
  /// In en, this message translates to:
  /// **'Archive Date'**
  String get payrollPersonResultsArchiveDate;

  /// No description provided for @payrollPersonResultsTaskNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get payrollPersonResultsTaskNotFound;

  /// No description provided for @payrollPersonResultsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get payrollPersonResultsComingSoon;

  /// No description provided for @payrollPersonResultsUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Person results listing is under development'**
  String get payrollPersonResultsUnderDevelopment;

  /// No description provided for @payrollPersonResultsTaskDetailProcess.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get payrollPersonResultsTaskDetailProcess;

  /// No description provided for @payrollPersonResultsTaskDetailAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get payrollPersonResultsTaskDetailAssignment;

  /// No description provided for @payrollPersonResultsTaskDetailCalculation.
  ///
  /// In en, this message translates to:
  /// **'Calculation'**
  String get payrollPersonResultsTaskDetailCalculation;

  /// No description provided for @payrollPersonResultsDownloadToExcel.
  ///
  /// In en, this message translates to:
  /// **'Download to Excel'**
  String get payrollPersonResultsDownloadToExcel;

  /// No description provided for @payrollPersonResultsPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get payrollPersonResultsPrint;

  /// No description provided for @payrollPersonResultsTaskDetailProcessDetails.
  ///
  /// In en, this message translates to:
  /// **'Process Details'**
  String get payrollPersonResultsTaskDetailProcessDetails;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveResults.
  ///
  /// In en, this message translates to:
  /// **'Archive Results'**
  String get payrollPersonResultsTaskDetailArchiveResults;

  /// No description provided for @payrollPersonResultsTaskDetailMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get payrollPersonResultsTaskDetailMessages;

  /// No description provided for @payrollPersonResultsTaskDetailTotalMessages.
  ///
  /// In en, this message translates to:
  /// **'Total Messages'**
  String get payrollPersonResultsTaskDetailTotalMessages;

  /// No description provided for @payrollPersonResultsTaskDetailTotalMessagesValue.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get payrollPersonResultsTaskDetailTotalMessagesValue;

  /// No description provided for @payrollPersonResultsTaskDetailWarnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get payrollPersonResultsTaskDetailWarnings;

  /// No description provided for @payrollPersonResultsTaskDetailWarningsValue.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get payrollPersonResultsTaskDetailWarningsValue;

  /// No description provided for @payrollPersonResultsTaskDetailErrors.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get payrollPersonResultsTaskDetailErrors;

  /// No description provided for @payrollPersonResultsTaskDetailErrorsValue.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get payrollPersonResultsTaskDetailErrorsValue;

  /// No description provided for @payrollPersonResultsTaskDetailInformational.
  ///
  /// In en, this message translates to:
  /// **'Informational'**
  String get payrollPersonResultsTaskDetailInformational;

  /// No description provided for @payrollPersonResultsTaskDetailInformationalValue.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get payrollPersonResultsTaskDetailInformationalValue;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by message text'**
  String get payrollPersonResultsTaskDetailMessagesSearchHint;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get payrollPersonResultsTaskDetailMessagesInformation;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get payrollPersonResultsTaskDetailMessagesWarning;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get payrollPersonResultsTaskDetailMessagesError;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesMessageText.
  ///
  /// In en, this message translates to:
  /// **'Message Text'**
  String get payrollPersonResultsTaskDetailMessagesMessageText;

  /// No description provided for @payrollPersonResultsTaskDetailDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get payrollPersonResultsTaskDetailDetails;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesCalculatePayrollTask.
  ///
  /// In en, this message translates to:
  /// **'Calculate Payroll'**
  String get payrollPersonResultsTaskDetailMessagesCalculatePayrollTask;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOff.
  ///
  /// In en, this message translates to:
  /// **'The deduction amount for the Leave Salary Write Off KW Calculator element wasn\'t populated. Enter a deduction amount to process the deduction.'**
  String get payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOff;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkipped.
  ///
  /// In en, this message translates to:
  /// **'No absence exists in the current month. Leave Salary Basic KW calculation skipped.'**
  String get payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkipped;

  /// No description provided for @payrollPersonResultsTaskDetailMessageNrvRecoveryZero.
  ///
  /// In en, this message translates to:
  /// **'NRV Basic Salary Recovery KW: Recovery amount is zero. Verify the loan balance or recovery setup for this employee.'**
  String get payrollPersonResultsTaskDetailMessageNrvRecoveryZero;

  /// No description provided for @payrollPersonResultsTaskDetailMessageAirTicketInfo.
  ///
  /// In en, this message translates to:
  /// **'Air Ticket Information KW: Ticket class set to ECONOMY. No cash encashment processed for this period.'**
  String get payrollPersonResultsTaskDetailMessageAirTicketInfo;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String payrollPersonResultsTaskDetailMessagesCount(int count);

  /// No description provided for @payrollPersonResultsTaskDetailMessagesFooterWarnings.
  ///
  /// In en, this message translates to:
  /// **'{count} Warnings'**
  String payrollPersonResultsTaskDetailMessagesFooterWarnings(int count);

  /// No description provided for @payrollPersonResultsTaskDetailMessagesFooterErrors.
  ///
  /// In en, this message translates to:
  /// **'{count} Errors'**
  String payrollPersonResultsTaskDetailMessagesFooterErrors(int count);

  /// No description provided for @payrollPersonResultsTaskDetailMessagesFooterInfo.
  ///
  /// In en, this message translates to:
  /// **'{count} Info'**
  String payrollPersonResultsTaskDetailMessagesFooterInfo(int count);

  /// No description provided for @payrollPersonResultsTaskDetailMessagesPayrollElement.
  ///
  /// In en, this message translates to:
  /// **'Payroll Element'**
  String get payrollPersonResultsTaskDetailMessagesPayrollElement;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesProcessTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Process Timestamp'**
  String get payrollPersonResultsTaskDetailMessagesProcessTimestamp;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesFormulaTrace.
  ///
  /// In en, this message translates to:
  /// **'Formula Trace'**
  String get payrollPersonResultsTaskDetailMessagesFormulaTrace;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesSuggestedResolution.
  ///
  /// In en, this message translates to:
  /// **'Suggested Resolution'**
  String get payrollPersonResultsTaskDetailMessagesSuggestedResolution;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesExpandedTitle.
  ///
  /// In en, this message translates to:
  /// **'{severity} — {taskName}'**
  String payrollPersonResultsTaskDetailMessagesExpandedTitle(
    String severity,
    String taskName,
  );

  /// No description provided for @payrollPersonResultsTaskDetailMessagesProcessTimestampValue.
  ///
  /// In en, this message translates to:
  /// **'28 Dec 2025, 14:32:07'**
  String get payrollPersonResultsTaskDetailMessagesProcessTimestampValue;

  /// No description provided for @payrollPersonResultsTaskDetailMessagesPayrollRelationshipValue.
  ///
  /// In en, this message translates to:
  /// **'KHURAM KHALID PERVAIZ SHAHZAD – E8308'**
  String get payrollPersonResultsTaskDetailMessagesPayrollRelationshipValue;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffElement.
  ///
  /// In en, this message translates to:
  /// **'Leave Salary Write Off KW'**
  String get payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffElement;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffFormulaTrace.
  ///
  /// In en, this message translates to:
  /// **'FORMULA_LEAVE_WRITEOFF_KW → DEDUCTION_AMOUNT → NULL → Warning raised at step 3'**
  String
  get payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffFormulaTrace;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffResolution.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Element Entries and ensure the deduction amount for Leave Salary Write Off KW is populated for the current payroll period before reprocessing.'**
  String get payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffResolution;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedElement.
  ///
  /// In en, this message translates to:
  /// **'Leave Salary Basic KW'**
  String
  get payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedElement;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedFormulaTrace.
  ///
  /// In en, this message translates to:
  /// **'FORMULA_LEAVE_BASIC_KW → ABSENCE_CHECK → NO_ABSENCE → Information logged at step 2'**
  String
  get payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedFormulaTrace;

  /// No description provided for @payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedResolution.
  ///
  /// In en, this message translates to:
  /// **'No action required. Leave Salary Basic KW is skipped when no absence exists in the current month.'**
  String
  get payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedResolution;

  /// No description provided for @payrollPersonResultsTaskDetailMessageNrvRecoveryZeroElement.
  ///
  /// In en, this message translates to:
  /// **'NRV Basic Salary Recovery KW'**
  String get payrollPersonResultsTaskDetailMessageNrvRecoveryZeroElement;

  /// No description provided for @payrollPersonResultsTaskDetailMessageNrvRecoveryZeroFormulaTrace.
  ///
  /// In en, this message translates to:
  /// **'FORMULA_NRV_RECOVERY_KW → LOAN_BALANCE → ZERO → Warning raised at step 4'**
  String get payrollPersonResultsTaskDetailMessageNrvRecoveryZeroFormulaTrace;

  /// No description provided for @payrollPersonResultsTaskDetailMessageNrvRecoveryZeroResolution.
  ///
  /// In en, this message translates to:
  /// **'Verify the employee loan balance and recovery setup in Element Entries before reprocessing payroll.'**
  String get payrollPersonResultsTaskDetailMessageNrvRecoveryZeroResolution;

  /// No description provided for @payrollPersonResultsTaskDetailMessageAirTicketInfoElement.
  ///
  /// In en, this message translates to:
  /// **'Air Ticket Information KW'**
  String get payrollPersonResultsTaskDetailMessageAirTicketInfoElement;

  /// No description provided for @payrollPersonResultsTaskDetailMessageAirTicketInfoFormulaTrace.
  ///
  /// In en, this message translates to:
  /// **'FORMULA_AIR_TICKET_KW → TICKET_CLASS → ECONOMY → Information logged at step 1'**
  String get payrollPersonResultsTaskDetailMessageAirTicketInfoFormulaTrace;

  /// No description provided for @payrollPersonResultsTaskDetailMessageAirTicketInfoResolution.
  ///
  /// In en, this message translates to:
  /// **'No action required. Air ticket class is set to ECONOMY and no cash encashment was processed for this period.'**
  String get payrollPersonResultsTaskDetailMessageAirTicketInfoResolution;

  /// No description provided for @payrollPersonResultsTaskStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get payrollPersonResultsTaskStatusCompleted;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollRunStatus.
  ///
  /// In en, this message translates to:
  /// **'Payroll Run Status'**
  String get payrollPersonResultsTaskDetailPayrollRunStatus;

  /// No description provided for @payrollPersonResultsTaskDetailNetPay.
  ///
  /// In en, this message translates to:
  /// **'Net Pay'**
  String get payrollPersonResultsTaskDetailNetPay;

  /// No description provided for @payrollPersonResultsTaskDetailProcessType.
  ///
  /// In en, this message translates to:
  /// **'Process Type'**
  String get payrollPersonResultsTaskDetailProcessType;

  /// No description provided for @payrollPersonResultsTaskDetailProcessTypeRegularNormal.
  ///
  /// In en, this message translates to:
  /// **'Regular Normal'**
  String get payrollPersonResultsTaskDetailProcessTypeRegularNormal;

  /// No description provided for @payrollPersonResultsTaskDetailProcessOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll Process Overview'**
  String get payrollPersonResultsTaskDetailProcessOverviewTitle;

  /// No description provided for @payrollPersonResultsTaskDetailProcessOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll execution and processing information'**
  String get payrollPersonResultsTaskDetailProcessOverviewSubtitle;

  /// No description provided for @payrollPersonResultsTaskDetailExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get payrollPersonResultsTaskDetailExportPdf;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollFlow.
  ///
  /// In en, this message translates to:
  /// **'Payroll Flow'**
  String get payrollPersonResultsTaskDetailPayrollFlow;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollFlowSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary {period}'**
  String payrollPersonResultsTaskDetailPayrollFlowSalary(String period);

  /// No description provided for @payrollPersonResultsTaskDetailStatutoryPeriod.
  ///
  /// In en, this message translates to:
  /// **'Statutory Period'**
  String get payrollPersonResultsTaskDetailStatutoryPeriod;

  /// No description provided for @payrollPersonResultsTaskDetailStatutoryPeriodValue.
  ///
  /// In en, this message translates to:
  /// **'12'**
  String get payrollPersonResultsTaskDetailStatutoryPeriodValue;

  /// No description provided for @payrollPersonResultsTaskDetailPeriodEndDate.
  ///
  /// In en, this message translates to:
  /// **'Period End Date'**
  String get payrollPersonResultsTaskDetailPeriodEndDate;

  /// No description provided for @payrollPersonResultsTaskDetailProcessConfigurationGroup.
  ///
  /// In en, this message translates to:
  /// **'Process Configuration Group'**
  String get payrollPersonResultsTaskDetailProcessConfigurationGroup;

  /// No description provided for @payrollPersonResultsTaskDetailProcessConfigurationGroupValue.
  ///
  /// In en, this message translates to:
  /// **'Standard Payroll Config'**
  String get payrollPersonResultsTaskDetailProcessConfigurationGroupValue;

  /// No description provided for @payrollPersonResultsTaskDetailDateEarned.
  ///
  /// In en, this message translates to:
  /// **'Date Earned'**
  String get payrollPersonResultsTaskDetailDateEarned;

  /// No description provided for @payrollPersonResultsTaskDetailConsolidationGroup.
  ///
  /// In en, this message translates to:
  /// **'Consolidation Group'**
  String get payrollPersonResultsTaskDetailConsolidationGroup;

  /// No description provided for @payrollPersonResultsTaskDetailConsolidationGroupValue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Payroll'**
  String get payrollPersonResultsTaskDetailConsolidationGroupValue;

  /// No description provided for @payrollPersonResultsTaskDetailRunType.
  ///
  /// In en, this message translates to:
  /// **'Run Type'**
  String get payrollPersonResultsTaskDetailRunType;

  /// No description provided for @payrollPersonResultsTaskDetailPeriodName.
  ///
  /// In en, this message translates to:
  /// **'Period Name'**
  String get payrollPersonResultsTaskDetailPeriodName;

  /// No description provided for @payrollPersonResultsTaskDetailPeriodNameValue.
  ///
  /// In en, this message translates to:
  /// **'12 {period} Monthly Calendar'**
  String payrollPersonResultsTaskDetailPeriodNameValue(String period);

  /// No description provided for @payrollPersonResultsTaskDetailPeriodStartDate.
  ///
  /// In en, this message translates to:
  /// **'Period Start Date'**
  String get payrollPersonResultsTaskDetailPeriodStartDate;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollRelationshipNumber.
  ///
  /// In en, this message translates to:
  /// **'Payroll Relationship Number'**
  String get payrollPersonResultsTaskDetailPayrollRelationshipNumber;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollRelationshipNumberValue.
  ///
  /// In en, this message translates to:
  /// **'8308'**
  String get payrollPersonResultsTaskDetailPayrollRelationshipNumberValue;

  /// No description provided for @payrollPersonResultsTaskDetailPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payrollPersonResultsTaskDetailPaymentMethod;

  /// No description provided for @payrollPersonResultsTaskDetailPaymentMethodValue.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get payrollPersonResultsTaskDetailPaymentMethodValue;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll Timeline'**
  String get payrollPersonResultsTaskDetailPayrollTimelineTitle;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Payroll Submitted'**
  String get payrollPersonResultsTaskDetailTimelineSubmitted;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineSubmittedDate.
  ///
  /// In en, this message translates to:
  /// **'28 Nov 2025'**
  String get payrollPersonResultsTaskDetailTimelineSubmittedDate;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineCalculated.
  ///
  /// In en, this message translates to:
  /// **'Payroll Calculated'**
  String get payrollPersonResultsTaskDetailTimelineCalculated;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineCalculatedDate.
  ///
  /// In en, this message translates to:
  /// **'28 Dec 2025'**
  String get payrollPersonResultsTaskDetailTimelineCalculatedDate;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineCostingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Costing Completed'**
  String get payrollPersonResultsTaskDetailTimelineCostingCompleted;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineCostingCompletedDate.
  ///
  /// In en, this message translates to:
  /// **'29 Dec 2025'**
  String get payrollPersonResultsTaskDetailTimelineCostingCompletedDate;

  /// No description provided for @payrollPersonResultsTaskDetailTimelinePayslipGenerated.
  ///
  /// In en, this message translates to:
  /// **'Payslip Generated'**
  String get payrollPersonResultsTaskDetailTimelinePayslipGenerated;

  /// No description provided for @payrollPersonResultsTaskDetailTimelinePayslipGeneratedDate.
  ///
  /// In en, this message translates to:
  /// **'30 Dec 2025'**
  String get payrollPersonResultsTaskDetailTimelinePayslipGeneratedDate;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineArchived.
  ///
  /// In en, this message translates to:
  /// **'Payroll Archived'**
  String get payrollPersonResultsTaskDetailTimelineArchived;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineArchivedDate.
  ///
  /// In en, this message translates to:
  /// **'31 Dec 2025'**
  String get payrollPersonResultsTaskDetailTimelineArchivedDate;

  /// No description provided for @payrollPersonResultsTaskDetailRateDetailsHours.
  ///
  /// In en, this message translates to:
  /// **'Rate Details : Hours'**
  String get payrollPersonResultsTaskDetailRateDetailsHours;

  /// No description provided for @payrollPersonResultsTaskDetailRateDetailsDays.
  ///
  /// In en, this message translates to:
  /// **'Rate Details : Days'**
  String get payrollPersonResultsTaskDetailRateDetailsDays;

  /// No description provided for @payrollPersonResultsTaskDetailElementName.
  ///
  /// In en, this message translates to:
  /// **'Element Name'**
  String get payrollPersonResultsTaskDetailElementName;

  /// No description provided for @payrollPersonResultsTaskDetailElementClassification.
  ///
  /// In en, this message translates to:
  /// **'Element Classification'**
  String get payrollPersonResultsTaskDetailElementClassification;

  /// No description provided for @payrollPersonResultsTaskDetailAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get payrollPersonResultsTaskDetailAmount;

  /// No description provided for @payrollPersonResultsTaskDetailRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get payrollPersonResultsTaskDetailRate;

  /// No description provided for @payrollPersonResultsTaskDetailHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get payrollPersonResultsTaskDetailHours;

  /// No description provided for @payrollPersonResultsTaskDetailDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get payrollPersonResultsTaskDetailDays;

  /// No description provided for @payrollPersonResultsTaskDetailElementBasicSalaryKw.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary KW'**
  String get payrollPersonResultsTaskDetailElementBasicSalaryKw;

  /// No description provided for @payrollPersonResultsTaskDetailElementHousingAllowanceKw.
  ///
  /// In en, this message translates to:
  /// **'Housing Allowance KW'**
  String get payrollPersonResultsTaskDetailElementHousingAllowanceKw;

  /// No description provided for @payrollPersonResultsTaskDetailClassificationEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get payrollPersonResultsTaskDetailClassificationEarnings;

  /// No description provided for @payrollPersonResultsTaskDetailClassificationAllowances.
  ///
  /// In en, this message translates to:
  /// **'Allowances'**
  String get payrollPersonResultsTaskDetailClassificationAllowances;

  /// No description provided for @payrollPersonResultsTaskDetailBasicSalaryAmount.
  ///
  /// In en, this message translates to:
  /// **'KWD 1,700.000'**
  String get payrollPersonResultsTaskDetailBasicSalaryAmount;

  /// No description provided for @payrollPersonResultsTaskDetailHousingAllowanceAmount.
  ///
  /// In en, this message translates to:
  /// **'KWD 300.000'**
  String get payrollPersonResultsTaskDetailHousingAllowanceAmount;

  /// No description provided for @payrollPersonResultsTaskDetailBasicSalaryHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'KWD 9.80/hr'**
  String get payrollPersonResultsTaskDetailBasicSalaryHourlyRate;

  /// No description provided for @payrollPersonResultsTaskDetailHousingAllowanceHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'KWD 1.73/hr'**
  String get payrollPersonResultsTaskDetailHousingAllowanceHourlyRate;

  /// No description provided for @payrollPersonResultsTaskDetailBasicSalaryHours.
  ///
  /// In en, this message translates to:
  /// **'173.33'**
  String get payrollPersonResultsTaskDetailBasicSalaryHours;

  /// No description provided for @payrollPersonResultsTaskDetailHousingAllowanceHours.
  ///
  /// In en, this message translates to:
  /// **'173.33'**
  String get payrollPersonResultsTaskDetailHousingAllowanceHours;

  /// No description provided for @payrollPersonResultsTaskDetailBasicSalaryDailyRate.
  ///
  /// In en, this message translates to:
  /// **'KWD 56.67/day'**
  String get payrollPersonResultsTaskDetailBasicSalaryDailyRate;

  /// No description provided for @payrollPersonResultsTaskDetailHousingAllowanceDailyRate.
  ///
  /// In en, this message translates to:
  /// **'KWD 10.00/day'**
  String get payrollPersonResultsTaskDetailHousingAllowanceDailyRate;

  /// No description provided for @payrollPersonResultsTaskDetailBasicSalaryDays.
  ///
  /// In en, this message translates to:
  /// **'30'**
  String get payrollPersonResultsTaskDetailBasicSalaryDays;

  /// No description provided for @payrollPersonResultsTaskDetailHousingAllowanceDays.
  ///
  /// In en, this message translates to:
  /// **'30'**
  String get payrollPersonResultsTaskDetailHousingAllowanceDays;

  /// No description provided for @payrollPersonResultsTaskDetailEarningsBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Earnings Breakdown'**
  String get payrollPersonResultsTaskDetailEarningsBreakdown;

  /// No description provided for @payrollPersonResultsTaskDetailBasicSalary.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary'**
  String get payrollPersonResultsTaskDetailBasicSalary;

  /// No description provided for @payrollPersonResultsTaskDetailHousingAllowShort.
  ///
  /// In en, this message translates to:
  /// **'Housing Allow.'**
  String get payrollPersonResultsTaskDetailHousingAllowShort;

  /// No description provided for @payrollPersonResultsTaskDetailOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get payrollPersonResultsTaskDetailOther;

  /// No description provided for @payrollPersonResultsTaskDetailBasicSalaryBreakdownValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 1,700'**
  String get payrollPersonResultsTaskDetailBasicSalaryBreakdownValue;

  /// No description provided for @payrollPersonResultsTaskDetailHousingAllowanceBreakdownValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 300'**
  String get payrollPersonResultsTaskDetailHousingAllowanceBreakdownValue;

  /// No description provided for @payrollPersonResultsTaskDetailOtherBreakdownValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 0'**
  String get payrollPersonResultsTaskDetailOtherBreakdownValue;

  /// No description provided for @payrollPersonResultsTaskDetailExecutionMetrics.
  ///
  /// In en, this message translates to:
  /// **'Execution Metrics'**
  String get payrollPersonResultsTaskDetailExecutionMetrics;

  /// No description provided for @payrollPersonResultsTaskDetailProcessingTime.
  ///
  /// In en, this message translates to:
  /// **'Processing Time'**
  String get payrollPersonResultsTaskDetailProcessingTime;

  /// No description provided for @payrollPersonResultsTaskDetailProcessingTimeValue.
  ///
  /// In en, this message translates to:
  /// **'4m 23s'**
  String get payrollPersonResultsTaskDetailProcessingTimeValue;

  /// No description provided for @payrollPersonResultsTaskDetailElementsProcessed.
  ///
  /// In en, this message translates to:
  /// **'Elements Processed'**
  String get payrollPersonResultsTaskDetailElementsProcessed;

  /// No description provided for @payrollPersonResultsTaskDetailElementsProcessedValue.
  ///
  /// In en, this message translates to:
  /// **'18'**
  String get payrollPersonResultsTaskDetailElementsProcessedValue;

  /// No description provided for @payrollPersonResultsTaskDetailCalculationRules.
  ///
  /// In en, this message translates to:
  /// **'Calculation Rules'**
  String get payrollPersonResultsTaskDetailCalculationRules;

  /// No description provided for @payrollPersonResultsTaskDetailCalculationRulesValue.
  ///
  /// In en, this message translates to:
  /// **'46'**
  String get payrollPersonResultsTaskDetailCalculationRulesValue;

  /// No description provided for @payrollPersonResultsTaskDetailErrorsWarnings.
  ///
  /// In en, this message translates to:
  /// **'Errors / Warnings'**
  String get payrollPersonResultsTaskDetailErrorsWarnings;

  /// No description provided for @payrollPersonResultsTaskDetailErrorsWarningsValue.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get payrollPersonResultsTaskDetailErrorsWarningsValue;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollDistribution.
  ///
  /// In en, this message translates to:
  /// **'Payroll Distribution'**
  String get payrollPersonResultsTaskDetailPayrollDistribution;

  /// No description provided for @payrollPersonResultsTaskDetailGrossPay.
  ///
  /// In en, this message translates to:
  /// **'Gross Pay'**
  String get payrollPersonResultsTaskDetailGrossPay;

  /// No description provided for @payrollPersonResultsTaskDetailGrossPayValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 2,000.000'**
  String get payrollPersonResultsTaskDetailGrossPayValue;

  /// No description provided for @payrollPersonResultsTaskDetailDeductions.
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get payrollPersonResultsTaskDetailDeductions;

  /// No description provided for @payrollPersonResultsTaskDetailDeductionsValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 0.000'**
  String get payrollPersonResultsTaskDetailDeductionsValue;

  /// No description provided for @payrollPersonResultsTaskDetailNetPayValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 2,000.000'**
  String get payrollPersonResultsTaskDetailNetPayValue;

  /// No description provided for @payrollPersonResultsTaskDetailEmployerCost.
  ///
  /// In en, this message translates to:
  /// **'Employer Cost'**
  String get payrollPersonResultsTaskDetailEmployerCost;

  /// No description provided for @payrollPersonResultsTaskDetailEmployerCostValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 196.154'**
  String get payrollPersonResultsTaskDetailEmployerCostValue;

  /// No description provided for @payrollPersonResultsTaskDetailTotalArchivedElements.
  ///
  /// In en, this message translates to:
  /// **'Total Archived Elements'**
  String get payrollPersonResultsTaskDetailTotalArchivedElements;

  /// No description provided for @payrollPersonResultsTaskDetailTotalNetPay.
  ///
  /// In en, this message translates to:
  /// **'Total Net Pay'**
  String get payrollPersonResultsTaskDetailTotalNetPay;

  /// No description provided for @payrollPersonResultsTaskDetailTotalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get payrollPersonResultsTaskDetailTotalEarnings;

  /// No description provided for @payrollPersonResultsTaskDetailTotalDeductions.
  ///
  /// In en, this message translates to:
  /// **'Total Deductions'**
  String get payrollPersonResultsTaskDetailTotalDeductions;

  /// No description provided for @payrollPersonResultsTaskDetailTotalArchivedElementsValue.
  ///
  /// In en, this message translates to:
  /// **'8'**
  String get payrollPersonResultsTaskDetailTotalArchivedElementsValue;

  /// No description provided for @payrollPersonResultsTaskDetailTotalEarningsValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 2,105.000'**
  String get payrollPersonResultsTaskDetailTotalEarningsValue;

  /// No description provided for @payrollPersonResultsTaskDetailTotalDeductionsValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 100.000'**
  String get payrollPersonResultsTaskDetailTotalDeductionsValue;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive Summary'**
  String get payrollPersonResultsTaskDetailArchiveSummaryTitle;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll archive metadata and execution reference'**
  String get payrollPersonResultsTaskDetailArchiveSummarySubtitle;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveVerified.
  ///
  /// In en, this message translates to:
  /// **'Archive Verified'**
  String get payrollPersonResultsTaskDetailArchiveVerified;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveReference.
  ///
  /// In en, this message translates to:
  /// **'Archive Reference'**
  String get payrollPersonResultsTaskDetailArchiveReference;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveReferenceValue.
  ///
  /// In en, this message translates to:
  /// **'ARCH-2026-BGH-JUN-{relationship}'**
  String payrollPersonResultsTaskDetailArchiveReferenceValue(
    String relationship,
  );

  /// No description provided for @payrollPersonResultsTaskDetailElementsArchived.
  ///
  /// In en, this message translates to:
  /// **'Elements Archived'**
  String get payrollPersonResultsTaskDetailElementsArchived;

  /// No description provided for @payrollPersonResultsTaskDetailElementsArchivedValue.
  ///
  /// In en, this message translates to:
  /// **'8'**
  String get payrollPersonResultsTaskDetailElementsArchivedValue;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollRelationship.
  ///
  /// In en, this message translates to:
  /// **'Payroll Relationship'**
  String get payrollPersonResultsTaskDetailPayrollRelationship;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedPayrollElementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Archived Payroll Elements'**
  String get payrollPersonResultsTaskDetailArchivedPayrollElementsTitle;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedPayrollElementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All payroll elements captured in this archive run'**
  String get payrollPersonResultsTaskDetailArchivedPayrollElementsSubtitle;

  /// No description provided for @payrollPersonResultsTaskDetailExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get payrollPersonResultsTaskDetailExport;

  /// No description provided for @payrollPersonResultsTaskDetailInputValueName.
  ///
  /// In en, this message translates to:
  /// **'Input Value Name'**
  String get payrollPersonResultsTaskDetailInputValueName;

  /// No description provided for @payrollPersonResultsTaskDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get payrollPersonResultsTaskDetailStatus;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedStatus.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get payrollPersonResultsTaskDetailArchivedStatus;

  /// No description provided for @payrollPersonResultsTaskDetailClassificationInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get payrollPersonResultsTaskDetailClassificationInformation;

  /// No description provided for @payrollPersonResultsTaskDetailClassificationVoluntaryDeductions.
  ///
  /// In en, this message translates to:
  /// **'Voluntary Deductions'**
  String get payrollPersonResultsTaskDetailClassificationVoluntaryDeductions;

  /// No description provided for @payrollPersonResultsTaskDetailClassificationEmployerCharges.
  ///
  /// In en, this message translates to:
  /// **'Employer Charges'**
  String get payrollPersonResultsTaskDetailClassificationEmployerCharges;

  /// No description provided for @payrollPersonResultsTaskDetailKuwaitGrossSalaryKw.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Gross Salary KW'**
  String get payrollPersonResultsTaskDetailKuwaitGrossSalaryKw;

  /// No description provided for @payrollPersonResultsTaskDetailTelephoneDeduction.
  ///
  /// In en, this message translates to:
  /// **'Telephone Deduction'**
  String get payrollPersonResultsTaskDetailTelephoneDeduction;

  /// No description provided for @payrollPersonResultsTaskDetailNrvRecovery.
  ///
  /// In en, this message translates to:
  /// **'NRV Recovery'**
  String get payrollPersonResultsTaskDetailNrvRecovery;

  /// No description provided for @payrollPersonResultsTaskDetailLeaveProvisioning.
  ///
  /// In en, this message translates to:
  /// **'Leave Provisioning'**
  String get payrollPersonResultsTaskDetailLeaveProvisioning;

  /// No description provided for @payrollPersonResultsTaskDetailNetPayKw.
  ///
  /// In en, this message translates to:
  /// **'Net Pay KW'**
  String get payrollPersonResultsTaskDetailNetPayKw;

  /// No description provided for @payrollPersonResultsTaskDetailAirTicketInfo.
  ///
  /// In en, this message translates to:
  /// **'Air Ticket Info'**
  String get payrollPersonResultsTaskDetailAirTicketInfo;

  /// No description provided for @payrollPersonResultsTaskDetailInputGrossPay.
  ///
  /// In en, this message translates to:
  /// **'Gross Pay'**
  String get payrollPersonResultsTaskDetailInputGrossPay;

  /// No description provided for @payrollPersonResultsTaskDetailInputDeductionAmount.
  ///
  /// In en, this message translates to:
  /// **'Deduction Amount'**
  String get payrollPersonResultsTaskDetailInputDeductionAmount;

  /// No description provided for @payrollPersonResultsTaskDetailInputRecoveryAmount.
  ///
  /// In en, this message translates to:
  /// **'Recovery Amount'**
  String get payrollPersonResultsTaskDetailInputRecoveryAmount;

  /// No description provided for @payrollPersonResultsTaskDetailInputProvisionAmount.
  ///
  /// In en, this message translates to:
  /// **'Provision Amount'**
  String get payrollPersonResultsTaskDetailInputProvisionAmount;

  /// No description provided for @payrollPersonResultsTaskDetailInputNetPay.
  ///
  /// In en, this message translates to:
  /// **'Net Pay'**
  String get payrollPersonResultsTaskDetailInputNetPay;

  /// No description provided for @payrollPersonResultsTaskDetailInputEntitlementValue.
  ///
  /// In en, this message translates to:
  /// **'Entitlement Value'**
  String get payrollPersonResultsTaskDetailInputEntitlementValue;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedKuwaitGrossSalaryAmount.
  ///
  /// In en, this message translates to:
  /// **'KWD 2,105.000'**
  String get payrollPersonResultsTaskDetailArchivedKuwaitGrossSalaryAmount;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedTelephoneDeductionAmount.
  ///
  /// In en, this message translates to:
  /// **'KWD 5.000'**
  String get payrollPersonResultsTaskDetailArchivedTelephoneDeductionAmount;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedNrvRecoveryAmount.
  ///
  /// In en, this message translates to:
  /// **'KWD 95.000'**
  String get payrollPersonResultsTaskDetailArchivedNrvRecoveryAmount;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedLeaveProvisioningAmount.
  ///
  /// In en, this message translates to:
  /// **'KWD 141.935'**
  String get payrollPersonResultsTaskDetailArchivedLeaveProvisioningAmount;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedAirTicketInfoAmount.
  ///
  /// In en, this message translates to:
  /// **'KWD 0.000'**
  String get payrollPersonResultsTaskDetailArchivedAirTicketInfoAmount;

  /// No description provided for @payrollPersonResultsTaskDetailArchivedElementsTotalValue.
  ///
  /// In en, this message translates to:
  /// **'KWD 6,246.935'**
  String get payrollPersonResultsTaskDetailArchivedElementsTotalValue;

  /// No description provided for @payrollPersonResultsTaskDetailDataIntegrityChecksTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Integrity Checks'**
  String get payrollPersonResultsTaskDetailDataIntegrityChecksTitle;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollBalanceReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Payroll Balance Reconciliation'**
  String get payrollPersonResultsTaskDetailPayrollBalanceReconciliation;

  /// No description provided for @payrollPersonResultsTaskDetailElementEntryCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Element Entry Completeness'**
  String get payrollPersonResultsTaskDetailElementEntryCompleteness;

  /// No description provided for @payrollPersonResultsTaskDetailCostingDistributionVerified.
  ///
  /// In en, this message translates to:
  /// **'Costing Distribution Verified'**
  String get payrollPersonResultsTaskDetailCostingDistributionVerified;

  /// No description provided for @payrollPersonResultsTaskDetailNetPayReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Net Pay Reconciliation'**
  String get payrollPersonResultsTaskDetailNetPayReconciliation;

  /// No description provided for @payrollPersonResultsTaskDetailDuplicateRecordCheck.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Record Check'**
  String get payrollPersonResultsTaskDetailDuplicateRecordCheck;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveChecksumVerified.
  ///
  /// In en, this message translates to:
  /// **'Archive Checksum Verified'**
  String get payrollPersonResultsTaskDetailArchiveChecksumVerified;

  /// No description provided for @payrollPersonResultsTaskDetailCheckPassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get payrollPersonResultsTaskDetailCheckPassed;

  /// No description provided for @payrollPersonResultsTaskDetailPayrollLifecycleTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll Lifecycle Timeline'**
  String get payrollPersonResultsTaskDetailPayrollLifecycleTimelineTitle;

  /// No description provided for @payrollPersonResultsTaskDetailTimelinePrepaymentsProcessed.
  ///
  /// In en, this message translates to:
  /// **'Prepayments Processed'**
  String get payrollPersonResultsTaskDetailTimelinePrepaymentsProcessed;

  /// No description provided for @payrollPersonResultsTaskDetailTimelineResultsArchived.
  ///
  /// In en, this message translates to:
  /// **'Results Archived'**
  String get payrollPersonResultsTaskDetailTimelineResultsArchived;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveTimelineCalculatedDate.
  ///
  /// In en, this message translates to:
  /// **'28/Jun/2026'**
  String get payrollPersonResultsTaskDetailArchiveTimelineCalculatedDate;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveTimelinePrepaymentsDate.
  ///
  /// In en, this message translates to:
  /// **'29/Jun/2026'**
  String get payrollPersonResultsTaskDetailArchiveTimelinePrepaymentsDate;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveTimelineCostingDate.
  ///
  /// In en, this message translates to:
  /// **'29/Jun/2026'**
  String get payrollPersonResultsTaskDetailArchiveTimelineCostingDate;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveTimelinePayslipsDate.
  ///
  /// In en, this message translates to:
  /// **'30/Jun/2026'**
  String get payrollPersonResultsTaskDetailArchiveTimelinePayslipsDate;

  /// No description provided for @payrollPersonResultsTaskDetailArchiveTimelineArchivedDate.
  ///
  /// In en, this message translates to:
  /// **'30/Jun/2026'**
  String get payrollPersonResultsTaskDetailArchiveTimelineArchivedDate;

  /// No description provided for @payrollManageElementEntries.
  ///
  /// In en, this message translates to:
  /// **'Manage Element Entries'**
  String get payrollManageElementEntries;

  /// No description provided for @payrollElementEntriesAddElement.
  ///
  /// In en, this message translates to:
  /// **'Add Element'**
  String get payrollElementEntriesAddElement;

  /// No description provided for @payrollElementEntriesUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get payrollElementEntriesUpload;

  /// No description provided for @payrollElementEntriesExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get payrollElementEntriesExport;

  /// No description provided for @payrollElementEntriesSwitchEmployee.
  ///
  /// In en, this message translates to:
  /// **'Switch employee:'**
  String get payrollElementEntriesSwitchEmployee;

  /// No description provided for @payrollElementEntriesSelectEmployee.
  ///
  /// In en, this message translates to:
  /// **'Select employee:'**
  String get payrollElementEntriesSelectEmployee;

  /// No description provided for @payrollElementEntriesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search employee by name, ID, department, payroll…'**
  String get payrollElementEntriesSearchHint;

  /// No description provided for @payrollElementEntriesPersonNo.
  ///
  /// In en, this message translates to:
  /// **'Person No.'**
  String get payrollElementEntriesPersonNo;

  /// No description provided for @payrollElementEntriesPayrollRel.
  ///
  /// In en, this message translates to:
  /// **'Payroll Rel.'**
  String get payrollElementEntriesPayrollRel;

  /// No description provided for @payrollElementEntriesAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get payrollElementEntriesAssignment;

  /// No description provided for @payrollElementEntriesSearchResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 results} =1{1 result} other{{count} results}}'**
  String payrollElementEntriesSearchResults(int count);

  /// No description provided for @payrollElementEntriesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get payrollElementEntriesComingSoon;

  /// No description provided for @payrollElementEntriesUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'This page is under development'**
  String get payrollElementEntriesUnderDevelopment;

  /// No description provided for @payrollElementEntriesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Select an Employee to Begin'**
  String get payrollElementEntriesEmptyTitle;

  /// No description provided for @payrollElementEntriesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Search and select an employee from the field above to view and manage their element entries.'**
  String get payrollElementEntriesEmptyMessage;

  /// No description provided for @payrollElementEntriesLoadingEmployeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading employee details...'**
  String get payrollElementEntriesLoadingEmployeeDetails;

  /// No description provided for @payrollElementEntriesDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete element entries?'**
  String get payrollElementEntriesDeleteConfirmTitle;

  /// No description provided for @payrollElementEntriesDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Are you sure you want to delete the selected element entry? This action cannot be undone.} other{Are you sure you want to delete {count} selected element entries? This action cannot be undone.}}'**
  String payrollElementEntriesDeleteConfirmMessage(int count);

  /// No description provided for @payrollElementEntriesDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Element entry deleted successfully} other{{count} element entries deleted successfully}}'**
  String payrollElementEntriesDeletedSuccess(int count);

  /// No description provided for @payrollAddElementSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get payrollAddElementSaveDraft;

  /// No description provided for @payrollAddElementSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get payrollAddElementSubmit;

  /// No description provided for @payrollAddElementEffectiveBannerPrefix.
  ///
  /// In en, this message translates to:
  /// **'You are editing element entries effective as of '**
  String get payrollAddElementEffectiveBannerPrefix;

  /// No description provided for @payrollAddElementEffectiveBannerSuffix.
  ///
  /// In en, this message translates to:
  /// **'. Changes will apply from this date forward unless overridden.'**
  String get payrollAddElementEffectiveBannerSuffix;

  /// No description provided for @payrollAddElementProcessInformation.
  ///
  /// In en, this message translates to:
  /// **'Process Information'**
  String get payrollAddElementProcessInformation;

  /// No description provided for @payrollAddElementEffectiveAsOfDate.
  ///
  /// In en, this message translates to:
  /// **'Effective As-of Date'**
  String get payrollAddElementEffectiveAsOfDate;

  /// No description provided for @payrollAddElementEntryType.
  ///
  /// In en, this message translates to:
  /// **'Entry Type'**
  String get payrollAddElementEntryType;

  /// No description provided for @payrollAddElementAssignmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Assignment Number'**
  String get payrollAddElementAssignmentNumber;

  /// No description provided for @payrollAddElementSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get payrollAddElementSource;

  /// No description provided for @payrollAddElementElementProcessingType.
  ///
  /// In en, this message translates to:
  /// **'Element Processing Type'**
  String get payrollAddElementElementProcessingType;

  /// No description provided for @payrollAddElementEntryDetails.
  ///
  /// In en, this message translates to:
  /// **'Entry Details'**
  String get payrollAddElementEntryDetails;

  /// No description provided for @payrollAddElementElementConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Element configuration'**
  String get payrollAddElementElementConfiguration;

  /// No description provided for @payrollAddElementElement.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get payrollAddElementElement;

  /// No description provided for @payrollAddElementElementClassificationName.
  ///
  /// In en, this message translates to:
  /// **'Element Classification Name'**
  String get payrollAddElementElementClassificationName;

  /// No description provided for @payrollAddElementSelectElementTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Element'**
  String get payrollAddElementSelectElementTitle;

  /// No description provided for @payrollAddElementSelectElementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an assigned compensation component'**
  String get payrollAddElementSelectElementSubtitle;

  /// No description provided for @payrollAddElementSelectElementSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search components...'**
  String get payrollAddElementSelectElementSearchHint;

  /// No description provided for @payrollAddElementSelectElementEmpty.
  ///
  /// In en, this message translates to:
  /// **'No assigned components found'**
  String get payrollAddElementSelectElementEmpty;

  /// No description provided for @payrollAddElementSelectEmployeeForElement.
  ///
  /// In en, this message translates to:
  /// **'Select an employee first'**
  String get payrollAddElementSelectEmployeeForElement;

  /// No description provided for @payrollAddElementSubpriority.
  ///
  /// In en, this message translates to:
  /// **'Subpriority'**
  String get payrollAddElementSubpriority;

  /// No description provided for @payrollAddElementSubpriorityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter subpriority'**
  String get payrollAddElementSubpriorityHint;

  /// No description provided for @payrollAddElementGeneralInformation.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get payrollAddElementGeneralInformation;

  /// No description provided for @payrollAddElementCosting.
  ///
  /// In en, this message translates to:
  /// **'Costing'**
  String get payrollAddElementCosting;

  /// No description provided for @payrollAddElementEffectiveStartDate.
  ///
  /// In en, this message translates to:
  /// **'Effective Start Date'**
  String get payrollAddElementEffectiveStartDate;

  /// No description provided for @payrollAddElementEffectiveEndDate.
  ///
  /// In en, this message translates to:
  /// **'Effective End Date'**
  String get payrollAddElementEffectiveEndDate;

  /// No description provided for @payrollAddElementCreatorType.
  ///
  /// In en, this message translates to:
  /// **'Creator Type'**
  String get payrollAddElementCreatorType;

  /// No description provided for @payrollAddElementProcessed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get payrollAddElementProcessed;

  /// No description provided for @payrollAddElementRetroactiveEntry.
  ///
  /// In en, this message translates to:
  /// **'Retroactive Entry'**
  String get payrollAddElementRetroactiveEntry;

  /// No description provided for @payrollAddElementAutomaticEntry.
  ///
  /// In en, this message translates to:
  /// **'Automatic Entry'**
  String get payrollAddElementAutomaticEntry;

  /// No description provided for @payrollAddElementSequenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Sequence Number'**
  String get payrollAddElementSequenceNumber;

  /// No description provided for @payrollAddElementReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get payrollAddElementReason;

  /// No description provided for @payrollAddElementReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter reason for this element entry…'**
  String get payrollAddElementReasonHint;

  /// No description provided for @payrollAddElementEntryValues.
  ///
  /// In en, this message translates to:
  /// **'Entry Values'**
  String get payrollAddElementEntryValues;

  /// No description provided for @payrollAddElementEntryValuesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Configure the pay value and amount for this element entry.'**
  String get payrollAddElementEntryValuesTooltip;

  /// No description provided for @payrollAddElementPayValue.
  ///
  /// In en, this message translates to:
  /// **'Pay Value'**
  String get payrollAddElementPayValue;

  /// No description provided for @payrollAddElementPayValueHint.
  ///
  /// In en, this message translates to:
  /// **'Enter pay value'**
  String get payrollAddElementPayValueHint;

  /// No description provided for @payrollAddElementSelectPayValue.
  ///
  /// In en, this message translates to:
  /// **'Select Pay Value'**
  String get payrollAddElementSelectPayValue;

  /// No description provided for @payrollAddElementAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get payrollAddElementAmount;

  /// No description provided for @payrollAddElementAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get payrollAddElementAmountHint;

  /// No description provided for @payrollAddElementCurrencyKwd.
  ///
  /// In en, this message translates to:
  /// **'KWD'**
  String get payrollAddElementCurrencyKwd;

  /// No description provided for @payrollAddElementExtraDetails.
  ///
  /// In en, this message translates to:
  /// **'Extra Details'**
  String get payrollAddElementExtraDetails;

  /// No description provided for @payrollAddElementContextSegment.
  ///
  /// In en, this message translates to:
  /// **'Context Segment'**
  String get payrollAddElementContextSegment;

  /// No description provided for @payrollAddElementSelectContextSegment.
  ///
  /// In en, this message translates to:
  /// **'Select Context Segment'**
  String get payrollAddElementSelectContextSegment;

  /// No description provided for @payrollAddElementCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created by: {name}'**
  String payrollAddElementCreatedBy(String name);

  /// No description provided for @payrollAddElementCreatedOn.
  ///
  /// In en, this message translates to:
  /// **'Created on: {date}'**
  String payrollAddElementCreatedOn(String date);

  /// No description provided for @payrollAddElementLastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified: {dateTime}'**
  String payrollAddElementLastModified(String dateTime);

  /// No description provided for @payrollAddElementPayrollStatus.
  ///
  /// In en, this message translates to:
  /// **'Payroll Status: {status}'**
  String payrollAddElementPayrollStatus(String status);

  /// No description provided for @payrollAddElementElementEntryOption.
  ///
  /// In en, this message translates to:
  /// **'Element Entry'**
  String get payrollAddElementElementEntryOption;

  /// No description provided for @payrollAddElementManualEntryOption.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get payrollAddElementManualEntryOption;

  /// No description provided for @payrollAddElementRecurringOption.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get payrollAddElementRecurringOption;

  /// No description provided for @payrollAddElementBasicSalaryKw.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary KW'**
  String get payrollAddElementBasicSalaryKw;

  /// No description provided for @payrollAddElementStandardEarnings.
  ///
  /// In en, this message translates to:
  /// **'Standard Earnings'**
  String get payrollAddElementStandardEarnings;

  /// No description provided for @payrollAddElementUserOption.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get payrollAddElementUserOption;

  /// No description provided for @payrollAddElementNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get payrollAddElementNo;

  /// No description provided for @payrollAddElementYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get payrollAddElementYes;

  /// No description provided for @payrollAddElementSystemAdministrator.
  ///
  /// In en, this message translates to:
  /// **'System Administrator'**
  String get payrollAddElementSystemAdministrator;

  /// No description provided for @payrollAddElementStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get payrollAddElementStatusOpen;

  /// No description provided for @payrollAddElementDateHint.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get payrollAddElementDateHint;

  /// No description provided for @payrollAddElementCostingDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure cost allocation for this element entry.'**
  String get payrollAddElementCostingDescription;

  /// No description provided for @payrollAddElementCostingEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No costing overrides configured. Default payroll costing rules apply.'**
  String get payrollAddElementCostingEmptyMessage;

  /// No description provided for @payrollAddElementCostAllocationKeyFlexfield.
  ///
  /// In en, this message translates to:
  /// **'Cost Allocation Key Flexfield'**
  String get payrollAddElementCostAllocationKeyFlexfield;

  /// No description provided for @payrollAddElementSelectCostAllocationKeyFlexfield.
  ///
  /// In en, this message translates to:
  /// **'Select Cost Allocation Key Flexfield'**
  String get payrollAddElementSelectCostAllocationKeyFlexfield;

  /// No description provided for @payrollAddElementCostingType.
  ///
  /// In en, this message translates to:
  /// **'Costing Type'**
  String get payrollAddElementCostingType;

  /// No description provided for @payrollAddElementSelectCostingType.
  ///
  /// In en, this message translates to:
  /// **'Select Costing Type'**
  String get payrollAddElementSelectCostingType;

  /// No description provided for @payrollAddElementAccountCode.
  ///
  /// In en, this message translates to:
  /// **'Account Code'**
  String get payrollAddElementAccountCode;

  /// No description provided for @payrollAddElementAccountCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5010-100-00'**
  String get payrollAddElementAccountCodeHint;

  /// No description provided for @payrollAddElementCostCentre.
  ///
  /// In en, this message translates to:
  /// **'Cost Centre'**
  String get payrollAddElementCostCentre;

  /// No description provided for @payrollAddElementCostCentreHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. CC-42'**
  String get payrollAddElementCostCentreHint;

  /// No description provided for @payrollAddElementDraftSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Draft saved successfully'**
  String get payrollAddElementDraftSavedSuccess;

  /// No description provided for @payrollAddElementSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Element entry submitted successfully'**
  String get payrollAddElementSubmittedSuccess;

  /// No description provided for @payrollAddElementValidationEffectiveAsOfDate.
  ///
  /// In en, this message translates to:
  /// **'Effective as-of date is required'**
  String get payrollAddElementValidationEffectiveAsOfDate;

  /// No description provided for @payrollAddElementValidationEntryType.
  ///
  /// In en, this message translates to:
  /// **'Entry type is required'**
  String get payrollAddElementValidationEntryType;

  /// No description provided for @payrollAddElementValidationElement.
  ///
  /// In en, this message translates to:
  /// **'Element is required'**
  String get payrollAddElementValidationElement;

  /// No description provided for @payrollAddElementValidationEffectiveStartDate.
  ///
  /// In en, this message translates to:
  /// **'Effective start date is required'**
  String get payrollAddElementValidationEffectiveStartDate;

  /// No description provided for @payrollAddElementValidationAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get payrollAddElementValidationAmount;

  /// No description provided for @payrollAddElementValidationEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise is required'**
  String get payrollAddElementValidationEnterprise;

  /// No description provided for @payrollAddElementValidationEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee is required'**
  String get payrollAddElementValidationEmployee;

  /// No description provided for @payrollSubmitPayrollFlow.
  ///
  /// In en, this message translates to:
  /// **'Submit Payroll Flow'**
  String get payrollSubmitPayrollFlow;

  /// No description provided for @payrollSubmitPayrollFlowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Digify Simplified Payroll Cycle KW'**
  String get payrollSubmitPayrollFlowSubtitle;

  /// No description provided for @payrollSubmitPayrollFlowReviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit →'**
  String get payrollSubmitPayrollFlowReviewSubmit;

  /// No description provided for @payrollSubmitPayrollFlowProcessingInfo.
  ///
  /// In en, this message translates to:
  /// **'Payroll processing may take several minutes depending on employee volume and selected parameters.'**
  String get payrollSubmitPayrollFlowProcessingInfo;

  /// No description provided for @payrollSubmitPayrollFlowStepFlowDetails.
  ///
  /// In en, this message translates to:
  /// **'Flow Details'**
  String get payrollSubmitPayrollFlowStepFlowDetails;

  /// No description provided for @payrollSubmitPayrollFlowStepParameters.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get payrollSubmitPayrollFlowStepParameters;

  /// No description provided for @payrollSubmitPayrollFlowStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get payrollSubmitPayrollFlowStepReview;

  /// No description provided for @payrollSubmitPayrollFlowFlowInformation.
  ///
  /// In en, this message translates to:
  /// **'Flow Information'**
  String get payrollSubmitPayrollFlowFlowInformation;

  /// No description provided for @payrollSubmitPayrollFlowFlowInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure payroll process execution settings'**
  String get payrollSubmitPayrollFlowFlowInformationSubtitle;

  /// No description provided for @payrollSubmitPayrollFlowPayrollFlow.
  ///
  /// In en, this message translates to:
  /// **'Payroll Flow'**
  String get payrollSubmitPayrollFlowPayrollFlow;

  /// No description provided for @payrollSubmitPayrollFlowSelectPayrollFlow.
  ///
  /// In en, this message translates to:
  /// **'Select Payroll Flow'**
  String get payrollSubmitPayrollFlowSelectPayrollFlow;

  /// No description provided for @payrollSubmitPayrollFlowSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get payrollSubmitPayrollFlowSchedule;

  /// No description provided for @payrollSubmitPayrollFlowScheduleAsSoonAsPossible.
  ///
  /// In en, this message translates to:
  /// **'As soon as possible'**
  String get payrollSubmitPayrollFlowScheduleAsSoonAsPossible;

  /// No description provided for @payrollSubmitPayrollFlowRequiredParameters.
  ///
  /// In en, this message translates to:
  /// **'Required Parameters'**
  String get payrollSubmitPayrollFlowRequiredParameters;

  /// No description provided for @payrollSubmitPayrollFlowRequiredParametersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Define payroll processing scope and calculation parameters'**
  String get payrollSubmitPayrollFlowRequiredParametersSubtitle;

  /// No description provided for @payrollSubmitPayrollFlowScope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get payrollSubmitPayrollFlowScope;

  /// No description provided for @payrollSubmitPayrollFlowSelectScope.
  ///
  /// In en, this message translates to:
  /// **'Select Scope'**
  String get payrollSubmitPayrollFlowSelectScope;

  /// No description provided for @payrollSubmitPayrollFlowPayroll.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payrollSubmitPayrollFlowPayroll;

  /// No description provided for @payrollSubmitPayrollFlowSelectPayroll.
  ///
  /// In en, this message translates to:
  /// **'Select Payroll'**
  String get payrollSubmitPayrollFlowSelectPayroll;

  /// No description provided for @payrollSubmitPayrollFlowPayrollPeriod.
  ///
  /// In en, this message translates to:
  /// **'Payroll Period'**
  String get payrollSubmitPayrollFlowPayrollPeriod;

  /// No description provided for @payrollSubmitPayrollFlowSelectPayrollPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select Payroll Period'**
  String get payrollSubmitPayrollFlowSelectPayrollPeriod;

  /// No description provided for @payrollSubmitPayrollFlowConsolidationGroup.
  ///
  /// In en, this message translates to:
  /// **'Consolidation Group'**
  String get payrollSubmitPayrollFlowConsolidationGroup;

  /// No description provided for @payrollSubmitPayrollFlowSelectConsolidationGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Consolidation Group'**
  String get payrollSubmitPayrollFlowSelectConsolidationGroup;

  /// No description provided for @payrollSubmitPayrollFlowRunType.
  ///
  /// In en, this message translates to:
  /// **'Run Type'**
  String get payrollSubmitPayrollFlowRunType;

  /// No description provided for @payrollSubmitPayrollFlowSelectRunType.
  ///
  /// In en, this message translates to:
  /// **'Select Run Type'**
  String get payrollSubmitPayrollFlowSelectRunType;

  /// No description provided for @payrollSubmitPayrollFlowPayrollRelationshipGroup.
  ///
  /// In en, this message translates to:
  /// **'Payroll Relationship Group'**
  String get payrollSubmitPayrollFlowPayrollRelationshipGroup;

  /// No description provided for @payrollSubmitPayrollFlowSelectPayrollRelationshipGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Payroll Relationship Group'**
  String get payrollSubmitPayrollFlowSelectPayrollRelationshipGroup;

  /// No description provided for @payrollSubmitPayrollFlowOptionalParameters.
  ///
  /// In en, this message translates to:
  /// **'Optional Parameters'**
  String get payrollSubmitPayrollFlowOptionalParameters;

  /// No description provided for @payrollSubmitPayrollFlowOptionalParametersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure additional payroll processing filters and settings'**
  String get payrollSubmitPayrollFlowOptionalParametersSubtitle;

  /// No description provided for @payrollSubmitPayrollFlowProcessStartDate.
  ///
  /// In en, this message translates to:
  /// **'Process Start Date'**
  String get payrollSubmitPayrollFlowProcessStartDate;

  /// No description provided for @payrollSubmitPayrollFlowProcessEndDate.
  ///
  /// In en, this message translates to:
  /// **'Process End Date'**
  String get payrollSubmitPayrollFlowProcessEndDate;

  /// No description provided for @payrollSubmitPayrollFlowDateEarned.
  ///
  /// In en, this message translates to:
  /// **'Date Earned'**
  String get payrollSubmitPayrollFlowDateEarned;

  /// No description provided for @payrollSubmitPayrollFlowDateHint.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get payrollSubmitPayrollFlowDateHint;

  /// No description provided for @payrollSubmitPayrollFlowElementGroup.
  ///
  /// In en, this message translates to:
  /// **'Element Group'**
  String get payrollSubmitPayrollFlowElementGroup;

  /// No description provided for @payrollSubmitPayrollFlowSelectElementGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Element Group'**
  String get payrollSubmitPayrollFlowSelectElementGroup;

  /// No description provided for @payrollSubmitPayrollFlowReportCategory.
  ///
  /// In en, this message translates to:
  /// **'Report Category'**
  String get payrollSubmitPayrollFlowReportCategory;

  /// No description provided for @payrollSubmitPayrollFlowSelectReportCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Report Category'**
  String get payrollSubmitPayrollFlowSelectReportCategory;

  /// No description provided for @payrollSubmitPayrollFlowProcessConfigurationGroup.
  ///
  /// In en, this message translates to:
  /// **'Process Configuration Group'**
  String get payrollSubmitPayrollFlowProcessConfigurationGroup;

  /// No description provided for @payrollSubmitPayrollFlowSelectProcessConfigurationGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Process Configuration Group'**
  String get payrollSubmitPayrollFlowSelectProcessConfigurationGroup;

  /// No description provided for @payrollSubmitPayrollFlowRunMode.
  ///
  /// In en, this message translates to:
  /// **'Run Mode'**
  String get payrollSubmitPayrollFlowRunMode;

  /// No description provided for @payrollSubmitPayrollFlowRunModeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get payrollSubmitPayrollFlowRunModeNormal;

  /// No description provided for @payrollSubmitPayrollFlowReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Payroll Configuration'**
  String get payrollSubmitPayrollFlowReviewTitle;

  /// No description provided for @payrollSubmitPayrollFlowReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm all settings before submitting. Fields marked with * are required.'**
  String get payrollSubmitPayrollFlowReviewSubtitle;

  /// No description provided for @payrollSubmitPayrollFlowConfirmSubmit.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Submit'**
  String get payrollSubmitPayrollFlowConfirmSubmit;

  /// No description provided for @payrollFlowMonitor.
  ///
  /// In en, this message translates to:
  /// **'Flow Monitor'**
  String get payrollFlowMonitor;

  /// No description provided for @payrollFlowMonitorTitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll Flow Monitoring'**
  String get payrollFlowMonitorTitle;

  /// No description provided for @payrollFlowMonitorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track payroll process execution, reports, and task statuses'**
  String get payrollFlowMonitorSubtitle;

  /// No description provided for @payrollFlowMonitorProcessAllTasks.
  ///
  /// In en, this message translates to:
  /// **'Process All Tasks'**
  String get payrollFlowMonitorProcessAllTasks;

  /// No description provided for @payrollFlowMonitorRefreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get payrollFlowMonitorRefreshStatus;

  /// No description provided for @payrollFlowMonitorRetryFailedTasks.
  ///
  /// In en, this message translates to:
  /// **'Retry Failed Tasks'**
  String get payrollFlowMonitorRetryFailedTasks;

  /// No description provided for @payrollFlowMonitorExportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get payrollFlowMonitorExportReport;

  /// No description provided for @payrollFlowMonitorTotalTasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get payrollFlowMonitorTotalTasks;

  /// No description provided for @payrollFlowMonitorCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get payrollFlowMonitorCompleted;

  /// No description provided for @payrollFlowMonitorInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get payrollFlowMonitorInProgress;

  /// No description provided for @payrollFlowMonitorPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get payrollFlowMonitorPending;

  /// No description provided for @payrollFlowMonitorOverallActivities.
  ///
  /// In en, this message translates to:
  /// **'Overall Activities'**
  String get payrollFlowMonitorOverallActivities;

  /// No description provided for @payrollFlowMonitorCriticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical Alerts'**
  String get payrollFlowMonitorCriticalAlerts;

  /// No description provided for @payrollFlowMonitorCompletedWithAlerts.
  ///
  /// In en, this message translates to:
  /// **'Completed with Alerts'**
  String get payrollFlowMonitorCompletedWithAlerts;

  /// No description provided for @payrollFlowMonitorRelatedFlows.
  ///
  /// In en, this message translates to:
  /// **'Related Flows'**
  String get payrollFlowMonitorRelatedFlows;

  /// No description provided for @payrollFlowMonitorTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get payrollFlowMonitorTasksTitle;

  /// No description provided for @payrollFlowMonitorTasksCompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'({completed} of {total} completed)'**
  String payrollFlowMonitorTasksCompletedSummary(int completed, int total);

  /// No description provided for @payrollFlowMonitorTasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String payrollFlowMonitorTasksCount(int count);

  /// No description provided for @payrollFlowMonitorTaskNumber.
  ///
  /// In en, this message translates to:
  /// **'Task #{number}'**
  String payrollFlowMonitorTaskNumber(int number);

  /// No description provided for @payrollFlowMonitorTaskTypeReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get payrollFlowMonitorTaskTypeReport;

  /// No description provided for @payrollFlowMonitorTaskTypeProcess.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get payrollFlowMonitorTaskTypeProcess;

  /// No description provided for @payrollFlowMonitorTaskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get payrollFlowMonitorTaskDetails;

  /// No description provided for @payrollFlowMonitorOutputs.
  ///
  /// In en, this message translates to:
  /// **'Outputs'**
  String get payrollFlowMonitorOutputs;

  /// No description provided for @payrollFlowMonitorActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get payrollFlowMonitorActivity;

  /// No description provided for @payrollFlowMonitorSubmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Submitted By'**
  String get payrollFlowMonitorSubmittedBy;

  /// No description provided for @payrollFlowMonitorSubmissionDate.
  ///
  /// In en, this message translates to:
  /// **'Submission Date'**
  String get payrollFlowMonitorSubmissionDate;

  /// No description provided for @payrollFlowMonitorStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get payrollFlowMonitorStatus;

  /// No description provided for @payrollFlowMonitorOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get payrollFlowMonitorOwner;

  /// No description provided for @payrollFlowMonitorLoggingLevel.
  ///
  /// In en, this message translates to:
  /// **'Logging Level'**
  String get payrollFlowMonitorLoggingLevel;

  /// No description provided for @payrollFlowMonitorOwnerType.
  ///
  /// In en, this message translates to:
  /// **'Owner Type'**
  String get payrollFlowMonitorOwnerType;

  /// No description provided for @payrollFlowMonitorRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get payrollFlowMonitorRecords;

  /// No description provided for @payrollFlowMonitorNoOutputs.
  ///
  /// In en, this message translates to:
  /// **'Sorry, we couldn\'t find any report outputs to display.'**
  String get payrollFlowMonitorNoOutputs;

  /// No description provided for @payrollFlowMonitorNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks to display.'**
  String get payrollFlowMonitorNoTasks;

  /// No description provided for @payrollFlowMonitorNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get payrollFlowMonitorNotAvailable;

  /// No description provided for @payrollFlowMonitorOwnerPayrollManager.
  ///
  /// In en, this message translates to:
  /// **'Payroll Manager'**
  String get payrollFlowMonitorOwnerPayrollManager;

  /// No description provided for @payrollFlowMonitorLoggingStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get payrollFlowMonitorLoggingStandard;

  /// No description provided for @payrollFlowMonitorOwnerTypeRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get payrollFlowMonitorOwnerTypeRole;

  /// No description provided for @payrollFlowMonitorTaskRunRetroactiveNotificationReport.
  ///
  /// In en, this message translates to:
  /// **'Run Retroactive Notification Report'**
  String get payrollFlowMonitorTaskRunRetroactiveNotificationReport;

  /// No description provided for @payrollFlowMonitorTaskRunRetroactiveEntriesReport.
  ///
  /// In en, this message translates to:
  /// **'Run Retroactive Entries Report'**
  String get payrollFlowMonitorTaskRunRetroactiveEntriesReport;

  /// No description provided for @payrollFlowMonitorTaskRecalculatePayrollRetroactive.
  ///
  /// In en, this message translates to:
  /// **'Recalculate Payroll for Retroactive Changes'**
  String get payrollFlowMonitorTaskRecalculatePayrollRetroactive;

  /// No description provided for @payrollFlowMonitorTaskCalculatePayroll.
  ///
  /// In en, this message translates to:
  /// **'Calculate Payroll'**
  String get payrollFlowMonitorTaskCalculatePayroll;

  /// No description provided for @payrollFlowMonitorTaskPayrollCostingReport.
  ///
  /// In en, this message translates to:
  /// **'Payroll Costing Report'**
  String get payrollFlowMonitorTaskPayrollCostingReport;

  /// No description provided for @payrollFlowMonitorTaskCalculatePrepayments.
  ///
  /// In en, this message translates to:
  /// **'Calculate PrePayments'**
  String get payrollFlowMonitorTaskCalculatePrepayments;

  /// No description provided for @payrollFlowMonitorTaskArchivePeriodicPayrollResults.
  ///
  /// In en, this message translates to:
  /// **'Archive Periodic Payroll Results'**
  String get payrollFlowMonitorTaskArchivePeriodicPayrollResults;

  /// No description provided for @payrollFlowMonitorFlowParameters.
  ///
  /// In en, this message translates to:
  /// **'Flow Parameters'**
  String get payrollFlowMonitorFlowParameters;

  /// No description provided for @payrollFlowMonitorCheckOrganizationPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Check Organization Payment Method'**
  String get payrollFlowMonitorCheckOrganizationPaymentMethod;

  /// No description provided for @payrollFlowMonitorEftOrganizationPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'EFT Organization Payment Method'**
  String get payrollFlowMonitorEftOrganizationPaymentMethod;

  /// No description provided for @payrollFlowMonitorRetroProcessDate.
  ///
  /// In en, this message translates to:
  /// **'Retro Process Date'**
  String get payrollFlowMonitorRetroProcessDate;

  /// No description provided for @payrollFlowMonitorDisplayAllHours.
  ///
  /// In en, this message translates to:
  /// **'Display All Hours'**
  String get payrollFlowMonitorDisplayAllHours;

  /// No description provided for @payrollFlowMonitorScopeDetail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get payrollFlowMonitorScopeDetail;

  /// No description provided for @payrollFlowMonitorParametersPayrollValue.
  ///
  /// In en, this message translates to:
  /// **'Digify Solutions LLC. Payroll'**
  String get payrollFlowMonitorParametersPayrollValue;

  /// No description provided for @payrollFlowMonitorParametersPayrollPeriodValue.
  ///
  /// In en, this message translates to:
  /// **'6 2026 Monthly Calendar'**
  String get payrollFlowMonitorParametersPayrollPeriodValue;

  /// No description provided for @payrollFlowMonitorParametersRelationshipGroupValue.
  ///
  /// In en, this message translates to:
  /// **'DIGIFY_ACTIVE_EMPLOYEES_KW'**
  String get payrollFlowMonitorParametersRelationshipGroupValue;

  /// No description provided for @payrollFlowMonitorParametersRunTypeRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get payrollFlowMonitorParametersRunTypeRegular;

  /// No description provided for @compliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get compliance;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @manageEnterpriseStructure.
  ///
  /// In en, this message translates to:
  /// **'Manage Enterprise Structure'**
  String get manageEnterpriseStructure;

  /// No description provided for @configureManageHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Configure and manage your organizational hierarchy structures'**
  String get configureManageHierarchy;

  /// No description provided for @configureManageHierarchyAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة وتكوين هياكل التسلسل الإداري للمؤسسة'**
  String get configureManageHierarchyAr;

  /// No description provided for @currentlyActiveStructure.
  ///
  /// In en, this message translates to:
  /// **'Currently Active Structure'**
  String get currentlyActiveStructure;

  /// No description provided for @standardKuwaitCorporateStructure.
  ///
  /// In en, this message translates to:
  /// **'Standard Kuwait Corporate Structure'**
  String get standardKuwaitCorporateStructure;

  /// No description provided for @traditionalHierarchicalStructure.
  ///
  /// In en, this message translates to:
  /// **'Traditional hierarchical structure with all five levels for comprehensive organizational management'**
  String get traditionalHierarchicalStructure;

  /// No description provided for @activeLevels.
  ///
  /// In en, this message translates to:
  /// **'Active Levels'**
  String get activeLevels;

  /// No description provided for @components.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get components;

  /// No description provided for @employeesAssigned.
  ///
  /// In en, this message translates to:
  /// **'Employees Assigned'**
  String get employeesAssigned;

  /// No description provided for @totalStructures.
  ///
  /// In en, this message translates to:
  /// **'Total Structures'**
  String get totalStructures;

  /// No description provided for @activeStructure.
  ///
  /// In en, this message translates to:
  /// **'Active Structure'**
  String get activeStructure;

  /// No description provided for @componentsInUse.
  ///
  /// In en, this message translates to:
  /// **'Components in Use'**
  String get componentsInUse;

  /// No description provided for @structureConfigurations.
  ///
  /// In en, this message translates to:
  /// **'Structure Configurations'**
  String get structureConfigurations;

  /// No description provided for @manageDifferentConfigurations.
  ///
  /// In en, this message translates to:
  /// **'Manage different organizational hierarchy configurations. Only one can be active at a time.'**
  String get manageDifferentConfigurations;

  /// No description provided for @createNewStructure.
  ///
  /// In en, this message translates to:
  /// **'Create New Structure'**
  String get createNewStructure;

  /// No description provided for @selectEnterpriseFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an enterprise first'**
  String get selectEnterpriseFirst;

  /// No description provided for @createUserSelectEmployeeFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Select an employee first'**
  String get createUserSelectEmployeeFirstTitle;

  /// No description provided for @createUserSelectEmployeeFirstMessage.
  ///
  /// In en, this message translates to:
  /// **'Use the search field above to choose an employee. Their account, contact, and employment details will appear here.'**
  String get createUserSelectEmployeeFirstMessage;

  /// No description provided for @loadingEmployeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading employee details…'**
  String get loadingEmployeeDetails;

  /// No description provided for @createUserEmployeeSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Selection'**
  String get createUserEmployeeSelectionTitle;

  /// No description provided for @createUserSelectEmployeeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Employee'**
  String get createUserSelectEmployeeFieldLabel;

  /// No description provided for @createUserEmployeeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Attach to Employee'**
  String get createUserEmployeeModeLabel;

  /// No description provided for @createUserStandaloneModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Standalone User'**
  String get createUserStandaloneModeLabel;

  /// No description provided for @createUserStandaloneModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a user without linking to an employee. Only account and contact information are required in this mode.'**
  String get createUserStandaloneModeDescription;

  /// No description provided for @hierarchy.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy'**
  String get hierarchy;

  /// No description provided for @levels.
  ///
  /// In en, this message translates to:
  /// **'levels'**
  String get levels;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @modified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modified;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @notUsed.
  ///
  /// In en, this message translates to:
  /// **'NOT USED'**
  String get notUsed;

  /// No description provided for @simplifiedStructure.
  ///
  /// In en, this message translates to:
  /// **'Simplified Structure'**
  String get simplifiedStructure;

  /// No description provided for @streamlinedStructure.
  ///
  /// In en, this message translates to:
  /// **'Streamlined structure for smaller organizations - Company, Division, and Department only'**
  String get streamlinedStructure;

  /// No description provided for @flatOrganizationStructure.
  ///
  /// In en, this message translates to:
  /// **'Flat Organization Structure'**
  String get flatOrganizationStructure;

  /// No description provided for @minimalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Minimal hierarchy for startups and agile teams - Company and Department only'**
  String get minimalHierarchy;

  /// No description provided for @currentlyActiveStructureMessage.
  ///
  /// In en, this message translates to:
  /// **'This is the currently active structure. To activate a different structure, click the \"Activate\" button on another configuration.'**
  String get currentlyActiveStructureMessage;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies;

  /// No description provided for @division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get division;

  /// No description provided for @divisions.
  ///
  /// In en, this message translates to:
  /// **'Divisions'**
  String get divisions;

  /// No description provided for @businessUnit.
  ///
  /// In en, this message translates to:
  /// **'Business Unit'**
  String get businessUnit;

  /// No description provided for @businessUnits.
  ///
  /// In en, this message translates to:
  /// **'Business Units'**
  String get businessUnits;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get departments;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @sections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get sections;

  /// No description provided for @companyCode.
  ///
  /// In en, this message translates to:
  /// **'Company Code'**
  String get companyCode;

  /// No description provided for @companyNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Company Name (English)'**
  String get companyNameEnglish;

  /// No description provided for @companyNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Company Name (Arabic)'**
  String get companyNameArabic;

  /// No description provided for @legalNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Legal Name (English)'**
  String get legalNameEnglish;

  /// No description provided for @legalNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Legal Name (Arabic)'**
  String get legalNameArabic;

  /// No description provided for @industry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get industry;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @poBox.
  ///
  /// In en, this message translates to:
  /// **'P.O. Box'**
  String get poBox;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @fiscalYearStart.
  ///
  /// In en, this message translates to:
  /// **'Fiscal Year Start (MM-DD)'**
  String get fiscalYearStart;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @viewEnterpriseStructureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'View Enterprise Structure Configuration'**
  String get viewEnterpriseStructureConfiguration;

  /// No description provided for @reviewOrganizationalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Review organizational hierarchy levels and sequence'**
  String get reviewOrganizationalHierarchy;

  /// No description provided for @structureConfigurationActive.
  ///
  /// In en, this message translates to:
  /// **'Structure Configuration Active'**
  String get structureConfigurationActive;

  /// No description provided for @enterpriseStructureActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Your enterprise structure hierarchy is configured and active. You can modify the levels and order below.'**
  String get enterpriseStructureActiveMessage;

  /// No description provided for @configurationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Configuration Instructions'**
  String get configurationInstructions;

  /// No description provided for @companyMandatoryInstruction.
  ///
  /// In en, this message translates to:
  /// **'Company is mandatory and must be the top level - it cannot be disabled or reordered'**
  String get companyMandatoryInstruction;

  /// No description provided for @enableDisableLevelsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable levels based on your organizational needs'**
  String get enableDisableLevelsInstruction;

  /// No description provided for @useArrowsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Use the up/down arrows to change the hierarchy sequence'**
  String get useArrowsInstruction;

  /// No description provided for @orderDeterminesRelationshipsInstruction.
  ///
  /// In en, this message translates to:
  /// **'The order determines parent-child relationships in your org structure'**
  String get orderDeterminesRelationshipsInstruction;

  /// No description provided for @changesAffectComponentsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Changes will affect how components are created and displayed in the tree view'**
  String get changesAffectComponentsInstruction;

  /// No description provided for @previewStructure.
  ///
  /// In en, this message translates to:
  /// **'Preview Structure'**
  String get previewStructure;

  /// No description provided for @saveConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Save Configuration'**
  String get saveConfiguration;

  /// No description provided for @organizationalHierarchyLevels.
  ///
  /// In en, this message translates to:
  /// **'Organizational Hierarchy Levels'**
  String get organizationalHierarchyLevels;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @levelInHierarchy.
  ///
  /// In en, this message translates to:
  /// **'{level}'**
  String levelInHierarchy(int level);

  /// No description provided for @hierarchyPreview.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Preview'**
  String get hierarchyPreview;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'{levelNumber}'**
  String level(int levelNumber);

  /// No description provided for @configurationSummary.
  ///
  /// In en, this message translates to:
  /// **'Configuration Summary'**
  String get configurationSummary;

  /// No description provided for @totalLevels.
  ///
  /// In en, this message translates to:
  /// **'Total Levels'**
  String get totalLevels;

  /// No description provided for @hierarchyDepth.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Depth'**
  String get hierarchyDepth;

  /// No description provided for @topLevel.
  ///
  /// In en, this message translates to:
  /// **'Top Level'**
  String get topLevel;

  /// No description provided for @editEnterpriseStructureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Edit Enterprise Structure Configuration'**
  String get editEnterpriseStructureConfiguration;

  /// No description provided for @defineOrganizationalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Define your organizational hierarchy levels and sequence'**
  String get defineOrganizationalHierarchy;

  /// No description provided for @createEnterpriseStructureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Create Enterprise Structure Configuration'**
  String get createEnterpriseStructureConfiguration;

  /// No description provided for @noConfigurationFound.
  ///
  /// In en, this message translates to:
  /// **'No Configuration Found'**
  String get noConfigurationFound;

  /// No description provided for @pleaseConfigureEnterpriseStructure.
  ///
  /// In en, this message translates to:
  /// **'Please configure your enterprise structure hierarchy before creating components.'**
  String get pleaseConfigureEnterpriseStructure;

  /// No description provided for @structureName.
  ///
  /// In en, this message translates to:
  /// **'Structure Name'**
  String get structureName;

  /// No description provided for @structureNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Standard Corporate Structure, Simplified Structure'**
  String get structureNamePlaceholder;

  /// No description provided for @descriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe this structure configuration and when it should be used...'**
  String get descriptionPlaceholder;

  /// No description provided for @manageComponentValues.
  ///
  /// In en, this message translates to:
  /// **'Manage Component Values'**
  String get manageComponentValues;

  /// No description provided for @componentValuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and manage organizational components (Company, Division, Business Unit, Department, Section)'**
  String get componentValuesSubtitle;

  /// No description provided for @manageOrganizationalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Manage organizational hierarchy and structure'**
  String get manageOrganizationalHierarchy;

  /// No description provided for @manageOrganizationalHierarchyAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة الهيكل التنظيمي والتسلسل الإداري'**
  String get manageOrganizationalHierarchyAr;

  /// No description provided for @structureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Structure Configuration'**
  String get structureConfiguration;

  /// No description provided for @organizationalTreeStructure.
  ///
  /// In en, this message translates to:
  /// **'Organizational Tree Structure'**
  String get organizationalTreeStructure;

  /// No description provided for @addNewComponent.
  ///
  /// In en, this message translates to:
  /// **'Add New Component'**
  String get addNewComponent;

  /// No description provided for @bulkUpload.
  ///
  /// In en, this message translates to:
  /// **'Bulk Upload'**
  String get bulkUpload;

  /// No description provided for @bulkUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Upload - Enterprise Structure Components'**
  String get bulkUploadTitle;

  /// No description provided for @bulkUploadInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Instructions'**
  String get bulkUploadInstructionsTitle;

  /// No description provided for @bulkUploadInstructionDownloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download the template file to see the required format'**
  String get bulkUploadInstructionDownloadTemplate;

  /// No description provided for @bulkUploadInstructionRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all required fields: Type, Code, Name, Name Arabic, Parent Code (if applicable)'**
  String get bulkUploadInstructionRequiredFields;

  /// No description provided for @bulkUploadInstructionOptionalFields.
  ///
  /// In en, this message translates to:
  /// **'Optional fields: Manager ID, Cost Center, Location, Description'**
  String get bulkUploadInstructionOptionalFields;

  /// No description provided for @bulkUploadInstructionParentCode.
  ///
  /// In en, this message translates to:
  /// **'Parent Code must match an existing component code'**
  String get bulkUploadInstructionParentCode;

  /// No description provided for @bulkUploadInstructionFileFormat.
  ///
  /// In en, this message translates to:
  /// **'File format: Excel (.xlsx) or CSV (.csv)'**
  String get bulkUploadInstructionFileFormat;

  /// No description provided for @bulkUploadInstructionRowLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum 1000 rows per upload'**
  String get bulkUploadInstructionRowLimit;

  /// No description provided for @bulkUploadStepDownloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Download Template'**
  String get bulkUploadStepDownloadLabel;

  /// No description provided for @bulkUploadDownloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download Excel Template'**
  String get bulkUploadDownloadTemplate;

  /// No description provided for @bulkUploadStepUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Upload Filled Template'**
  String get bulkUploadStepUploadLabel;

  /// No description provided for @bulkUploadDropHint.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop your file here, or click to browse'**
  String get bulkUploadDropHint;

  /// No description provided for @bulkUploadSupportedFormats.
  ///
  /// In en, this message translates to:
  /// **'Supports: .xlsx, .csv (Max size: 10MB)'**
  String get bulkUploadSupportedFormats;

  /// No description provided for @bulkUploadTemplatePreview.
  ///
  /// In en, this message translates to:
  /// **'Template Format Preview'**
  String get bulkUploadTemplatePreview;

  /// No description provided for @bulkUploadTypeHeader.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bulkUploadTypeHeader;

  /// No description provided for @bulkUploadCodeHeader.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get bulkUploadCodeHeader;

  /// No description provided for @bulkUploadNameHeader.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bulkUploadNameHeader;

  /// No description provided for @bulkUploadNameArabicHeader.
  ///
  /// In en, this message translates to:
  /// **'Name Arabic'**
  String get bulkUploadNameArabicHeader;

  /// No description provided for @bulkUploadParentCodeHeader.
  ///
  /// In en, this message translates to:
  /// **'Parent Code'**
  String get bulkUploadParentCodeHeader;

  /// No description provided for @bulkUploadManagerIdHeader.
  ///
  /// In en, this message translates to:
  /// **'Manager ID'**
  String get bulkUploadManagerIdHeader;

  /// No description provided for @bulkUploadLocationHeader.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get bulkUploadLocationHeader;

  /// No description provided for @bulkUploadSampleRow1Type.
  ///
  /// In en, this message translates to:
  /// **'company'**
  String get bulkUploadSampleRow1Type;

  /// No description provided for @bulkUploadSampleRow1Code.
  ///
  /// In en, this message translates to:
  /// **'COMP-001'**
  String get bulkUploadSampleRow1Code;

  /// No description provided for @bulkUploadSampleRow1Name.
  ///
  /// In en, this message translates to:
  /// **'Main Company'**
  String get bulkUploadSampleRow1Name;

  /// No description provided for @bulkUploadSampleRow1NameArabic.
  ///
  /// In en, this message translates to:
  /// **'الشركة الرئيسية'**
  String get bulkUploadSampleRow1NameArabic;

  /// No description provided for @bulkUploadSampleRow1ParentCode.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get bulkUploadSampleRow1ParentCode;

  /// No description provided for @bulkUploadSampleRow1ManagerId.
  ///
  /// In en, this message translates to:
  /// **'EMP-001'**
  String get bulkUploadSampleRow1ManagerId;

  /// No description provided for @bulkUploadSampleRow1Location.
  ///
  /// In en, this message translates to:
  /// **'Kuwait City'**
  String get bulkUploadSampleRow1Location;

  /// No description provided for @bulkUploadSampleRow2Type.
  ///
  /// In en, this message translates to:
  /// **'division'**
  String get bulkUploadSampleRow2Type;

  /// No description provided for @bulkUploadSampleRow2Code.
  ///
  /// In en, this message translates to:
  /// **'DIV-001'**
  String get bulkUploadSampleRow2Code;

  /// No description provided for @bulkUploadSampleRow2Name.
  ///
  /// In en, this message translates to:
  /// **'Finance Division'**
  String get bulkUploadSampleRow2Name;

  /// No description provided for @bulkUploadSampleRow2NameArabic.
  ///
  /// In en, this message translates to:
  /// **'قسم المالية'**
  String get bulkUploadSampleRow2NameArabic;

  /// No description provided for @bulkUploadSampleRow2ParentCode.
  ///
  /// In en, this message translates to:
  /// **'COMP-001'**
  String get bulkUploadSampleRow2ParentCode;

  /// No description provided for @bulkUploadSampleRow2ManagerId.
  ///
  /// In en, this message translates to:
  /// **'EMP-010'**
  String get bulkUploadSampleRow2ManagerId;

  /// No description provided for @bulkUploadSampleRow2Location.
  ///
  /// In en, this message translates to:
  /// **'Kuwait City HQ'**
  String get bulkUploadSampleRow2Location;

  /// No description provided for @bulkUploadUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload & Process'**
  String get bulkUploadUploadButton;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @searchComponents.
  ///
  /// In en, this message translates to:
  /// **'Search by name, code, or Arabic name...'**
  String get searchComponents;

  /// No description provided for @componentType.
  ///
  /// In en, this message translates to:
  /// **'Component Type'**
  String get componentType;

  /// No description provided for @componentCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get componentCode;

  /// No description provided for @componentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get componentName;

  /// No description provided for @arabicName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Name'**
  String get arabicName;

  /// No description provided for @parentComponent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parentComponent;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @createComponent.
  ///
  /// In en, this message translates to:
  /// **'Create Component'**
  String get createComponent;

  /// No description provided for @editComponent.
  ///
  /// In en, this message translates to:
  /// **'Edit Component'**
  String get editComponent;

  /// No description provided for @viewComponent.
  ///
  /// In en, this message translates to:
  /// **'View Component'**
  String get viewComponent;

  /// No description provided for @deleteComponent.
  ///
  /// In en, this message translates to:
  /// **'Delete Component'**
  String get deleteComponent;

  /// No description provided for @treeView.
  ///
  /// In en, this message translates to:
  /// **'Tree View'**
  String get treeView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @noComponentsFound.
  ///
  /// In en, this message translates to:
  /// **'No components found'**
  String get noComponentsFound;

  /// No description provided for @confirmDeleteComponent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this component?'**
  String get confirmDeleteComponent;

  /// No description provided for @componentTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Component type is required'**
  String get componentTypeRequired;

  /// No description provided for @componentCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Component code is required'**
  String get componentCodeRequired;

  /// No description provided for @componentNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Component name is required'**
  String get componentNameRequired;

  /// No description provided for @arabicNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Arabic name is required'**
  String get arabicNameRequired;

  /// No description provided for @selectComponentType.
  ///
  /// In en, this message translates to:
  /// **'Select component type'**
  String get selectComponentType;

  /// No description provided for @enterComponentCode.
  ///
  /// In en, this message translates to:
  /// **'Enter component code'**
  String get enterComponentCode;

  /// No description provided for @enterComponentName.
  ///
  /// In en, this message translates to:
  /// **'Enter component name'**
  String get enterComponentName;

  /// No description provided for @enterArabicName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic name'**
  String get enterArabicName;

  /// No description provided for @selectParentComponent.
  ///
  /// In en, this message translates to:
  /// **'Select parent component (optional)'**
  String get selectParentComponent;

  /// No description provided for @selectManager.
  ///
  /// In en, this message translates to:
  /// **'Select manager'**
  String get selectManager;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter location'**
  String get enterLocation;

  /// No description provided for @componentCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Component created successfully'**
  String get componentCreatedSuccessfully;

  /// No description provided for @componentUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Component updated successfully'**
  String get componentUpdatedSuccessfully;

  /// No description provided for @componentDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Component deleted successfully'**
  String get componentDeletedSuccessfully;

  /// No description provided for @bulkUploadInstructions.
  ///
  /// In en, this message translates to:
  /// **'Upload a CSV file with component data. Download the template for the correct format.'**
  String get bulkUploadInstructions;

  /// No description provided for @downloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download Template'**
  String get downloadTemplate;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upload successful'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @processingUpload.
  ///
  /// In en, this message translates to:
  /// **'Processing upload...'**
  String get processingUpload;

  /// No description provided for @selectComponentTypePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select type...'**
  String get selectComponentTypePlaceholder;

  /// No description provided for @componentDetails.
  ///
  /// In en, this message translates to:
  /// **'Component Details'**
  String get componentDetails;

  /// No description provided for @hierarchyRelationships.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy & Relationships'**
  String get hierarchyRelationships;

  /// No description provided for @managementInformation.
  ///
  /// In en, this message translates to:
  /// **'Management Information'**
  String get managementInformation;

  /// No description provided for @auditTrail.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get auditTrail;

  /// No description provided for @additionalFields.
  ///
  /// In en, this message translates to:
  /// **'Additional Fields'**
  String get additionalFields;

  /// No description provided for @nameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get nameEnglish;

  /// No description provided for @nameArabicSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get nameArabicSectionTitle;

  /// No description provided for @nameArabic.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get nameArabic;

  /// No description provided for @costCenter.
  ///
  /// In en, this message translates to:
  /// **'Cost Center'**
  String get costCenter;

  /// No description provided for @childComponents.
  ///
  /// In en, this message translates to:
  /// **'Child Components'**
  String get childComponents;

  /// No description provided for @hierarchyPath.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Path'**
  String get hierarchyPath;

  /// No description provided for @hierarchyLevel.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Level'**
  String get hierarchyLevel;

  /// No description provided for @lastUpdatedDate.
  ///
  /// In en, this message translates to:
  /// **'Last Updated Date'**
  String get lastUpdatedDate;

  /// No description provided for @lastUpdatedBy.
  ///
  /// In en, this message translates to:
  /// **'Last Updated By'**
  String get lastUpdatedBy;

  /// No description provided for @establishedDate.
  ///
  /// In en, this message translates to:
  /// **'Established Date'**
  String get establishedDate;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get registrationNumber;

  /// No description provided for @taxId.
  ///
  /// In en, this message translates to:
  /// **'Tax Id'**
  String get taxId;

  /// No description provided for @rootLevelNoParent.
  ///
  /// In en, this message translates to:
  /// **'Root Level - No Parent'**
  String get rootLevelNoParent;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description provided'**
  String get noDescription;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @companyManagement.
  ///
  /// In en, this message translates to:
  /// **'Company Management'**
  String get companyManagement;

  /// No description provided for @manageCompanyInformation.
  ///
  /// In en, this message translates to:
  /// **'Manage company information and organizational entities'**
  String get manageCompanyInformation;

  /// No description provided for @addCompany.
  ///
  /// In en, this message translates to:
  /// **'Add Company'**
  String get addCompany;

  /// No description provided for @totalCompanies.
  ///
  /// In en, this message translates to:
  /// **'Total Companies'**
  String get totalCompanies;

  /// No description provided for @activeCompanies.
  ///
  /// In en, this message translates to:
  /// **'Active Companies'**
  String get activeCompanies;

  /// No description provided for @totalEmployees.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployees;

  /// No description provided for @compliant.
  ///
  /// In en, this message translates to:
  /// **'Compliant'**
  String get compliant;

  /// No description provided for @searchCompaniesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by company name, code, or registration number...'**
  String get searchCompaniesPlaceholder;

  /// No description provided for @editCompany.
  ///
  /// In en, this message translates to:
  /// **'Edit Company'**
  String get editCompany;

  /// No description provided for @updateCompany.
  ///
  /// In en, this message translates to:
  /// **'Update Company'**
  String get updateCompany;

  /// No description provided for @hintCompanyCode.
  ///
  /// In en, this message translates to:
  /// **'Enter company code'**
  String get hintCompanyCode;

  /// No description provided for @hintCompanyNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Enter company name in English'**
  String get hintCompanyNameEnglish;

  /// No description provided for @hintCompanyNameArabic.
  ///
  /// In en, this message translates to:
  /// **'أدخل اسم الشركة بالعربية'**
  String get hintCompanyNameArabic;

  /// No description provided for @hintLegalNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Enter legal name in English'**
  String get hintLegalNameEnglish;

  /// No description provided for @hintLegalNameArabic.
  ///
  /// In en, this message translates to:
  /// **'أدخل الاسم القانوني بالعربية'**
  String get hintLegalNameArabic;

  /// No description provided for @hintRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter registration number'**
  String get hintRegistrationNumber;

  /// No description provided for @hintTaxId.
  ///
  /// In en, this message translates to:
  /// **'Enter tax ID'**
  String get hintTaxId;

  /// No description provided for @hintEstablishedDate.
  ///
  /// In en, this message translates to:
  /// **'dd/MM/yyyy'**
  String get hintEstablishedDate;

  /// No description provided for @hintIndustry.
  ///
  /// In en, this message translates to:
  /// **'Enter industry'**
  String get hintIndustry;

  /// No description provided for @hintCountry.
  ///
  /// In en, this message translates to:
  /// **'Enter country'**
  String get hintCountry;

  /// No description provided for @hintCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get hintCity;

  /// No description provided for @hintAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter full address'**
  String get hintAddress;

  /// No description provided for @hintPoBox.
  ///
  /// In en, this message translates to:
  /// **'Enter P.O. Box'**
  String get hintPoBox;

  /// No description provided for @hintZipCode.
  ///
  /// In en, this message translates to:
  /// **'Enter zip code'**
  String get hintZipCode;

  /// No description provided for @hintPhone.
  ///
  /// In en, this message translates to:
  /// **'e.g. +965 2222 2222'**
  String get hintPhone;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'e.g. john.smith@company.com'**
  String get hintEmail;

  /// No description provided for @hintWebsite.
  ///
  /// In en, this message translates to:
  /// **'Enter website URL'**
  String get hintWebsite;

  /// No description provided for @hintTotalEmployees.
  ///
  /// In en, this message translates to:
  /// **'Enter total employees'**
  String get hintTotalEmployees;

  /// No description provided for @hintFiscalYearStart.
  ///
  /// In en, this message translates to:
  /// **'MM-DD'**
  String get hintFiscalYearStart;

  /// No description provided for @companyDetails.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get companyDetails;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @financialAndOperational.
  ///
  /// In en, this message translates to:
  /// **'Financial & Operational'**
  String get financialAndOperational;

  /// No description provided for @established.
  ///
  /// In en, this message translates to:
  /// **'Established'**
  String get established;

  /// No description provided for @divisionManagement.
  ///
  /// In en, this message translates to:
  /// **'Division Management'**
  String get divisionManagement;

  /// No description provided for @manageDivisionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage organizational divisions across companies'**
  String get manageDivisionsSubtitle;

  /// No description provided for @addDivision.
  ///
  /// In en, this message translates to:
  /// **'Add Division'**
  String get addDivision;

  /// No description provided for @totalDivisions.
  ///
  /// In en, this message translates to:
  /// **'Total Divisions'**
  String get totalDivisions;

  /// No description provided for @activeDivisions.
  ///
  /// In en, this message translates to:
  /// **'Active Divisions'**
  String get activeDivisions;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudget;

  /// No description provided for @searchDivisionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by division name, code, or head of division...'**
  String get searchDivisionsPlaceholder;

  /// No description provided for @allCompanies.
  ///
  /// In en, this message translates to:
  /// **'All Companies'**
  String get allCompanies;

  /// No description provided for @head.
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get head;

  /// No description provided for @emp.
  ///
  /// In en, this message translates to:
  /// **'emp'**
  String get emp;

  /// No description provided for @depts.
  ///
  /// In en, this message translates to:
  /// **'depts'**
  String get depts;

  /// No description provided for @addNewDivision.
  ///
  /// In en, this message translates to:
  /// **'Add New Division'**
  String get addNewDivision;

  /// No description provided for @editDivision.
  ///
  /// In en, this message translates to:
  /// **'Edit Division'**
  String get editDivision;

  /// No description provided for @divisionCode.
  ///
  /// In en, this message translates to:
  /// **'Division Code'**
  String get divisionCode;

  /// No description provided for @divisionNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Division Name (English)'**
  String get divisionNameEnglish;

  /// No description provided for @divisionNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Division Name (Arabic)'**
  String get divisionNameArabic;

  /// No description provided for @headOfDivision.
  ///
  /// In en, this message translates to:
  /// **'Head of Division'**
  String get headOfDivision;

  /// No description provided for @headEmail.
  ///
  /// In en, this message translates to:
  /// **'Head Email'**
  String get headEmail;

  /// No description provided for @headPhone.
  ///
  /// In en, this message translates to:
  /// **'Head Phone'**
  String get headPhone;

  /// No description provided for @businessFocus.
  ///
  /// In en, this message translates to:
  /// **'Business Focus'**
  String get businessFocus;

  /// No description provided for @totalDepartments.
  ///
  /// In en, this message translates to:
  /// **'Total Departments'**
  String get totalDepartments;

  /// No description provided for @annualBudgetKwd.
  ///
  /// In en, this message translates to:
  /// **'Annual Budget (KWD)'**
  String get annualBudgetKwd;

  /// No description provided for @divisionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get divisionDescription;

  /// No description provided for @createDivision.
  ///
  /// In en, this message translates to:
  /// **'Create Division'**
  String get createDivision;

  /// No description provided for @updateDivision.
  ///
  /// In en, this message translates to:
  /// **'Update Division'**
  String get updateDivision;

  /// No description provided for @selectCompany.
  ///
  /// In en, this message translates to:
  /// **'Select Company'**
  String get selectCompany;

  /// No description provided for @hintDivisionCode.
  ///
  /// In en, this message translates to:
  /// **'e.g., DIV-FIN'**
  String get hintDivisionCode;

  /// No description provided for @hintDivisionNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Division Name'**
  String get hintDivisionNameEnglish;

  /// No description provided for @hintDivisionNameArabic.
  ///
  /// In en, this message translates to:
  /// **'اسم القسم'**
  String get hintDivisionNameArabic;

  /// No description provided for @hintHeadOfDivision.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get hintHeadOfDivision;

  /// No description provided for @hintHeadEmail.
  ///
  /// In en, this message translates to:
  /// **'email@company.com'**
  String get hintHeadEmail;

  /// No description provided for @hintHeadPhone.
  ///
  /// In en, this message translates to:
  /// **'+965 XXXX XXXX'**
  String get hintHeadPhone;

  /// No description provided for @hintLocation.
  ///
  /// In en, this message translates to:
  /// **'Building/Floor'**
  String get hintLocation;

  /// No description provided for @hintBusinessFocus.
  ///
  /// In en, this message translates to:
  /// **'e.g., Financial Services'**
  String get hintBusinessFocus;

  /// No description provided for @hintTotalDepartments.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintTotalDepartments;

  /// No description provided for @hintAnnualBudgetKwd.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintAnnualBudgetKwd;

  /// No description provided for @hintDivisionDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the division\'s role and responsibilities'**
  String get hintDivisionDescription;

  /// No description provided for @divisionDetails.
  ///
  /// In en, this message translates to:
  /// **'Division Details'**
  String get divisionDetails;

  /// No description provided for @leadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get leadership;

  /// No description provided for @organizationalMetrics.
  ///
  /// In en, this message translates to:
  /// **'Organizational Metrics'**
  String get organizationalMetrics;

  /// No description provided for @annualBudget.
  ///
  /// In en, this message translates to:
  /// **'Annual Budget'**
  String get annualBudget;

  /// No description provided for @businessUnitManagement.
  ///
  /// In en, this message translates to:
  /// **'Business Unit Management'**
  String get businessUnitManagement;

  /// No description provided for @manageBusinessUnitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage business units within divisions'**
  String get manageBusinessUnitsSubtitle;

  /// No description provided for @addBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Add Business Unit'**
  String get addBusinessUnit;

  /// No description provided for @totalUnits.
  ///
  /// In en, this message translates to:
  /// **'Total Units'**
  String get totalUnits;

  /// No description provided for @activeUnits.
  ///
  /// In en, this message translates to:
  /// **'Active Units'**
  String get activeUnits;

  /// No description provided for @searchBusinessUnitsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by business unit name, code, or head...'**
  String get searchBusinessUnitsPlaceholder;

  /// No description provided for @allDivisions.
  ///
  /// In en, this message translates to:
  /// **'All Divisions'**
  String get allDivisions;

  /// No description provided for @focusArea.
  ///
  /// In en, this message translates to:
  /// **'Focus Area'**
  String get focusArea;

  /// No description provided for @unitCode.
  ///
  /// In en, this message translates to:
  /// **'Unit Code'**
  String get unitCode;

  /// No description provided for @unitNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Unit Name (English)'**
  String get unitNameEnglish;

  /// No description provided for @unitNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Unit Name (Arabic)'**
  String get unitNameArabic;

  /// No description provided for @headOfUnit.
  ///
  /// In en, this message translates to:
  /// **'Head of Unit'**
  String get headOfUnit;

  /// No description provided for @createBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Create Unit'**
  String get createBusinessUnit;

  /// No description provided for @editBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Edit Business Unit'**
  String get editBusinessUnit;

  /// No description provided for @updateBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Update Unit'**
  String get updateBusinessUnit;

  /// No description provided for @hintBusinessUnitCode.
  ///
  /// In en, this message translates to:
  /// **'e.g., BU-FIN'**
  String get hintBusinessUnitCode;

  /// No description provided for @hintBusinessUnitName.
  ///
  /// In en, this message translates to:
  /// **'Business Unit Name'**
  String get hintBusinessUnitName;

  /// No description provided for @hintBusinessUnitNameArabic.
  ///
  /// In en, this message translates to:
  /// **'اسم الوحدة'**
  String get hintBusinessUnitNameArabic;

  /// No description provided for @hintSelectDivision.
  ///
  /// In en, this message translates to:
  /// **'Select Division'**
  String get hintSelectDivision;

  /// No description provided for @hintHeadOfUnit.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get hintHeadOfUnit;

  /// No description provided for @hintBusinessUnitHeadEmail.
  ///
  /// In en, this message translates to:
  /// **'email@company.com'**
  String get hintBusinessUnitHeadEmail;

  /// No description provided for @hintBusinessUnitHeadPhone.
  ///
  /// In en, this message translates to:
  /// **'+965 XXXX XXXX'**
  String get hintBusinessUnitHeadPhone;

  /// No description provided for @hintBusinessUnitFocus.
  ///
  /// In en, this message translates to:
  /// **'e.g., Treasury & Investments'**
  String get hintBusinessUnitFocus;

  /// No description provided for @hintBusinessUnitDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the business unit'**
  String get hintBusinessUnitDescription;

  /// No description provided for @businessUnitDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Unit Details'**
  String get businessUnitDetails;

  /// No description provided for @departmentManagement.
  ///
  /// In en, this message translates to:
  /// **'Department Management'**
  String get departmentManagement;

  /// No description provided for @manageDepartmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage departments within business units'**
  String get manageDepartmentsSubtitle;

  /// No description provided for @addDepartment.
  ///
  /// In en, this message translates to:
  /// **'Add Department'**
  String get addDepartment;

  /// No description provided for @activeDepartments.
  ///
  /// In en, this message translates to:
  /// **'Active Departments'**
  String get activeDepartments;

  /// No description provided for @totalEmployeesDept.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployeesDept;

  /// No description provided for @totalBudgetDept.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudgetDept;

  /// No description provided for @searchDepartmentsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by department name, code, or head...'**
  String get searchDepartmentsPlaceholder;

  /// No description provided for @allBusinessUnits.
  ///
  /// In en, this message translates to:
  /// **'All Business Units'**
  String get allBusinessUnits;

  /// No description provided for @departmentFocus.
  ///
  /// In en, this message translates to:
  /// **'Department Focus'**
  String get departmentFocus;

  /// No description provided for @departmentCode.
  ///
  /// In en, this message translates to:
  /// **'Department Code'**
  String get departmentCode;

  /// No description provided for @departmentNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Department Name (English)'**
  String get departmentNameEnglish;

  /// No description provided for @departmentNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Department Name (Arabic)'**
  String get departmentNameArabic;

  /// No description provided for @headOfDepartment.
  ///
  /// In en, this message translates to:
  /// **'Head of Department'**
  String get headOfDepartment;

  /// No description provided for @hintDepartmentCode.
  ///
  /// In en, this message translates to:
  /// **'e.g., DEPT-TREAS'**
  String get hintDepartmentCode;

  /// No description provided for @hintDepartmentNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get hintDepartmentNameEnglish;

  /// No description provided for @hintDepartmentNameArabic.
  ///
  /// In en, this message translates to:
  /// **'اسم القسم'**
  String get hintDepartmentNameArabic;

  /// No description provided for @hintBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Select Business Unit'**
  String get hintBusinessUnit;

  /// No description provided for @hintHeadOfDepartment.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get hintHeadOfDepartment;

  /// No description provided for @hintAnnualBudgetDepartment.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintAnnualBudgetDepartment;

  /// No description provided for @hintDescriptionDepartment.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the department'**
  String get hintDescriptionDepartment;

  /// No description provided for @editDepartment.
  ///
  /// In en, this message translates to:
  /// **'Edit Department'**
  String get editDepartment;

  /// No description provided for @updateDepartment.
  ///
  /// In en, this message translates to:
  /// **'Update Department'**
  String get updateDepartment;

  /// No description provided for @departmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Department Details'**
  String get departmentDetails;

  /// No description provided for @departmentLeadership.
  ///
  /// In en, this message translates to:
  /// **'Department Leadership'**
  String get departmentLeadership;

  /// No description provided for @departmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Department Description'**
  String get departmentDescription;

  /// No description provided for @departmentBudget.
  ///
  /// In en, this message translates to:
  /// **'Annual Budget (KWD)'**
  String get departmentBudget;

  /// No description provided for @sectionManagement.
  ///
  /// In en, this message translates to:
  /// **'Section Management'**
  String get sectionManagement;

  /// No description provided for @manageSectionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize and manage organizational sections'**
  String get manageSectionsSubtitle;

  /// No description provided for @addSection.
  ///
  /// In en, this message translates to:
  /// **'Add Section'**
  String get addSection;

  /// No description provided for @editSection.
  ///
  /// In en, this message translates to:
  /// **'Edit Section'**
  String get editSection;

  /// No description provided for @updateSection.
  ///
  /// In en, this message translates to:
  /// **'Update Section'**
  String get updateSection;

  /// No description provided for @sectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Section Details'**
  String get sectionDetails;

  /// No description provided for @totalSections.
  ///
  /// In en, this message translates to:
  /// **'Total Sections'**
  String get totalSections;

  /// No description provided for @activeSections.
  ///
  /// In en, this message translates to:
  /// **'Active Sections'**
  String get activeSections;

  /// No description provided for @totalEmployeesSection.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployeesSection;

  /// No description provided for @totalBudgetSection.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudgetSection;

  /// No description provided for @searchSectionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search sections...'**
  String get searchSectionsPlaceholder;

  /// No description provided for @managePositions.
  ///
  /// In en, this message translates to:
  /// **'Manage Positions'**
  String get managePositions;

  /// No description provided for @managePositionsJobFamilies.
  ///
  /// In en, this message translates to:
  /// **'Manage positions, job families, levels, and organizational structure'**
  String get managePositionsJobFamilies;

  /// No description provided for @managePositionsJobFamiliesAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة الوظائف والعائلات الوظيفية والمستويات والهيكل التنظيمي'**
  String get managePositionsJobFamiliesAr;

  /// No description provided for @totalPositions.
  ///
  /// In en, this message translates to:
  /// **'Total Positions'**
  String get totalPositions;

  /// No description provided for @filledPositions.
  ///
  /// In en, this message translates to:
  /// **'Filled Positions'**
  String get filledPositions;

  /// No description provided for @vacantPositions.
  ///
  /// In en, this message translates to:
  /// **'Vacant Positions'**
  String get vacantPositions;

  /// No description provided for @fillRate.
  ///
  /// In en, this message translates to:
  /// **'Fill Rate'**
  String get fillRate;

  /// No description provided for @positions.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get positions;

  /// No description provided for @jobFamilies.
  ///
  /// In en, this message translates to:
  /// **'Job Families'**
  String get jobFamilies;

  /// No description provided for @addJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Add Job Family'**
  String get addJobFamily;

  /// No description provided for @jobLevels.
  ///
  /// In en, this message translates to:
  /// **'Job Levels'**
  String get jobLevels;

  /// No description provided for @jobFamilyOverview.
  ///
  /// In en, this message translates to:
  /// **'Job Family Overview'**
  String get jobFamilyOverview;

  /// No description provided for @jobFamilyStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get jobFamilyStatus;

  /// No description provided for @positionsByLevel.
  ///
  /// In en, this message translates to:
  /// **'Positions By Level'**
  String get positionsByLevel;

  /// No description provided for @jobFamilyCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get jobFamilyCreated;

  /// No description provided for @jobFamilyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get jobFamilyUpdated;

  /// No description provided for @noDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No job level data is available for this family.'**
  String get noDataMessage;

  /// No description provided for @jobFamilyDetails.
  ///
  /// In en, this message translates to:
  /// **'Job Family Details'**
  String get jobFamilyDetails;

  /// No description provided for @jobLevelDetails.
  ///
  /// In en, this message translates to:
  /// **'Job Level Details'**
  String get jobLevelDetails;

  /// No description provided for @talentStatus.
  ///
  /// In en, this message translates to:
  /// **'Talent Status'**
  String get talentStatus;

  /// No description provided for @jobLevelCode.
  ///
  /// In en, this message translates to:
  /// **'Level Code'**
  String get jobLevelCode;

  /// No description provided for @salaryRangeSection.
  ///
  /// In en, this message translates to:
  /// **'Salary Range'**
  String get salaryRangeSection;

  /// No description provided for @minimumSalary.
  ///
  /// In en, this message translates to:
  /// **'Minimum Salary'**
  String get minimumSalary;

  /// No description provided for @maximumSalary.
  ///
  /// In en, this message translates to:
  /// **'Maximum Salary'**
  String get maximumSalary;

  /// No description provided for @medianSalary.
  ///
  /// In en, this message translates to:
  /// **'Median Salary'**
  String get medianSalary;

  /// No description provided for @keyResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'Key Responsibilities'**
  String get keyResponsibilities;

  /// No description provided for @progressionPath.
  ///
  /// In en, this message translates to:
  /// **'Progression Path'**
  String get progressionPath;

  /// No description provided for @averageTenure.
  ///
  /// In en, this message translates to:
  /// **'Average Tenure'**
  String get averageTenure;

  /// No description provided for @positionStatistics.
  ///
  /// In en, this message translates to:
  /// **'Position Statistics'**
  String get positionStatistics;

  /// No description provided for @enterNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Enter English name'**
  String get enterNameEnglish;

  /// No description provided for @enterNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic name'**
  String get enterNameArabic;

  /// No description provided for @positionFamilyDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get positionFamilyDescription;

  /// No description provided for @addNewJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Add New Job Family'**
  String get addNewJobFamily;

  /// No description provided for @jobFamilyCode.
  ///
  /// In en, this message translates to:
  /// **'Job Family Code'**
  String get jobFamilyCode;

  /// No description provided for @jobFamilyCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Job family code is required'**
  String get jobFamilyCodeRequired;

  /// No description provided for @jobFamilyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., JF-001'**
  String get jobFamilyCodeHint;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @autoGenerated.
  ///
  /// In en, this message translates to:
  /// **'Auto-generated'**
  String get autoGenerated;

  /// No description provided for @jobFamilyNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Job Family Name (English)'**
  String get jobFamilyNameEnglish;

  /// No description provided for @jobFamilyNameEnglishRequired.
  ///
  /// In en, this message translates to:
  /// **'Job family name (English) is required'**
  String get jobFamilyNameEnglishRequired;

  /// No description provided for @jobFamilyNameEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Finance & Accounting'**
  String get jobFamilyNameEnglishHint;

  /// No description provided for @jobFamilyNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Job Family Name (Arabic)'**
  String get jobFamilyNameArabic;

  /// No description provided for @jobFamilyNameArabicHint.
  ///
  /// In en, this message translates to:
  /// **'مثال: المالية والمحاسبة'**
  String get jobFamilyNameArabicHint;

  /// No description provided for @createJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Create Job Family'**
  String get createJobFamily;

  /// No description provided for @jobFamilyCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job family created successfully'**
  String get jobFamilyCreatedSuccessfully;

  /// No description provided for @jobFamilyUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job family updated successfully'**
  String get jobFamilyUpdatedSuccessfully;

  /// No description provided for @editJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Family'**
  String get editJobFamily;

  /// No description provided for @addNewJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Add New Job Level'**
  String get addNewJobLevel;

  /// No description provided for @editJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Level'**
  String get editJobLevel;

  /// No description provided for @levelName.
  ///
  /// In en, this message translates to:
  /// **'Level Name'**
  String get levelName;

  /// No description provided for @levelNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Level name is required'**
  String get levelNameRequired;

  /// No description provided for @levelNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Executive'**
  String get levelNameHint;

  /// No description provided for @jobLevelDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the level'**
  String get jobLevelDescriptionHint;

  /// No description provided for @jobLevelDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get jobLevelDescriptionRequired;

  /// No description provided for @jobFamilyDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Job family description is required'**
  String get jobFamilyDescriptionRequired;

  /// No description provided for @gradeRange.
  ///
  /// In en, this message translates to:
  /// **'Grade Range'**
  String get gradeRange;

  /// No description provided for @gradeRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Grade X - Grade Y'**
  String get gradeRangeHint;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @defaultJobFamily.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get defaultJobFamily;

  /// No description provided for @createJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Create Job Level'**
  String get createJobLevel;

  /// No description provided for @jobLevelCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., EXEC'**
  String get jobLevelCodeHint;

  /// No description provided for @jobLevelCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Job level code is required'**
  String get jobLevelCodeRequired;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @minimumGrade.
  ///
  /// In en, this message translates to:
  /// **'Minimum Grade'**
  String get minimumGrade;

  /// No description provided for @maximumGrade.
  ///
  /// In en, this message translates to:
  /// **'Maximum Grade'**
  String get maximumGrade;

  /// No description provided for @gradeStructure.
  ///
  /// In en, this message translates to:
  /// **'Grade & Step Structure'**
  String get gradeStructure;

  /// No description provided for @reportingStructure.
  ///
  /// In en, this message translates to:
  /// **'Reporting Structure'**
  String get reportingStructure;

  /// No description provided for @positionTree.
  ///
  /// In en, this message translates to:
  /// **'Position Tree'**
  String get positionTree;

  /// No description provided for @addPosition.
  ///
  /// In en, this message translates to:
  /// **'Add Position'**
  String get addPosition;

  /// No description provided for @editPosition.
  ///
  /// In en, this message translates to:
  /// **'Edit Position'**
  String get editPosition;

  /// No description provided for @addJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Add Job Level'**
  String get addJobLevel;

  /// No description provided for @addGrade.
  ///
  /// In en, this message translates to:
  /// **'Add Grade'**
  String get addGrade;

  /// No description provided for @createGrade.
  ///
  /// In en, this message translates to:
  /// **'Create Grade'**
  String get createGrade;

  /// No description provided for @editGrade.
  ///
  /// In en, this message translates to:
  /// **'Edit Grade'**
  String get editGrade;

  /// No description provided for @gradeName.
  ///
  /// In en, this message translates to:
  /// **'Grade Name'**
  String get gradeName;

  /// No description provided for @gradeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Grade A'**
  String get gradeNameHint;

  /// No description provided for @gradeDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter grade description'**
  String get gradeDescriptionHint;

  /// No description provided for @gradeSteps.
  ///
  /// In en, this message translates to:
  /// **'Grade Steps'**
  String get gradeSteps;

  /// No description provided for @gradeStepLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get gradeStepLabelHint;

  /// No description provided for @gradeStepAmountHint.
  ///
  /// In en, this message translates to:
  /// **'SAR 5,000'**
  String get gradeStepAmountHint;

  /// No description provided for @addStep.
  ///
  /// In en, this message translates to:
  /// **'Add Step'**
  String get addStep;

  /// No description provided for @gradeNumber.
  ///
  /// In en, this message translates to:
  /// **'Grade Number'**
  String get gradeNumber;

  /// No description provided for @selectGrade.
  ///
  /// In en, this message translates to:
  /// **'Select Grade'**
  String get selectGrade;

  /// No description provided for @selectGradeCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select grade category first'**
  String get selectGradeCategoryFirst;

  /// No description provided for @noGradeNumbersForCategory.
  ///
  /// In en, this message translates to:
  /// **'No grade numbers available for this category'**
  String get noGradeNumbersForCategory;

  /// No description provided for @selectMinimumGradeFirst.
  ///
  /// In en, this message translates to:
  /// **'Select minimum grade first'**
  String get selectMinimumGradeFirst;

  /// No description provided for @noHigherGradesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No higher grades available for this level'**
  String get noHigherGradesAvailable;

  /// No description provided for @pleaseSelectGrades.
  ///
  /// In en, this message translates to:
  /// **'Please select both minimum and maximum grades'**
  String get pleaseSelectGrades;

  /// No description provided for @minGradeMustBeLessOrEqualMax.
  ///
  /// In en, this message translates to:
  /// **'Minimum grade must be less than or equal to maximum grade'**
  String get minGradeMustBeLessOrEqualMax;

  /// No description provided for @gradeCategory.
  ///
  /// In en, this message translates to:
  /// **'Grade Category'**
  String get gradeCategory;

  /// No description provided for @gradeNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a grade number'**
  String get gradeNumberRequired;

  /// No description provided for @gradeCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a grade category'**
  String get gradeCategoryRequired;

  /// No description provided for @createNewGradeCategory.
  ///
  /// In en, this message translates to:
  /// **'Create New Grade Category'**
  String get createNewGradeCategory;

  /// No description provided for @createNewGradeNumber.
  ///
  /// In en, this message translates to:
  /// **'Create New Grade Number'**
  String get createNewGradeNumber;

  /// No description provided for @selectOneOrMoreGradeCategories.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more grade categories'**
  String get selectOneOrMoreGradeCategories;

  /// No description provided for @selectOneOrMoreGradeNumbers.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more grade numbers'**
  String get selectOneOrMoreGradeNumbers;

  /// No description provided for @lookupValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get lookupValueRequired;

  /// No description provided for @lookupValueDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This value has already been added'**
  String get lookupValueDuplicate;

  /// No description provided for @lookupValuesCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Lookup values created successfully'**
  String get lookupValuesCreatedSuccessfully;

  /// No description provided for @errorCreatingLookupValues.
  ///
  /// In en, this message translates to:
  /// **'Failed to create lookup values'**
  String get errorCreatingLookupValues;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enterValue;

  /// No description provided for @lookupCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get lookupCodeLabel;

  /// No description provided for @gradeCategoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Grade Category Name'**
  String get gradeCategoryNameLabel;

  /// No description provided for @gradeCategoryCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grade Category Code'**
  String get gradeCategoryCodeLabel;

  /// No description provided for @gradeCategoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. President'**
  String get gradeCategoryNameHint;

  /// No description provided for @gradeCategoryCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. P'**
  String get gradeCategoryCodeHint;

  /// No description provided for @gradeNumberInputHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Director'**
  String get gradeNumberInputHint;

  /// No description provided for @selectedItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedItemsCount(int count);

  /// No description provided for @stepSalaryRequired.
  ///
  /// In en, this message translates to:
  /// **'Step {step} salary is required'**
  String stepSalaryRequired(int step);

  /// No description provided for @stepSalaryInvalid.
  ///
  /// In en, this message translates to:
  /// **'Step {step} must be a valid number (0 or greater)'**
  String stepSalaryInvalid(int step);

  /// No description provided for @gradeCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Grade created successfully'**
  String get gradeCreatedSuccessfully;

  /// No description provided for @errorCreatingGrade.
  ///
  /// In en, this message translates to:
  /// **'Error creating grade'**
  String get errorCreatingGrade;

  /// No description provided for @gradeUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Grade updated successfully'**
  String get gradeUpdatedSuccessfully;

  /// No description provided for @errorUpdatingGrade.
  ///
  /// In en, this message translates to:
  /// **'Error updating grade'**
  String get errorUpdatingGrade;

  /// No description provided for @entryLevel.
  ///
  /// In en, this message translates to:
  /// **'Entry Level'**
  String get entryLevel;

  /// No description provided for @stepSalaryStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Step Salary Structure'**
  String get stepSalaryStructureTitle;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @kdSymbol.
  ///
  /// In en, this message translates to:
  /// **'KD'**
  String get kdSymbol;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @searchPositionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search positions by title, code, or Arabic name...'**
  String get searchPositionsPlaceholder;

  /// No description provided for @positionsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get positionsExportSuccess;

  /// No description provided for @positionsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export positions'**
  String get positionsExportFailed;

  /// No description provided for @allDepartments.
  ///
  /// In en, this message translates to:
  /// **'All Departments'**
  String get allDepartments;

  /// No description provided for @positionCode.
  ///
  /// In en, this message translates to:
  /// **'Position Code'**
  String get positionCode;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @jobFamily.
  ///
  /// In en, this message translates to:
  /// **'Job Family'**
  String get jobFamily;

  /// No description provided for @jobLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get jobLevel;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @gradeStep.
  ///
  /// In en, this message translates to:
  /// **'Grade/Step'**
  String get gradeStep;

  /// No description provided for @reportsTo.
  ///
  /// In en, this message translates to:
  /// **'Reports To'**
  String get reportsTo;

  /// No description provided for @headcount.
  ///
  /// In en, this message translates to:
  /// **'Headcount'**
  String get headcount;

  /// No description provided for @vacancy.
  ///
  /// In en, this message translates to:
  /// **'Vacancy'**
  String get vacancy;

  /// No description provided for @vacant.
  ///
  /// In en, this message translates to:
  /// **'vacant'**
  String get vacant;

  /// No description provided for @filled.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get filled;

  /// No description provided for @titleEnglish.
  ///
  /// In en, this message translates to:
  /// **'Title (English)'**
  String get titleEnglish;

  /// No description provided for @titleArabic.
  ///
  /// In en, this message translates to:
  /// **'Title (Arabic)'**
  String get titleArabic;

  /// No description provided for @reportingStructureDescription.
  ///
  /// In en, this message translates to:
  /// **'Tabular view of position reporting relationships and hierarchy'**
  String get reportingStructureDescription;

  /// No description provided for @reportingStructureDescriptionAr.
  ///
  /// In en, this message translates to:
  /// **'عرض جدولي لهيكل التقارير والتسلسل الوظيفي'**
  String get reportingStructureDescriptionAr;

  /// No description provided for @exportTable.
  ///
  /// In en, this message translates to:
  /// **'Export Table'**
  String get exportTable;

  /// No description provided for @reportingStructureExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get reportingStructureExportSuccess;

  /// No description provided for @reportingStructureExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export reporting structure'**
  String get reportingStructureExportFailed;

  /// No description provided for @withReports.
  ///
  /// In en, this message translates to:
  /// **'With Reports'**
  String get withReports;

  /// No description provided for @positionTitle.
  ///
  /// In en, this message translates to:
  /// **'Position Title'**
  String get positionTitle;

  /// No description provided for @directReports.
  ///
  /// In en, this message translates to:
  /// **'Direct Reports'**
  String get directReports;

  /// No description provided for @noReports.
  ///
  /// In en, this message translates to:
  /// **'No reports'**
  String get noReports;

  /// No description provided for @viewReports.
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReports;

  /// No description provided for @positionTypes.
  ///
  /// In en, this message translates to:
  /// **'Position Types'**
  String get positionTypes;

  /// No description provided for @topLevelPositions.
  ///
  /// In en, this message translates to:
  /// **'Top Level Positions'**
  String get topLevelPositions;

  /// No description provided for @noReportingManager.
  ///
  /// In en, this message translates to:
  /// **'No reporting manager'**
  String get noReportingManager;

  /// No description provided for @managementPositions.
  ///
  /// In en, this message translates to:
  /// **'Management Positions'**
  String get managementPositions;

  /// No description provided for @hasDirectReports.
  ///
  /// In en, this message translates to:
  /// **'Has direct reports'**
  String get hasDirectReports;

  /// No description provided for @individualContributors.
  ///
  /// In en, this message translates to:
  /// **'Individual Contributors'**
  String get individualContributors;

  /// No description provided for @noDirectReports.
  ///
  /// In en, this message translates to:
  /// **'No direct reports'**
  String get noDirectReports;

  /// No description provided for @positionDetails.
  ///
  /// In en, this message translates to:
  /// **'Position Details'**
  String get positionDetails;

  /// No description provided for @organizationalInformation.
  ///
  /// In en, this message translates to:
  /// **'Organizational Information'**
  String get organizationalInformation;

  /// No description provided for @jobClassification.
  ///
  /// In en, this message translates to:
  /// **'Job Classification'**
  String get jobClassification;

  /// No description provided for @headcountInformation.
  ///
  /// In en, this message translates to:
  /// **'Headcount Information'**
  String get headcountInformation;

  /// No description provided for @salaryInformation.
  ///
  /// In en, this message translates to:
  /// **'Salary Information'**
  String get salaryInformation;

  /// No description provided for @reportingRelationship.
  ///
  /// In en, this message translates to:
  /// **'Reporting Relationship'**
  String get reportingRelationship;

  /// No description provided for @employmentType.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get employmentType;

  /// No description provided for @budgetedMin.
  ///
  /// In en, this message translates to:
  /// **'Budgeted Min'**
  String get budgetedMin;

  /// No description provided for @budgetedMax.
  ///
  /// In en, this message translates to:
  /// **'Budgeted Max'**
  String get budgetedMax;

  /// No description provided for @actualAverage.
  ///
  /// In en, this message translates to:
  /// **'Actual Average'**
  String get actualAverage;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @deleteJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Delete Job Level'**
  String get deleteJobLevel;

  /// No description provided for @deleteJobLevelConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this job level? This action cannot be undone.'**
  String get deleteJobLevelConfirmationMessage;

  /// No description provided for @jobLevelCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job level created successfully'**
  String get jobLevelCreatedSuccessfully;

  /// No description provided for @jobLevelUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job level updated successfully'**
  String get jobLevelUpdatedSuccessfully;

  /// No description provided for @jobLevelDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job level deleted successfully'**
  String get jobLevelDeletedSuccessfully;

  /// No description provided for @errorCreatingJobLevel.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while creating the job level'**
  String get errorCreatingJobLevel;

  /// No description provided for @errorDeletingJobLevel.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while deleting the job level'**
  String get errorDeletingJobLevel;

  /// No description provided for @timeManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Management'**
  String get timeManagementTitle;

  /// No description provided for @tmAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get tmAttendance;

  /// No description provided for @tmLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get tmLate;

  /// No description provided for @tmOvertime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get tmOvertime;

  /// No description provided for @tmAbsences.
  ///
  /// In en, this message translates to:
  /// **'Absences'**
  String get tmAbsences;

  /// No description provided for @tmPendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get tmPendingApprovals;

  /// No description provided for @tmCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get tmCheckIn;

  /// No description provided for @tmCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get tmCheckOut;

  /// No description provided for @tmRequestLeave.
  ///
  /// In en, this message translates to:
  /// **'Request Leave'**
  String get tmRequestLeave;

  /// No description provided for @tmAssignSchedule.
  ///
  /// In en, this message translates to:
  /// **'Assign Schedule'**
  String get tmAssignSchedule;

  /// No description provided for @tmApprovals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get tmApprovals;

  /// No description provided for @tmOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tmOverview;

  /// No description provided for @tmSchedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get tmSchedules;

  /// No description provided for @tmRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get tmRequests;

  /// No description provided for @tmEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get tmEmployee;

  /// No description provided for @tmType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tmType;

  /// No description provided for @tmDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get tmDate;

  /// No description provided for @tmDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get tmDuration;

  /// No description provided for @tmStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tmStatus;

  /// No description provided for @tmAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get tmAction;

  /// No description provided for @tmSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by employee, type...'**
  String get tmSearchPlaceholder;

  /// No description provided for @tmFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get tmFilterAll;

  /// No description provided for @tmFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get tmFilterPending;

  /// No description provided for @tmFilterApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get tmFilterApproved;

  /// No description provided for @tmFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get tmFilterRejected;

  /// No description provided for @manageShiftsWorkPatterns.
  ///
  /// In en, this message translates to:
  /// **'Manage shifts, work patterns, schedules, and assignments'**
  String get manageShiftsWorkPatterns;

  /// No description provided for @manageShiftsWorkPatternsAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة الورديات وأنماط العمل والجداول والتعيينات'**
  String get manageShiftsWorkPatternsAr;

  /// No description provided for @shifts.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shifts;

  /// No description provided for @workPatterns.
  ///
  /// In en, this message translates to:
  /// **'Work Patterns'**
  String get workPatterns;

  /// No description provided for @addWorkPattern.
  ///
  /// In en, this message translates to:
  /// **'Add Work Pattern'**
  String get addWorkPattern;

  /// No description provided for @createWorkPattern.
  ///
  /// In en, this message translates to:
  /// **'Create Work Pattern'**
  String get createWorkPattern;

  /// No description provided for @workSchedules.
  ///
  /// In en, this message translates to:
  /// **'Work Schedules'**
  String get workSchedules;

  /// No description provided for @createWorkSchedule.
  ///
  /// In en, this message translates to:
  /// **'Create Schedule'**
  String get createWorkSchedule;

  /// No description provided for @scheduleAssignments.
  ///
  /// In en, this message translates to:
  /// **'Schedule Assignments'**
  String get scheduleAssignments;

  /// No description provided for @viewCalendar.
  ///
  /// In en, this message translates to:
  /// **'View Calendar'**
  String get viewCalendar;

  /// No description provided for @publicHolidays.
  ///
  /// In en, this message translates to:
  /// **'Public Holidays'**
  String get publicHolidays;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// No description provided for @deleteStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Organization Structure'**
  String get deleteStructureTitle;

  /// No description provided for @cascadeDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete the organization structure and all associated organizational units.'**
  String get cascadeDeleteWarning;

  /// No description provided for @cascadeDeleteDetails.
  ///
  /// In en, this message translates to:
  /// **'The structure \"{structureName}\" has {orgUnitsCount} organizational unit(s) that will be deleted. This action cannot be undone.'**
  String cascadeDeleteDetails(String structureName, int orgUnitsCount);

  /// No description provided for @deleteStructureMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to proceed?'**
  String get deleteStructureMessage;

  /// No description provided for @structureReferencedError.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete organization structure: This structure is referenced by other records in the database.'**
  String get structureReferencedError;

  /// No description provided for @structureDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Organization structure deleted successfully.'**
  String get structureDeletedSuccess;

  /// No description provided for @confirmDeleteStructure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this structure?'**
  String get confirmDeleteStructure;

  /// No description provided for @activateStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate structure'**
  String get activateStructureTitle;

  /// No description provided for @confirmActivateStructure.
  ///
  /// In en, this message translates to:
  /// **'Do you want to set this structure as the active organization structure?'**
  String get confirmActivateStructure;

  /// No description provided for @structureHasOrgUnits.
  ///
  /// In en, this message translates to:
  /// **'This structure has {count} organizational unit(s) that reference it. You must delete all organizational units first, or use cascade delete.'**
  String structureHasOrgUnits(int count);

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @leaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Leave Requests'**
  String get leaveRequests;

  /// No description provided for @leaveRequestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Submit and approve requests'**
  String get leaveRequestsDescription;

  /// No description provided for @leaveBalance.
  ///
  /// In en, this message translates to:
  /// **'Leave Balance'**
  String get leaveBalance;

  /// No description provided for @leaveBalanceDescription.
  ///
  /// In en, this message translates to:
  /// **'View and manage employee leave balances and accruals'**
  String get leaveBalanceDescription;

  /// No description provided for @leaveBalancesExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get leaveBalancesExportSuccess;

  /// No description provided for @leaveBalancesExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export leave balances'**
  String get leaveBalancesExportFailed;

  /// No description provided for @myLeaveBalance.
  ///
  /// In en, this message translates to:
  /// **'My Leave Balance'**
  String get myLeaveBalance;

  /// No description provided for @myLeaveBalanceDescription.
  ///
  /// In en, this message translates to:
  /// **'View your leave balances, carry forward, and forfeit information'**
  String get myLeaveBalanceDescription;

  /// No description provided for @applyLeave.
  ///
  /// In en, this message translates to:
  /// **'Apply Leave'**
  String get applyLeave;

  /// No description provided for @requestEncashment.
  ///
  /// In en, this message translates to:
  /// **'Request Encashment'**
  String get requestEncashment;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeName;

  /// No description provided for @employeeNumber.
  ///
  /// In en, this message translates to:
  /// **'Employee #'**
  String get employeeNumber;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @daysAvailable.
  ///
  /// In en, this message translates to:
  /// **'days available'**
  String get daysAvailable;

  /// No description provided for @currentYear.
  ///
  /// In en, this message translates to:
  /// **'Current Year'**
  String get currentYear;

  /// No description provided for @carriedForward.
  ///
  /// In en, this message translates to:
  /// **'Carried Forward'**
  String get carriedForward;

  /// No description provided for @carryForwardAllowed.
  ///
  /// In en, this message translates to:
  /// **'Carry Forward Allowed'**
  String get carryForwardAllowed;

  /// No description provided for @atRisk.
  ///
  /// In en, this message translates to:
  /// **'At Risk'**
  String get atRisk;

  /// No description provided for @atRiskForfeitable.
  ///
  /// In en, this message translates to:
  /// **'At-Risk (Forfeitable)'**
  String get atRiskForfeitable;

  /// No description provided for @encashmentAvailable.
  ///
  /// In en, this message translates to:
  /// **'Encashment Available'**
  String get encashmentAvailable;

  /// No description provided for @requestEncashmentButton.
  ///
  /// In en, this message translates to:
  /// **'Request →'**
  String get requestEncashmentButton;

  /// No description provided for @encashmentDescription.
  ///
  /// In en, this message translates to:
  /// **'You can request to encash unused leave days for monetary compensation'**
  String get encashmentDescription;

  /// No description provided for @atRiskDescription.
  ///
  /// In en, this message translates to:
  /// **'These days exceed the carry forward limit and will be forfeited after {date}'**
  String atRiskDescription(String date);

  /// No description provided for @hajjLeave.
  ///
  /// In en, this message translates to:
  /// **'Hajj Leave'**
  String get hajjLeave;

  /// No description provided for @hajjLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'إجازة الحج'**
  String get hajjLeaveArabic;

  /// No description provided for @compassionateLeave.
  ///
  /// In en, this message translates to:
  /// **'Compassionate Leave'**
  String get compassionateLeave;

  /// No description provided for @compassionateLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'إجازة خاصة'**
  String get compassionateLeaveArabic;

  /// No description provided for @annualLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'الإجازة السنوية'**
  String get annualLeaveArabic;

  /// No description provided for @sickLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'الإجازة المرضية'**
  String get sickLeaveArabic;

  /// No description provided for @kuwaitLaborLawLeavePolicy.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law Leave Policy'**
  String get kuwaitLaborLawLeavePolicy;

  /// No description provided for @carryForwardPolicy.
  ///
  /// In en, this message translates to:
  /// **'Carry Forward'**
  String get carryForwardPolicy;

  /// No description provided for @carryForwardPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Annual leave can be carried forward subject to Kuwait Labor Law regulations and company policy limits'**
  String get carryForwardPolicyDescription;

  /// No description provided for @forfeitRules.
  ///
  /// In en, this message translates to:
  /// **'Forfeit Rules'**
  String get forfeitRules;

  /// No description provided for @forfeitRulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave days exceeding carry forward limits will be forfeited at the end of the grace period'**
  String get forfeitRulesDescription;

  /// No description provided for @encashmentPolicy.
  ///
  /// In en, this message translates to:
  /// **'Encashment'**
  String get encashmentPolicy;

  /// No description provided for @encashmentPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Eligible leave types can be encashed subject to manager approval and company policy'**
  String get encashmentPolicyDescription;

  /// No description provided for @teamLeaveRiskDescription.
  ///
  /// In en, this message translates to:
  /// **'Team absence risk analysis'**
  String get teamLeaveRiskDescription;

  /// No description provided for @leavePolicies.
  ///
  /// In en, this message translates to:
  /// **'Leave Policies'**
  String get leavePolicies;

  /// No description provided for @leavePoliciesDescription.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law policies'**
  String get leavePoliciesDescription;

  /// No description provided for @policyConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Policy Configuration'**
  String get policyConfiguration;

  /// No description provided for @policyConfigurationDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure leave eligibility'**
  String get policyConfigurationDescription;

  /// No description provided for @addNewPolicy.
  ///
  /// In en, this message translates to:
  /// **'Add New Policy'**
  String get addNewPolicy;

  /// No description provided for @forfeitPolicy.
  ///
  /// In en, this message translates to:
  /// **'Forfeit Policy'**
  String get forfeitPolicy;

  /// No description provided for @forfeitPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave forfeit rules'**
  String get forfeitPolicyDescription;

  /// No description provided for @forfeitProcessing.
  ///
  /// In en, this message translates to:
  /// **'Leave Forfeit Processing'**
  String get forfeitProcessing;

  /// No description provided for @forfeitProcessingDescription.
  ///
  /// In en, this message translates to:
  /// **'Process automatic leave forfeit for employees exceeding carry forward limits'**
  String get forfeitProcessingDescription;

  /// No description provided for @forfeitReports.
  ///
  /// In en, this message translates to:
  /// **'Forfeit Reports'**
  String get forfeitReports;

  /// No description provided for @forfeitReportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Forfeit analytics'**
  String get forfeitReportsDescription;

  /// No description provided for @leaveCalendar.
  ///
  /// In en, this message translates to:
  /// **'Leave Calendar'**
  String get leaveCalendar;

  /// No description provided for @leaveCalendarDescription.
  ///
  /// In en, this message translates to:
  /// **'Team absence calendar'**
  String get leaveCalendarDescription;

  /// No description provided for @manageEmployeeLeaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Manage employee leave requests according to Kuwait Labor Law'**
  String get manageEmployeeLeaveRequests;

  /// No description provided for @newLeaveRequest.
  ///
  /// In en, this message translates to:
  /// **'New Leave Request'**
  String get newLeaveRequest;

  /// No description provided for @kuwaitLaborLawLeaveEntitlements.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law Leave Entitlements'**
  String get kuwaitLaborLawLeaveEntitlements;

  /// No description provided for @annualLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'30 days per year after 1 year of service'**
  String get annualLeaveEntitlement;

  /// No description provided for @sickLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'15 days full pay + 10 days half pay + 10 days unpaid'**
  String get sickLeaveEntitlement;

  /// No description provided for @maternityLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'70 days total (30 before, 40 after delivery)'**
  String get maternityLeaveEntitlement;

  /// No description provided for @emergencyLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'5 days per year for emergencies'**
  String get emergencyLeaveEntitlement;

  /// No description provided for @leaveFilterAll.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get leaveFilterAll;

  /// No description provided for @leaveFilterDraft.
  ///
  /// In en, this message translates to:
  /// **'draft'**
  String get leaveFilterDraft;

  /// No description provided for @leaveFilterPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get leaveFilterPending;

  /// No description provided for @leaveFilterApproved.
  ///
  /// In en, this message translates to:
  /// **'approved'**
  String get leaveFilterApproved;

  /// No description provided for @leaveFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get leaveFilterRejected;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @leaveBalanceTotal.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get leaveBalanceTotal;

  /// No description provided for @leaveBalanceUsed.
  ///
  /// In en, this message translates to:
  /// **'Used:'**
  String get leaveBalanceUsed;

  /// No description provided for @leaveBalanceRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining:'**
  String get leaveBalanceRemaining;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @submittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted at'**
  String get submittedAt;

  /// No description provided for @processedAt.
  ///
  /// In en, this message translates to:
  /// **'Processed at'**
  String get processedAt;

  /// No description provided for @maternityLeave.
  ///
  /// In en, this message translates to:
  /// **'Maternity Leave'**
  String get maternityLeave;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @rejectTimesheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Timesheet'**
  String get rejectTimesheetTitle;

  /// No description provided for @rejectReason.
  ///
  /// In en, this message translates to:
  /// **'Reject reason'**
  String get rejectReason;

  /// No description provided for @rejectReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason for rejection'**
  String get rejectReasonRequired;

  /// No description provided for @approveTimesheetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve timesheet'**
  String get approveTimesheetConfirmTitle;

  /// No description provided for @approveTimesheetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this timesheet?'**
  String get approveTimesheetConfirmMessage;

  /// No description provided for @rejectTimesheetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject timesheet'**
  String get rejectTimesheetConfirmTitle;

  /// No description provided for @rejectTimesheetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this timesheet? You will need to provide a reason.'**
  String get rejectTimesheetConfirmMessage;

  /// No description provided for @approveOvertimeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve overtime request'**
  String get approveOvertimeConfirmTitle;

  /// No description provided for @approveOvertimeConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this overtime request?'**
  String get approveOvertimeConfirmMessage;

  /// No description provided for @rejectOvertimeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject overtime request'**
  String get rejectOvertimeConfirmTitle;

  /// No description provided for @rejectOvertimeConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this overtime request? You will need to provide a reason.'**
  String get rejectOvertimeConfirmMessage;

  /// No description provided for @cancelOvertimeDraftConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel draft overtime request'**
  String get cancelOvertimeDraftConfirmTitle;

  /// No description provided for @cancelOvertimeDraftConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this draft? This action cannot be undone.'**
  String get cancelOvertimeDraftConfirmMessage;

  /// No description provided for @overtimeDraftCancelled.
  ///
  /// In en, this message translates to:
  /// **'Draft overtime request cancelled successfully'**
  String get overtimeDraftCancelled;

  /// No description provided for @totalRequests.
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get totalRequests;

  /// No description provided for @leaveRequestGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Leave Request Guidelines'**
  String get leaveRequestGuidelines;

  /// No description provided for @submitRequests3DaysAdvance.
  ///
  /// In en, this message translates to:
  /// **'• Submit requests at least 3 days in advance for annual leave'**
  String get submitRequests3DaysAdvance;

  /// No description provided for @sickLeaveRequiresCertificate.
  ///
  /// In en, this message translates to:
  /// **'• Sick leave requires medical certificate if more than 3 days'**
  String get sickLeaveRequiresCertificate;

  /// No description provided for @ensureWorkHandover.
  ///
  /// In en, this message translates to:
  /// **'• Ensure work handover is completed before leave starts'**
  String get ensureWorkHandover;

  /// No description provided for @typeToSearchEmployees.
  ///
  /// In en, this message translates to:
  /// **'Type to search employees...'**
  String get typeToSearchEmployees;

  /// No description provided for @searchByNameOrEmployeeNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by name or employee number'**
  String get searchByNameOrEmployeeNumber;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchToFindEmployeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Search to find employees'**
  String get searchToFindEmployeesTitle;

  /// No description provided for @searchEmployeeEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a name or employee number in the search field above and press Enter to find employees.'**
  String get searchEmployeeEmptyMessage;

  /// No description provided for @noEmployeesMatchSearchMessage.
  ///
  /// In en, this message translates to:
  /// **'No employees match your search. Try a different name or employee number.'**
  String get noEmployeesMatchSearchMessage;

  /// No description provided for @leaveTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Leave Type'**
  String get leaveTypeRequired;

  /// No description provided for @annualLeavePaidVacation.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave (Paid Vacation)'**
  String get annualLeavePaidVacation;

  /// No description provided for @regularPaidVacationLeave.
  ///
  /// In en, this message translates to:
  /// **'Regular paid vacation leave'**
  String get regularPaidVacationLeave;

  /// No description provided for @maximum30DaysPerYear.
  ///
  /// In en, this message translates to:
  /// **'Maximum: 30 days per year'**
  String get maximum30DaysPerYear;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @fullDay.
  ///
  /// In en, this message translates to:
  /// **'Full Day'**
  String get fullDay;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @completeAllStepsToSubmit.
  ///
  /// In en, this message translates to:
  /// **'Complete all steps to submit your leave application'**
  String get completeAllStepsToSubmit;

  /// No description provided for @leaveDetails.
  ///
  /// In en, this message translates to:
  /// **'Leave Details'**
  String get leaveDetails;

  /// No description provided for @contactNotes.
  ///
  /// In en, this message translates to:
  /// **'Contact & Notes'**
  String get contactNotes;

  /// No description provided for @documentsReview.
  ///
  /// In en, this message translates to:
  /// **'Documents & Review'**
  String get documentsReview;

  /// No description provided for @reasonForLeave.
  ///
  /// In en, this message translates to:
  /// **'Reason for Leave'**
  String get reasonForLeave;

  /// No description provided for @pleaseProvideDetailedReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a detailed reason for your leave request...'**
  String get pleaseProvideDetailedReason;

  /// No description provided for @charactersCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/500 characters'**
  String charactersCount(int count);

  /// No description provided for @workDelegatedTo.
  ///
  /// In en, this message translates to:
  /// **'Work Delegated To'**
  String get workDelegatedTo;

  /// No description provided for @selectColleagueToHandleWork.
  ///
  /// In en, this message translates to:
  /// **'Select colleague to handle your work...'**
  String get selectColleagueToHandleWork;

  /// No description provided for @selectColleagueWhoWillHandle.
  ///
  /// In en, this message translates to:
  /// **'Select a colleague who will handle your responsibilities during your absence'**
  String get selectColleagueWhoWillHandle;

  /// No description provided for @contactInformationDuringLeave.
  ///
  /// In en, this message translates to:
  /// **'Contact Information During Leave'**
  String get contactInformationDuringLeave;

  /// No description provided for @addressDuringLeave.
  ///
  /// In en, this message translates to:
  /// **'Address During Leave'**
  String get addressDuringLeave;

  /// No description provided for @enterAddressOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your address or location during leave...'**
  String get enterAddressOrLocation;

  /// No description provided for @contactPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone Number'**
  String get contactPhoneNumber;

  /// No description provided for @emergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get emergencyContactName;

  /// No description provided for @enterEmergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter emergency contact name'**
  String get enterEmergencyContactName;

  /// No description provided for @emergencyContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Phone'**
  String get emergencyContactPhone;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @anyAdditionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Any additional information or special considerations...'**
  String get anyAdditionalInformation;

  /// No description provided for @supportingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Supporting Documents'**
  String get supportingDocuments;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentType;

  /// No description provided for @replaceDocument.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replaceDocument;

  /// No description provided for @clickToUploadOrDragDrop.
  ///
  /// In en, this message translates to:
  /// **'Click to upload or drag and drop'**
  String get clickToUploadOrDragDrop;

  /// No description provided for @pdfDocDocxJpgPngUpTo10MB.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOC, DOCX, JPG, PNG up to 10MB each'**
  String get pdfDocDocxJpgPngUpTo10MB;

  /// No description provided for @requiredDocuments.
  ///
  /// In en, this message translates to:
  /// **'Required Documents:'**
  String get requiredDocuments;

  /// No description provided for @supportingDocumentsIfApplicable.
  ///
  /// In en, this message translates to:
  /// **'• Supporting documents (if applicable)'**
  String get supportingDocumentsIfApplicable;

  /// No description provided for @requestSummary.
  ///
  /// In en, this message translates to:
  /// **'Request Summary'**
  String get requestSummary;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @filesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s)'**
  String filesCount(int count);

  /// No description provided for @declaration.
  ///
  /// In en, this message translates to:
  /// **'Declaration'**
  String get declaration;

  /// No description provided for @declarationText.
  ///
  /// In en, this message translates to:
  /// **'By submitting this leave request, I confirm that all information provided is accurate and complete. I understand that providing false information may result in disciplinary action. I have completed necessary work handover and informed relevant parties about my absence.'**
  String get declarationText;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @saveAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as draft'**
  String get saveAsDraft;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @teamLeaveRisk.
  ///
  /// In en, this message translates to:
  /// **'Team Leave Risk'**
  String get teamLeaveRisk;

  /// No description provided for @teamLeaveRiskDashboard.
  ///
  /// In en, this message translates to:
  /// **'Team Leave Risk Dashboard'**
  String get teamLeaveRiskDashboard;

  /// No description provided for @monitorAndManageTeamMembersAtRisk.
  ///
  /// In en, this message translates to:
  /// **'Monitor and manage team members at risk of leave forfeit'**
  String get monitorAndManageTeamMembersAtRisk;

  /// No description provided for @teamMembers.
  ///
  /// In en, this message translates to:
  /// **'Team Members'**
  String get teamMembers;

  /// No description provided for @activeEmployees.
  ///
  /// In en, this message translates to:
  /// **'Active employees'**
  String get activeEmployees;

  /// No description provided for @employeesAtRisk.
  ///
  /// In en, this message translates to:
  /// **'Employees at Risk'**
  String get employeesAtRisk;

  /// No description provided for @totalAtRiskDays.
  ///
  /// In en, this message translates to:
  /// **'Total At-Risk Days'**
  String get totalAtRiskDays;

  /// No description provided for @acrossAllTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Across all team members'**
  String get acrossAllTeamMembers;

  /// No description provided for @avgAtRiskPerEmployee.
  ///
  /// In en, this message translates to:
  /// **'Avg At-Risk per Employee'**
  String get avgAtRiskPerEmployee;

  /// No description provided for @daysPerEmployee.
  ///
  /// In en, this message translates to:
  /// **'Days per employee'**
  String get daysPerEmployee;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @allLeaveTypes.
  ///
  /// In en, this message translates to:
  /// **'All Leave Types'**
  String get allLeaveTypes;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @attendanceLogsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get attendanceLogsExportSuccess;

  /// No description provided for @attendanceLogsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export attendance logs'**
  String get attendanceLogsExportFailed;

  /// No description provided for @attendanceSummaryExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get attendanceSummaryExportSuccess;

  /// No description provided for @attendanceSummaryExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export attendance summary'**
  String get attendanceSummaryExportFailed;

  /// No description provided for @timesheetsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get timesheetsExportSuccess;

  /// No description provided for @timesheetsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export timesheets'**
  String get timesheetsExportFailed;

  /// No description provided for @overtimeRequestsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get overtimeRequestsExportSuccess;

  /// No description provided for @overtimeRequestsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export overtime requests'**
  String get overtimeRequestsExportFailed;

  /// No description provided for @compComponentsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get compComponentsExportSuccess;

  /// No description provided for @compComponentsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export compensation components'**
  String get compComponentsExportFailed;

  /// No description provided for @compSalaryStructuresExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get compSalaryStructuresExportSuccess;

  /// No description provided for @compSalaryStructuresExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export salary structures'**
  String get compSalaryStructuresExportFailed;

  /// No description provided for @compPlansExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get compPlansExportSuccess;

  /// No description provided for @compPlansExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export compensation plans'**
  String get compPlansExportFailed;

  /// No description provided for @compSalaryChangeHistoryExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get compSalaryChangeHistoryExportSuccess;

  /// No description provided for @compSalaryChangeHistoryExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export salary change history'**
  String get compSalaryChangeHistoryExportFailed;

  /// No description provided for @compEmployeeCompensationExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get compEmployeeCompensationExportSuccess;

  /// No description provided for @compEmployeeCompensationExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export employee compensation'**
  String get compEmployeeCompensationExportFailed;

  /// No description provided for @jobRolesExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get jobRolesExportSuccess;

  /// No description provided for @jobRolesExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export job roles'**
  String get jobRolesExportFailed;

  /// No description provided for @dataRolesExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get dataRolesExportSuccess;

  /// No description provided for @dataRolesExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data roles'**
  String get dataRolesExportFailed;

  /// No description provided for @dutyRolesExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get dutyRolesExportSuccess;

  /// No description provided for @dutyRolesExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export duty roles'**
  String get dutyRolesExportFailed;

  /// No description provided for @functionRolesExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get functionRolesExportSuccess;

  /// No description provided for @functionRolesExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export function roles'**
  String get functionRolesExportFailed;

  /// No description provided for @requisitionsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get requisitionsExportSuccess;

  /// No description provided for @requisitionsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export requisitions'**
  String get requisitionsExportFailed;

  /// No description provided for @candidatesExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get candidatesExportSuccess;

  /// No description provided for @candidatesExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export candidates'**
  String get candidatesExportFailed;

  /// No description provided for @jobOffersExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export file ready to save'**
  String get jobOffersExportSuccess;

  /// No description provided for @jobOffersExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export job offers'**
  String get jobOffersExportFailed;

  /// No description provided for @employeesWithAtRiskLeave.
  ///
  /// In en, this message translates to:
  /// **'Employees with At-Risk Leave'**
  String get employeesWithAtRiskLeave;

  /// No description provided for @atRiskDays.
  ///
  /// In en, this message translates to:
  /// **'At-Risk Days'**
  String get atRiskDays;

  /// No description provided for @carryForwardLimit.
  ///
  /// In en, this message translates to:
  /// **'Carry Forward Limit'**
  String get carryForwardLimit;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysLeft(int count);

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @managerActionRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Manager Action Recommendations'**
  String get managerActionRecommendations;

  /// No description provided for @encourageLeavePlanning.
  ///
  /// In en, this message translates to:
  /// **'Encourage Leave Planning'**
  String get encourageLeavePlanning;

  /// No description provided for @encourageLeavePlanningDescription.
  ///
  /// In en, this message translates to:
  /// **'Proactively discuss leave plans with team members who have high at-risk balances'**
  String get encourageLeavePlanningDescription;

  /// No description provided for @approvePendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Approve Pending Requests'**
  String get approvePendingRequests;

  /// No description provided for @approvePendingRequestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Review and approve pending leave requests to help employees utilize their balance'**
  String get approvePendingRequestsDescription;

  /// No description provided for @encashmentOption.
  ///
  /// In en, this message translates to:
  /// **'Encashment Option'**
  String get encashmentOption;

  /// No description provided for @encashmentOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Consider approving encashment requests for employees who cannot take leave'**
  String get encashmentOptionDescription;

  /// No description provided for @overtimeManagment.
  ///
  /// In en, this message translates to:
  /// **'Overtime Management'**
  String get overtimeManagment;

  /// No description provided for @overtimeManagmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Track and manage overtime hours and approvals'**
  String get overtimeManagmentDescription;

  /// No description provided for @requestOvertime.
  ///
  /// In en, this message translates to:
  /// **'Request Overtime'**
  String get requestOvertime;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @userSummary.
  ///
  /// In en, this message translates to:
  /// **'User Summary'**
  String get userSummary;

  /// No description provided for @requestAssessment.
  ///
  /// In en, this message translates to:
  /// **'Request Assessment'**
  String get requestAssessment;

  /// No description provided for @candidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate'**
  String get candidate;

  /// No description provided for @assessmentType.
  ///
  /// In en, this message translates to:
  /// **'Assessment Type'**
  String get assessmentType;

  /// No description provided for @assessmentTemplate.
  ///
  /// In en, this message translates to:
  /// **'Assessment Template'**
  String get assessmentTemplate;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @difficultyLevel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty Level'**
  String get difficultyLevel;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// No description provided for @completionDueDate.
  ///
  /// In en, this message translates to:
  /// **'Completion Due Date'**
  String get completionDueDate;

  /// No description provided for @skillsToAssess.
  ///
  /// In en, this message translates to:
  /// **'Skills to Assess'**
  String get skillsToAssess;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'Add Skill'**
  String get addSkill;

  /// No description provided for @instructionsForCandidate.
  ///
  /// In en, this message translates to:
  /// **'Instructions for Candidate'**
  String get instructionsForCandidate;

  /// No description provided for @sendAssessmentRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Assessment Request'**
  String get sendAssessmentRequest;

  /// No description provided for @editAssessment.
  ///
  /// In en, this message translates to:
  /// **'Edit Assessment'**
  String get editAssessment;

  /// No description provided for @updateAssessment.
  ///
  /// In en, this message translates to:
  /// **'Update Assessment'**
  String get updateAssessment;

  /// No description provided for @assessmentUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Assessment updated successfully'**
  String get assessmentUpdatedSuccessfully;

  /// No description provided for @selectTemplateOrCustom.
  ///
  /// In en, this message translates to:
  /// **'Select a template or create custom'**
  String get selectTemplateOrCustom;

  /// No description provided for @technicalCoding.
  ///
  /// In en, this message translates to:
  /// **'Technical Coding'**
  String get technicalCoding;

  /// No description provided for @internal.
  ///
  /// In en, this message translates to:
  /// **'Internal'**
  String get internal;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @sixtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'60 minutes'**
  String get sixtyMinutes;

  /// No description provided for @skillsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., JavaScript, Problem Solving, Leadership'**
  String get skillsHint;

  /// No description provided for @instructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Provide specific instructions, guidelines, or focus areas for the assessment...'**
  String get instructionsHint;

  /// No description provided for @hiringPipelineApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get hiringPipelineApplied;

  /// No description provided for @hiringPipelineScreening.
  ///
  /// In en, this message translates to:
  /// **'Screening'**
  String get hiringPipelineScreening;

  /// No description provided for @hiringPipelineShortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get hiringPipelineShortlisted;

  /// No description provided for @hiringPipelineInterviewRound1.
  ///
  /// In en, this message translates to:
  /// **'Interview Round 1'**
  String get hiringPipelineInterviewRound1;

  /// No description provided for @hiringPipelineInterviewRound2.
  ///
  /// In en, this message translates to:
  /// **'Interview Round 2'**
  String get hiringPipelineInterviewRound2;

  /// No description provided for @hiringPipelineInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get hiringPipelineInterview;

  /// No description provided for @hiringPipelineOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get hiringPipelineOffer;

  /// No description provided for @hiringPipelineRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get hiringPipelineRejected;

  /// No description provided for @hiringPipelineSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get hiringPipelineSelected;

  /// No description provided for @hiringPipelineOffered.
  ///
  /// In en, this message translates to:
  /// **'Offered'**
  String get hiringPipelineOffered;

  /// No description provided for @hiringPipelineHired.
  ///
  /// In en, this message translates to:
  /// **'Hired'**
  String get hiringPipelineHired;

  /// No description provided for @hiringPipelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Hiring Pipeline'**
  String get hiringPipelineTitle;

  /// No description provided for @hiringApplicationMoveStageTitle.
  ///
  /// In en, this message translates to:
  /// **'Move Stage'**
  String get hiringApplicationMoveStageTitle;

  /// No description provided for @hiringApplicationMoveStageSelectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Stage'**
  String get hiringApplicationMoveStageSelectLabel;

  /// No description provided for @hiringApplicationMoveStageSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select a stage'**
  String get hiringApplicationMoveStageSelectHint;

  /// No description provided for @hiringApplicationMoveStageCommentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Comments (Optional)'**
  String get hiringApplicationMoveStageCommentsLabel;

  /// No description provided for @hiringApplicationMoveStageCommentsHint.
  ///
  /// In en, this message translates to:
  /// **'Add any comments about this stage change...'**
  String get hiringApplicationMoveStageCommentsHint;

  /// No description provided for @hiringApplicationMoveStageButton.
  ///
  /// In en, this message translates to:
  /// **'Move Stage'**
  String get hiringApplicationMoveStageButton;

  /// No description provided for @hiringApplicationMoveStageSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application stage updated successfully'**
  String get hiringApplicationMoveStageSuccess;

  /// No description provided for @hiringApplicationAddNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Notes'**
  String get hiringApplicationAddNoteTitle;

  /// No description provided for @hiringApplicationAddNoteTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Note Type'**
  String get hiringApplicationAddNoteTypeLabel;

  /// No description provided for @hiringApplicationAddNoteTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select note type'**
  String get hiringApplicationAddNoteTypeHint;

  /// No description provided for @hiringApplicationAddNoteTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get hiringApplicationAddNoteTextLabel;

  /// No description provided for @hiringApplicationAddNoteTextHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your notes about this candidate...'**
  String get hiringApplicationAddNoteTextHint;

  /// No description provided for @hiringApplicationAddNotePrivateLabel.
  ///
  /// In en, this message translates to:
  /// **'Mark as private (visible only to recruiters)'**
  String get hiringApplicationAddNotePrivateLabel;

  /// No description provided for @hiringApplicationAddNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Save Notes'**
  String get hiringApplicationAddNoteButton;

  /// No description provided for @hiringApplicationAddNoteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Note saved successfully'**
  String get hiringApplicationAddNoteSuccess;

  /// No description provided for @hiringApplicationNoteTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Note'**
  String get hiringApplicationNoteTypeGeneral;

  /// No description provided for @hiringApplicationNoteTypeInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview Note'**
  String get hiringApplicationNoteTypeInterview;

  /// No description provided for @hiringApplicationNoteTypeFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get hiringApplicationNoteTypeFeedback;

  /// No description provided for @hiringApplicationNoteTypeInternalReview.
  ///
  /// In en, this message translates to:
  /// **'Internal Review'**
  String get hiringApplicationNoteTypeInternalReview;

  /// No description provided for @hiringApplicationRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Application'**
  String get hiringApplicationRejectTitle;

  /// No description provided for @hiringApplicationRejectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this application? This action cannot be undone.'**
  String get hiringApplicationRejectSubtitle;

  /// No description provided for @hiringApplicationRejectReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get hiringApplicationRejectReasonLabel;

  /// No description provided for @hiringApplicationRejectReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select a reason'**
  String get hiringApplicationRejectReasonHint;

  /// No description provided for @hiringApplicationRejectCommentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Comments'**
  String get hiringApplicationRejectCommentsLabel;

  /// No description provided for @hiringApplicationRejectCommentsHint.
  ///
  /// In en, this message translates to:
  /// **'Provide additional details about the rejection...'**
  String get hiringApplicationRejectCommentsHint;

  /// No description provided for @hiringApplicationRejectSendEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Send rejection email to candidate'**
  String get hiringApplicationRejectSendEmailLabel;

  /// No description provided for @hiringApplicationRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject Application'**
  String get hiringApplicationRejectButton;

  /// No description provided for @hiringApplicationRejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application rejected successfully'**
  String get hiringApplicationRejectSuccess;

  /// No description provided for @hiringApplicationRejectReasonNotMatching.
  ///
  /// In en, this message translates to:
  /// **'Not qualified for the role'**
  String get hiringApplicationRejectReasonNotMatching;

  /// No description provided for @hiringApplicationRejectReasonOverqualified.
  ///
  /// In en, this message translates to:
  /// **'Overqualified'**
  String get hiringApplicationRejectReasonOverqualified;

  /// No description provided for @hiringApplicationRejectReasonSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary expectations too high'**
  String get hiringApplicationRejectReasonSalary;

  /// No description provided for @hiringApplicationRejectReasonTechnical.
  ///
  /// In en, this message translates to:
  /// **'Failed technical assessment'**
  String get hiringApplicationRejectReasonTechnical;

  /// No description provided for @hiringApplicationRejectReasonCultureFit.
  ///
  /// In en, this message translates to:
  /// **'Poor culture fit'**
  String get hiringApplicationRejectReasonCultureFit;

  /// No description provided for @hiringApplicationRejectReasonPositionFilled.
  ///
  /// In en, this message translates to:
  /// **'Position filled by another candidate'**
  String get hiringApplicationRejectReasonPositionFilled;

  /// No description provided for @hiringApplicationRejectReasonWithdrew.
  ///
  /// In en, this message translates to:
  /// **'Candidate withdrew'**
  String get hiringApplicationRejectReasonWithdrew;

  /// No description provided for @hiringApplicationRejectReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get hiringApplicationRejectReasonOther;

  /// No description provided for @grc.
  ///
  /// In en, this message translates to:
  /// **'GRC'**
  String get grc;

  /// No description provided for @grcSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Governance, Risk & Compliance'**
  String get grcSubtitle;

  /// No description provided for @grcDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get grcDashboard;

  /// No description provided for @grcDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Real-time GRC overview and risk KPIs'**
  String get grcDashboardDescription;

  /// No description provided for @grcLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get grcLibrary;

  /// No description provided for @grcLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Compliance question library and evaluation criteria'**
  String get grcLibraryDescription;

  /// No description provided for @grcAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get grcAssets;

  /// No description provided for @grcAssetsDescription.
  ///
  /// In en, this message translates to:
  /// **'IT asset inventory for risk management'**
  String get grcAssetsDescription;

  /// No description provided for @grcRisks.
  ///
  /// In en, this message translates to:
  /// **'Risks'**
  String get grcRisks;

  /// No description provided for @grcRisksDescription.
  ///
  /// In en, this message translates to:
  /// **'Risk register, heat map, and treatment tracking'**
  String get grcRisksDescription;

  /// No description provided for @grcAssessments.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get grcAssessments;

  /// No description provided for @grcAssessmentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Framework assessments and compliance scoring'**
  String get grcAssessmentsDescription;

  /// No description provided for @grcControls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get grcControls;

  /// No description provided for @grcControlsDescription.
  ///
  /// In en, this message translates to:
  /// **'Control register and effectiveness tracking'**
  String get grcControlsDescription;

  /// No description provided for @grcTprm.
  ///
  /// In en, this message translates to:
  /// **'TPRM'**
  String get grcTprm;

  /// No description provided for @grcTprmDescription.
  ///
  /// In en, this message translates to:
  /// **'Third-party and vendor risk management'**
  String get grcTprmDescription;

  /// No description provided for @grcPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get grcPrograms;

  /// No description provided for @grcProgramsDescription.
  ///
  /// In en, this message translates to:
  /// **'GRC improvement programs and initiatives'**
  String get grcProgramsDescription;

  /// No description provided for @grcAddControl.
  ///
  /// In en, this message translates to:
  /// **'Add Control'**
  String get grcAddControl;

  /// No description provided for @grcEditControl.
  ///
  /// In en, this message translates to:
  /// **'Edit Control'**
  String get grcEditControl;

  /// No description provided for @grcAddAsset.
  ///
  /// In en, this message translates to:
  /// **'Add Asset'**
  String get grcAddAsset;

  /// No description provided for @grcEditAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get grcEditAsset;

  /// No description provided for @grcAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get grcAddQuestion;

  /// No description provided for @grcEditQuestion.
  ///
  /// In en, this message translates to:
  /// **'Edit Question'**
  String get grcEditQuestion;

  /// No description provided for @grcManageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get grcManageCategories;

  /// No description provided for @grcAddVendor.
  ///
  /// In en, this message translates to:
  /// **'Add Vendor'**
  String get grcAddVendor;

  /// No description provided for @grcSearchControls.
  ///
  /// In en, this message translates to:
  /// **'Search controls…'**
  String get grcSearchControls;

  /// No description provided for @grcSearchAssets.
  ///
  /// In en, this message translates to:
  /// **'Search assets…'**
  String get grcSearchAssets;

  /// No description provided for @grcSearchQuestions.
  ///
  /// In en, this message translates to:
  /// **'Search questions…'**
  String get grcSearchQuestions;

  /// No description provided for @grcSearchRisks.
  ///
  /// In en, this message translates to:
  /// **'Search risks…'**
  String get grcSearchRisks;

  /// No description provided for @grcControlName.
  ///
  /// In en, this message translates to:
  /// **'Control Name'**
  String get grcControlName;

  /// No description provided for @grcDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get grcDescription;

  /// No description provided for @grcOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get grcOwner;

  /// No description provided for @grcEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Effectiveness'**
  String get grcEffectiveness;

  /// No description provided for @grcType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get grcType;

  /// No description provided for @grcStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get grcStatus;

  /// No description provided for @grcAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get grcAllTypes;

  /// No description provided for @grcAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get grcAllStatuses;

  /// No description provided for @grcNoResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get grcNoResultsFound;

  /// No description provided for @grcErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get grcErrorGeneric;

  /// No description provided for @grcDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get grcDeleteConfirmTitle;

  /// No description provided for @grcDeleteQuestionMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this question? This action cannot be undone.'**
  String get grcDeleteQuestionMessage;

  /// No description provided for @grcControlDeleted.
  ///
  /// In en, this message translates to:
  /// **'Control deleted successfully'**
  String get grcControlDeleted;

  /// No description provided for @grcAssetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Asset deleted successfully'**
  String get grcAssetDeleted;

  /// No description provided for @grcQuestionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Question deleted successfully'**
  String get grcQuestionDeleted;

  /// No description provided for @grcSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get grcSavedSuccessfully;

  /// No description provided for @grcTotalControls.
  ///
  /// In en, this message translates to:
  /// **'Total Controls'**
  String get grcTotalControls;

  /// No description provided for @grcTotalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get grcTotalAssets;

  /// No description provided for @grcTotalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get grcTotalQuestions;

  /// No description provided for @grcTotalRisks.
  ///
  /// In en, this message translates to:
  /// **'Total Risks'**
  String get grcTotalRisks;

  /// No description provided for @grcFrameworks.
  ///
  /// In en, this message translates to:
  /// **'Frameworks'**
  String get grcFrameworks;

  /// No description provided for @grcCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get grcCompliance;

  /// No description provided for @grcLastAssessment.
  ///
  /// In en, this message translates to:
  /// **'Last Assessment'**
  String get grcLastAssessment;

  /// No description provided for @grcAddAssessment.
  ///
  /// In en, this message translates to:
  /// **'Create Assessment'**
  String get grcAddAssessment;

  /// No description provided for @grcViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get grcViewDetails;

  /// No description provided for @grcRiskExposure.
  ///
  /// In en, this message translates to:
  /// **'Risk Exposure'**
  String get grcRiskExposure;

  /// No description provided for @grcCriticalRisks.
  ///
  /// In en, this message translates to:
  /// **'Critical Risks'**
  String get grcCriticalRisks;

  /// No description provided for @grcControlEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Control Effectiveness'**
  String get grcControlEffectiveness;

  /// No description provided for @grcVendorRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Vendor Risk Score'**
  String get grcVendorRiskScore;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authTitle;

  /// No description provided for @loadUser.
  ///
  /// In en, this message translates to:
  /// **'Load user'**
  String get loadUser;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// Greeting for signed-in user
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String userGreeting(String name);

  /// No description provided for @noUserYet.
  ///
  /// In en, this message translates to:
  /// **'No user loaded yet'**
  String get noUserYet;

  /// Label showing user id
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String userId(String id);

  /// No description provided for @toggleLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get toggleLanguage;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get toggleTheme;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time system overview and controls'**
  String get dashboardSubtitle;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @activeProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get activeProjects;

  /// No description provided for @systemHealth.
  ///
  /// In en, this message translates to:
  /// **'System Health'**
  String get systemHealth;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentActivities;

  /// No description provided for @analyticsOverview.
  ///
  /// In en, this message translates to:
  /// **'Analytics Overview'**
  String get analyticsOverview;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search dashboard...'**
  String get searchPlaceholder;

  /// No description provided for @headerTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrated GRC Platform'**
  String get headerTitle;

  /// No description provided for @headerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity, Governance & Security Management'**
  String get headerSubtitle;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'John Smith'**
  String get userName;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'GRC Director'**
  String get userRole;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get navAssets;

  /// No description provided for @navRisks.
  ///
  /// In en, this message translates to:
  /// **'Risks'**
  String get navRisks;

  /// No description provided for @navAssessments.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get navAssessments;

  /// No description provided for @navControls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get navControls;

  /// No description provided for @navTprm.
  ///
  /// In en, this message translates to:
  /// **'TPRM'**
  String get navTprm;

  /// No description provided for @navPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get navPrograms;

  /// No description provided for @navReviewProgress.
  ///
  /// In en, this message translates to:
  /// **'Review Progress'**
  String get navReviewProgress;

  /// No description provided for @navRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get navRoles;

  /// No description provided for @statTotalRiskExposure.
  ///
  /// In en, this message translates to:
  /// **'Total Risk Exposure'**
  String get statTotalRiskExposure;

  /// No description provided for @statCriticalRisks.
  ///
  /// In en, this message translates to:
  /// **'Critical Risks'**
  String get statCriticalRisks;

  /// No description provided for @statControlEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Avg Control Effectiveness'**
  String get statControlEffectiveness;

  /// No description provided for @statVendorRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Vendor Risk Score'**
  String get statVendorRiskScore;

  /// No description provided for @riskExposureTrend.
  ///
  /// In en, this message translates to:
  /// **'Risk Exposure Trend'**
  String get riskExposureTrend;

  /// No description provided for @riskExposureTrendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly risk exposure overview'**
  String get riskExposureTrendSubtitle;

  /// No description provided for @riskExposureLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Exposure'**
  String get riskExposureLabel;

  /// No description provided for @riskByCategory.
  ///
  /// In en, this message translates to:
  /// **'Risk by Category'**
  String get riskByCategory;

  /// No description provided for @riskByCategorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Risk distribution across categories'**
  String get riskByCategorySubtitle;

  /// No description provided for @grcRiskCategoryOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get grcRiskCategoryOperational;

  /// No description provided for @grcRiskCategoryCyber.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity'**
  String get grcRiskCategoryCyber;

  /// No description provided for @grcRiskCategoryCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get grcRiskCategoryCompliance;

  /// No description provided for @grcRiskCategoryFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get grcRiskCategoryFinancial;

  /// No description provided for @grcRiskCategoryVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get grcRiskCategoryVendor;

  /// No description provided for @topRiskAssetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Risk Assets (by Financial Exposure)'**
  String get topRiskAssetsTitle;

  /// No description provided for @tableRiskId.
  ///
  /// In en, this message translates to:
  /// **'Risk ID'**
  String get tableRiskId;

  /// No description provided for @tableAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get tableAsset;

  /// No description provided for @tableImpactVar.
  ///
  /// In en, this message translates to:
  /// **'Impact (VaR)'**
  String get tableImpactVar;

  /// No description provided for @tableLikelihood.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get tableLikelihood;

  /// No description provided for @tableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tableStatus;

  /// No description provided for @likelihoodHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get likelihoodHigh;

  /// No description provided for @likelihoodMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get likelihoodMedium;

  /// No description provided for @likelihoodLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get likelihoodLow;

  /// No description provided for @statusCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get statusCritical;

  /// No description provided for @statusHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get statusHigh;

  /// No description provided for @statusMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get statusMedium;

  /// No description provided for @summaryCloudWorkloads.
  ///
  /// In en, this message translates to:
  /// **'Cloud Workloads'**
  String get summaryCloudWorkloads;

  /// No description provided for @summaryAcrossProviders.
  ///
  /// In en, this message translates to:
  /// **'Across 4 providers'**
  String get summaryAcrossProviders;

  /// No description provided for @summaryActiveControls.
  ///
  /// In en, this message translates to:
  /// **'Active Controls'**
  String get summaryActiveControls;

  /// No description provided for @summaryEffectivePercent.
  ///
  /// In en, this message translates to:
  /// **'87% effective'**
  String get summaryEffectivePercent;

  /// No description provided for @summarySecurityEvents.
  ///
  /// In en, this message translates to:
  /// **'Security Events'**
  String get summarySecurityEvents;

  /// No description provided for @summaryLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get summaryLast30Days;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Question Library'**
  String get libraryTitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Standard evaluation criteria and assessment questions'**
  String get librarySubtitle;

  /// No description provided for @manageQuestions.
  ///
  /// In en, this message translates to:
  /// **'Manage Questions'**
  String get manageQuestions;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @exitEditMode.
  ///
  /// In en, this message translates to:
  /// **'Exit Edit Mode'**
  String get exitEditMode;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addQuestion;

  /// No description provided for @exportLibrary.
  ///
  /// In en, this message translates to:
  /// **'Export Library'**
  String get exportLibrary;

  /// No description provided for @editModeActive.
  ///
  /// In en, this message translates to:
  /// **'Edit Mode Active'**
  String get editModeActive;

  /// No description provided for @editModeDescription.
  ///
  /// In en, this message translates to:
  /// **'You can now add, edit, or delete questions in this library. Changes are saved locally in your session.'**
  String get editModeDescription;

  /// No description provided for @manageCategoriesAndWeights.
  ///
  /// In en, this message translates to:
  /// **'Manage categories and weights'**
  String get manageCategoriesAndWeights;

  /// No description provided for @addNewQuestionsToCategories.
  ///
  /// In en, this message translates to:
  /// **'Add new questions to categories'**
  String get addNewQuestionsToCategories;

  /// No description provided for @editExistingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Edit existing questions'**
  String get editExistingQuestions;

  /// No description provided for @deleteQuestions.
  ///
  /// In en, this message translates to:
  /// **'Delete questions'**
  String get deleteQuestions;

  /// No description provided for @selectFramework.
  ///
  /// In en, this message translates to:
  /// **'Select Framework'**
  String get selectFramework;

  /// No description provided for @questionsLower.
  ///
  /// In en, this message translates to:
  /// **'questions'**
  String get questionsLower;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @searchQuestionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search questions or tags...'**
  String get searchQuestionsPlaceholder;

  /// No description provided for @totalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get totalQuestions;

  /// No description provided for @requireEvidence.
  ///
  /// In en, this message translates to:
  /// **'Require Evidence'**
  String get requireEvidence;

  /// No description provided for @libraryVersion.
  ///
  /// In en, this message translates to:
  /// **'Library Version'**
  String get libraryVersion;

  /// No description provided for @evidenceRequired.
  ///
  /// In en, this message translates to:
  /// **'Evidence Required'**
  String get evidenceRequired;

  /// No description provided for @evaluationCriteria.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Criteria:'**
  String get evaluationCriteria;

  /// No description provided for @relatedControls.
  ///
  /// In en, this message translates to:
  /// **'Related Controls:'**
  String get relatedControls;

  /// No description provided for @showGuidance.
  ///
  /// In en, this message translates to:
  /// **'Show Guidance'**
  String get showGuidance;

  /// No description provided for @manageCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{libraryId} - {count} categories'**
  String manageCategoriesSubtitle(String libraryId, int count);

  /// No description provided for @totalCategoryWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Category Weight'**
  String get totalCategoryWeight;

  /// No description provided for @categoryWeightHint.
  ///
  /// In en, this message translates to:
  /// **'Category weights should total 100% for accurate scoring'**
  String get categoryWeightHint;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @categoryId.
  ///
  /// In en, this message translates to:
  /// **'Category ID'**
  String get categoryId;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @categoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get categoryDescription;

  /// No description provided for @weightPercent.
  ///
  /// In en, this message translates to:
  /// **'Weight (%)'**
  String get weightPercent;

  /// No description provided for @categoryWeightContributionHint.
  ///
  /// In en, this message translates to:
  /// **'This determines the category\'s contribution to the overall score'**
  String get categoryWeightContributionHint;

  /// No description provided for @saveCategory.
  ///
  /// In en, this message translates to:
  /// **'Save Category'**
  String get saveCategory;

  /// No description provided for @categoryIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., sox-404'**
  String get categoryIdPlaceholder;

  /// No description provided for @categoryNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Section 404 - Management Assessment'**
  String get categoryNamePlaceholder;

  /// No description provided for @categoryDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Brief description of this category...'**
  String get categoryDescriptionPlaceholder;

  /// No description provided for @saveAllChanges.
  ///
  /// In en, this message translates to:
  /// **'Save All Changes'**
  String get saveAllChanges;

  /// No description provided for @categoriesFooterSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} categories • Total weight: {weight}%'**
  String categoriesFooterSummary(int count, int weight);

  /// No description provided for @editQuestion.
  ///
  /// In en, this message translates to:
  /// **'Edit Question'**
  String get editQuestion;

  /// No description provided for @questionId.
  ///
  /// In en, this message translates to:
  /// **'Question ID'**
  String get questionId;

  /// No description provided for @questionIdHint.
  ///
  /// In en, this message translates to:
  /// **'Question ID cannot be changed'**
  String get questionIdHint;

  /// No description provided for @questionText.
  ///
  /// In en, this message translates to:
  /// **'Question Text'**
  String get questionText;

  /// No description provided for @questionType.
  ///
  /// In en, this message translates to:
  /// **'Question Type'**
  String get questionType;

  /// No description provided for @weightRange.
  ///
  /// In en, this message translates to:
  /// **'Weight (1-10)'**
  String get weightRange;

  /// No description provided for @subcategoryOptional.
  ///
  /// In en, this message translates to:
  /// **'Subcategory (Optional)'**
  String get subcategoryOptional;

  /// No description provided for @evaluationCriteriaHint.
  ///
  /// In en, this message translates to:
  /// **'Select the criteria applicable to this question'**
  String get evaluationCriteriaHint;

  /// No description provided for @criteriaDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get criteriaDocumentation;

  /// No description provided for @criteriaDocumentationDesc.
  ///
  /// In en, this message translates to:
  /// **'Policies, procedures, and documentation completeness'**
  String get criteriaDocumentationDesc;

  /// No description provided for @criteriaImplementation.
  ///
  /// In en, this message translates to:
  /// **'Implementation'**
  String get criteriaImplementation;

  /// No description provided for @criteriaImplementationDesc.
  ///
  /// In en, this message translates to:
  /// **'Controls and processes are fully operational'**
  String get criteriaImplementationDesc;

  /// No description provided for @criteriaEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Effectiveness'**
  String get criteriaEffectiveness;

  /// No description provided for @criteriaEffectivenessDesc.
  ///
  /// In en, this message translates to:
  /// **'Controls achieve their intended objectives'**
  String get criteriaEffectivenessDesc;

  /// No description provided for @criteriaMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get criteriaMonitoring;

  /// No description provided for @criteriaMonitoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Regular monitoring and measurement mechanisms'**
  String get criteriaMonitoringDesc;

  /// No description provided for @criteriaContinuousImprovement.
  ///
  /// In en, this message translates to:
  /// **'Continuous Improvement'**
  String get criteriaContinuousImprovement;

  /// No description provided for @criteriaContinuousImprovementDesc.
  ///
  /// In en, this message translates to:
  /// **'Process for improvement and lessons learned'**
  String get criteriaContinuousImprovementDesc;

  /// No description provided for @criteriaWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight: {percent}%'**
  String criteriaWeightLabel(int percent);

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @addTagPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add tag...'**
  String get addTagPlaceholder;

  /// No description provided for @relatedControlsOptional.
  ///
  /// In en, this message translates to:
  /// **'Related Controls (Optional)'**
  String get relatedControlsOptional;

  /// No description provided for @addControlPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add control ID...'**
  String get addControlPlaceholder;

  /// No description provided for @selectControlsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select controls from catalog...'**
  String get selectControlsPlaceholder;

  /// No description provided for @additionalSettings.
  ///
  /// In en, this message translates to:
  /// **'Additional Settings'**
  String get additionalSettings;

  /// No description provided for @requireEvidenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Respondents must provide evidence or documentation for this question'**
  String get requireEvidenceDescription;

  /// No description provided for @guidanceNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Guidance Notes (Optional)'**
  String get guidanceNotesOptional;

  /// No description provided for @questionTypeYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes No'**
  String get questionTypeYesNo;

  /// No description provided for @addNewQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add New Question'**
  String get addNewQuestion;

  /// No description provided for @questionIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., sox-404-001'**
  String get questionIdPlaceholder;

  /// No description provided for @questionTextPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter the question text...'**
  String get questionTextPlaceholder;

  /// No description provided for @categoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Management Assessment'**
  String get categoryPlaceholder;

  /// No description provided for @subcategoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Control Framework'**
  String get subcategoryPlaceholder;

  /// No description provided for @guidanceNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Provide guidance for assessors on how to answer this question...'**
  String get guidanceNotesPlaceholder;

  /// No description provided for @assetRegistryTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset Registry'**
  String get assetRegistryTitle;

  /// No description provided for @assetRegistrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and monitor enterprise assets'**
  String get assetRegistrySubtitle;

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add Asset'**
  String get addAsset;

  /// No description provided for @statTotalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get statTotalAssets;

  /// No description provided for @statApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get statApplications;

  /// No description provided for @statCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get statCloud;

  /// No description provided for @statData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get statData;

  /// No description provided for @statTotalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get statTotalValue;

  /// No description provided for @searchAssetsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search assets by name or ID...'**
  String get searchAssetsPlaceholder;

  /// No description provided for @tableAssetId.
  ///
  /// In en, this message translates to:
  /// **'Asset ID'**
  String get tableAssetId;

  /// No description provided for @tableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get tableName;

  /// No description provided for @tableType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tableType;

  /// No description provided for @tableBusinessValue.
  ///
  /// In en, this message translates to:
  /// **'Business Value'**
  String get tableBusinessValue;

  /// No description provided for @tableOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get tableOwner;

  /// No description provided for @tableEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get tableEnvironment;

  /// No description provided for @tableCloudProvider.
  ///
  /// In en, this message translates to:
  /// **'Cloud Provider'**
  String get tableCloudProvider;

  /// No description provided for @tableRiskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get tableRiskLevel;

  /// No description provided for @tableClassification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get tableClassification;

  /// No description provided for @tableActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get tableActions;

  /// No description provided for @assetTypeData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get assetTypeData;

  /// No description provided for @assetTypeApplication.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get assetTypeApplication;

  /// No description provided for @assetTypeInfrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get assetTypeInfrastructure;

  /// No description provided for @assetTypeCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get assetTypeCloud;

  /// No description provided for @classificationConfidential.
  ///
  /// In en, this message translates to:
  /// **'Confidential'**
  String get classificationConfidential;

  /// No description provided for @classificationInternal.
  ///
  /// In en, this message translates to:
  /// **'Internal'**
  String get classificationInternal;

  /// No description provided for @addNewAsset.
  ///
  /// In en, this message translates to:
  /// **'Add New Asset'**
  String get addNewAsset;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Asset Name'**
  String get assetName;

  /// No description provided for @assetType.
  ///
  /// In en, this message translates to:
  /// **'Asset Type'**
  String get assetType;

  /// No description provided for @assetDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get assetDescription;

  /// No description provided for @businessValue.
  ///
  /// In en, this message translates to:
  /// **'Business Value (\$)'**
  String get businessValue;

  /// No description provided for @assetOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get assetOwner;

  /// No description provided for @ipAddressEndpoint.
  ///
  /// In en, this message translates to:
  /// **'IP Address / Endpoint'**
  String get ipAddressEndpoint;

  /// No description provided for @criticality.
  ///
  /// In en, this message translates to:
  /// **'Criticality'**
  String get criticality;

  /// No description provided for @complianceRequirements.
  ///
  /// In en, this message translates to:
  /// **'Compliance Requirements'**
  String get complianceRequirements;

  /// No description provided for @complianceIso27001.
  ///
  /// In en, this message translates to:
  /// **'ISO 27001'**
  String get complianceIso27001;

  /// No description provided for @complianceSoc2.
  ///
  /// In en, this message translates to:
  /// **'SOC 2'**
  String get complianceSoc2;

  /// No description provided for @complianceGdpr.
  ///
  /// In en, this message translates to:
  /// **'GDPR'**
  String get complianceGdpr;

  /// No description provided for @complianceHipaa.
  ///
  /// In en, this message translates to:
  /// **'HIPAA'**
  String get complianceHipaa;

  /// No description provided for @compliancePciDss.
  ///
  /// In en, this message translates to:
  /// **'PCI-DSS'**
  String get compliancePciDss;

  /// No description provided for @complianceNist.
  ///
  /// In en, this message translates to:
  /// **'NIST'**
  String get complianceNist;

  /// No description provided for @complianceCis.
  ///
  /// In en, this message translates to:
  /// **'CIS'**
  String get complianceCis;

  /// No description provided for @complianceFedRamp.
  ///
  /// In en, this message translates to:
  /// **'FedRAMP'**
  String get complianceFedRamp;

  /// No description provided for @assetTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get assetTags;

  /// No description provided for @enterAssetName.
  ///
  /// In en, this message translates to:
  /// **'Enter asset name'**
  String get enterAssetName;

  /// No description provided for @assetDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe the asset and its purpose'**
  String get assetDescriptionPlaceholder;

  /// No description provided for @assetOwnerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Owner name or team'**
  String get assetOwnerPlaceholder;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., us-east-1, Europe, Data Center A'**
  String get locationPlaceholder;

  /// No description provided for @ipAddressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'IP address or URL'**
  String get ipAddressPlaceholder;

  /// No description provided for @assetTagsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Separate tags with commas (e.g., critical, customer-facing, pii)'**
  String get assetTagsPlaceholder;

  /// No description provided for @envProduction.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get envProduction;

  /// No description provided for @envStaging.
  ///
  /// In en, this message translates to:
  /// **'Staging'**
  String get envStaging;

  /// No description provided for @envDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get envDevelopment;

  /// No description provided for @envOnPrem.
  ///
  /// In en, this message translates to:
  /// **'On-Prem'**
  String get envOnPrem;

  /// No description provided for @providerAws.
  ///
  /// In en, this message translates to:
  /// **'AWS'**
  String get providerAws;

  /// No description provided for @providerAzure.
  ///
  /// In en, this message translates to:
  /// **'Azure'**
  String get providerAzure;

  /// No description provided for @providerGcp.
  ///
  /// In en, this message translates to:
  /// **'GCP'**
  String get providerGcp;

  /// No description provided for @infrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get infrastructure;

  /// No description provided for @relatedItems.
  ///
  /// In en, this message translates to:
  /// **'Related Items'**
  String get relatedItems;

  /// No description provided for @linkedRisks.
  ///
  /// In en, this message translates to:
  /// **'Linked Risks'**
  String get linkedRisks;

  /// No description provided for @appliedControls.
  ///
  /// In en, this message translates to:
  /// **'Applied Controls'**
  String get appliedControls;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get editAsset;

  /// No description provided for @viewRisks.
  ///
  /// In en, this message translates to:
  /// **'View Risks'**
  String get viewRisks;

  /// No description provided for @viewControls.
  ///
  /// In en, this message translates to:
  /// **'View Controls'**
  String get viewControls;

  /// No description provided for @deleteAsset.
  ///
  /// In en, this message translates to:
  /// **'Delete Asset'**
  String get deleteAsset;

  /// No description provided for @riskRegistryTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Register'**
  String get riskRegistryTitle;

  /// No description provided for @riskRegistrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive risk management with quantified assessment'**
  String get riskRegistrySubtitle;

  /// No description provided for @addRisk.
  ///
  /// In en, this message translates to:
  /// **'Add Risk'**
  String get addRisk;

  /// No description provided for @statInherentRisk.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk (VaR)'**
  String get statInherentRisk;

  /// No description provided for @statResidualRisk.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk (VaR)'**
  String get statResidualRisk;

  /// No description provided for @statRiskReduction.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction'**
  String get statRiskReduction;

  /// No description provided for @riskHeatMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Heat Map (Likelihood × Impact)'**
  String get riskHeatMapTitle;

  /// No description provided for @heatMapLikelihoodHeader.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get heatMapLikelihoodHeader;

  /// No description provided for @heatMapColLow.
  ///
  /// In en, this message translates to:
  /// **'Low (1-4)'**
  String get heatMapColLow;

  /// No description provided for @heatMapColMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium (5-9)'**
  String get heatMapColMedium;

  /// No description provided for @heatMapColHigh.
  ///
  /// In en, this message translates to:
  /// **'High (10-14)'**
  String get heatMapColHigh;

  /// No description provided for @heatMapColCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical (15-25)'**
  String get heatMapColCritical;

  /// No description provided for @heatMapRowVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High (5)'**
  String get heatMapRowVeryHigh;

  /// No description provided for @heatMapRowHigh.
  ///
  /// In en, this message translates to:
  /// **'High (4)'**
  String get heatMapRowHigh;

  /// No description provided for @heatMapRowMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium (3)'**
  String get heatMapRowMedium;

  /// No description provided for @heatMapRowLow.
  ///
  /// In en, this message translates to:
  /// **'Low (2)'**
  String get heatMapRowLow;

  /// No description provided for @heatMapRowVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low (1)'**
  String get heatMapRowVeryLow;

  /// No description provided for @searchRisksPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search risks by title or ID...'**
  String get searchRisksPlaceholder;

  /// No description provided for @tableRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tableRiskTitle;

  /// No description provided for @tableRiskAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get tableRiskAssets;

  /// No description provided for @tableRiskCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get tableRiskCategory;

  /// No description provided for @tableImpactDollar.
  ///
  /// In en, this message translates to:
  /// **'Impact (\$)'**
  String get tableImpactDollar;

  /// No description provided for @tableInherent.
  ///
  /// In en, this message translates to:
  /// **'Inherent'**
  String get tableInherent;

  /// No description provided for @tableResidual.
  ///
  /// In en, this message translates to:
  /// **'Residual'**
  String get tableResidual;

  /// No description provided for @tableTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get tableTreatment;

  /// No description provided for @statusAssessed.
  ///
  /// In en, this message translates to:
  /// **'Assessed'**
  String get statusAssessed;

  /// No description provided for @statusTreated.
  ///
  /// In en, this message translates to:
  /// **'Treated'**
  String get statusTreated;

  /// No description provided for @statusMonitored.
  ///
  /// In en, this message translates to:
  /// **'Monitored'**
  String get statusMonitored;

  /// No description provided for @likelihoodVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get likelihoodVeryHigh;

  /// No description provided for @likelihoodVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low'**
  String get likelihoodVeryLow;

  /// No description provided for @treatmentMitigate.
  ///
  /// In en, this message translates to:
  /// **'Mitigate'**
  String get treatmentMitigate;

  /// No description provided for @treatmentTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get treatmentTransfer;

  /// No description provided for @treatmentAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get treatmentAccept;

  /// No description provided for @treatmentAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get treatmentAvoid;

  /// No description provided for @riskManagementIntegration.
  ///
  /// In en, this message translates to:
  /// **'Risk Management Integration'**
  String get riskManagementIntegration;

  /// No description provided for @integrationLinkedToAssets.
  ///
  /// In en, this message translates to:
  /// **'Linked to Assets'**
  String get integrationLinkedToAssets;

  /// No description provided for @integrationLinkedToAssetsDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect risks to asset inventory'**
  String get integrationLinkedToAssetsDesc;

  /// No description provided for @integrationControlMapping.
  ///
  /// In en, this message translates to:
  /// **'Control Mapping'**
  String get integrationControlMapping;

  /// No description provided for @integrationControlMappingDesc.
  ///
  /// In en, this message translates to:
  /// **'Map controls to reduce risk'**
  String get integrationControlMappingDesc;

  /// No description provided for @integrationAssessmentFramework.
  ///
  /// In en, this message translates to:
  /// **'Assessment Framework'**
  String get integrationAssessmentFramework;

  /// No description provided for @integrationAssessmentFrameworkDesc.
  ///
  /// In en, this message translates to:
  /// **'Use question library for assessments'**
  String get integrationAssessmentFrameworkDesc;

  /// No description provided for @integrationMitigationPrograms.
  ///
  /// In en, this message translates to:
  /// **'Mitigation Programs'**
  String get integrationMitigationPrograms;

  /// No description provided for @integrationMitigationProgramsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track remediation actions'**
  String get integrationMitigationProgramsDesc;

  /// No description provided for @addNewRisk.
  ///
  /// In en, this message translates to:
  /// **'Add New Risk'**
  String get addNewRisk;

  /// No description provided for @stepIdentification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get stepIdentification;

  /// No description provided for @stepAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get stepAssessment;

  /// No description provided for @stepTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get stepTreatment;

  /// No description provided for @stepControls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get stepControls;

  /// No description provided for @stepMitigation.
  ///
  /// In en, this message translates to:
  /// **'Mitigation'**
  String get stepMitigation;

  /// No description provided for @riskIdentificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Identification'**
  String get riskIdentificationTitle;

  /// No description provided for @riskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Title'**
  String get riskTitleLabel;

  /// No description provided for @riskTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Data Breach - Customer Database'**
  String get riskTitlePlaceholder;

  /// No description provided for @riskDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Detailed description of the risk...'**
  String get riskDescriptionPlaceholder;

  /// No description provided for @riskSubcategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get riskSubcategoryLabel;

  /// No description provided for @riskSubcategoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Optional subcategory'**
  String get riskSubcategoryPlaceholder;

  /// No description provided for @affectedAssets.
  ///
  /// In en, this message translates to:
  /// **'Affected Assets'**
  String get affectedAssets;

  /// No description provided for @holdCtrlToSelectMultiple.
  ///
  /// In en, this message translates to:
  /// **'Hold Ctrl/Cmd to select multiple'**
  String get holdCtrlToSelectMultiple;

  /// No description provided for @riskAssetsTapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap assets below to link them to this risk'**
  String get riskAssetsTapToSelect;

  /// No description provided for @riskAssetsSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get riskAssetsSelectAll;

  /// No description provided for @rootCause.
  ///
  /// In en, this message translates to:
  /// **'Root Cause'**
  String get rootCause;

  /// No description provided for @rootCausePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'What is the root cause of this risk?'**
  String get rootCausePlaceholder;

  /// No description provided for @consequences.
  ///
  /// In en, this message translates to:
  /// **'Consequences'**
  String get consequences;

  /// No description provided for @addConsequencePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add consequence...'**
  String get addConsequencePlaceholder;

  /// No description provided for @vulnerabilities.
  ///
  /// In en, this message translates to:
  /// **'Vulnerabilities'**
  String get vulnerabilities;

  /// No description provided for @addVulnerabilityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add vulnerability...'**
  String get addVulnerabilityPlaceholder;

  /// No description provided for @threats.
  ///
  /// In en, this message translates to:
  /// **'Threats'**
  String get threats;

  /// No description provided for @addThreatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add threat...'**
  String get addThreatPlaceholder;

  /// No description provided for @riskOwner.
  ///
  /// In en, this message translates to:
  /// **'Risk Owner'**
  String get riskOwner;

  /// No description provided for @riskOwnerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., CISO'**
  String get riskOwnerPlaceholder;

  /// No description provided for @ownerRole.
  ///
  /// In en, this message translates to:
  /// **'Owner Role'**
  String get ownerRole;

  /// No description provided for @ownerRolePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Chief Information Security Officer'**
  String get ownerRolePlaceholder;

  /// No description provided for @departmentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Information Security'**
  String get departmentPlaceholder;

  /// No description provided for @riskAssessmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Assessment'**
  String get riskAssessmentTitle;

  /// No description provided for @inherentLikelihood.
  ///
  /// In en, this message translates to:
  /// **'Inherent Likelihood'**
  String get inherentLikelihood;

  /// No description provided for @inherentImpact.
  ///
  /// In en, this message translates to:
  /// **'Inherent Impact'**
  String get inherentImpact;

  /// No description provided for @financialImpactUsd.
  ///
  /// In en, this message translates to:
  /// **'Financial Impact (USD)'**
  String get financialImpactUsd;

  /// No description provided for @financialImpactHint.
  ///
  /// In en, this message translates to:
  /// **'Estimated financial loss if risk materializes'**
  String get financialImpactHint;

  /// No description provided for @inherentRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk Score'**
  String get inherentRiskScore;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @valueAtRisk.
  ///
  /// In en, this message translates to:
  /// **'Value at Risk'**
  String get valueAtRisk;

  /// No description provided for @likelihoodVeryLowPct.
  ///
  /// In en, this message translates to:
  /// **'20% probability'**
  String get likelihoodVeryLowPct;

  /// No description provided for @likelihoodLowPct.
  ///
  /// In en, this message translates to:
  /// **'40% probability'**
  String get likelihoodLowPct;

  /// No description provided for @likelihoodMediumPct.
  ///
  /// In en, this message translates to:
  /// **'60% probability'**
  String get likelihoodMediumPct;

  /// No description provided for @likelihoodHighPct.
  ///
  /// In en, this message translates to:
  /// **'80% probability'**
  String get likelihoodHighPct;

  /// No description provided for @likelihoodVeryHighPct.
  ///
  /// In en, this message translates to:
  /// **'100% probability'**
  String get likelihoodVeryHighPct;

  /// No description provided for @riskTreatmentStrategyTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Treatment Strategy'**
  String get riskTreatmentStrategyTitle;

  /// No description provided for @treatmentStrategyLabel.
  ///
  /// In en, this message translates to:
  /// **'Treatment Strategy'**
  String get treatmentStrategyLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @riskAppetite.
  ///
  /// In en, this message translates to:
  /// **'Risk Appetite'**
  String get riskAppetite;

  /// No description provided for @riskToleranceUsd.
  ///
  /// In en, this message translates to:
  /// **'Risk Tolerance (USD)'**
  String get riskToleranceUsd;

  /// No description provided for @treatmentPlan.
  ///
  /// In en, this message translates to:
  /// **'Treatment Plan'**
  String get treatmentPlan;

  /// No description provided for @treatmentPlanPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe the treatment plan and strategy...'**
  String get treatmentPlanPlaceholder;

  /// No description provided for @statusIdentified.
  ///
  /// In en, this message translates to:
  /// **'Identified'**
  String get statusIdentified;

  /// No description provided for @appetiteCautious.
  ///
  /// In en, this message translates to:
  /// **'Cautious'**
  String get appetiteCautious;

  /// No description provided for @appetiteModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get appetiteModerate;

  /// No description provided for @appetiteAggressive.
  ///
  /// In en, this message translates to:
  /// **'Aggressive'**
  String get appetiteAggressive;

  /// No description provided for @controlEffectivenessTitle.
  ///
  /// In en, this message translates to:
  /// **'Control Effectiveness'**
  String get controlEffectivenessTitle;

  /// No description provided for @overallControlEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Overall Control Effectiveness (%)'**
  String get overallControlEffectiveness;

  /// No description provided for @residualRiskAfterControls.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk (After Controls)'**
  String get residualRiskAfterControls;

  /// No description provided for @controlsNoteText.
  ///
  /// In en, this message translates to:
  /// **'Note: Link specific controls in the next step to track individual control effectiveness and test results.'**
  String get controlsNoteText;

  /// No description provided for @likelihood.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get likelihood;

  /// No description provided for @impact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impact;

  /// No description provided for @reduction.
  ///
  /// In en, this message translates to:
  /// **'↓ {pct}% reduction'**
  String reduction(String pct);

  /// No description provided for @mitigationActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mitigation Actions'**
  String get mitigationActionsTitle;

  /// No description provided for @mitigationInfoText.
  ///
  /// In en, this message translates to:
  /// **'After saving, you can add detailed mitigation actions, link controls, and track progress in the risk detail view.'**
  String get mitigationInfoText;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Additional notes or comments...'**
  String get notesPlaceholder;

  /// No description provided for @riskSummary.
  ///
  /// In en, this message translates to:
  /// **'Risk Summary'**
  String get riskSummary;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get summaryTitle;

  /// No description provided for @inherentRisk.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk'**
  String get inherentRisk;

  /// No description provided for @residualRisk.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk'**
  String get residualRisk;

  /// No description provided for @summaryTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get summaryTreatment;

  /// No description provided for @summaryOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get summaryOwner;

  /// No description provided for @saveRisk.
  ///
  /// In en, this message translates to:
  /// **'Save Risk'**
  String get saveRisk;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @categoryCyberSecurity.
  ///
  /// In en, this message translates to:
  /// **'Cyber Security'**
  String get categoryCyberSecurity;

  /// No description provided for @categoryDataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get categoryDataSecurity;

  /// No description provided for @categoryOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get categoryOperational;

  /// No description provided for @categoryCloudSecurity.
  ///
  /// In en, this message translates to:
  /// **'Cloud Security'**
  String get categoryCloudSecurity;

  /// No description provided for @categoryAccessControl.
  ///
  /// In en, this message translates to:
  /// **'Access Control'**
  String get categoryAccessControl;

  /// No description provided for @categoryThirdPartyRisk.
  ///
  /// In en, this message translates to:
  /// **'Third Party Risk'**
  String get categoryThirdPartyRisk;

  /// No description provided for @categoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTechnology;

  /// No description provided for @riskInformation.
  ///
  /// In en, this message translates to:
  /// **'Risk Information'**
  String get riskInformation;

  /// No description provided for @linkedAssetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked Assets'**
  String get linkedAssetsLabel;

  /// No description provided for @inherentRiskVar.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk (VaR)'**
  String get inherentRiskVar;

  /// No description provided for @controlEffectivenessLabel.
  ///
  /// In en, this message translates to:
  /// **'Control Effectiveness'**
  String get controlEffectivenessLabel;

  /// No description provided for @residualRiskVar.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk (VaR)'**
  String get residualRiskVar;

  /// No description provided for @riskReductionLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction'**
  String get riskReductionLabel;

  /// No description provided for @editRisk.
  ///
  /// In en, this message translates to:
  /// **'Edit Risk'**
  String get editRisk;

  /// No description provided for @riskIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'Risk ID:'**
  String get riskIdPrefix;

  /// No description provided for @likelihoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get likelihoodLabel;

  /// No description provided for @impactLabel.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impactLabel;

  /// No description provided for @frameworkAssessmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Framework Assessments'**
  String get frameworkAssessmentsTitle;

  /// No description provided for @frameworkAssessmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and assess compliance across multiple frameworks'**
  String get frameworkAssessmentsSubtitle;

  /// No description provided for @assessmentHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessment Hub'**
  String get assessmentHubTitle;

  /// No description provided for @assessmentHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive framework assessments with standardized criteria'**
  String get assessmentHubSubtitle;

  /// No description provided for @assessmentHubDescription.
  ///
  /// In en, this message translates to:
  /// **'Access the question library with 42 questions across 3 frameworks. Conduct assessments with weighted scoring, evidence collection, and real-time compliance tracking.'**
  String get assessmentHubDescription;

  /// No description provided for @launchAssessmentHub.
  ///
  /// In en, this message translates to:
  /// **'Launch Assessment Hub'**
  String get launchAssessmentHub;

  /// No description provided for @hubLibraries.
  ///
  /// In en, this message translates to:
  /// **'Libraries'**
  String get hubLibraries;

  /// No description provided for @hubQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get hubQuestions;

  /// No description provided for @hubCriteria.
  ///
  /// In en, this message translates to:
  /// **'Criteria'**
  String get hubCriteria;

  /// No description provided for @statTotalFrameworks.
  ///
  /// In en, this message translates to:
  /// **'Total Frameworks'**
  String get statTotalFrameworks;

  /// No description provided for @statAvgCompliance.
  ///
  /// In en, this message translates to:
  /// **'Avg Compliance'**
  String get statAvgCompliance;

  /// No description provided for @statTotalControls.
  ///
  /// In en, this message translates to:
  /// **'Total Controls'**
  String get statTotalControls;

  /// No description provided for @statActiveFrameworks.
  ///
  /// In en, this message translates to:
  /// **'Active Frameworks'**
  String get statActiveFrameworks;

  /// No description provided for @complianceLevel.
  ///
  /// In en, this message translates to:
  /// **'Compliance Level'**
  String get complianceLevel;

  /// No description provided for @frameworkStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get frameworkStatusLabel;

  /// No description provided for @frameworkControlsLabel.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get frameworkControlsLabel;

  /// No description provided for @lastAssessmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Assessment'**
  String get lastAssessmentLabel;

  /// No description provided for @frameworkStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get frameworkStatusActive;

  /// No description provided for @frameworkStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get frameworkStatusInProgress;

  /// No description provided for @compliantControls.
  ///
  /// In en, this message translates to:
  /// **'Compliant Controls'**
  String get compliantControls;

  /// No description provided for @outOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Out of {total} total'**
  String outOfTotal(int total);

  /// No description provided for @partialComplianceLabel.
  ///
  /// In en, this message translates to:
  /// **'Partial Compliance'**
  String get partialComplianceLabel;

  /// No description provided for @needsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get needsImprovement;

  /// No description provided for @nonCompliantLabel.
  ///
  /// In en, this message translates to:
  /// **'Non-Compliant'**
  String get nonCompliantLabel;

  /// No description provided for @immediateActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Immediate action required'**
  String get immediateActionRequired;

  /// No description provided for @complianceShort.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get complianceShort;

  /// No description provided for @compliantCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Compliant'**
  String compliantCount(int count);

  /// No description provided for @partialCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Partial'**
  String partialCount(int count);

  /// No description provided for @nonCompliantCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Non-Compliant'**
  String nonCompliantCount(int count);

  /// No description provided for @remediationActionItems.
  ///
  /// In en, this message translates to:
  /// **'Remediation Action Items'**
  String get remediationActionItems;

  /// No description provided for @openCompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'{open} open items • {completed} completed'**
  String openCompletedSummary(int open, int completed);

  /// No description provided for @addAction.
  ///
  /// In en, this message translates to:
  /// **'Add Action'**
  String get addAction;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String dueDate(String date);

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner: {name}'**
  String ownerName(String name);

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get priorityMedium;

  /// No description provided for @remediationStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get remediationStatusOpen;

  /// No description provided for @remediationStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'in-progress'**
  String get remediationStatusInProgress;

  /// No description provided for @answerYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get answerYes;

  /// No description provided for @answerPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get answerPartial;

  /// No description provided for @answerNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get answerNo;

  /// No description provided for @answerNa.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get answerNa;

  /// No description provided for @evidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidenceLabel;

  /// No description provided for @addRemediationAction.
  ///
  /// In en, this message translates to:
  /// **'Add Remediation Action'**
  String get addRemediationAction;

  /// No description provided for @editActionItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Action Item'**
  String get editActionItem;

  /// No description provided for @deleteActionItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Action Item'**
  String get deleteActionItemTitle;

  /// No description provided for @deleteActionItemMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this action item? This action cannot be undone.'**
  String get deleteActionItemMessage;

  /// No description provided for @relatedSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Related Section'**
  String get relatedSectionLabel;

  /// No description provided for @selectSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Select section'**
  String get selectSectionHint;

  /// No description provided for @actionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Action Title'**
  String get actionTitleLabel;

  /// No description provided for @actionTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Brief action item title'**
  String get actionTitleHint;

  /// No description provided for @actionDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get actionDescriptionLabel;

  /// No description provided for @actionDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Detailed description of the action needed'**
  String get actionDescriptionHint;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDateLabel;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @ownerHint.
  ///
  /// In en, this message translates to:
  /// **'Responsible person/team'**
  String get ownerHint;

  /// No description provided for @createAction.
  ///
  /// In en, this message translates to:
  /// **'Create Action'**
  String get createAction;

  /// No description provided for @optionHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get optionHigh;

  /// No description provided for @optionMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get optionMedium;

  /// No description provided for @optionLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get optionLow;

  /// No description provided for @optionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get optionOpen;

  /// No description provided for @optionInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get optionInProgress;

  /// No description provided for @optionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get optionCompleted;

  /// No description provided for @hubPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive framework assessments with standardized evaluation criteria'**
  String get hubPageSubtitle;

  /// No description provided for @addAssessment.
  ///
  /// In en, this message translates to:
  /// **'Add Assessment'**
  String get addAssessment;

  /// No description provided for @hubQuestionLibraries.
  ///
  /// In en, this message translates to:
  /// **'Question Libraries'**
  String get hubQuestionLibraries;

  /// No description provided for @hubTotalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get hubTotalQuestions;

  /// No description provided for @hubStandardCriteria.
  ///
  /// In en, this message translates to:
  /// **'Standard Criteria'**
  String get hubStandardCriteria;

  /// No description provided for @hubCustomAssessments.
  ///
  /// In en, this message translates to:
  /// **'Custom Assessments'**
  String get hubCustomAssessments;

  /// No description provided for @hubStandardEvaluationCriteria.
  ///
  /// In en, this message translates to:
  /// **'Standard Evaluation Criteria'**
  String get hubStandardEvaluationCriteria;

  /// No description provided for @hubCriteriaIntro.
  ///
  /// In en, this message translates to:
  /// **'All assessments use these standardized criteria to ensure consistent and objective evaluation across frameworks.'**
  String get hubCriteriaIntro;

  /// No description provided for @hubStandardFrameworkAssessments.
  ///
  /// In en, this message translates to:
  /// **'Standard Framework Assessments'**
  String get hubStandardFrameworkAssessments;

  /// No description provided for @hubAssessmentFeatures.
  ///
  /// In en, this message translates to:
  /// **'Assessment Features'**
  String get hubAssessmentFeatures;

  /// No description provided for @weightValue.
  ///
  /// In en, this message translates to:
  /// **'Weight: {value}%'**
  String weightValue(int value);

  /// No description provided for @soxComplianceAssessment.
  ///
  /// In en, this message translates to:
  /// **'SOX Compliance Assessment'**
  String get soxComplianceAssessment;

  /// No description provided for @soxComplianceDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive assessment for Sarbanes-Oxley Act compliance with 14 questions across 3 categories.'**
  String get soxComplianceDesc;

  /// No description provided for @cosoErmAssessment.
  ///
  /// In en, this message translates to:
  /// **'COSO ERM Assessment'**
  String get cosoErmAssessment;

  /// No description provided for @cosoErmDesc.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Risk Management framework assessment with 8 questions across 3 components.'**
  String get cosoErmDesc;

  /// No description provided for @cybersecurityAssessment.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity Assessment'**
  String get cybersecurityAssessment;

  /// No description provided for @cybersecurityDesc.
  ///
  /// In en, this message translates to:
  /// **'NIST CSF and ISO 27001 aligned assessment with 20 questions across 5 functions.'**
  String get cybersecurityDesc;

  /// No description provided for @hubQuestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions:'**
  String get hubQuestionsLabel;

  /// No description provided for @hubCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories:'**
  String get hubCategoriesLabel;

  /// No description provided for @hubEstTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. Time:'**
  String get hubEstTimeLabel;

  /// No description provided for @startAssessment.
  ///
  /// In en, this message translates to:
  /// **'Start Assessment'**
  String get startAssessment;

  /// No description provided for @assessmentFrameworkLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'{frameworkName} Question Library'**
  String assessmentFrameworkLibraryTitle(String frameworkName);

  /// No description provided for @assessmentFrameworkLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse questions and evaluation criteria for this framework'**
  String get assessmentFrameworkLibrarySubtitle;

  /// No description provided for @assessmentFrameworkLibraryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get assessmentFrameworkLibraryComingSoon;

  /// No description provided for @assessmentFrameworkLibraryUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Framework question library is under development'**
  String get assessmentFrameworkLibraryUnderDevelopment;

  /// No description provided for @featureWeightedScoring.
  ///
  /// In en, this message translates to:
  /// **'Weighted Scoring'**
  String get featureWeightedScoring;

  /// No description provided for @featureWeightedScoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Questions and criteria weighted by importance'**
  String get featureWeightedScoringDesc;

  /// No description provided for @featureRealTimeScoring.
  ///
  /// In en, this message translates to:
  /// **'Real-time Scoring'**
  String get featureRealTimeScoring;

  /// No description provided for @featureRealTimeScoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatic calculation as you answer'**
  String get featureRealTimeScoringDesc;

  /// No description provided for @featureEvidenceCollection.
  ///
  /// In en, this message translates to:
  /// **'Evidence Collection'**
  String get featureEvidenceCollection;

  /// No description provided for @featureEvidenceCollectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Attach evidence and documentation'**
  String get featureEvidenceCollectionDesc;

  /// No description provided for @featureProgressTracking.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get featureProgressTracking;

  /// No description provided for @featureProgressTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Track completion by category'**
  String get featureProgressTrackingDesc;

  /// No description provided for @qlibSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get qlibSaveDraft;

  /// No description provided for @qlibSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Assessment'**
  String get qlibSubmit;

  /// No description provided for @qlibQuestionsAnswered.
  ///
  /// In en, this message translates to:
  /// **'Questions Answered'**
  String get qlibQuestionsAnswered;

  /// No description provided for @qlibOverallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Score'**
  String get qlibOverallScore;

  /// No description provided for @qlibNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get qlibNeedsImprovement;

  /// No description provided for @qlibEvidenceAttached.
  ///
  /// In en, this message translates to:
  /// **'Evidence Attached'**
  String get qlibEvidenceAttached;

  /// No description provided for @qlibFindings.
  ///
  /// In en, this message translates to:
  /// **'Findings'**
  String get qlibFindings;

  /// No description provided for @qlibCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get qlibCategories;

  /// No description provided for @qlibCategoryProgress.
  ///
  /// In en, this message translates to:
  /// **'Category Progress'**
  String get qlibCategoryProgress;

  /// No description provided for @qlibAnswered.
  ///
  /// In en, this message translates to:
  /// **'{answered}/{total} answered'**
  String qlibAnswered(int answered, int total);

  /// No description provided for @qlibResponse.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get qlibResponse;

  /// No description provided for @qlibQuestionWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight: {value}'**
  String qlibQuestionWeight(int value);

  /// No description provided for @qlibNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get qlibNotesOptional;

  /// No description provided for @qlibEvidencePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Provide evidence or reference documentation...'**
  String get qlibEvidencePlaceholder;

  /// No description provided for @qlibNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Additional notes or context...'**
  String get qlibNotesPlaceholder;

  /// No description provided for @qlibPreviousCategory.
  ///
  /// In en, this message translates to:
  /// **'Previous Category'**
  String get qlibPreviousCategory;

  /// No description provided for @qlibNextCategory.
  ///
  /// In en, this message translates to:
  /// **'Next Category'**
  String get qlibNextCategory;

  /// No description provided for @qlibCategoryOf.
  ///
  /// In en, this message translates to:
  /// **'Category {current} of {total}'**
  String qlibCategoryOf(int current, int total);

  /// No description provided for @qlibAnsweredBadge.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get qlibAnsweredBadge;

  /// No description provided for @qlibScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {value}%'**
  String qlibScore(int value);

  /// No description provided for @qlibSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Select an option...'**
  String get qlibSelectOption;

  /// No description provided for @caTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Assessment'**
  String get caTitle;

  /// No description provided for @caNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Assessment Name'**
  String get caNameLabel;

  /// No description provided for @caNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Custom Security Assessment'**
  String get caNameHint;

  /// No description provided for @caDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get caDescriptionLabel;

  /// No description provided for @caDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the assessment'**
  String get caDescriptionHint;

  /// No description provided for @caSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get caSelectCategory;

  /// No description provided for @caColorThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get caColorThemeLabel;

  /// No description provided for @caQuestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get caQuestionsLabel;

  /// No description provided for @caEstTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. Time'**
  String get caEstTimeLabel;

  /// No description provided for @caEstTimeHint.
  ///
  /// In en, this message translates to:
  /// **'30-45 min'**
  String get caEstTimeHint;

  /// No description provided for @createAssessment.
  ///
  /// In en, this message translates to:
  /// **'Create Assessment'**
  String get createAssessment;

  /// No description provided for @caCatCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get caCatCompliance;

  /// No description provided for @caCatSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get caCatSecurity;

  /// No description provided for @caCatPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get caCatPrivacy;

  /// No description provided for @caCatOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get caCatOperational;

  /// No description provided for @caCatFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get caCatFinancial;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeBlue;

  /// No description provided for @themeGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeGreen;

  /// No description provided for @themePurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themePurple;

  /// No description provided for @themeOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeOrange;

  /// No description provided for @themeRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeRed;

  /// No description provided for @addNewProgram.
  ///
  /// In en, this message translates to:
  /// **'Add New Program'**
  String get addNewProgram;

  /// No description provided for @createNewProgram.
  ///
  /// In en, this message translates to:
  /// **'Create New Program'**
  String get createNewProgram;

  /// No description provided for @addProgramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new risk mitigation program'**
  String get addProgramSubtitle;

  /// No description provided for @programNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Program Name'**
  String get programNameLabel;

  /// No description provided for @programNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Identity Security Program'**
  String get programNameHint;

  /// No description provided for @programBriefDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description'**
  String get programBriefDescription;

  /// No description provided for @programDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe the program objectives and scope...'**
  String get programDescriptionPlaceholder;

  /// No description provided for @programOwnerHint.
  ///
  /// In en, this message translates to:
  /// **'Select owner...'**
  String get programOwnerHint;

  /// No description provided for @programOwnerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Team/Person'**
  String get programOwnerPlaceholder;

  /// No description provided for @programStatusPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get programStatusPlanning;

  /// No description provided for @programProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress (%)'**
  String get programProgressLabel;

  /// No description provided for @programBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget (\$)'**
  String get programBudgetLabel;

  /// No description provided for @programSpentLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent (\$)'**
  String get programSpentLabel;

  /// No description provided for @targetRisksLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Risks (comma-separated IDs)'**
  String get targetRisksLabel;

  /// No description provided for @linkedAssetsCommaLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked Assets (comma-separated IDs)'**
  String get linkedAssetsCommaLabel;

  /// No description provided for @linkedAssetsHint.
  ///
  /// In en, this message translates to:
  /// **'AST-001, AST-006'**
  String get linkedAssetsHint;

  /// No description provided for @programKpisTitle.
  ///
  /// In en, this message translates to:
  /// **'KPIs'**
  String get programKpisTitle;

  /// No description provided for @riskReductionPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction (%)'**
  String get riskReductionPercentLabel;

  /// No description provided for @targetReductionPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Reduction (%)'**
  String get targetReductionPercentLabel;

  /// No description provided for @controlsImplementedLabel.
  ///
  /// In en, this message translates to:
  /// **'Controls Implemented'**
  String get controlsImplementedLabel;

  /// No description provided for @targetControlsLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Controls'**
  String get targetControlsLabel;

  /// No description provided for @riskReductionTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction Target (%)'**
  String get riskReductionTargetLabel;

  /// No description provided for @budgetTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Budget (\$K)'**
  String get budgetTotalLabel;

  /// No description provided for @linkedControls.
  ///
  /// In en, this message translates to:
  /// **'Linked Controls'**
  String get linkedControls;

  /// No description provided for @linkedControlsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., CTL-001, CTL-002'**
  String get linkedControlsHint;

  /// No description provided for @linkedRisksHint.
  ///
  /// In en, this message translates to:
  /// **'R-001, R-004'**
  String get linkedRisksHint;

  /// No description provided for @goalsAndBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Goals & Budget'**
  String get goalsAndBudgetTitle;

  /// No description provided for @programIntegrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Integration'**
  String get programIntegrationTitle;

  /// No description provided for @createProgram.
  ///
  /// In en, this message translates to:
  /// **'Create Program'**
  String get createProgram;

  /// No description provided for @updateProgram.
  ///
  /// In en, this message translates to:
  /// **'Update Program'**
  String get updateProgram;

  /// No description provided for @programCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Program created successfully'**
  String get programCreatedSuccess;

  /// No description provided for @programUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Program updated successfully'**
  String get programUpdatedSuccess;

  /// No description provided for @programsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Mitigation Programs'**
  String get programsPageTitle;

  /// No description provided for @programsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track security programs and their impact on risk reduction'**
  String get programsPageSubtitle;

  /// No description provided for @newProgram.
  ///
  /// In en, this message translates to:
  /// **'New Program'**
  String get newProgram;

  /// No description provided for @programNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Program name is required'**
  String get programNameRequired;

  /// No description provided for @programOwnerRequired.
  ///
  /// In en, this message translates to:
  /// **'Program owner is required'**
  String get programOwnerRequired;

  /// No description provided for @programOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Program Overview'**
  String get programOverviewTitle;

  /// No description provided for @programTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get programTimelineTitle;

  /// No description provided for @programProgressTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get programProgressTrackingTitle;

  /// No description provided for @programOverallProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get programOverallProgressLabel;

  /// No description provided for @programKpisSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators'**
  String get programKpisSectionTitle;

  /// No description provided for @programBudgetManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Management'**
  String get programBudgetManagementTitle;

  /// No description provided for @programBudgetUtilizationLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Utilization'**
  String get programBudgetUtilizationLabel;

  /// No description provided for @programBudgetSpentTotal.
  ///
  /// In en, this message translates to:
  /// **'\'\$\'{spent}K / \'\$\'{total}K'**
  String programBudgetSpentTotal(int spent, int total);

  /// No description provided for @programRemainingBudget.
  ///
  /// In en, this message translates to:
  /// **'Remaining: \'\$\'{amount}K'**
  String programRemainingBudget(int amount);

  /// No description provided for @programTargetReductionPercent.
  ///
  /// In en, this message translates to:
  /// **'Target: {percent}%'**
  String programTargetReductionPercent(int percent);

  /// No description provided for @programTargetControlsCount.
  ///
  /// In en, this message translates to:
  /// **'Target: {count} controls'**
  String programTargetControlsCount(int count);

  /// No description provided for @programLinkedItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Linked Items'**
  String get programLinkedItemsTitle;

  /// No description provided for @programTargetRisksCount.
  ///
  /// In en, this message translates to:
  /// **'Target Risks ({count})'**
  String programTargetRisksCount(int count);

  /// No description provided for @programLinkedAssetsCount.
  ///
  /// In en, this message translates to:
  /// **'Linked Assets ({count})'**
  String programLinkedAssetsCount(int count);

  /// No description provided for @editProgram.
  ///
  /// In en, this message translates to:
  /// **'Edit Program'**
  String get editProgram;

  /// No description provided for @reviewProgressPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive performance tracking across all GRC areas'**
  String get reviewProgressPageSubtitle;

  /// No description provided for @reviewProgressLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get reviewProgressLast30Days;

  /// No description provided for @reviewProgressExportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get reviewProgressExportReport;

  /// No description provided for @reviewProgressOverallHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall GRC Health Score'**
  String get reviewProgressOverallHealthTitle;

  /// No description provided for @reviewProgressHealthDescription.
  ///
  /// In en, this message translates to:
  /// **'Strong performance across all areas with continuous improvement'**
  String get reviewProgressHealthDescription;

  /// No description provided for @reviewProgressHealthTrend.
  ///
  /// In en, this message translates to:
  /// **'+{percent}%'**
  String reviewProgressHealthTrend(double percent);

  /// No description provided for @reviewProgressComplianceLabel.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get reviewProgressComplianceLabel;

  /// No description provided for @reviewProgressItemsTracked.
  ///
  /// In en, this message translates to:
  /// **'{count} items tracked'**
  String reviewProgressItemsTracked(int count);

  /// No description provided for @reviewProgressPerformanceTrendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Trends (6 Months)'**
  String get reviewProgressPerformanceTrendsTitle;

  /// No description provided for @reviewProgressFrameworkComplianceTitle.
  ///
  /// In en, this message translates to:
  /// **'Framework Compliance'**
  String get reviewProgressFrameworkComplianceTitle;

  /// No description provided for @reviewProgressRiskDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Distribution'**
  String get reviewProgressRiskDistributionTitle;

  /// No description provided for @reviewProgressRiskReductionLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction'**
  String get reviewProgressRiskReductionLabel;

  /// No description provided for @reviewProgressRiskReductionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'from inherent to residual'**
  String get reviewProgressRiskReductionSubtitle;

  /// No description provided for @reviewProgressRiskCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get reviewProgressRiskCritical;

  /// No description provided for @reviewProgressRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get reviewProgressRiskHigh;

  /// No description provided for @reviewProgressRiskMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get reviewProgressRiskMedium;

  /// No description provided for @reviewProgressRiskLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get reviewProgressRiskLow;

  /// No description provided for @reviewProgressControlEffectivenessTitle.
  ///
  /// In en, this message translates to:
  /// **'Control Effectiveness'**
  String get reviewProgressControlEffectivenessTitle;

  /// No description provided for @reviewProgressAverageEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Average Effectiveness'**
  String get reviewProgressAverageEffectiveness;

  /// No description provided for @reviewProgressControlsImplemented.
  ///
  /// In en, this message translates to:
  /// **'Implemented'**
  String get reviewProgressControlsImplemented;

  /// No description provided for @reviewProgressControlsPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get reviewProgressControlsPartial;

  /// No description provided for @reviewProgressControlsNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Not Impl.'**
  String get reviewProgressControlsNotImplemented;

  /// No description provided for @reviewProgressLastTested.
  ///
  /// In en, this message translates to:
  /// **'Last Tested'**
  String get reviewProgressLastTested;

  /// No description provided for @reviewProgressAssessmentProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessment Progress'**
  String get reviewProgressAssessmentProgressTitle;

  /// No description provided for @reviewProgressPriorityActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Priority Action Items'**
  String get reviewProgressPriorityActionsTitle;

  /// No description provided for @reviewProgressPriorityActionsTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String reviewProgressPriorityActionsTotal(int count);

  /// No description provided for @reviewProgressItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String reviewProgressItemsCount(int count);

  /// No description provided for @reviewProgressActionDueIn.
  ///
  /// In en, this message translates to:
  /// **'{area} • Due in {days} days'**
  String reviewProgressActionDueIn(String area, int days);

  /// No description provided for @reviewProgressRecentActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get reviewProgressRecentActivityTitle;

  /// No description provided for @reviewProgressActivityBy.
  ///
  /// In en, this message translates to:
  /// **'by {actor}'**
  String reviewProgressActivityBy(String actor);

  /// No description provided for @reviewProgressStatusPass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get reviewProgressStatusPass;

  /// No description provided for @reviewProgressStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get reviewProgressStatusUpdated;

  /// No description provided for @reviewProgressStatusAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get reviewProgressStatusAdded;

  /// No description provided for @reviewProgressActivityControlTested.
  ///
  /// In en, this message translates to:
  /// **'Control CTL-010 tested'**
  String get reviewProgressActivityControlTested;

  /// No description provided for @reviewProgressActivityRiskReassessed.
  ///
  /// In en, this message translates to:
  /// **'Risk R-003 reassessed'**
  String get reviewProgressActivityRiskReassessed;

  /// No description provided for @reviewProgressActivitySoxCompleted.
  ///
  /// In en, this message translates to:
  /// **'SOX assessment completed'**
  String get reviewProgressActivitySoxCompleted;

  /// No description provided for @reviewProgressActivityAssetRegistered.
  ///
  /// In en, this message translates to:
  /// **'New asset AST-145 registered'**
  String get reviewProgressActivityAssetRegistered;

  /// No description provided for @reviewProgressActivityProgramUpdated.
  ///
  /// In en, this message translates to:
  /// **'Security awareness program updated'**
  String get reviewProgressActivityProgramUpdated;

  /// No description provided for @reviewProgressActorSocManager.
  ///
  /// In en, this message translates to:
  /// **'SOC Manager'**
  String get reviewProgressActorSocManager;

  /// No description provided for @reviewProgressActorCloudArchitect.
  ///
  /// In en, this message translates to:
  /// **'Cloud Architect'**
  String get reviewProgressActorCloudArchitect;

  /// No description provided for @reviewProgressActorComplianceTeam.
  ///
  /// In en, this message translates to:
  /// **'Compliance Team'**
  String get reviewProgressActorComplianceTeam;

  /// No description provided for @reviewProgressActorItAdmin.
  ///
  /// In en, this message translates to:
  /// **'IT Admin'**
  String get reviewProgressActorItAdmin;

  /// No description provided for @reviewProgressActorHrManager.
  ///
  /// In en, this message translates to:
  /// **'HR Manager'**
  String get reviewProgressActorHrManager;

  /// No description provided for @reviewProgressKeyInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Insights & Recommendations'**
  String get reviewProgressKeyInsightsTitle;

  /// No description provided for @reviewProgressInsightControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Strong Control Posture'**
  String get reviewProgressInsightControlTitle;

  /// No description provided for @reviewProgressInsightControlDescription.
  ///
  /// In en, this message translates to:
  /// **'90% of controls are fully implemented with 86% average effectiveness. Continue quarterly testing.'**
  String get reviewProgressInsightControlDescription;

  /// No description provided for @reviewProgressInsightProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Program Completion Gap'**
  String get reviewProgressInsightProgramTitle;

  /// No description provided for @reviewProgressInsightProgramDescription.
  ///
  /// In en, this message translates to:
  /// **'3 programs need attention to reach 75% target. Focus on security awareness and vendor assessments.'**
  String get reviewProgressInsightProgramDescription;

  /// No description provided for @reviewProgressInsightRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction Success'**
  String get reviewProgressInsightRiskTitle;

  /// No description provided for @reviewProgressInsightRiskDescription.
  ///
  /// In en, this message translates to:
  /// **'82% reduction from inherent to residual risk. Excellent progress on mitigation strategies.'**
  String get reviewProgressInsightRiskDescription;

  /// No description provided for @rolesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Role Model'**
  String get rolesPageTitle;

  /// No description provided for @rolesPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Role-based access control and functional responsibilities'**
  String get rolesPageSubtitle;

  /// No description provided for @rolesStatFunctionalRoles.
  ///
  /// In en, this message translates to:
  /// **'Functional Roles'**
  String get rolesStatFunctionalRoles;

  /// No description provided for @rolesStatSystemRoles.
  ///
  /// In en, this message translates to:
  /// **'System Roles (RBAC)'**
  String get rolesStatSystemRoles;

  /// No description provided for @rolesStatCategories.
  ///
  /// In en, this message translates to:
  /// **'Role Categories'**
  String get rolesStatCategories;

  /// No description provided for @rolesStatModulePermissions.
  ///
  /// In en, this message translates to:
  /// **'Module Permissions'**
  String get rolesStatModulePermissions;

  /// No description provided for @rolesViewModeLabel.
  ///
  /// In en, this message translates to:
  /// **'View Mode:'**
  String get rolesViewModeLabel;

  /// No description provided for @rolesViewModeFunctional.
  ///
  /// In en, this message translates to:
  /// **'Functional Roles'**
  String get rolesViewModeFunctional;

  /// No description provided for @rolesViewModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Roles (RBAC)'**
  String get rolesViewModeSystem;

  /// No description provided for @rolesSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search roles...'**
  String get rolesSearchPlaceholder;

  /// No description provided for @rolesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get rolesFilterAll;

  /// No description provided for @rolesCategoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} roles'**
  String rolesCategoryCount(int count);

  /// No description provided for @rolesScopePrefix.
  ///
  /// In en, this message translates to:
  /// **'Scope: {scope}'**
  String rolesScopePrefix(String scope);

  /// No description provided for @rolesScopeGlobal.
  ///
  /// In en, this message translates to:
  /// **'GLOBAL'**
  String get rolesScopeGlobal;

  /// No description provided for @rolesScopeBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'BUSINESS UNIT'**
  String get rolesScopeBusinessUnit;

  /// No description provided for @rolesScopeCustom.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM'**
  String get rolesScopeCustom;

  /// No description provided for @rolesScopeAsset.
  ///
  /// In en, this message translates to:
  /// **'ASSET'**
  String get rolesScopeAsset;

  /// No description provided for @rolesSystemRolesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'System Roles (RBAC)'**
  String get rolesSystemRolesSectionTitle;

  /// No description provided for @rolesArchitectureTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Layer Role Architecture'**
  String get rolesArchitectureTitle;

  /// No description provided for @rolesArchitectureFunctionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Functional Roles (Business)'**
  String get rolesArchitectureFunctionalTitle;

  /// No description provided for @rolesArchitectureFunctionalDescription.
  ///
  /// In en, this message translates to:
  /// **'Represent actual business positions and responsibilities within the organization.'**
  String get rolesArchitectureFunctionalDescription;

  /// No description provided for @rolesArchitectureFunctionalBullet1.
  ///
  /// In en, this message translates to:
  /// **'• CRO, CISO, CFO, Risk Manager, Auditor'**
  String get rolesArchitectureFunctionalBullet1;

  /// No description provided for @rolesArchitectureFunctionalBullet2.
  ///
  /// In en, this message translates to:
  /// **'• Aligned to organizational structure'**
  String get rolesArchitectureFunctionalBullet2;

  /// No description provided for @rolesArchitectureFunctionalBullet3.
  ///
  /// In en, this message translates to:
  /// **'• Business accountability and ownership'**
  String get rolesArchitectureFunctionalBullet3;

  /// No description provided for @rolesArchitectureSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System Roles (RBAC)'**
  String get rolesArchitectureSystemTitle;

  /// No description provided for @rolesArchitectureSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Technical access control roles that define permissions within the platform.'**
  String get rolesArchitectureSystemDescription;

  /// No description provided for @rolesArchitectureSystemBullet1.
  ///
  /// In en, this message translates to:
  /// **'• Simplified RBAC with 11 system roles'**
  String get rolesArchitectureSystemBullet1;

  /// No description provided for @rolesArchitectureSystemBullet2.
  ///
  /// In en, this message translates to:
  /// **'• Module-level permission control'**
  String get rolesArchitectureSystemBullet2;

  /// No description provided for @rolesArchitectureSystemBullet3.
  ///
  /// In en, this message translates to:
  /// **'• Data scope management (Global/BU/Asset)'**
  String get rolesArchitectureSystemBullet3;

  /// No description provided for @rolesCategoryExecutiveGovernance.
  ///
  /// In en, this message translates to:
  /// **'Executive & Governance'**
  String get rolesCategoryExecutiveGovernance;

  /// No description provided for @rolesCategoryGrcLeadership.
  ///
  /// In en, this message translates to:
  /// **'GRC Leadership & Management'**
  String get rolesCategoryGrcLeadership;

  /// No description provided for @rolesCategorySecurityCyber.
  ///
  /// In en, this message translates to:
  /// **'Security & Cyber'**
  String get rolesCategorySecurityCyber;

  /// No description provided for @rolesCategoryCloudTprm.
  ///
  /// In en, this message translates to:
  /// **'Cloud & Third-Party Risk'**
  String get rolesCategoryCloudTprm;

  /// No description provided for @rolesCategoryBcmResilience.
  ///
  /// In en, this message translates to:
  /// **'Business Continuity & Resilience'**
  String get rolesCategoryBcmResilience;

  /// No description provided for @rolesCategoryAuditAssurance.
  ///
  /// In en, this message translates to:
  /// **'Audit & Assurance'**
  String get rolesCategoryAuditAssurance;

  /// No description provided for @rolesCategoryOperationalBusiness.
  ///
  /// In en, this message translates to:
  /// **'Operational / Business'**
  String get rolesCategoryOperationalBusiness;

  /// No description provided for @rolesCategoryPlatformTechnical.
  ///
  /// In en, this message translates to:
  /// **'Platform & Technical'**
  String get rolesCategoryPlatformTechnical;

  /// No description provided for @rolesCategoryProgramRemediation.
  ///
  /// In en, this message translates to:
  /// **'Program & Remediation'**
  String get rolesCategoryProgramRemediation;

  /// No description provided for @rolesRoleCroTitle.
  ///
  /// In en, this message translates to:
  /// **'Chief Risk Officer (CRO)'**
  String get rolesRoleCroTitle;

  /// No description provided for @rolesRoleCroDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns enterprise risk framework and approves risk appetite'**
  String get rolesRoleCroDescription;

  /// No description provided for @rolesRoleCisoTitle.
  ///
  /// In en, this message translates to:
  /// **'Chief Information Security Officer (CISO)'**
  String get rolesRoleCisoTitle;

  /// No description provided for @rolesRoleCisoDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns cybersecurity and oversees SOC, incident response'**
  String get rolesRoleCisoDescription;

  /// No description provided for @rolesRoleCfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Chief Financial Officer (CFO)'**
  String get rolesRoleCfoTitle;

  /// No description provided for @rolesRoleCfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns SOX compliance and financial controls'**
  String get rolesRoleCfoDescription;

  /// No description provided for @rolesRoleCooTitle.
  ///
  /// In en, this message translates to:
  /// **'Chief Operating Officer (COO)'**
  String get rolesRoleCooTitle;

  /// No description provided for @rolesRoleCooDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns operational risk and business continuity'**
  String get rolesRoleCooDescription;

  /// No description provided for @rolesRoleGrcDirectorTitle.
  ///
  /// In en, this message translates to:
  /// **'GRC Director / Head of Risk'**
  String get rolesRoleGrcDirectorTitle;

  /// No description provided for @rolesRoleGrcDirectorDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages overall GRC platform and aligns all frameworks'**
  String get rolesRoleGrcDirectorDescription;

  /// No description provided for @rolesRoleEnterpriseRiskManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Manager (Enterprise Risk)'**
  String get rolesRoleEnterpriseRiskManagerTitle;

  /// No description provided for @rolesRoleEnterpriseRiskManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Maintains risk register and performs risk assessments'**
  String get rolesRoleEnterpriseRiskManagerDescription;

  /// No description provided for @rolesRoleOperationalRiskManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Operational Risk Manager'**
  String get rolesRoleOperationalRiskManagerTitle;

  /// No description provided for @rolesRoleOperationalRiskManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages RCSA and tracks KRIs and loss events'**
  String get rolesRoleOperationalRiskManagerDescription;

  /// No description provided for @rolesRoleComplianceManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Compliance Manager'**
  String get rolesRoleComplianceManagerTitle;

  /// No description provided for @rolesRoleComplianceManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages regulatory frameworks and tracks compliance status'**
  String get rolesRoleComplianceManagerDescription;

  /// No description provided for @rolesRoleSecurityArchitectTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Architect'**
  String get rolesRoleSecurityArchitectTitle;

  /// No description provided for @rolesRoleSecurityArchitectDescription.
  ///
  /// In en, this message translates to:
  /// **'Designs security controls and maps to frameworks'**
  String get rolesRoleSecurityArchitectDescription;

  /// No description provided for @rolesRoleSocAnalystTitle.
  ///
  /// In en, this message translates to:
  /// **'SOC Analyst'**
  String get rolesRoleSocAnalystTitle;

  /// No description provided for @rolesRoleSocAnalystDescription.
  ///
  /// In en, this message translates to:
  /// **'Monitors SIEM alerts and investigates incidents'**
  String get rolesRoleSocAnalystDescription;

  /// No description provided for @rolesRoleVulnerabilityManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Vulnerability Manager'**
  String get rolesRoleVulnerabilityManagerTitle;

  /// No description provided for @rolesRoleVulnerabilityManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Tracks vulnerabilities and manages remediation cycles'**
  String get rolesRoleVulnerabilityManagerDescription;

  /// No description provided for @rolesRoleIamManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity & Access Manager'**
  String get rolesRoleIamManagerTitle;

  /// No description provided for @rolesRoleIamManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages IAM/PAM/MFA and access controls'**
  String get rolesRoleIamManagerDescription;

  /// No description provided for @rolesRoleCloudSecurityManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Security Manager'**
  String get rolesRoleCloudSecurityManagerTitle;

  /// No description provided for @rolesRoleCloudSecurityManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Oversees CSPM/CNAPP and cloud risk posture'**
  String get rolesRoleCloudSecurityManagerDescription;

  /// No description provided for @rolesRoleVendorRiskManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor Risk Manager (TPRM)'**
  String get rolesRoleVendorRiskManagerTitle;

  /// No description provided for @rolesRoleVendorRiskManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Performs vendor risk assessments and monitors third-party risks'**
  String get rolesRoleVendorRiskManagerDescription;

  /// No description provided for @rolesRoleBcmManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'BCM Manager'**
  String get rolesRoleBcmManagerTitle;

  /// No description provided for @rolesRoleBcmManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns Business Continuity and conducts BIA'**
  String get rolesRoleBcmManagerDescription;

  /// No description provided for @rolesRoleCrisisManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Crisis Manager'**
  String get rolesRoleCrisisManagerTitle;

  /// No description provided for @rolesRoleCrisisManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Handles major incidents and coordinates response'**
  String get rolesRoleCrisisManagerDescription;

  /// No description provided for @rolesRoleInternalAuditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Internal Auditor'**
  String get rolesRoleInternalAuditorTitle;

  /// No description provided for @rolesRoleInternalAuditorDescription.
  ///
  /// In en, this message translates to:
  /// **'Performs audits and reviews evidence'**
  String get rolesRoleInternalAuditorDescription;

  /// No description provided for @rolesRoleExternalAuditorTitle.
  ///
  /// In en, this message translates to:
  /// **'External Auditor'**
  String get rolesRoleExternalAuditorTitle;

  /// No description provided for @rolesRoleExternalAuditorDescription.
  ///
  /// In en, this message translates to:
  /// **'Independent validation and compliance review'**
  String get rolesRoleExternalAuditorDescription;

  /// No description provided for @rolesRoleBuRiskOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Unit Risk Owner'**
  String get rolesRoleBuRiskOwnerTitle;

  /// No description provided for @rolesRoleBuRiskOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns risks for specific business unit'**
  String get rolesRoleBuRiskOwnerDescription;

  /// No description provided for @rolesRoleAssetOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset Owner'**
  String get rolesRoleAssetOwnerTitle;

  /// No description provided for @rolesRoleAssetOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns and is responsible for asset security'**
  String get rolesRoleAssetOwnerDescription;

  /// No description provided for @rolesRoleControlOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Control Owner'**
  String get rolesRoleControlOwnerTitle;

  /// No description provided for @rolesRoleControlOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Responsible for control execution and evidence'**
  String get rolesRoleControlOwnerDescription;

  /// No description provided for @rolesRoleProcessOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Process Owner'**
  String get rolesRoleProcessOwnerTitle;

  /// No description provided for @rolesRoleProcessOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Owns business process and identifies operational risks'**
  String get rolesRoleProcessOwnerDescription;

  /// No description provided for @rolesRoleGrcAdministratorTitle.
  ///
  /// In en, this message translates to:
  /// **'GRC System Administrator'**
  String get rolesRoleGrcAdministratorTitle;

  /// No description provided for @rolesRoleGrcAdministratorDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages platform configuration and user access'**
  String get rolesRoleGrcAdministratorDescription;

  /// No description provided for @rolesRoleIntegrationManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Integration/API Manager'**
  String get rolesRoleIntegrationManagerTitle;

  /// No description provided for @rolesRoleIntegrationManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages APIs and system integrations'**
  String get rolesRoleIntegrationManagerDescription;

  /// No description provided for @rolesRoleDataStewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Steward'**
  String get rolesRoleDataStewardTitle;

  /// No description provided for @rolesRoleDataStewardDescription.
  ///
  /// In en, this message translates to:
  /// **'Ensures data quality and maintains master data integrity'**
  String get rolesRoleDataStewardDescription;

  /// No description provided for @rolesRoleProgramManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Program Manager'**
  String get rolesRoleProgramManagerTitle;

  /// No description provided for @rolesRoleProgramManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages risk mitigation programs and tracks KPIs'**
  String get rolesRoleProgramManagerDescription;

  /// No description provided for @rolesRoleRemediationOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Remediation Owner'**
  String get rolesRoleRemediationOwnerTitle;

  /// No description provided for @rolesRoleRemediationOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Fixes issues/findings and ensures closure'**
  String get rolesRoleRemediationOwnerDescription;

  /// No description provided for @rolesBadgeGrcAdmin.
  ///
  /// In en, this message translates to:
  /// **'Grc Admin'**
  String get rolesBadgeGrcAdmin;

  /// No description provided for @rolesBadgeRiskManager.
  ///
  /// In en, this message translates to:
  /// **'Risk Manager'**
  String get rolesBadgeRiskManager;

  /// No description provided for @rolesBadgeRiskAssessor.
  ///
  /// In en, this message translates to:
  /// **'Risk Assessor'**
  String get rolesBadgeRiskAssessor;

  /// No description provided for @rolesBadgeComplianceManager.
  ///
  /// In en, this message translates to:
  /// **'Compliance Manager'**
  String get rolesBadgeComplianceManager;

  /// No description provided for @rolesBadgeFrameworkOwner.
  ///
  /// In en, this message translates to:
  /// **'Framework Owner'**
  String get rolesBadgeFrameworkOwner;

  /// No description provided for @rolesBadgeControlOwner.
  ///
  /// In en, this message translates to:
  /// **'Control Owner'**
  String get rolesBadgeControlOwner;

  /// No description provided for @rolesBadgeControlTester.
  ///
  /// In en, this message translates to:
  /// **'Control Tester'**
  String get rolesBadgeControlTester;

  /// No description provided for @rolesBadgeAssetOwner.
  ///
  /// In en, this message translates to:
  /// **'Asset Owner'**
  String get rolesBadgeAssetOwner;

  /// No description provided for @rolesBadgeViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get rolesBadgeViewer;

  /// No description provided for @rolesBadgeAuditor.
  ///
  /// In en, this message translates to:
  /// **'Auditor'**
  String get rolesBadgeAuditor;

  /// No description provided for @rolesBadgeSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get rolesBadgeSuperAdmin;

  /// No description provided for @rolesSystemSuperAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get rolesSystemSuperAdminTitle;

  /// No description provided for @rolesSystemSuperAdminDescription.
  ///
  /// In en, this message translates to:
  /// **'Full platform access across all modules and configuration'**
  String get rolesSystemSuperAdminDescription;

  /// No description provided for @rolesSystemGrcAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Grc Admin'**
  String get rolesSystemGrcAdminTitle;

  /// No description provided for @rolesSystemGrcAdminDescription.
  ///
  /// In en, this message translates to:
  /// **'Administrative access to GRC configuration and user management'**
  String get rolesSystemGrcAdminDescription;

  /// No description provided for @rolesSystemRiskManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Manager'**
  String get rolesSystemRiskManagerTitle;

  /// No description provided for @rolesSystemRiskManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage risks, assessments, and mitigation programs'**
  String get rolesSystemRiskManagerDescription;

  /// No description provided for @rolesSystemRiskAssessorTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Assessor'**
  String get rolesSystemRiskAssessorTitle;

  /// No description provided for @rolesSystemRiskAssessorDescription.
  ///
  /// In en, this message translates to:
  /// **'Perform risk assessments and update risk registers'**
  String get rolesSystemRiskAssessorDescription;

  /// No description provided for @rolesSystemComplianceManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Compliance Manager'**
  String get rolesSystemComplianceManagerTitle;

  /// No description provided for @rolesSystemComplianceManagerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage compliance frameworks, controls, and library content'**
  String get rolesSystemComplianceManagerDescription;

  /// No description provided for @rolesSystemFrameworkOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Framework Owner'**
  String get rolesSystemFrameworkOwnerTitle;

  /// No description provided for @rolesSystemFrameworkOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Own framework mappings, library, and assessment templates'**
  String get rolesSystemFrameworkOwnerDescription;

  /// No description provided for @rolesSystemControlOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Control Owner'**
  String get rolesSystemControlOwnerTitle;

  /// No description provided for @rolesSystemControlOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage control implementation and linked assets'**
  String get rolesSystemControlOwnerDescription;

  /// No description provided for @rolesSystemControlTesterTitle.
  ///
  /// In en, this message translates to:
  /// **'Control Tester'**
  String get rolesSystemControlTesterTitle;

  /// No description provided for @rolesSystemControlTesterDescription.
  ///
  /// In en, this message translates to:
  /// **'Execute control tests and upload evidence'**
  String get rolesSystemControlTesterDescription;

  /// No description provided for @rolesSystemAssetOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset Owner'**
  String get rolesSystemAssetOwnerTitle;

  /// No description provided for @rolesSystemAssetOwnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage assigned assets and related risk linkages'**
  String get rolesSystemAssetOwnerDescription;

  /// No description provided for @rolesSystemViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get rolesSystemViewerTitle;

  /// No description provided for @rolesSystemViewerDescription.
  ///
  /// In en, this message translates to:
  /// **'Read-only access to dashboards and reports'**
  String get rolesSystemViewerDescription;

  /// No description provided for @rolesSystemAuditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Auditor'**
  String get rolesSystemAuditorTitle;

  /// No description provided for @rolesSystemAuditorDescription.
  ///
  /// In en, this message translates to:
  /// **'Review assessments, controls, and audit trail evidence'**
  String get rolesSystemAuditorDescription;

  /// No description provided for @rolesModuleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get rolesModuleDashboard;

  /// No description provided for @rolesModuleAdministration.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get rolesModuleAdministration;

  /// No description provided for @rolesModuleAllModules.
  ///
  /// In en, this message translates to:
  /// **'All Modules'**
  String get rolesModuleAllModules;

  /// No description provided for @rolesModuleConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get rolesModuleConfiguration;

  /// No description provided for @rolesModuleUserManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get rolesModuleUserManagement;

  /// No description provided for @rolesModuleRisks.
  ///
  /// In en, this message translates to:
  /// **'Risks'**
  String get rolesModuleRisks;

  /// No description provided for @rolesModuleAssessments.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get rolesModuleAssessments;

  /// No description provided for @rolesModulePrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get rolesModulePrograms;

  /// No description provided for @rolesModuleControls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get rolesModuleControls;

  /// No description provided for @rolesModuleLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get rolesModuleLibrary;

  /// No description provided for @rolesModuleAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get rolesModuleAssets;

  /// No description provided for @rolesModuleReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Read Only'**
  String get rolesModuleReadOnly;

  /// No description provided for @rolesModuleAuditTrail.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get rolesModuleAuditTrail;

  /// No description provided for @rolesSectionResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities'**
  String get rolesSectionResponsibilities;

  /// No description provided for @rolesSectionModuleAccess.
  ///
  /// In en, this message translates to:
  /// **'Module Access'**
  String get rolesSectionModuleAccess;

  /// No description provided for @rolesSectionSystemRolesRbac.
  ///
  /// In en, this message translates to:
  /// **'System Roles (RBAC)'**
  String get rolesSectionSystemRolesRbac;

  /// No description provided for @rolesSectionPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get rolesSectionPermissions;

  /// No description provided for @rolesRoleCroResp1.
  ///
  /// In en, this message translates to:
  /// **'Owns enterprise risk framework (COSO)'**
  String get rolesRoleCroResp1;

  /// No description provided for @rolesRoleCroResp2.
  ///
  /// In en, this message translates to:
  /// **'Approves risk appetite & tolerance'**
  String get rolesRoleCroResp2;

  /// No description provided for @rolesRoleCroResp3.
  ///
  /// In en, this message translates to:
  /// **'Reviews enterprise risk exposure (\$)'**
  String get rolesRoleCroResp3;

  /// No description provided for @rolesRoleCroResp4.
  ///
  /// In en, this message translates to:
  /// **'Final authority on risk acceptance'**
  String get rolesRoleCroResp4;

  /// No description provided for @rolesRoleCisoResp1.
  ///
  /// In en, this message translates to:
  /// **'Owns enterprise cybersecurity strategy'**
  String get rolesRoleCisoResp1;

  /// No description provided for @rolesRoleCisoResp2.
  ///
  /// In en, this message translates to:
  /// **'Oversees SOC operations and incident response'**
  String get rolesRoleCisoResp2;

  /// No description provided for @rolesRoleCisoResp3.
  ///
  /// In en, this message translates to:
  /// **'Approves security architecture and controls'**
  String get rolesRoleCisoResp3;

  /// No description provided for @rolesDetailRespAccountability.
  ///
  /// In en, this message translates to:
  /// **'Provides oversight and accountability for assigned domain'**
  String get rolesDetailRespAccountability;

  /// No description provided for @rolesDetailRespCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Collaborates with cross-functional GRC stakeholders'**
  String get rolesDetailRespCollaboration;

  /// No description provided for @rolesPermActionsViewCreateEditApprove.
  ///
  /// In en, this message translates to:
  /// **'view, create, edit, approve'**
  String get rolesPermActionsViewCreateEditApprove;

  /// No description provided for @rolesPermActionsViewApprove.
  ///
  /// In en, this message translates to:
  /// **'view, approve'**
  String get rolesPermActionsViewApprove;

  /// No description provided for @rolesPermActionsViewCreateEdit.
  ///
  /// In en, this message translates to:
  /// **'view, create, edit'**
  String get rolesPermActionsViewCreateEdit;

  /// No description provided for @rolesPermActionsViewEdit.
  ///
  /// In en, this message translates to:
  /// **'view, edit'**
  String get rolesPermActionsViewEdit;

  /// No description provided for @rolesPermActionsViewOnly.
  ///
  /// In en, this message translates to:
  /// **'view'**
  String get rolesPermActionsViewOnly;

  /// No description provided for @rolesPermActionsFull.
  ///
  /// In en, this message translates to:
  /// **'full access'**
  String get rolesPermActionsFull;

  /// No description provided for @rolesSelectSystemRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a System Role'**
  String get rolesSelectSystemRoleTitle;

  /// No description provided for @rolesSelectSystemRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Click on any system role above to view its permission matrix'**
  String get rolesSelectSystemRoleSubtitle;

  /// No description provided for @rolesPermissionMatrixTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Matrix'**
  String get rolesPermissionMatrixTitle;

  /// No description provided for @rolesPermissionMatrixForRole.
  ///
  /// In en, this message translates to:
  /// **'Permissions for {roleName}'**
  String rolesPermissionMatrixForRole(String roleName);

  /// No description provided for @rolesMatrixColModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get rolesMatrixColModule;

  /// No description provided for @rolesMatrixColPermissionLevel.
  ///
  /// In en, this message translates to:
  /// **'Permission Level'**
  String get rolesMatrixColPermissionLevel;

  /// No description provided for @rolesPermissionLevelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Levels'**
  String get rolesPermissionLevelsTitle;

  /// No description provided for @rolesPermLevelAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get rolesPermLevelAdmin;

  /// No description provided for @rolesPermLevelAdminDesc.
  ///
  /// In en, this message translates to:
  /// **'Full control'**
  String get rolesPermLevelAdminDesc;

  /// No description provided for @rolesPermLevelManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get rolesPermLevelManage;

  /// No description provided for @rolesPermLevelManageDesc.
  ///
  /// In en, this message translates to:
  /// **'Create, edit, delete'**
  String get rolesPermLevelManageDesc;

  /// No description provided for @rolesPermLevelEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get rolesPermLevelEdit;

  /// No description provided for @rolesPermLevelEditDesc.
  ///
  /// In en, this message translates to:
  /// **'Create, modify'**
  String get rolesPermLevelEditDesc;

  /// No description provided for @rolesPermLevelView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get rolesPermLevelView;

  /// No description provided for @rolesPermLevelViewDesc.
  ///
  /// In en, this message translates to:
  /// **'Read-only'**
  String get rolesPermLevelViewDesc;

  /// No description provided for @rolesPermLevelNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get rolesPermLevelNone;

  /// No description provided for @rolesPermLevelNoneDesc.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get rolesPermLevelNoneDesc;

  /// No description provided for @rolesMappedFunctionalRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mapped to Functional Roles'**
  String get rolesMappedFunctionalRolesTitle;

  /// No description provided for @rolesModuleSlugDashboard.
  ///
  /// In en, this message translates to:
  /// **'dashboard'**
  String get rolesModuleSlugDashboard;

  /// No description provided for @rolesModuleSlugLibrary.
  ///
  /// In en, this message translates to:
  /// **'library'**
  String get rolesModuleSlugLibrary;

  /// No description provided for @rolesModuleSlugAssets.
  ///
  /// In en, this message translates to:
  /// **'assets'**
  String get rolesModuleSlugAssets;

  /// No description provided for @rolesModuleSlugRisks.
  ///
  /// In en, this message translates to:
  /// **'risks'**
  String get rolesModuleSlugRisks;

  /// No description provided for @rolesModuleSlugAssessments.
  ///
  /// In en, this message translates to:
  /// **'assessments'**
  String get rolesModuleSlugAssessments;

  /// No description provided for @rolesModuleSlugControls.
  ///
  /// In en, this message translates to:
  /// **'controls'**
  String get rolesModuleSlugControls;

  /// No description provided for @rolesModuleSlugTprm.
  ///
  /// In en, this message translates to:
  /// **'tprm'**
  String get rolesModuleSlugTprm;

  /// No description provided for @rolesModuleSlugPrograms.
  ///
  /// In en, this message translates to:
  /// **'programs'**
  String get rolesModuleSlugPrograms;

  /// No description provided for @rolesModuleSlugAdministration.
  ///
  /// In en, this message translates to:
  /// **'administration'**
  String get rolesModuleSlugAdministration;

  /// No description provided for @rolesModuleSlugConfiguration.
  ///
  /// In en, this message translates to:
  /// **'configuration'**
  String get rolesModuleSlugConfiguration;

  /// No description provided for @rolesModuleSlugUserManagement.
  ///
  /// In en, this message translates to:
  /// **'user_management'**
  String get rolesModuleSlugUserManagement;

  /// No description provided for @rolesModuleSlugAuditTrail.
  ///
  /// In en, this message translates to:
  /// **'audit_trail'**
  String get rolesModuleSlugAuditTrail;

  /// No description provided for @rolesModuleSlugReadOnly.
  ///
  /// In en, this message translates to:
  /// **'read_only'**
  String get rolesModuleSlugReadOnly;

  /// No description provided for @cosoAvgMaturityScore.
  ///
  /// In en, this message translates to:
  /// **'Avg Maturity Score'**
  String get cosoAvgMaturityScore;

  /// No description provided for @cosoComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get cosoComponents;

  /// No description provided for @cosoStrongControls.
  ///
  /// In en, this message translates to:
  /// **'Strong Controls'**
  String get cosoStrongControls;

  /// No description provided for @cosoMaturityLevel.
  ///
  /// In en, this message translates to:
  /// **'Maturity Level'**
  String get cosoMaturityLevel;

  /// No description provided for @cosoMaturityByComponent.
  ///
  /// In en, this message translates to:
  /// **'Maturity by Component'**
  String get cosoMaturityByComponent;

  /// No description provided for @cosoErmMaturityAssessment.
  ///
  /// In en, this message translates to:
  /// **'ERM Maturity Assessment'**
  String get cosoErmMaturityAssessment;

  /// No description provided for @cosoMaturityScore.
  ///
  /// In en, this message translates to:
  /// **'Maturity Score'**
  String get cosoMaturityScore;

  /// No description provided for @cosoStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get cosoStrong;

  /// No description provided for @cosoAdequate.
  ///
  /// In en, this message translates to:
  /// **'Adequate'**
  String get cosoAdequate;

  /// No description provided for @cosoDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing'**
  String get cosoDeveloping;

  /// No description provided for @cosoMaturity.
  ///
  /// In en, this message translates to:
  /// **'Maturity'**
  String get cosoMaturity;

  /// No description provided for @cosoErmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Risk Management - Integrated Framework'**
  String get cosoErmSubtitle;

  /// No description provided for @cosoExportAssessment.
  ///
  /// In en, this message translates to:
  /// **'Export Assessment'**
  String get cosoExportAssessment;

  /// No description provided for @cosoImprovementRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Improvement Recommendations'**
  String get cosoImprovementRecommendations;

  /// No description provided for @cosoRec1Title.
  ///
  /// In en, this message translates to:
  /// **'Enhance Review & Revision Process'**
  String get cosoRec1Title;

  /// No description provided for @cosoRec1Desc.
  ///
  /// In en, this message translates to:
  /// **'Implement quarterly risk portfolio reviews and establish continuous improvement metrics'**
  String get cosoRec1Desc;

  /// No description provided for @cosoRec1Meta.
  ///
  /// In en, this message translates to:
  /// **'Priority: Medium • Impact: High'**
  String get cosoRec1Meta;

  /// No description provided for @cosoRec2Title.
  ///
  /// In en, this message translates to:
  /// **'Strengthen External Communication'**
  String get cosoRec2Title;

  /// No description provided for @cosoRec2Desc.
  ///
  /// In en, this message translates to:
  /// **'Develop stakeholder communication framework for risk disclosures'**
  String get cosoRec2Desc;

  /// No description provided for @cosoRec2Meta.
  ///
  /// In en, this message translates to:
  /// **'Priority: Low • Impact: Medium'**
  String get cosoRec2Meta;

  /// No description provided for @cosoComp1Title.
  ///
  /// In en, this message translates to:
  /// **'Governance & Culture'**
  String get cosoComp1Title;

  /// No description provided for @cosoComp1Short.
  ///
  /// In en, this message translates to:
  /// **'Governance'**
  String get cosoComp1Short;

  /// No description provided for @cosoComp1Desc.
  ///
  /// In en, this message translates to:
  /// **'Board oversight, operating structures, and organizational culture'**
  String get cosoComp1Desc;

  /// No description provided for @cosoComp2Title.
  ///
  /// In en, this message translates to:
  /// **'Strategy & Objective-Setting'**
  String get cosoComp2Title;

  /// No description provided for @cosoComp2Short.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get cosoComp2Short;

  /// No description provided for @cosoComp2Desc.
  ///
  /// In en, this message translates to:
  /// **'Strategic planning and risk appetite alignment'**
  String get cosoComp2Desc;

  /// No description provided for @cosoComp3Title.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get cosoComp3Title;

  /// No description provided for @cosoComp3Short.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get cosoComp3Short;

  /// No description provided for @cosoComp3Desc.
  ///
  /// In en, this message translates to:
  /// **'Risk identification, assessment, and prioritization'**
  String get cosoComp3Desc;

  /// No description provided for @cosoComp4Title.
  ///
  /// In en, this message translates to:
  /// **'Review & Revision'**
  String get cosoComp4Title;

  /// No description provided for @cosoComp4Short.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get cosoComp4Short;

  /// No description provided for @cosoComp4Desc.
  ///
  /// In en, this message translates to:
  /// **'Monitoring and revising risk management practices'**
  String get cosoComp4Desc;

  /// No description provided for @cosoComp5Title.
  ///
  /// In en, this message translates to:
  /// **'Information, Communication & Reporting'**
  String get cosoComp5Title;

  /// No description provided for @cosoComp5Short.
  ///
  /// In en, this message translates to:
  /// **'Information, Communication'**
  String get cosoComp5Short;

  /// No description provided for @cosoComp5Desc.
  ///
  /// In en, this message translates to:
  /// **'Risk information flow and reporting'**
  String get cosoComp5Desc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
