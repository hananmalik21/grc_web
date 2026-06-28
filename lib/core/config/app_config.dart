class AppConfig {
  AppConfig._();

  static const String appName = 'GRC';

  // Debug Credentials
  // static const String debugUsername = 'hanan.khalid@digify.com';
  // static const String debugUsername = 'digify.affan@mailinator.com';
  // static const String debugPassword = 'Password1!';

  static const String debugUsername = 'enterprise_admin'; // for admin
  static const String debugPassword = 'Admin!ChangeMe'; // for admin

  static const String placeholderUserName = 'System Administrator';
  static const String placeholderUserEmail = 'admin@digifyhr.com';
  static const String placeholderUserRole = 'System Admin';

  // Debug-only permission bypass switch for UI/layout inspection.
  static const bool debugBypassAllPermissions = false;
}
